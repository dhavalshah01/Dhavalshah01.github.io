# Copilot Instructions — Dhaval Shah Portfolio & Blog

This repository is a **static website** (no build step, no framework, no package manager) hosted on **GitHub Pages** at `https://dhavalshah01.github.io/`. It contains a personal portfolio and a technical blog. Everything is plain HTML, CSS, and vanilla JavaScript served as-is.

## Project structure

```
Dhavalshah01.github.io/
├── index.html                  # Main portfolio / landing page (self-contained, inline <style>)
├── sitemap.xml                 # SEO: lists every indexable page (regenerate when pages change)
├── robots.txt                  # SEO: allows crawling, points to sitemap.xml
├── README.md
├── GOOGLE_ANALYTICS_SETUP.md
├── variants/                   # Alternate portfolio designs (self-contained)
│   ├── fluent-microsoft.html
│   ├── gradient-colorful.html
│   ├── light-professional.html
│   └── terminal-hacker.html
└── blog/
    ├── index.html              # Blog landing: card grid + tag filter (links ./blog.css)
    ├── blog.css                # Shared stylesheet for ALL blog article pages
    ├── post-template.html      # Reference template for new articles
    └── <article-slug>.html     # One file per article (links ./blog.css)
```

## Golden rules

- **No build tooling.** Do not introduce npm, bundlers, frameworks, TypeScript, or a CSS preprocessor. Edit HTML/CSS/JS directly.
- **Do not create Markdown docs** to summarize changes unless explicitly asked.
- **Reuse existing CSS components** in `blog/blog.css` before inventing new ones. Grep the file to confirm a class exists before relying on it. If a genuinely new visual is needed, add it to the end of `blog.css` (with dark-mode and mobile rules) rather than inlining styles in an article.
- **Escape HTML entities** in prose (`&amp;`, `&lt;`, `&gt;`, `&mdash;` / `—`).
- After edits, validate with the errors check on every file you touched.

## Required `<head>` blocks (every HTML page)

1. **Google Analytics (GA4)** must be the first thing in `<head>` on every page, ID `G-EHT814VRKY`:
   ```html
   <script async src="https://www.googletagmanager.com/gtag/js?id=G-EHT814VRKY"></script>
   <script>
     window.dataLayer = window.dataLayer || [];
     function gtag(){dataLayer.push(arguments);}
     gtag('js', new Date());
     gtag('config', 'G-EHT814VRKY');
   </script>
   ```
2. **SEO + Open Graph** meta: `title` (`<Article Title> | Dhaval Shah`), `description`, `author`, `robots`, a `canonical` link, and `og:type`/`og:title`/`og:description`/`og:url`. Canonical and OG URLs follow `https://dhavalshah01.github.io/blog/<slug>.html`.
3. **Fonts**: Inter + JetBrains Mono via Google Fonts; **Font Awesome 6.5.1** via cdnjs.
4. Blog article and `blog/index.html` link the shared stylesheet: `<link rel="stylesheet" href="./blog.css">`. The root `index.html` and `variants/*` are self-contained with an inline `<style>` block instead.

## Authoring a new blog article

1. Copy the shell from `blog/post-template.html` (navbar, `article-hero`, `article-body > .prose`, `author-box`, `article-footer`, `blog-footer`, closing theme script). Real articles link `./blog.css` rather than using the template's inline `<style>`.
2. File name = URL slug, kebab-case, in `blog/` (e.g. `rag-series-2-chunking.html`).
3. Fill the hero: tags (`article-tag`), `<h1>`, and `article-meta` with calendar date (`Month D, YYYY`), clock read time (`N min read`), and author.
4. Write original prose inside `.prose`. Use existing components for visuals: `callout` (`callout-info`/`callout-warn`/`callout-tip`), `ui-mock`/`flow-mock`, `chat-mock`, `prose-table-scroll` for tables, etc.
5. Footer share link is a LinkedIn URL pointing at the article's canonical URL.
6. **Wire it into `blog/index.html`** (see below).

## Wiring a card into `blog/index.html`

Cards live in `<div class="blog-grid" id="blogGrid">`, ordered **newest-first** with a numbered HTML comment (`<!-- 39 -->`, counting **down** as you go down the page; the highest number sits at the top). Insert new cards above the current top card. Card pattern:

```html
<!-- NN -->
<a href="./<slug>.html" class="post-card reveal" data-tags="<space-separated-slugs>">
    <div class="post-card-accent"></div>
    <div class="post-card-body">
        <div class="post-meta"><span><i class="fas fa-calendar"></i> Mon D, 2026</span><span><i class="fas fa-clock"></i> N min</span></div>
        <h2>Article Title</h2>
        <p>2–3 sentence excerpt.</p>
        <div class="post-tags"><span class="post-tag">Tag A</span><span class="post-tag">Tag B</span></div>
    </div>
    <div class="post-card-footer">Read Article <i class="fas fa-arrow-right"></i></div>
</a>
```

- The hero date inside the article uses the long form (`June 9, 2026`); the index card uses the short form (`Jun 9, 2026`). Keep them consistent for the same article.
- The tag **filter is generic** — it reads `data-tags`, so new tag slugs work with no JavaScript changes. Existing slugs include `search-ai`, `prompt-engineering`, `agentic-ai`, `azure`, `power-platform`. Reuse an existing slug so the article appears under an existing filter chip.
7. **Update the SEO files** (see below) — the new page must be added to `sitemap.xml`.

## Updating SEO files when pages are added or removed

Whenever you **add, rename, or delete** any indexable page (a blog article, a new top-level page, etc.), the SEO files must be kept in sync or search engines won't discover the change:

- **`sitemap.xml`** (required) — must contain a `<url>` entry for every public page and exclude `blog/post-template.html`. Regenerate it from the filesystem rather than hand-editing, so nothing is missed. Run this from the repo root (`resume/`):

  ```powershell
  $root = "Dhavalshah01.github.io"; $base = "https://dhavalshah01.github.io"
  $urls = New-Object System.Collections.Generic.List[object]
  $urls.Add([pscustomobject]@{ loc = "$base/"; priority = "1.0"; mod = (Get-Item "$root\index.html").LastWriteTime.ToString("yyyy-MM-dd") })
  $urls.Add([pscustomobject]@{ loc = "$base/blog/"; priority = "0.9"; mod = (Get-Item "$root\blog\index.html").LastWriteTime.ToString("yyyy-MM-dd") })
  Get-ChildItem "$root\blog" -Filter *.html |
      Where-Object { $_.Name -notin @('index.html','post-template.html') } | Sort-Object Name |
      ForEach-Object { $urls.Add([pscustomobject]@{ loc = "$base/blog/$($_.Name)"; priority = "0.8"; mod = $_.LastWriteTime.ToString("yyyy-MM-dd") }) }
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
  [void]$sb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
  foreach ($u in $urls) {
      [void]$sb.AppendLine("  <url>"); [void]$sb.AppendLine("    <loc>$($u.loc)</loc>")
      [void]$sb.AppendLine("    <lastmod>$($u.mod)</lastmod>"); [void]$sb.AppendLine("    <changefreq>monthly</changefreq>")
      [void]$sb.AppendLine("    <priority>$($u.priority)</priority>"); [void]$sb.AppendLine("  </url>")
  }
  [void]$sb.AppendLine('</urlset>')
  Set-Content -Path "$root\sitemap.xml" -Value $sb.ToString() -Encoding UTF8 -NoNewline
  ```

- **`robots.txt`** — usually no change needed. Only edit it if a path should be hidden from crawlers (add a `Disallow:`) or if the `Sitemap:` URL changes. `post-template.html` is already disallowed.
- **Per-page SEO meta** — every new page still needs its own `canonical`, `og:url`, `title`, and `description` in `<head>` (see "Required `<head>` blocks"). The sitemap lists the page; the canonical/OG tags make it index correctly.
- After regenerating, confirm the new slug appears in `sitemap.xml` and that the count matches the number of public pages.

## Theme / dark mode

Dark mode is the **default**. Each page's closing `<script>` reads `localStorage.getItem('darkMode')`: `null` or `'true'` enables dark mode and swaps the navbar icon `fa-moon` → `fa-sun`. Preserve this script when copying the shell; do not change the default.

## Design tokens (set in `:root`)

Primary `#0078d4`, primary-dark `#005a9e`, accent `#00b4d8`, dark `#0f172a`. Radius `16px` / `10px`. Fonts: body `Inter`, monospace `JetBrains Mono`. Keep new visuals consistent with these tokens.

## Validation

There is no test suite or linter. "Validation" means: confirm no HTML/CSS errors are reported on changed files, and (optionally) open the page in the browser to verify visuals render correctly in dark mode.
