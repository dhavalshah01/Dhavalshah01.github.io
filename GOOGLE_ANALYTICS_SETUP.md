# Google Analytics Setup Guide for dhavalshah01.github.io

This guide walks you through setting up Google Analytics 4 (GA4) on your GitHub Pages portfolio site so you can track visitor details including demographics, traffic sources, page views, user behavior, and more.

---

## Step 1: Create a Google Analytics Account

1. Go to [Google Analytics](https://analytics.google.com/).
2. Sign in with your Google account.
3. Click **Start measuring** (or **Admin** → **+ Create Account** if you already have an existing GA account).
4. Enter an **Account name** (e.g., `Dhaval Shah Portfolio`).
5. Configure data sharing settings as desired, then click **Next**.

## Step 2: Create a Property

1. Enter a **Property name** (e.g., `dhavalshah01.github.io`).
2. Select your **Reporting time zone** and **Currency**.
3. Click **Next**.
4. Select your **Industry category** (e.g., `Technology`) and **Business size**.
5. Click **Next**.
6. Choose your **Business objectives** — select all that apply:
   - **Generate leads**
   - **Examine user behavior**
   - **Get baseline reports** *(recommended — this enables the most comprehensive default reports)*
7. Click **Create**.
8. Accept the Google Analytics Terms of Service.

## Step 3: Set Up a Web Data Stream

1. Select **Web** as the platform.
2. Enter your **Website URL**: `https://dhavalshah01.github.io`
3. Enter a **Stream name** (e.g., `Portfolio Site`).
4. Ensure **Enhanced measurement** is toggled **ON** — this automatically tracks:
   - Page views
   - Scrolls
   - Outbound clicks
   - Site search
   - Video engagement
   - File downloads
5. Click **Create stream**.

## Step 4: Get Your Measurement ID

1. After creating the stream, you'll see a **Measurement ID** that looks like: `G-XXXXXXXXXX`.
2. **Copy this Measurement ID** — you'll need it for the next step.

## Step 5: Add the Tracking Code to Your Site

The Google Analytics gtag.js tracking snippet has already been added to all HTML pages in this repository. However, it uses a **placeholder** Measurement ID (`G-XXXXXXXXXX`) that you must replace with your actual ID.

### Replace the Placeholder in All HTML Files

Search for `G-XXXXXXXXXX` in the following files and replace it with your actual Measurement ID:

- `index.html`
- `variants/fluent-microsoft.html`
- `variants/gradient-colorful.html`
- `variants/light-professional.html`
- `variants/terminal-hacker.html`

There are **two occurrences** per file that need to be replaced:

1. In the `<script>` tag `src` URL:
   ```html
   <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
   ```

2. In the `gtag('config', ...)` call:
   ```html
   gtag('config', 'G-XXXXXXXXXX');
   ```

You can do a global find-and-replace across all files:
```bash
# From the repository root (Linux / Git Bash):
find . -name "*.html" -exec sed -i 's/G-XXXXXXXXXX/G-YOUR_ACTUAL_ID/g' {} +

# On macOS, use:
find . -name "*.html" -exec sed -i '' 's/G-XXXXXXXXXX/G-YOUR_ACTUAL_ID/g' {} +
```

## Step 6: Deploy and Verify

1. **Commit and push** the updated files to your `main` branch.
2. GitHub Pages will automatically deploy the changes.
3. Open your site: [https://dhavalshah01.github.io](https://dhavalshah01.github.io)

### Verify Tracking is Working

1. Go to [Google Analytics](https://analytics.google.com/).
2. Navigate to **Reports** → **Realtime**.
3. With your site open in another tab, you should see **1 active user** in the Realtime report within a few seconds.
4. If you don't see activity, check:
   - Your Measurement ID is correctly replaced (no `G-XXXXXXXXXX` remaining).
   - Your browser doesn't have an ad blocker or analytics blocker enabled.
   - Try in an Incognito/Private window.

## Step 7: Explore the Reports Available to You

Once data starts flowing (allow 24–48 hours for full reports), here's what you can see:

### Realtime Reports
- **Active users right now** — see live visitors on your site
- **Pages being viewed** — which pages are currently active
- **User location** — where visitors are coming from in real time
- **Traffic source** — how they found you (direct, organic, social, referral)

### User Acquisition Reports
- **Where users come from** — Google Search, LinkedIn, GitHub, direct URL, etc.
- **Campaigns & channels** — organic search, paid, social, email, referral
- **First visit source** — the channel that originally brought each user

### Engagement Reports
- **Page views** — total and per-page breakdown
- **Average engagement time** — how long users spend on your site
- **Scroll depth** — how far users scroll on each page (via Enhanced Measurement)
- **Outbound click tracking** — which external links users click
- **Events** — all tracked user interactions (page_view, scroll, click, etc.)

### Demographics Reports
- **Country & City** — geographic distribution of visitors
- **Language** — browser language preferences
- **Age & Gender** — demographic breakdown (requires Google Signals to be enabled, see below)
- **Interests** — user interest categories

### Tech Reports
- **Browser** — Chrome, Firefox, Safari, Edge, etc.
- **Operating System** — Windows, macOS, iOS, Android, Linux
- **Device category** — Desktop, Mobile, Tablet
- **Screen resolution** — display sizes of visitors

### Retention Reports
- **New vs Returning users** — how many visitors come back
- **User retention over time** — cohort-based return rates

---

## Optional: Enable Google Signals (for Demographics & Interests)

To unlock **age, gender, and interest** reporting:

1. In Google Analytics, go to **Admin** → **Data Settings** → **Data Collection**.
2. Toggle **Google signals data collection** to **ON**.
3. Acknowledge the policy requirements.
4. Note: This data is only available for users who have ad personalization enabled in their Google accounts.

## Optional: Enable Enhanced Conversions & Events

You can set up custom events to track specific interactions:

### Track Contact Button Clicks (Example)

Add this to your HTML where the contact button/link is:

```html
<a href="mailto:your@email.com" onclick="gtag('event', 'contact_click', { 'method': 'email' });">
  Contact Me
</a>
```

### Track Resume Downloads (Example)

```html
<a href="Profile.pdf" onclick="gtag('event', 'file_download', { 'file_name': 'Profile.pdf' });">
  Download Resume
</a>
```

### Track Section Views with Custom Events (Example)

```javascript
// Track when users view specific sections
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      gtag('event', 'section_view', {
        'section_name': entry.target.id
      });
      observer.unobserve(entry.target); // Track only once
    }
  });
}, { threshold: 0.5 });

document.querySelectorAll('section[id]').forEach(section => {
  observer.observe(section);
});
```

## Optional: Link Google Search Console

To see which Google search queries bring users to your site:

1. Go to [Google Search Console](https://search.google.com/search-console/).
2. Add your property: `https://dhavalshah01.github.io`.
3. Verify ownership using the **HTML tag** method (add a `<meta>` tag to your `<head>`).
4. In Google Analytics, go to **Admin** → **Product Links** → **Search Console Links**.
5. Click **Link** and follow the prompts.

This gives you:
- **Search queries** — exact terms people search to find your site
- **Impressions & clicks** — how often your site appears in search and how often people click
- **Average position** — where you rank in Google search results
- **Landing pages** — which pages receive organic traffic

---

## Summary of Data You Can View

| Category | Details |
|---|---|
| **Visitor Count** | Total users, new users, active users, sessions |
| **Traffic Sources** | Organic search, direct, social, referral, paid |
| **Geography** | Country, city, language |
| **Demographics** | Age, gender, interests (with Google Signals) |
| **Technology** | Browser, OS, device type, screen resolution |
| **Behavior** | Pages viewed, session duration, bounce rate, scroll depth |
| **Content** | Most viewed pages, entry/exit pages |
| **Events** | Clicks, downloads, video plays, scrolls, form submissions |
| **Conversions** | Any custom goals you define (e.g., contact clicks, resume downloads) |
| **Search Queries** | Google search terms (with Search Console linked) |
| **Retention** | New vs returning visitors, cohort analysis |
| **Realtime** | Live visitor count, active pages, current sources |

---

## Troubleshooting

| Issue | Solution |
|---|---|
| No data in Realtime | Check Measurement ID, disable ad blockers, try incognito |
| No demographic data | Enable Google Signals in Admin → Data Settings |
| No search query data | Link Google Search Console (see above) |
| Data delayed | Standard reports can take 24–48 hours to populate |
| Tracking only on some pages | Ensure all HTML files have the gtag snippet with correct ID |
