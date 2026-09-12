# Changelog

## 2.2.0 (2026-09-13)

- `pt-public-records/scripts/base-summary.py`: pulls every Portal BASE contract for an entity or supplier (date-filtered, 50 per request), writes `contratos.csv` and `resumo.md` (by year, by procedure, top awardees, direct-award counts); `--details` adds NIFs, CPV and the direct-award justification per contract. Self-test in `check.sh`.
- `newsroom-core`: PostToolUse hook that appends every WebFetch URL to `investigations/access-log.tsv`, a provenance trail behind the evidence log.
- `newsroom-graphics/scripts/render-check.mjs --svg` now writes a self-contained SVG (page CSS inlined, light tokens resolved) usable in a README or CMS; the map template accepts GeoJSON as well as TopoJSON.
- `examples/`: two graphics built end to end from real public data (Lisbon council contracts 2025; direct-award share across Madeira's municipalities) with reproducible data prep; both run through `render-check.mjs` in `check.sh`.
- `scripts/check.sh` runs without the Claude CLI (CI), syntax-checks every script, self-tests `base-summary.py` and the PDF hook; GitHub Actions workflow added.
- `README.pt.md` in Portuguese; every agent description carries Portuguese trigger phrases so routing works for reporters typing in Portuguese.
- `/pt-public-records:base-summary <entity>` command wrapping `base-summary.py`.
- `document-tools/scripts/scrub.sh`: metadata removal (exiftool) for files before they are shared, with a report of what could not be stripped.
- `examples/investigation-skeleton/`: the case folder with real evidence rows.
- `scripts/smoke.sh` (end-to-end run through a non-interactive Claude session) and `evals/` cases for pt-public-records, fact-check and osint-toolkit for `claude plugin eval`.
- Install path tested against GitHub for all seven plugins; token cost documented (about 4 300 always-on tokens for all seven).

## 2.1.0 (2026-09-12)

- Every source URL fetched and checked; wrong ones fixed (ECFP, EU Transparency Register, Citius, DGAL, CAOP landing, AT debtor list, whois .pt, OpenSanctions bulk).
- `pt-sources`: DGSI search URLs per court, and free keyless APIs (INE, Eurostat, BPstat, dados.gov.pt, TED, SNS Transparência, GLEIF, Wikidata, geoapi.pt, Wayback CDX, Arquivo.pt, urlscan, OpenSky, EU Sanctions Map, Open-Meteo, IPMA, Nominatim, Overpass); every entry marked fetch / browser / POST.
- `pt-public-records/scripts/base-search.sh`: Portal BASE JSON (contracts, announcements, entities, full record).
- `scripts/check-sources.sh`: fetches every cited URL and lists non-200s.
- Fixed: `render-check.mjs` could not install jsdom (npm rejected the dot-directory name); `archive.sh` Wayback save and fallback; `pdf2md.py` error for PDFs without a text layer.

## 2.0.0 (2026-09-12)

- Rebuilt as a validated marketplace with seven plugins, including `newsroom-graphics`.
