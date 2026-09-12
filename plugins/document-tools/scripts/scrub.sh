#!/usr/bin/env bash
# scrub.sh <file> [out_dir] — copy a file with its metadata removed before it is shared or published
# (author names, GPS, device, software, edit history in images, PDFs and Office files). Needs exiftool.
# ponytail: exiftool only. PDFs keep their XMP history in older revisions; for a hostile reader, print to PDF or rasterise.
set -euo pipefail
in="${1:?usage: scrub.sh <file> [out_dir]}"; out="${2:-scrubbed}"
command -v exiftool >/dev/null || { echo "exiftool not found (brew install exiftool / apt install libimage-exiftool-perl)" >&2; exit 2; }
mkdir -p "$out"
dest="$out/$(basename "$in")"
exiftool -all= -overwrite_original -q -o "$dest" "$in" 2>/dev/null || cp "$in" "$dest"
left="$(exiftool -s -s -s -Author -Creator -Producer -GPSLatitude -GPSLongitude -Artist -XPAuthor -Software -CreatorTool "$dest" 2>/dev/null | grep -v '^$' || true)"
echo "scrubbed: $dest"
[ -z "$left" ] || { echo "still present (check by hand):"; echo "$left"; }
