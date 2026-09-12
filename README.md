# Newsroom Agents

Claude Code plugins for investigative journalism. An orchestrator that plans a story and delegates to specialists for charts and maps, open-source research, Portuguese public records, fact-checking, corporate and offshore research, and document processing. Every agent is written to newsroom standards: primary sources, an evidence log, explicit confidence ratings, right of reply, and hard limits on privacy.

## Install

```
/plugin marketplace add afonsoajrodrigues/newsroom-agents
/plugin install newsroom-core@newsroom-agents
/plugin install newsroom-graphics@newsroom-agents
/plugin install osint-toolkit@newsroom-agents
/plugin install pt-public-records@newsroom-agents
/plugin install fact-check@newsroom-agents
/plugin install financial-corporate@newsroom-agents
/plugin install document-tools@newsroom-agents
```

Each plugin works on its own. `newsroom-core` is the one to start with; it knows how to use the others when they are installed.

## What you get

| Plugin | Agents | Commands and skills |
|---|---|---|
| `newsroom-core` | `investigation-lead` (plans, delegates, keeps the evidence log), `timeline-builder`, `data-analyst`, `prepublication-reviewer` | `/newsroom-core:start-investigation <slug>` scaffolds a case folder; `evidence-log` conventions |
| `newsroom-graphics` | `chart-builder` (D3 charts), `map-builder` (choropleth, symbols, locator maps with CAOP boundaries), `graphics-reviewer` | `/newsroom-graphics:new-graphic <slug> [chart\|map]` scaffolds from tested templates; `viz-standards` and `pt-geodata` skills; `scripts/geo-prep.py` (any vector file to simplified TopoJSON), `scripts/render-check.mjs` (executes the graphic in jsdom and checks the desk rules) |
| `osint-toolkit` | `osint-researcher`, `image-geolocation`, `social-media-investigator`, `web-archiver` | `osint-sources` tool map; `scripts/archive.sh` saves a page, hashes it, requests a Wayback snapshot and looks up Arquivo.pt |
| `pt-public-records` | `diario-republica-researcher`, `court-records-pt`, `procurement-watchdog`, `transparency-registers` | `/pt-public-records:lada-request <entity> <docs>` drafts a Lei 26/2016 request; `pt-sources` verified source directory with the free APIs and DGSI search URLs; `scripts/base-search.sh` queries Portal BASE contracts, announcements, entities and full contract records as JSON |
| `fact-check` | `claim-verifier`, `source-triangulator` | `verification-standards` shared confidence scale and independence test |
| `financial-corporate` | `corporate-structure-mapper`, `offshore-leaks-researcher` | |
| `document-tools` | `pdf-archivist` | `scripts/pdf2md.py` cached PDF to Markdown; a hook that blocks reading PDFs directly |

## A typical investigation

```
/newsroom-core:start-investigation camara-x-contratos "A Câmara X adjudicou por ajuste direto a uma empresa ligada a um vereador"
```

Then describe the story to Claude. The `investigation-lead` restates the hypothesis as a checkable claim, writes a research plan, and dispatches: `procurement-watchdog` pulls the contracts from Portal BASE, `corporate-structure-mapper` maps the company through Publicações MJ, `transparency-registers` finds the councillor's declaration of interests, `web-archiver` preserves every page, `timeline-builder` orders the events, `chart-builder` and `map-builder` turn the contract data into a bar chart and a municipality map, and `prepublication-reviewer` lists every unsupported sentence and everyone still owed a right of reply. Everything lands in `investigations/<slug>/evidence-log.md`.

You can also just ask in plain language, in Portuguese or English:

> "Verifica se esta foto do protesto foi mesmo tirada em Lisboa esta semana"

Claude routes the task to `image-geolocation` from its description. To force a specialist: "usa o agente court-records-pt".

## Requirements

- Claude Code 2.1 or later.
- No API keys and no paid services. Every source in the plugins was fetched and checked on 2026-09-12; `scripts/check-sources.sh` re-checks them. Free JSON endpoints used directly: Portal BASE (via `base-search.sh`), dados.gov.pt, INE, Eurostat, Banco de Portugal BPstat, TED, SNS Transparência, GLEIF, Wikidata, geoapi.pt, Wayback CDX, Arquivo.pt, Open-Meteo, urlscan, OpenSky, EU Sanctions Map. Some sites (Diário da República, Publicações MJ, OpenCorporates, ICIJ search, Mais Transparência) are JavaScript apps or block automated fetches: the agents know to use the Claude in Chrome browser tools for those. OCCRP Aleph needs a free account. RCBE (beneficial ownership) requires the reporter to log in with Cartão de Cidadão and state a legitimate interest, which investigative journalists have under EU law.
- `document-tools`: Python 3; the script installs `pymupdf4llm` on first use. For scanned PDFs install `ocrmypdf` (`brew install ocrmypdf`).
- `newsroom-graphics`: Node 18+ for `render-check.mjs` (installs `jsdom` into the plugin data directory on first run, with its own npm cache); Python with `geopandas` and `pyogrio` for `geo-prep.py`, plus `mapshaper` (`npm i -g mapshaper`) for topology-preserving simplification. Graphics themselves are standalone HTML loading only pinned D3 from jsdelivr.
- `pt-public-records`: `curl` and `jq` for `base-search.sh`.
- Optional: `exiftool` for image metadata, `ffmpeg` for video keyframes, `pandas` for `data-analyst` (installed into a venv in the case folder).

## Editorial guardrails

Every agent carries explicit limits: public sources only, no access behind logins that are not the reporter's own, no doxxing of private individuals, data patterns and database matches are leads and never proof, every claim gets a source with an access date, and adverse claims get a right of reply before publication. These are prompt-level rules, except the PDF hook, which is enforced. Editorial and legal review still apply.

## Contributing

Agents are Markdown files with YAML frontmatter under `plugins/<plugin>/agents/`; shared knowledge and commands are `plugins/<plugin>/skills/<name>/SKILL.md`. See `CLAUDE.md` for the conventions. Run `scripts/check.sh` before opening a pull request, and `scripts/check-sources.sh` when you touch a source URL. Investigation working files (`investigations/`, `docs_cache/`, PDFs) are gitignored; keep case material out of this repo.

## License

MIT. See `LICENSE`.
