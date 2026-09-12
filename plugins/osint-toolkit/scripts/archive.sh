#!/usr/bin/env bash
# archive.sh <URL> [out_dir]  — preserve a web page as evidence.
# Saves a local copy, its sha256, and requests a Wayback Machine snapshot.
# ponytail: Wayback only; add archive.ph if Wayback is blocked for a site.
set -euo pipefail
url="${1:?usage: archive.sh <URL> [out_dir]}"
out="${2:-archive}"
mkdir -p "$out"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
slug="$(printf '%s' "$url" | sed -E 's#^https?://##; s#[^A-Za-z0-9._-]+#_#g' | cut -c1-80)"
local_file="$out/${stamp}_${slug}.html"

curl -sL --max-time 60 -A "Mozilla/5.0 (newsroom-agents archive.sh)" "$url" -o "$local_file"
sha="$(shasum -a 256 "$local_file" | cut -d' ' -f1)"

wayback="$(curl -s -o /dev/null -D - --max-time 120 -A "Mozilla/5.0 (newsroom-agents archive.sh)" "https://web.archive.org/save/$url" \
  | awk 'tolower($1)=="content-location:" || tolower($1)=="location:" {print $2}' | tr -d '\r' | tail -1)"
case "$wayback" in
  /web/*) wayback="https://web.archive.org$wayback" ;;
  http*) ;;
  *) # save failed or Wayback is down: report the latest existing snapshot, if any
     latest="$(curl -s --max-time 30 "https://archive.org/wayback/available?url=$url" | sed -n 's/.*"url": *"\([^"]*\)".*/\1/p')"
     wayback="${latest:+latest existing snapshot: $latest; }save not confirmed, retry https://web.archive.org/save/$url or https://archive.ph" ;;
esac

printf '%s\t%s\t%s\t%s\t%s\n' "$stamp" "$url" "$local_file" "$sha" "$wayback" >> "$out/archive-log.tsv"
echo "url:      $url"
echo "saved:    $local_file"
echo "sha256:   $sha"
echo "wayback:  $wayback"
echo "logged:   $out/archive-log.tsv"
