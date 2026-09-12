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
echo "all checks passed"
