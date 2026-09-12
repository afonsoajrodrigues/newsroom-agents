#!/usr/bin/env bash
# Validates the marketplace and every plugin; fails on the first error.
set -euo pipefail
cd "$(dirname "$0")/.."
claude plugin validate . --strict
for p in plugins/*/; do claude plugin validate "$p" --strict; done
# every agent/skill has the frontmatter fields routing depends on
for f in plugins/*/agents/*.md plugins/*/skills/*/SKILL.md; do
  for key in name description; do
    grep -q "^$key:" "$f" || { echo "missing '$key:' in $f"; exit 1; }
  done
done
# marketplace entries point at real plugin dirs
for src in $(jq -r '.plugins[].source' .claude-plugin/marketplace.json); do
  [ -f "$src/.claude-plugin/plugin.json" ] || { echo "marketplace source missing: $src"; exit 1; }
done
# graphics templates must execute and pass the desk rules (needs node; jsdom is installed into .render-check on first run)
if command -v node >/dev/null; then
  tmp="$(mktemp -d)"; mkdir -p "$tmp/map/data"
  cp plugins/newsroom-graphics/skills/new-graphic/template.html "$tmp/index.html"
  cp plugins/newsroom-graphics/skills/new-graphic/map-template.html "$tmp/map/index.html"
  cp plugins/newsroom-graphics/skills/new-graphic/sample-boundaries.json "$tmp/map/data/boundaries.json"
  node plugins/newsroom-graphics/scripts/render-check.mjs "$tmp/index.html" | tail -1
  node plugins/newsroom-graphics/scripts/render-check.mjs "$tmp/map/index.html" | tail -1
  rm -rf "$tmp"
fi
echo "all checks passed"
