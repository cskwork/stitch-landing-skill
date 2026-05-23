# Stitch design-prompt template

This is the prompt template the skill feeds to `mcp__stitch__generate_screen_from_text` when generating developer-tool landing pages. Substitute the bracketed fields before sending.

```text
Landing page for "[PROJECT_NAME]" — [ONE_LINE_POSITIONING].

VISUAL STYLE: [terminal-inspired dark / clean minimal light / consumer-soft / brutalist — pick one]. Background [#PRIMARY_BG], primary accent [#PRIMARY_ACCENT] for CTAs and highlights, secondary accent [#SECONDARY_ACCENT] for success / multi-state, gray text [#TEXT_MUTED]. [Monospace JetBrains Mono | Inter | Manrope] for headlines; [Inter] for body. Sharp 4px corners, no rounded pills. Confident, technical, [hacker-IDE | productivity-app | API-docs] aesthetic.

Sections (top to bottom):

1. NAV: "[WORDMARK]" left; [link list] right; primary CTA "[CTA_LABEL]" in [#PRIMARY_ACCENT] right-aligned.

2. HERO: Mono headline "[HERO_HEADLINE]". Subhead "[SUBHEAD]". Below: [a wide screenshot of the actual product — describe what it should show, including labels, indicators, and chrome]. Two buttons: "[PRIMARY_CTA]" (amber filled), "[SECONDARY_CTA]" (outline).

3. FEATURES grid (3 columns × 2 rows, 6 cards): [list the 6 features verbatim from README — name + one-line description for each].

4. QUICKSTART: Split layout. Left = "[QUICKSTART_TITLE]" with 3 numbered steps. Right = a dark terminal block showing [$ commands with prompts].

5. [DOMAIN_SPECIFIC_TABLE]: A clean comparison table — [describe the rows and columns specific to this project, e.g. "rows = supported integrations, columns = transport, auth method, latency"].

6. SOCIAL PROOF: [Optional — only include if README has badges, stars, prior art, or recognizable forks].

7. CTA SECTION: Centered "[FINAL_CTA_HEADLINE]" with two buttons — "[PRIMARY_CTA]" filled, "[SECONDARY_CTA]" outlined.

8. FOOTER: Three columns — Project (README, Changelog, License), Community (GitHub, Issues, Discussions), Built with (key dependencies). Bottom row: "[LICENSE] · [OWNER]/[REPO]".

Make it feel inevitable for the target audience: [PRIMARY_PERSONA], [SECONDARY_PERSONA], [TERTIARY_PERSONA]. Confident, technical, no marketing fluff.
```

## Field cheatsheet

| Field                          | Where to find it                                                            |
| ------------------------------ | --------------------------------------------------------------------------- |
| `[PROJECT_NAME]`               | README H1                                                                   |
| `[ONE_LINE_POSITIONING]`       | README's first blockquote, or the "Why" subhead                             |
| `[HERO_HEADLINE]`              | Often the README tagline restated; should be ≤ 12 words                     |
| `[SUBHEAD]`                    | The sentence right after the tagline                                        |
| `[PRIMARY_BG / ACCENTS]`       | Pick from project's logo or existing brand. Default dev-tool: see palette   |
| `[6 features]`                 | "Why X?" bullets or "Features" section in README                            |
| `[QUICKSTART commands]`        | "Quickstart" or "Installation" section                                      |
| `[DOMAIN_SPECIFIC_TABLE]`      | Skip if no comparison data exists                                           |
| `[PERSONAS]`                   | "Who is this for?" section if present, else infer from features             |

## Default developer-tool palette

If the project doesn't have brand colors, use Stitch's "Symphony Orchestrator"-style developer palette:

- Background `#0B0E14`
- Card / container `#151921` with `#272D38` border
- Primary accent (CTAs, prompts) `#FFB454` amber
- Secondary accent (success, multi-state) `#7FD1B9` teal
- Body text `#BFBDB6` / `#E5E2DB`
- Mono `JetBrains Mono`, body `Inter`

This palette works well for orchestrators, CLIs, monitors, terminal apps, and infra tools. Switch to a lighter theme for SaaS / API products and consumer apps.

## Sizing notes

- Stitch `GEMINI_3_FLASH` returns in ~60-120 seconds and produces good first-pass layouts.
- Stitch `GEMINI_3_1_PRO` is slower (~120-300s) but handles long prompts (3-4 sections + 6 cards + table) more reliably.
- Keep the prompt under ~1500 words. Beyond that Stitch tends to drop later sections.
