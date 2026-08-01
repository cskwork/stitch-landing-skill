---
name: stitch-landing
description: Turn any project README into a deployed GitHub Pages landing page via Stitch MCP. Use when the user asks to "make a landing page", "deploy on GitHub Pages", "use Stitch to design a landing", or wants a hosted marketing/preview page generated from existing repo context. Triggers — "landing page", "github pages", "stitch landing", "ship a landing", "랜딩 페이지", "랜딩 만들어", "stitch로 디자인".
---

# stitch-landing

End-to-end skill that takes a project (README + screenshots) and ships a deployed landing page on GitHub Pages, using Stitch MCP for the design pass and Tailwind CDN for the production output.

## When to use

- User has a repo with a README and asks for a landing page hosted on GitHub Pages.
- User says "use Stitch to design", or wants a marketing/preview page they can share.
- Project already has screenshots, badges, or feature copy in the README that should be reused (don't rewrite copy — port it).

## When NOT to use

- The project already has a Pages site you'd be overwriting — confirm first.
- The user wants a multi-page docs site (use Docusaurus / MkDocs / Astro instead).
- The repo has no README and no clear positioning — run discovery first.

## Required tools

- **Stitch MCP** — `mcp__stitch__create_project`, `mcp__stitch__generate_screen_from_text`, `mcp__stitch__list_screens` (Stitch MCP server installed and authenticated).
- **gh CLI** — authenticated for the target repo's owner.
- **git** — push access to the target repo's default branch (or fallback to PR flow).
- **curl** — to download Stitch's HTML output and verify the live URL.

## The flow (8 phases)

### Phase 1 — Read the repo

Read `README.md`, `LICENSE`, screenshots in `docs/`, and any existing `index.html`. Extract:

- **Positioning** — the one-line tagline (usually the README's first blockquote or H1 subhead).
- **Value props** — bullet-list features under "Why" / "Features" / "Highlights".
- **Quickstart** — install command + first command.
- **Visual assets** — existing screenshots (`docs/*.svg`, `docs/*.png`).
- **License + homepage** — for the footer.

Confirm with the user if positioning is ambiguous. Skip this if the README is unambiguous.

### Phase 2 — Stitch design pass

```text
mcp__stitch__create_project { title: "<repo> Landing Page" }
mcp__stitch__generate_screen_from_text {
  projectId: <id>,
  deviceType: DESKTOP,
  modelId: GEMINI_3_FLASH,  // 3 Flash is faster than 3.1 Pro; switch to Pro for higher-fidelity designs
  prompt: <design-prompt — see references/design-prompt-template.md>
}
```

**Generation can take 1–3 minutes.** Do NOT retry on timeout — the tool docstring says so explicitly. Instead poll `mcp__stitch__list_screens { projectId }` every 60s. If no screen appears after ~3 minutes, retry once with a shorter prompt.

The successful response includes `htmlCode.downloadUrl` (a Google contribution URL) and a `theme.designMd` block with the full design system.

### Phase 3 — Download and inspect Stitch output

```bash
mkdir -p tmp_workspaces/landing-stitch
curl -sSL -o tmp_workspaces/landing-stitch/stitch-screen.html "<htmlCode.downloadUrl>"
```

Stitch's HTML uses Tailwind CDN with custom config and inline-base64 PNGs for assets. **Don't ship this verbatim** — the base64 wordmarks bloat the file (often 70K+ for one screen) and assets are placeholders. Use it as a structural reference and design-token source.

### Phase 4 — Author production `docs/index.html`

Write a single self-contained `docs/index.html` (~25-30K) that:

1. **Reuses Stitch's design tokens verbatim** — copy the `tailwind.config` block (`colors`, `fontFamily`, `borderRadius`, `spacing`) from Stitch's output. This is the cheapest way to keep visual parity with the design.
2. **Loads JetBrains Mono + Inter via Google Fonts** (Stitch's default typography pair for technical projects).
3. **Embeds the real repo screenshot** (e.g. `<img src="tui-screenshot.svg">`), not Stitch's placeholder.
4. **Ports README copy verbatim** — same taglines, same feature names, same quickstart commands. Don't paraphrase; the README has been workshopped.
5. **Includes semantic landmarks** — `<nav>`, `<main>`, `<section id>`, `<footer>`, alt text on images, og:image + meta description + theme-color.
6. **No JS framework.** Tailwind CDN + ~50 lines of inline `<style>` for the scanline texture, blinking cursor, terminal card chrome.

See `examples/index.html` for a reference output (oh-my-symphony).

### Phase 5 — Disable Jekyll

```bash
touch docs/.nojekyll
```

Without this, GitHub Pages runs Jekyll on the docs/ folder, which can mangle markdown files that share the directory and can refuse to serve filenames starting with `_`.

### Phase 6 — Enable GitHub Pages

```bash
gh api -X POST repos/<owner>/<repo>/pages \
  -f 'source[branch]=main' \
  -f 'source[path]=/docs'
```

Then set the repo homepage:

```bash
gh api -X PATCH repos/<owner>/<repo> -f homepage='https://<owner>.github.io/<repo>/'
```

If Pages is already enabled, this POST returns 409 — read the current config with `gh api repos/<owner>/<repo>/pages` and skip the enable step.

### Phase 7 — Commit and push

```bash
git add docs/index.html docs/.nojekyll
git commit -m "feat(docs): add landing page for GitHub Pages

Static landing page served from /docs on main, deployed at
https://<owner>.github.io/<repo>/.
"
git push origin main
```

If pushing to `main` is blocked by your auto-mode classifier, ask the user with AskUserQuestion and offer (a) push to main, (b) feature branch + PR, (c) stop and let user push manually.

### Phase 8 — Verify the live site

```bash
sleep 30  # let Pages build
gh api repos/<owner>/<repo>/pages/builds/latest --jq '{status, commit, error}'
curl -sI https://<owner>.github.io/<repo>/
curl -s  https://<owner>.github.io/<repo>/ | grep -E '(<title>|<your tagline>)'
```

Status should be `built`, HEAD response should be `HTTP/2 200`, and a grep of the live HTML should return your real content. **If status is `errored`, read `.error.message`** — common causes: unrelated markdown in `docs/` failing Jekyll (fix: keep `.nojekyll`), unsupported filename in `docs/` subdirectories (rename or move), or Pages disabled (re-run Phase 6).

## Defaults and conventions

- **Output path**: `docs/index.html` (Pages source = `main` branch `/docs` folder).
- **Design tokens**: Whatever Stitch generates. Don't second-guess the palette — Stitch's defaults are good and consistent with developer-tool aesthetics. Tweak only if the user has a brand book.
- **Font pairing**: JetBrains Mono (headlines, mono content) + Inter (body) for developer tools; Stitch picks others (Manrope, Space Grotesk) for consumer apps — keep whatever Stitch picks.
- **Tailwind**: CDN is fine for landing pages — first-paint cost is ~50 KB and Pages serves it gzipped. Don't introduce a build step unless the user asks.
- **Tracking**: Use `omc ultragoal` (or `TaskCreate`) for the 4-story plan: Design / Build / Host / Push. Helps survive session restarts on large work.

## Common pitfalls

- **Stitch timeout on first generation** — expected. The tool docstring says explicitly not to retry. Poll `list_screens` instead. If you call `generate_screen_from_text` a second time on the same project, it adds a section to the existing screen (it doesn't restart) — handy for iteration, harmful if you wanted a fresh start.
- **Base64-bloated Stitch HTML** — Stitch inlines PNG wordmarks and screenshots as base64. Don't ship verbatim; use as structural reference + token source only.
- **Heredoc-in-`$()` blocked** — some environments (e.g. bkit ENH-310 guard) block `git commit -m "$(cat <<EOF ... EOF)"`. Write the commit message to a file and use `git commit -F file.txt` instead.
- **Push-to-main blocked** — auto-mode classifiers commonly deny direct pushes to default branches. Always confirm via AskUserQuestion; offer the PR fallback.
- **Pages 404 for ~30s after first enable** — the very first Pages build can take 20-60 seconds. Don't panic on 404 before the build finishes; check `gh api .../pages/builds/latest` first.
- **`.nojekyll` is critical** — without it, files starting with `_` in `docs/` are silently dropped. The file is empty; just `touch` it.

## Deliverables

- `docs/index.html` — production landing page (~25-30K).
- `docs/.nojekyll` — empty file disabling Jekyll.
- Pages enabled, homepage set, commit pushed, live URL serving HTTP 200.
- Optional: an `omc ultragoal` plan with all four stories checkpointed complete + quality-gate JSON.

See `scripts/run-flow.sh` for a one-shot orchestrator and `examples/oh-my-symphony/` for a full reference deliverable.
