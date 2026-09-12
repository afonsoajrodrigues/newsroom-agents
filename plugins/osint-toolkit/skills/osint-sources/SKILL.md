---
name: osint-sources
description: Map of free open-source investigation tools by task (reverse image search, geolocation, archives, domains, social media, transport, sanctions) with what each is good for. Use when choosing a tool for a verification step.
user-invocable: false
---

# OSINT tool map

Free unless noted. Bellingcat's full directory: https://bellingcat.gitbook.io/toolkit. GIJN resource centre: https://gijn.org/resource/.

## Reverse image and video
- Google Lens https://lens.google.com, Yandex Images https://yandex.com/images (best for faces and Eastern Europe), TinEye https://tineye.com (oldest-first sort shows origin), Bing Visual Search.
- InVID/WeVerify browser plugin: keyframe extraction, magnifier, metadata.
- Metadata: `exiftool` locally. Platforms strip EXIF; absence means nothing.

## Geolocation
- Google Maps / Earth (historical imagery in Earth Pro), OpenStreetMap https://www.openstreetmap.org, Mapillary https://mapillary.com (street-level imagery), Sentinel Hub https://apps.sentinel-hub.com (recent satellite passes), GeoHints https://geohints.com (plates, poles, bollards by country), SunCalc https://www.suncalc.org (shadow direction for date/time), PeakVisor for mountain skylines.

## Archives
- Wayback Machine https://web.archive.org (save: `https://web.archive.org/save/<URL>`), archive.today https://archive.ph (for pages that block Wayback). Check both before declaring a page gone. Use the `web-archiver` agent to preserve evidence.

## Domains and infrastructure
- WHOIS https://www.whois.com, DomainTools https://whois.domaintools.com; certificate transparency https://crt.sh/?q=<domain> (subdomains, history); urlscan.io https://urlscan.io (what a page loads); DNSDumpster https://dnsdumpster.com; VirusTotal https://www.virustotal.com (passive DNS, related files).

## Social media
- Platform-native operators: `from:`, `since:`/`until:` or `before:`/`after:`, `site:`. Wayback snapshots of profile pages for handle and bio history. Username reuse across platforms: WhatsMyName https://whatsmyname.app (public profiles only).

## People and entities (public roles)
- Wikidata https://www.wikidata.org; OpenSanctions https://www.opensanctions.org (sanctions and PEP lists); EU Sanctions Map https://www.sanctionsmap.eu; OpenCorporates https://opencorporates.com; ICIJ Offshore Leaks https://offshoreleaks.icij.org; OCCRP Aleph https://aleph.occrp.org (free account).

## Transport
- Flightradar24, FlightAware, ADS-B Exchange (unfiltered); MarineTraffic, VesselFinder. Historical tracks usually paid.

## Rules of the desk
- Public data only. No logins that are not the reporter's own, no scraping behind authentication, no bypassing blocks.
- Archive before you cite. Log the tool used and the date for every finding.
