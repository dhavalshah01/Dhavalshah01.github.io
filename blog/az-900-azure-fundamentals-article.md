# AZ-900: A Practical Guide to Microsoft Azure Fundamentals

![AZ-900 visual roadmap](az-900-visual.svg)

The AZ-900 Microsoft Azure Fundamentals certification is designed for anyone who wants to build a strong foundation in cloud computing and Microsoft Azure. It is a good starting point for technical professionals, business stakeholders, project managers, sales teams, and anyone who works with cloud-based solutions but may not yet be hands-on with architecture or engineering. The exam focuses less on deep implementation and more on understanding cloud concepts, Azure services, pricing, governance, security, and support models.

This article summarizes the key areas to focus on while preparing for AZ-900 and provides a practical way to think about the exam topics.

## Why AZ-900 Matters

Cloud adoption is no longer limited to infrastructure teams. Modern applications, analytics platforms, AI solutions, security operations, and business systems are increasingly built on cloud services. AZ-900 helps establish a common language for understanding how cloud platforms work and how Azure supports business and technical outcomes.

The certification is especially useful because it explains Azure from a broad perspective. Instead of only focusing on how to deploy a virtual machine or configure a database, it helps candidates understand why organizations use cloud computing, how Microsoft structures Azure services, and how cost, security, compliance, and reliability fit into cloud decision-making.

## 1. Understand Core Cloud Concepts

The first area to master is general cloud computing. Candidates should understand what cloud computing means and how it differs from traditional on-premises infrastructure. This includes concepts such as scalability, elasticity, high availability, disaster recovery, and shared responsibility.

A key concept is the difference between capital expenditure and operational expenditure. On-premises environments often require upfront investment in hardware, facilities, and maintenance, while cloud platforms allow organizations to pay for resources as they use them. This model gives businesses more flexibility, especially when demand changes quickly.

You should also understand the major cloud service models:

| Model | What it means | Example |
|---|---|---|
| IaaS | Infrastructure as a Service gives you control over virtual machines, networking, and storage. | Azure Virtual Machines |
| PaaS | Platform as a Service lets you deploy applications without managing the underlying servers. | Azure App Service |
| SaaS | Software as a Service provides a complete application managed by the provider. | Microsoft 365 |

The exam also expects familiarity with public, private, and hybrid cloud models. Azure is commonly used in hybrid environments where organizations connect on-premises systems with cloud services.

## 2. Know the Core Azure Services

Azure includes a wide range of services, but AZ-900 focuses on recognizing major service categories and knowing when each one is used. The goal is not to become an expert in every service, but to understand the purpose of the most important ones.

For compute, candidates should understand Azure Virtual Machines, Azure App Service, Azure Functions, and containers. Virtual machines are useful when you need more control over the operating system, while App Service and Functions are better suited for managed application hosting and serverless workloads.

For storage, you should understand Azure Blob Storage, Azure Files, Azure Queue Storage, and Azure Table Storage. Blob Storage is commonly used for unstructured data such as images, documents, backups, and logs. Azure Files provides managed file shares that can be accessed using standard protocols.

Networking is another important area. Candidates should understand virtual networks, subnets, VPN Gateway, ExpressRoute, Azure DNS, and load balancing concepts. These services help connect resources securely, distribute traffic, and integrate cloud environments with on-premises infrastructure.

Common database and analytics services include Azure SQL Database, Azure Cosmos DB, Azure Synapse Analytics, Microsoft Fabric, and Azure Databricks. For AZ-900, focus on understanding relational versus non-relational data and knowing that different workloads require different data services.

## 3. Learn Security, Identity, and Governance

Security is a major part of Azure fundamentals. Candidates should understand the shared responsibility model, where Microsoft is responsible for securing the cloud platform, while customers are responsible for securing their data, identities, access, and configurations depending on the service model being used.

Microsoft Entra ID is central to identity and access management in Azure. It supports authentication, single sign-on, multifactor authentication, conditional access, and role-based access control. For the exam, it is important to understand that identity is often the first security boundary in cloud environments.

Role-Based Access Control, or RBAC, is used to assign permissions to users, groups, service principals, or managed identities. RBAC follows the principle of least privilege, meaning users should only receive the access they need to do their job.

Governance features are also important. Azure Policy helps enforce rules and standards, such as requiring specific regions, tagging resources, or restricting certain resource types. Resource locks help prevent accidental deletion or modification. Microsoft Purview, compliance offerings, and the Microsoft Trust Center are also relevant when discussing governance, privacy, and regulatory requirements.

## 4. Understand Pricing, Cost Management, and Support

AZ-900 includes questions about how Azure pricing works. Candidates should understand that Azure costs are influenced by resource type, usage duration, region, storage consumption, bandwidth, licensing, and support plans. The exam may ask about tools that help estimate and manage cloud costs.

Important cost-related tools include:

| Tool | Purpose |
|---|---|
| Azure Pricing Calculator | Estimate the cost of Azure services before deployment. |
| Total Cost of Ownership Calculator | Compare the cost of on-premises infrastructure with Azure. |
| Microsoft Cost Management | Monitor, analyze, and optimize actual Azure spend. |
| Budgets and alerts | Notify teams when spending approaches defined thresholds. |

Candidates should also understand service level agreements, or SLAs. An SLA describes Microsoft's commitment for service availability. Higher availability often requires designing solutions with redundancy across availability zones or regions.

Support plans are another topic to review. Azure offers different support options depending on business needs, from basic documentation and community support to paid plans with faster response times and technical support.

## How to Prepare for the AZ-900 Exam

The best way to prepare is to combine conceptual learning with hands-on exploration. Start by reviewing the official Microsoft Learn AZ-900 learning paths, then spend time in the Azure portal to see how services are organized. Even basic hands-on exposure makes it easier to remember the purpose of different services.

Focus on understanding scenarios rather than memorizing definitions. For example, instead of only memorizing that Azure Functions is serverless, understand when a serverless function would be preferred over a virtual machine or App Service. Similarly, understand when a company might use ExpressRoute instead of a VPN connection.

It is also helpful to create a simple study plan:

1. Review cloud concepts and service models.
2. Learn core Azure compute, storage, networking, and database services.
3. Study identity, security, governance, compliance, and monitoring.
4. Review pricing, SLAs, lifecycle, and support options.
5. Take practice questions and revisit weak areas.

## Common Mistakes to Avoid

One common mistake is going too deep into implementation details. AZ-900 is a fundamentals exam, so candidates do not need to memorize complex configuration steps or write deployment scripts. The exam is more focused on selecting the right service or concept for a given scenario.

Another mistake is ignoring pricing, governance, and support topics. Many candidates spend most of their time on compute and storage but lose points on cost management, SLAs, support plans, and compliance concepts. These areas are very important for the exam and for real-world cloud decision-making.

Finally, avoid treating Microsoft Entra ID, RBAC, and Azure Policy as separate isolated topics. In practice, they work together to secure and govern Azure environments. Identity controls who can access resources, RBAC controls what they can do, and policy controls what rules the environment must follow.

## Final Takeaway

AZ-900 is a strong certification for building cloud confidence and understanding Azure at a foundational level. It provides a clear overview of cloud concepts, Azure services, security, governance, pricing, and support. With a structured study approach and a focus on real-world scenarios, candidates can use AZ-900 as a stepping stone toward more advanced Azure certifications and practical cloud roles.

The key is to understand the "why" behind Azure services, not just the names of the services. If you can explain what problem each major Azure service solves, when to use it, and how it fits into secure and cost-effective cloud adoption, you will be well prepared for the exam.
