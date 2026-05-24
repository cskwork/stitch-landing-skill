# Changelog - 2026-05-24

## GitHub Pages 404 recovery

- Added a static `docs/index.html` landing page so GitHub Pages has an entrypoint for `https://cskwork.github.io/stitch-landing-skill/`.
- Added `docs/.nojekyll` because this repo uses the documented `main` + `/docs` Pages source and should serve static files without Jekyll processing.
- Kept the fix static and dependency-free beyond fonts because the user requested a 404 repair, not a new app build pipeline.
