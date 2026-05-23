# Examples

- `oh-my-symphony-index.html` — full production landing page (29.5K) shipped by this skill for [cskwork/oh-my-symphony](https://github.com/cskwork/oh-my-symphony). Live at https://cskwork.github.io/oh-my-symphony/.

## How to read it

Open `oh-my-symphony-index.html` in a browser to see the final output. Key structural beats to copy:

1. **`<head>`** — Tailwind CDN, custom `tailwind.config` script with Stitch's design tokens, two Google Fonts, ~50 lines of inline `<style>` (scanline texture, blinking cursor, terminal-card chrome, dot-grid hero background, table hover).
2. **`<nav>`** — sticky, blurred background, wordmark left + nav links + amber CTA right.
3. **Hero `<section>`** — terminal `$` prompt line, mono 3-line headline with the punchline highlighted, body paragraph, two CTAs, terminal-chrome screenshot card embedding the real `tui-screenshot.svg`.
4. **Features `<section>`** — 6 `feature-card`s in a 3×2 grid with `[NN] tag` labels.
5. **Quickstart `<section>`** — split layout: numbered steps left, terminal block right with `$ command` lines.
6. **Agent matrix table** — domain-specific comparison. Replace with whatever your project naturally has (integrations, plans, languages, etc.).
7. **Audience `<section>`** — 3 cards for primary personas.
8. **Final CTA + footer.**

The page is ~25-30 KB uncompressed; Tailwind CDN is the only external dependency and adds ~50 KB gzipped on first paint.
