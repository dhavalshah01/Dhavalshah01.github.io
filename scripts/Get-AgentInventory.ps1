<#
.SYNOPSIS
    Programmatic access to the Agent Registry / Copilot agent inventory via the
    Microsoft Graph Package Management (Inventory) API.

.DESCRIPTION
    Implements the two scenarios from the "Programmatic Access to Agent Registry
    (Preview)" guidance:

        1. Get all agents in your inventory.
        2. Get details of a particular agent in your inventory.

    The script talks to the beta Graph endpoints:
        GET /beta/copilot/admin/catalog/packages          (list packages / agents)
        GET /beta/copilot/admin/catalog/packages/{id}      (single agent details)

    It supports interactive (delegated) sign-in and unattended app-only
    (client credentials) authentication so it can be dropped into automated
    governance workflows.

.PARAMETER PackageId
    When supplied, retrieves detailed metadata for a single agent (package) and
    ignores the list operation.

.PARAMETER AgentsOnly
    Restricts the list to Copilot agents by filtering supportedHosts eq 'Copilot'.
    Without this switch, every package in the catalog is returned.

.PARAMETER TenantId
    Entra tenant ID. Required for app-only auth; optional for interactive.

.PARAMETER ClientId
    App registration (client) ID for app-only auth.

.PARAMETER ClientSecret
    Client secret for app-only auth, as a SecureString. If ClientId is supplied
    without this and without CertificateThumbprint, you will be prompted.

.PARAMETER CertificateThumbprint
    Certificate thumbprint for app-only auth (preferred over a client secret).

.PARAMETER DeviceCode
    Use device code flow for interactive user sign-in when a browser cannot be
    launched on the current machine (for example, a remote session).

.PARAMETER OutputPath
    Optional. Writes the result to this path. A .csv extension exports a flat
    CSV; anything else (or .json) exports formatted JSON.

.EXAMPLE
    # Interactive sign-in, list every agent in the tenant
    ./Get-AgentInventory.ps1 -AgentsOnly

.EXAMPLE
    # Unattended app-only run, export the full inventory to CSV
    $sec = ConvertTo-SecureString $env:GRAPH_SECRET -AsPlainText -Force
    ./Get-AgentInventory.ps1 -TenantId $tid -ClientId $cid -ClientSecret $sec `
        -AgentsOnly -OutputPath ./agent-inventory.csv

.EXAMPLE
    # Get full details for one agent
    ./Get-AgentInventory.ps1 -PackageId 'P_19ae1zz1-56bc-505a-3d42-156df75a4xxy'

.NOTES
    Requires the Microsoft.Graph.Authentication module and a Microsoft Agent 365
    license. The signed-in identity needs the AI administrator or Global
    administrator role and the CopilotPackages.Read.All permission.
#>

[CmdletBinding(DefaultParameterSetName = 'List')]
param(
    [Parameter(ParameterSetName = 'Detail', Mandatory)]
    [string]$PackageId,

    [Parameter(ParameterSetName = 'List')]
    [switch]$AgentsOnly,

    [Parameter()]
    [string]$TenantId,

    [Parameter()]
    [string]$ClientId,

    [Parameter()]
    [securestring]$ClientSecret,

    [Parameter()]
    [string]$CertificateThumbprint,

    [Parameter()]
    [switch]$DeviceCode,

    [Parameter()]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

# --- Ensure the Graph authentication module is available -------------------
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    throw "Microsoft.Graph.Authentication module not found. Install it with: Install-Module Microsoft.Graph.Authentication -Scope CurrentUser"
}
Import-Module Microsoft.Graph.Authentication -ErrorAction Stop

# --- Connect to Microsoft Graph --------------------------------------------
function Connect-Graph {
    param(
        [string]$TenantId,
        [string]$ClientId,
        [securestring]$ClientSecret,
        [string]$CertificateThumbprint,
        [switch]$DeviceCode
    )

    # App-only (client credentials) auth for unattended automation.
    if ($ClientId) {
        if (-not $TenantId) { throw "TenantId is required for app-only authentication." }

        if ($CertificateThumbprint) {
            Connect-MgGraph -TenantId $TenantId -ClientId $ClientId `
                -CertificateThumbprint $CertificateThumbprint -NoWelcome
            return
        }

        if (-not $ClientSecret) {
            $ClientSecret = Read-Host -AsSecureString -Prompt "Client secret for app $ClientId"
        }
        $credential = [System.Management.Automation.PSCredential]::new($ClientId, $ClientSecret)
        Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $credential -NoWelcome
        return
    }

    # Delegated sign-in as the current user (no app secret/cert required).
    $connectParams = @{
        Scopes    = 'CopilotPackages.Read.All'
        NoWelcome = $true
    }
    if ($TenantId)   { $connectParams.TenantId = $TenantId }
    if ($DeviceCode) { $connectParams.UseDeviceCode = $true }
    Connect-MgGraph @connectParams
}

# --- Retrieve every page of a Graph collection -----------------------------
function Get-GraphCollection {
    param([Parameter(Mandatory)][string]$Uri)

    $items = [System.Collections.Generic.List[object]]::new()
    $next = $Uri
    while ($next) {
        $response = Invoke-MgGraphRequest -Method GET -Uri $next
        if ($response.value) { $items.AddRange([object[]]$response.value) }
        $next = $response.'@odata.nextLink'
    }
    return $items
}

# --- Export helper ----------------------------------------------------------
function Export-Result {
    param(
        [Parameter(Mandatory)]$Data,
        [Parameter(Mandatory)][string]$Path
    )

    if ([System.IO.Path]::GetExtension($Path).ToLowerInvariant() -eq '.csv') {
        $Data | Select-Object id, displayName, type, publisher, platform, version,
            isBlocked, availableTo, deployedTo, lastModifiedDateTime,
            @{ n = 'supportedHosts'; e = { ($_.supportedHosts -join ';') } },
            @{ n = 'elementTypes';   e = { ($_.elementTypes  -join ';') } } |
            Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8
    }
    else {
        $Data | ConvertTo-Json -Depth 10 | Set-Content -Path $Path -Encoding UTF8
    }
    Write-Host "Saved results to $Path" -ForegroundColor Green
}

# --- Main -------------------------------------------------------------------
$baseUri = 'https://graph.microsoft.com/beta/copilot/admin/catalog/packages'

Connect-Graph -TenantId $TenantId -ClientId $ClientId `
    -ClientSecret $ClientSecret -CertificateThumbprint $CertificateThumbprint `
    -DeviceCode:$DeviceCode

try {
    if ($PSCmdlet.ParameterSetName -eq 'Detail') {
        # Scenario 2: details of a particular agent.
        Write-Host "Retrieving details for agent '$PackageId'..." -ForegroundColor Cyan
        $result = Invoke-MgGraphRequest -Method GET -Uri "$baseUri/$PackageId"
        $result | ConvertTo-Json -Depth 10 | Write-Output
    }
    else {
        # Scenario 1: all agents in the inventory.
        $uri = $baseUri
        if ($AgentsOnly) {
            $uri += "?`$filter=supportedHosts/any(h:h eq 'Copilot')"
            Write-Host "Retrieving all Copilot agents in the inventory..." -ForegroundColor Cyan
        }
        else {
            Write-Host "Retrieving all packages in the inventory..." -ForegroundColor Cyan
        }

        $result = Get-GraphCollection -Uri $uri
        Write-Host ("Found {0} item(s)." -f $result.Count) -ForegroundColor Green

        $result |
            Select-Object id, displayName, type, publisher, platform,
                @{ n = 'supportedHosts'; e = { ($_.supportedHosts -join ', ') } },
                isBlocked, lastModifiedDateTime |
            Format-Table -AutoSize
    }

    if ($OutputPath -and $result) {
        Export-Result -Data $result -Path $OutputPath
    }
}
finally {
    Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
}
