---
name: final-touches
description: Pre-ship final pass that completes OG/social tags, SEO metadata, brand favicon, and mobile-only responsiveness fixes without altering desktop. Use when user says 'final touches', 'og tags', 'seo', 'favicon', 'mobile optimisation', 'mobile optimization', or 'ship it'.
---

# Final Touches — OG/SEO + Mobile Pass

You are a pre-ship specialist. Your job is to take a finished page and make it
shippable: discoverable (SEO/social), branded (favicon), and solid on phones —
with a hard guarantee that the desktop view does not change.

## CORE PRINCIPLE

**Mobile-only deltas, desktop-identical output.** Every responsive change must
be scoped to a mobile breakpoint (`max-width` media query, `sm:`/`md:`/`lg:`
or `min-[...]:` prefix). Never edit a base/desktop class value in place —
add a mobile variant alongside it.

## WORKFLOW (MANDATORY, IN ORDER)

### 0. DETECT THE STACK

- Next.js App Router (`src/app/layout.tsx` exists) → use `Metadata` API.
- Plain HTML / Vite / other → edit `<head>` tags directly.
- Tailwind present? Check `package.json` / CSS. If no Tailwind, use raw CSS
  media queries for all responsive work.

### 1. SEO + OG TAGS AUDIT

Checklist — add whatever is missing, keep whatever exists:

- [ ] `metadataBase: new URL("https://<production-domain>")` so relative
      OG image paths resolve to absolute URLs.
- [ ] `title` with `default` + `template` (`"%s | <Brand>"`).
- [ ] `description` (150–160 chars), `keywords`, `authors`, `creator`,
      `publisher`, `robots: "index, follow"`.
- [ ] `openGraph`: `type: "website"`, `locale`, absolute `url`, `title`,
      `description`, `siteName`, `images: [{ url, width: 1200, height: 630, alt }]`.
      Use an existing hero/poster image — do not invent a new asset.
- [ ] `twitter`: `card: "summary_large_image"`, `title`, `description`,
      `images`.
- [ ] `alternates: { canonical }`.
- [ ] `viewport`: `width: "device-width"`, `initialScale: 1`,
      `themeColor` for light + dark.
- [ ] Plain-HTML fallback: `<meta property="og:*">`, `<meta name="twitter:*">`,
      `<link rel="canonical">`, `<meta name="description">`,
      `<meta name="theme-color">`.

Reference shape (Next.js):

```tsx
export const metadata: Metadata = {
  metadataBase: new URL("https://example.com"),
  title: { default: "<Brand> | <What>", template: "%s | <Brand>" },
  description: "<150-160 chars>",
  keywords: ["<niche>", "<service>", "<location>"],
  authors: [{ name: "<Brand>" }],
  creator: "<Brand>",
  publisher: "<Brand>",
  robots: "index, follow",
  icons: {
    icon: [{ url: "/icon.svg", type: "image/svg+xml" }],
    apple: [{ url: "/apple-icon.svg", type: "image/svg+xml" }],
    shortcut: "/icon.svg",
  },
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://example.com",
    title: "<Social title>",
    description: "<Social description>",
    siteName: "<Brand>",
    images: [{ url: "/hero-poster.jpg", width: 1200, height: 630, alt: "<Brand> — <what>" }],
  },
  twitter: {
    card: "summary_large_image",
    title: "<Social title>",
    description: "<Social description>",
    images: ["/hero-poster.jpg"],
  },
  alternates: { canonical: "https://example.com" },
};
```

### 2. FAVICON (BRAND MARK, NOT GENERIC)

- [ ] Design a minimal SVG brand mark (single motif from the business:
      bowl, bean, flame, tooth, leaf — flat shapes, 2–3 colors, readable at
      16×16). Dark rounded-square background (`rx`) + light foreground works
      at tiny sizes. No text, no fine detail.
- [ ] Next.js: write `src/app/icon.svg` (auto-served as favicon) and
      `src/app/apple-icon.svg` (larger 180-viewBox variant of the same mark).
- [ ] Mirror to `public/`: `icon.svg`, `apple-icon.svg`
      (plus a semantic alias like `public/<motif>.svg`, e.g. `noodle-bowl.svg`).
- [ ] Delete a stale default `src/app/favicon.ico` so the old generic icon
      stops being emitted alongside the new one.
- [ ] Reference all three in `metadata.icons` (see snippet above).

### 3. MOBILE-ONLY RESPONSIVENESS PASS

Audit at 320px, 375px, and 430px widths. Fix with mobile-scoped variants only.

**Breakpoint convention:**

| Target | Technique |
|---|---|
| Phones < 420px | `min-[420px]:` = the "phone landscape / large phone" step-up |
| Small phones < 380px | `min-[380px]:` step-up |
| Tablet/desktop | `sm:` / `md:` / `lg:` — existing desktop classes stay as-is |

**Pattern table — apply wherever the audit finds the smell:**

| Smell | Fix (mobile variant only) |
|---|---|
| `grid-cols-2` crushing content (emails, addresses, dates overflow) | `grid-cols-1 min-[420px]:grid-cols-2`; long-span items get `min-[420px]:col-span-2`; values get `[overflow-wrap:anywhere] min-w-0` |
| Form fields narrower than ~140px | Stack to 1-col on small phones; `min-w-0` on every label/input wrapper |
| iOS auto-zoom on focus | `text-base` (16px) on inputs/selects for mobile, `min-[420px]:text-sm` to restore desktop size |
| Small tap targets | `min-w-[44px] min-h-[44px]` on icon buttons, dots, socials (desktop keeps `sm:min-w-0 sm:min-h-0` if needed) |
| `min-h-[100dvh]` with stacked content | Move to `lg:min-h-[100dvh]`; mobile uses `items-start`, desktop keeps `lg:items-center` |
| Oversized mobile type | Step down one size on mobile only, e.g. `text-3xl min-[380px]:text-4xl sm:text-5xl`; long display titles get a mobile-only `clamp()` override in CSS with `!important` |
| `aspect-[4/5]` images towering on single-col mobile | `aspect-[16/11] sm:aspect-[4/5]`; galleries `grid-cols-1 min-[480px]:grid-cols-2` |
| Hover-reveal content (`opacity-0 group-hover:opacity-100`) | Always visible on touch: `opacity-100 min-[640px]:opacity-0 min-[640px]:group-hover:opacity-100` (same for translate) |
| Hover-expand flex rows overflowing phones | `flex-col min-[640px]:flex-row` + mobile CSS override forcing `width: 100% !important` |
| `px-6` squeezing 320px screens | `px-4 min-[380px]:px-6` |
| Oversized section rhythm | `py-12 sm:py-16`, `mb-10 sm:mb-20`, `gap-4 sm:gap-8` |
| Next.js `Image fill` mispositioned | The `fill` parent MUST have `relative` — add it if missing |
| Carousel/dot rows shifting layout | Constrain slide padding (`px-1 min-[380px]:px-4 sm:px-6`), cap card width (`max-w-md mx-auto lg:max-w-none`), give dots a fixed-height hit area |

**Mobile-only CSS safety net** (append inside existing stylesheet — never
rewrite desktop rules):

```css
@media (max-width: 640px) {
  /* Stack hover-expand panels; desktop keeps hover behavior */
  .accordion-panel,
  .accordion-panel:hover,
  .accordion-panel:not(:hover) {
    width: 100% !important;
    min-width: 0 !important;
  }
}

@media (max-width: 639px) {
  /* Scale down inline-clamped display type without touching desktop */
  .hero-title {
    font-size: clamp(2.35rem, 10.5vw, 3.4rem) !important;
    line-height: 1.08 !important;
    overflow-wrap: break-word;
  }
  img, video { max-width: 100%; }
}
```

### 4. VERIFY (DO NOT SKIP)

- [ ] `npm run lint` — zero errors (pre-existing warnings are acceptable,
      note them).
- [ ] `npm run build` — compiles clean.
- [ ] Serve production and grep emitted HTML for `og:title`, `og:image`,
      `twitter:card`, and icon `<link>` tags; confirm OG image resolves to an
      absolute URL and no stale `/favicon.ico` link remains.
- [ ] Confirm every edited class list still contains its original `lg:`/`sm:`
      desktop value — desktop is byte-for-byte the same design.

## QUALITY BAR

- No new image-generation dependencies — reuse existing public assets.
- No placeholder text in tags — every title/description/alt is real copy.
- No desktop class value changed in place — mobile variants only.
- No `echo`/heredoc file writes — use proper file tools.
- Report per-section: what was mobile-broken, what variant fixed it, and the
  verification output.

## SKILL TRIGGERS

Use this skill when:
- User says "final touches", "ship it", "pre-ship", or "polish".
- User asks for "og tags", "seo", "meta tags", "favicon", or "social preview".
- User reports "mobile is broken", "mobile optimisation", or a section being
  "all over the place" on phones.
- A landing page / marketing site is visually done and needs its shippable pass.
