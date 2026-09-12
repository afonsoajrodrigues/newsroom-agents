#!/usr/bin/env bash
# archive.sh <URL> [out_dir]  — preserve a web page as evidence.
# Saves a local copy, its sha256, requests a Wayback Machine snapshot (two attempts), and looks up
# the Portuguese web archive (arquivo.pt) for an existing capture. No API keys.
# ponytail: no archive.ph submission (it has no stable API); the agent reports the manual link when Wayback fails.
set -euo pipefail
url="${1:?usage: archive.sh <URL> [out_dir]}"
out="${2:-archive}"
mkdir -p "$out"
ua="Mozilla/5.0 (newsroom-agents archive.sh)"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
slug="$(printf '%s' "$url" | sed -E 's#^https?://##; s#[^A-Za-z0-9._-]+#_#g' | cut -c1-80)"
local_file="$out/${stamp}_${slug}.html"

curl -sL --max-time 60 -A "$ua" "$url" -o "$local_file"
sha="$(shasum -a 256 "$local_file" | cut -d' ' -f1)"

save_once() {
  curl -s -o /dev/null -D - --max-time 120 -A "$ua" "https://web.archive.org/save/$url" \
    | awk 'tolower($1)=="content-location:" || tolower($1)=="location:" {print $2}' | tr -d '\r' | tail -1
}
wayback="$(save_once)"; [ -n "$wayback" ] || { sleep 5; wayback="$(save_once)"; }
case "$wayback" in
  /web/*) wayback="https://web.archive.org$wayback" ;;
  http*) ;;
  *) # save failed or Wayback is rate-limiting: report the latest existing snapshot from the CDX index
     latest="$(curl -s --max-time 30 "https://web.archive.org/cdx/search/cdx?url=$url&limit=-1&fl=timestamp,original" | awk '{print "https://web.archive.org/web/"$1"/"$2}' || true)"
     wayback="${latest:+latest existing snapshot: $latest; }save not confirmed, retry https://web.archive.org/save/$url or submit at https://archive.ph" ;;
esac

# arquivo.pt keeps its own captures of .pt sites (from 1996); record the newest capture of the last two years, if any
since="$(( $(date -u +%Y) - 2 ))"
arquivo="$(curl -s --max-time 60 "https://arquivo.pt/wayback/cdx?url=$url&from=$since&output=json" | sed -n 's/.*"timestamp": *"\([0-9]*\)".*"url": *"\([^"]*\)".*/https:\/\/arquivo.pt\/wayback\/\1\/\2/p' | tail -1 || true)"

printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$stamp" "$url" "$local_file" "$sha" "$wayback" "${arquivo:-none}" >> "$out/archive-log.tsv"
echo "url:        $url"
echo "saved:      $local_file"
echo "sha256:     $sha"
echo "wayback:    $wayback"
echo "arquivo.pt: ${arquivo:-no capture}"
echo "logged:     $out/archive-log.tsv"
