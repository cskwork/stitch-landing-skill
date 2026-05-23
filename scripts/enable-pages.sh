#!/usr/bin/env bash
# enable-pages.sh — enable GitHub Pages on main /docs and set homepage URL.
#
# Usage:
#   ./scripts/enable-pages.sh <owner>/<repo>
#
# Idempotent: if Pages is already enabled, skips the POST and just patches the homepage.
set -euo pipefail

repo="${1:-}"
if [[ -z "$repo" ]]; then
  echo "usage: $0 <owner>/<repo>" >&2
  exit 2
fi

owner="${repo%%/*}"
name="${repo##*/}"
url="https://${owner}.github.io/${name}/"

existing=$(gh api "repos/${repo}/pages" 2>/dev/null || echo "")

if [[ -z "$existing" ]]; then
  echo "[enable-pages] Pages not yet enabled — POST /pages with main:/docs"
  gh api -X POST "repos/${repo}/pages" \
    -f 'source[branch]=main' \
    -f 'source[path]=/docs' \
    --jq '{html_url, source, status}'
else
  echo "[enable-pages] Pages already enabled:"
  echo "$existing" | gh api --include - 2>/dev/null || echo "$existing"
fi

echo
echo "[enable-pages] PATCH repo homepage to ${url}"
gh api -X PATCH "repos/${repo}" -f "homepage=${url}" --jq '.homepage'
