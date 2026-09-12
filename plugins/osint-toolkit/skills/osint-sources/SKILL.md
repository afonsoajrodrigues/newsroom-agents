---
name: osint-sources
description: Map of free open-source investigation tools by task (reverse image search, geolocation, archives, domains, social media, transport, sanctions) with what each is good for. Use when choosing a tool for a verification step.
user-invocable: false
---

# OSINT tool map

Free, no API keys. URLs checked 2026-09-12. `browser` marks sites that block curl/WebFetch (Cloudflare, JS apps): use the Claude in Chrome tools. Bellingcat's full directory: https://bellingcat.gitbook.io/toolkit. GIJN resource centre: https://gijn.org/resource/ (browser).

## Reverse image and video
- Google Lens https://lens.google.com, Yandex Images https://yandex.com/images (best for faces and Eastern Europe), TinEye https://tineye.com (oldest-first sort shows origin), Bing Visual Search.
- InVID/WeVerify browser plugin: keyframe extraction, magnifier, metadata.
- Metadata: `exiftool` locally. Platforms strip EXIF; absence means nothing.

## Geolocation
- Google Maps / Earth (historical imagery in Earth Pro), OpenStreetMap https://www.openstreetmap.org, Mapillary https://www.mapillary.com/app/ (street-level imagery, browser), GeoHints https://geohints.com (plates, poles, bollards by country), SunCalc https://www.suncalc.org (shadow direction for date/time), PeakVisor for mountain skylines.
- Satellite without an account: NASA Worldview https://worldview.earthdata.nasa.gov (daily MODIS/VIIRS, fires, smoke); Copernicus Browser https://browser.dataspace.copernicus.eu (Sentinel-2 at 10 m, free login for downloads); Sentinel Hub EO Browser https://apps.sentinel-hub.com needs a free account.
- Geocoding and features from OSM, no key: Nominatim `https://nominatim.openstreetmap.org/search?q=<place>&format=json` (send a descriptive User-Agent, one request per second) and the Overpass API https://overpass-api.de/api/interpreter for "every X within this bounding box" queries. Portuguese postal codes and parishes: https://json.geoapi.pt/cp/<código postal>.
- Weather on the claimed date: Open-Meteo historical archive `https://archive-api.open-meteo.com/v1/archive?latitude=<lat>&longitude=<lon>&start_date=<YYYY-MM-DD>&end_date=<YYYY-MM-DD>&daily=precipitation_sum,temperature_2m_max,wind_speed_10m_max` (JSON, no key, worldwide from 1940); IPMA open data https://api.ipma.pt/open-data/ for Portuguese forecasts and warnings.

## Archives
- Wayback Machine https://web.archive.org (save: `https://web.archive.org/save/<URL>`; all captures of a URL: `https://web.archive.org/cdx/search/cdx?url=<URL>&output=json`, add `&matchType=prefix` for a whole site section), archive.today https://archive.ph (for pages that block Wayback, manual submission).
- Arquivo.pt https://arquivo.pt, the Portuguese web archive since 1996: full text `https://arquivo.pt/textsearch?q=<terms>&maxItems=20`, captures `https://arquivo.pt/wayback/cdx?url=<url>&output=json`, replay `https://arquivo.pt/wayback/<timestamp>/<url>`. Often has .pt pages and old profile pages Wayback lacks.
- Check all three before declaring a page gone. Use the `web-archiver` agent to preserve evidence.

## Domains and infrastructure
- WHOIS https://www.whois.com, DomainTools https://whois.domaintools.com; .pt domains at the registry https://www.pt.pt/pt/ferramentas/whois/; certificate transparency https://crt.sh/?q=<domain>&output=json (subdomains, history; occasionally returns 502, retry); urlscan.io https://urlscan.io (what a page loads; search API without key: `https://urlscan.io/api/v1/search/?q=domain:<domain>`); DNSDumpster https://dnsdumpster.com; VirusTotal https://www.virustotal.com (passive DNS, related files).

## Social media
- Platform-native operators: `from:`, `since:`/`until:` or `before:`/`after:`, `site:`. Wayback snapshots of profile pages for handle and bio history. Username reuse across platforms: WhatsMyName https://whatsmyname.app (public profiles only).

## People and entities (public roles)
- Wikidata https://www.wikidata.org (SPARQL endpoint https://query.wikidata.org/sparql, no key); OpenSanctions https://www.opensanctions.org (web search free; the JSON API needs a key; bulk datasets free, listed at https://www.opensanctions.org/datasets/ and downloadable as `https://data.opensanctions.org/datasets/latest/<dataset>/index.json`); EU Sanctions Map https://www.sanctionsmap.eu (JSON at /api/v1/regime); GLEIF https://api.gleif.org/api/v1/lei-records?filter[entity.legalName]=<name> (company identifiers and parents, no key); OpenCorporates https://opencorporates.com (browser, captcha on curl); ICIJ Offshore Leaks https://offshoreleaks.icij.org (browser for search; full CSV download at /pages/database); OCCRP Aleph https://aleph.occrp.org (free account).

## Transport
- Flightradar24, FlightAware, ADS-B Exchange (unfiltered); OpenSky Network live states without key `https://opensky-network.org/api/states/all?lamin=&lomin=&lamax=&lomax=` (history needs a free account); MarineTraffic, VesselFinder. Historical tracks usually paid.

## Rules of the desk
- Public data only. No logins that are not the reporter's own, no scraping behind authentication, no bypassing blocks.
- Archive before you cite. Log the tool used and the date for every finding.
