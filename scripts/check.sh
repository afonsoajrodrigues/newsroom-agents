#!/usr/bin/env bash
# Validates the marketplace and every plugin; fails on the first error.
set -euo pipefail
cd "$(dirname "$0")/.."
if command -v claude >/dev/null; then
  claude plugin validate . --strict
  for p in plugins/*/; do claude plugin validate "$p" --strict; done
else
  echo "claude CLI not found: skipping manifest validation (run this locally before committing)"
  for f in .claude-plugin/marketplace.json plugins/*/.claude-plugin/plugin.json plugins/*/hooks/hooks.json; do jq -e . "$f" >/dev/null || { echo "invalid JSON: $f"; exit 1; }; done
fi
# scripts parse and self-test
for f in plugins/*/scripts/*.sh scripts/*.sh; do bash -n "$f" || exit 1; done
python3 -m py_compile plugins/*/scripts/*.py || exit 1
python3 plugins/pt-public-records/scripts/base-summary.py --selftest
# the PDF hook denies .pdf and stays silent otherwise
echo '{"tool_input":{"file_path":"/x/a.pdf"}}' | bash plugins/document-tools/scripts/block-pdf-read.sh | grep -q '"deny"' || { echo "pdf hook does not deny"; exit 1; }
[ -z "$(echo '{"tool_input":{"file_path":"/x/a.md"}}' | bash plugins/document-tools/scripts/block-pdf-read.sh)" ] || { echo "pdf hook blocks non-PDF"; exit 1; }
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
  for g in examples/*/index.html; do node plugins/newsroom-graphics/scripts/render-check.mjs "$g" | tail -1; done
fi
echo "all checks passed"
