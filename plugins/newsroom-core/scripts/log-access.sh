#!/usr/bin/env bash
# PostToolUse hook: append every WebFetch URL to investigations/access-log.tsv (date, URL) when an
# investigations/ folder exists in the working directory. Gives the evidence log a provenance trail
# of everything that was consulted, whether or not it ended up cited. Silent otherwise.
[ -d investigations ] || exit 0
url="$(cat | sed -n 's/.*"url"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
[ -n "$url" ] || exit 0
printf '%s\t%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$url" >> investigations/access-log.tsv
exit 0
