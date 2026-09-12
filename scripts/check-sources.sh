#!/usr/bin/env bash
# Fetches every URL cited in the plugins' skills and agents and lists the ones that do not answer 200.
# Network-dependent, so it is separate from check.sh. A 403 or 000 from curl often means the site
# blocks automated clients (use the browser), not that it is dead; 405/406 means the endpoint wants POST or
# a query body (TED, Overpass). Check by hand before editing the directory.
set -uo pipefail
cd "$(dirname "$0")/.."
ua="Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0 Safari/537.36"
grep -ohE 'https?://[^ )`"]+' plugins/*/skills/*/SKILL.md plugins/*/agents/*.md README.md \
  | sed -E 's/[].,;:]+$//' | grep -v '[<>]' | sort -u \
  | xargs -P 16 -n1 sh -c 'printf "%s %s\n" "$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 30 -A "'"$ua"'" "$0")" "$0"' \
  | sort > "${TMPDIR:-/tmp}/check-sources.txt"
total=$(wc -l < "${TMPDIR:-/tmp}/check-sources.txt")
bad=$(grep -vc '^200 ' "${TMPDIR:-/tmp}/check-sources.txt")
grep -v '^200 ' "${TMPDIR:-/tmp}/check-sources.txt"
echo "$total URLs checked, $bad not 200"
