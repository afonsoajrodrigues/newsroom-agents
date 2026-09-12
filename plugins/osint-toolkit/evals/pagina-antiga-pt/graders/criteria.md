---
type: llm
weight: 1
---

The response must name both the Wayback Machine (web.archive.org) and Arquivo.pt (arquivo.pt), the Portuguese web archive, as places to look for old captures, and must say to preserve the evidence with the plugin's archive.sh script or the web-archiver agent (local copy, sha256, archive links, log line). Mentioning archive.ph as a third option is fine. It must be in Portuguese. Fail if Arquivo.pt is missing, if it suggests accessing anything behind a login, or if it invents a URL that is not on web.archive.org, arquivo.pt or archive.ph.
