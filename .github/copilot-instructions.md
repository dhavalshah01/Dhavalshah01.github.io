# Copilot Instructions — Dhaval Shah Portfolio & Blog

This repository is a **static website** (no build step, no framework, no package manager) hosted on **GitHub Pages** at `https://dhavalshah01.github.io/`. It contains a personal portfolio and a technical blog. Everything is plain HTML, CSS, and vanilla JavaScript served as-is.

## Project structure

```
Dhavalshah01.github.io/
├── index.html                  # Main portfolio / landing page (self-contained, inline <style>)
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

## Theme / dark mode

Dark mode is the **default**. Each page's closing `<script>` reads `localStorage.getItem('darkMode')`: `null` or `'true'` enables dark mode and swaps the navbar icon `fa-moon` → `fa-sun`. Preserve this script when copying the shell; do not change the default.

## Design tokens (set in `:root`)

Primary `#0078d4`, primary-dark `#005a9e`, accent `#00b4d8`, dark `#0f172a`. Radius `16px` / `10px`. Fonts: body `Inter`, monospace `JetBrains Mono`. Keep new visuals consistent with these tokens.

## Validation

There is no test suite or linter. "Validation" means: confirm no HTML/CSS errors are reported on changed files, and (optionally) open the page in the browser to verify visuals render correctly in dark mode.
