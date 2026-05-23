# stitch-landing-skill

A Claude Code / Hermes skill that turns any project README into a deployed GitHub Pages landing page in one session, using **Stitch MCP** for the design pass and **Tailwind CDN** for production.

## What it does

```text
Project README + screenshots
        │
        ▼
┌─────────────────────────────────────────────────────────────┐
│  Phase 1  read repo (README, screenshots, license)         │
│  Phase 2  Stitch MCP: create_project + generate_screen     │
│  Phase 3  download + inspect HTML, extract design tokens   │
│  Phase 4  author production docs/index.html (Tailwind CDN) │
│  Phase 5  add docs/.nojekyll                                │
│  Phase 6  gh api: enable Pages on main /docs               │
│  Phase 7  commit + push (with PR fallback)                 │
│  Phase 8  verify: gh pages build, curl live URL            │
└─────────────────────────────────────────────────────────────┘
        │
        ▼
   https://<owner>.github.io/<repo>/ — live in ~60s
```

## Reference deliverable

The skill was extracted from the work that shipped [`cskwork/oh-my-symphony`'s landing page](https://cskwork.github.io/oh-my-symphony/). The full output is checked in at `examples/oh-my-symphony/index.html` so you can see what "production-ready" looks like before you start.

## Install

### Claude Code (user-level)

```bash
git clone https://github.com/cskwork/stitch-landing-skill ~/.claude/skills/stitch-landing
```

Restart Claude Code; trigger by saying "make a landing page for this repo and deploy on GitHub Pages".

### Hermes (category-based layout)

```bash
git clone https://github.com/cskwork/stitch-landing-skill ~/.hermes/skills/productivity/stitch-landing
```

### Codex CLI

The same `SKILL.md` format works for Codex skills. Symlink or `cp -R` into your Codex skills directory.

## Prerequisites

- **Stitch MCP** — install the `stitch.withgoogle.com` MCP server and authenticate. Without it the design phase fails.
- **gh CLI** — `gh auth login` for the target repo's owner.
- **git push access** to the target repo's default branch (or willingness to use a feature branch + PR).

## How it works

`SKILL.md` is the skill body — it documents the 8-phase flow with exact tool calls, defaults, and common pitfalls.

`scripts/` contains optional bash helpers for verification (Pages build polling, live-URL curl). The main flow runs in Claude Code's tool calls, not shell.

`examples/oh-my-symphony/index.html` is the actual landing page produced for the oh-my-symphony repo — useful as a structural reference.

`references/design-prompt-template.md` is the long-form Stitch prompt template the skill uses for developer-tool landing pages.

## Tested with

- Claude Code (Opus 4.7)
- Stitch MCP (`mcp__stitch__*`) — model IDs `GEMINI_3_FLASH` and `GEMINI_3_1_PRO`
- GitHub Pages (legacy build, `main` branch `/docs` folder)

## License

MIT — see `LICENSE`.

## Credits

- Stitch by Google — design generation
- The flow was first sketched in a Claude Code session shipping the [oh-my-symphony](https://github.com/cskwork/oh-my-symphony) landing page on 2026-05-23.
