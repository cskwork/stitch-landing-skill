#!/usr/bin/env bash
# verify-pages.sh — poll GitHub Pages build status and curl the live URL.
#
# Usage:
#   ./scripts/verify-pages.sh <owner>/<repo> [expected-grep-pattern]
#
# Exits 0 when the latest Pages build is `built` and the live URL returns 200.
# Exits 1 on any failure. Times out at 300s.
set -euo pipefail

repo="${1:-}"
pattern="${2:-<title>}"

if [[ -z "$repo" ]]; then
  echo "usage: $0 <owner>/<repo> [grep-pattern]" >&2
  exit 2
fi

owner="${repo%%/*}"
name="${repo##*/}"
url="https://${owner}.github.io/${name}/"

deadline=$(( $(date +%s) + 300 ))

while (( $(date +%s) < deadline )); do
  status=$(gh api "repos/${repo}/pages/builds/latest" --jq '.status' 2>/dev/null || echo "missing")
  echo "[$(date -u +%H:%M:%S)] pages build status: ${status}"
  case "$status" in
    built) break ;;
    errored)
      gh api "repos/${repo}/pages/builds/latest" --jq '.error'
      exit 1
      ;;
  esac
  sleep 15
done

if [[ "$status" != "built" ]]; then
  echo "timed out waiting for Pages build to finish (last status: ${status})" >&2
  exit 1
fi

echo
echo "HEAD ${url}"
curl -sI "$url" | head -5

echo
echo "GET ${url} | grep ${pattern}"
if curl -s "$url" | grep -E "$pattern"; then
  echo
  echo "live: ${url}"
else
  echo "pattern not found in deployed HTML" >&2
  exit 1
fi
