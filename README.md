# Newsroom Agents

[![check](https://github.com/afonsoajrodrigues/newsroom-agents/actions/workflows/check.yml/badge.svg)](https://github.com/afonsoajrodrigues/newsroom-agents/actions/workflows/check.yml)
[Versão em português](README.pt.md)

Claude Code plugins that turn Claude into an investigative desk: an orchestrator that plans a story and keeps the evidence log, and specialists for Portuguese public records, open-source research, fact-checking, corporate and offshore research, document processing, and publication-quality charts and maps. Every source is free and needs no API key. Every agent works to newsroom standards: primary sources, an evidence log with access dates and archives, explicit confidence ratings, right of reply, and hard limits on privacy.

Two things it produced from real public data, end to end, on 2026-09-12:

| [Contracts of the Lisbon city council in 2025](examples/lisboa-contratos-2025/) | [Direct-award share across Madeira's municipalities](examples/madeira-ajustes-diretos-2025/) |
|---|---|
| ![Grouped bar chart: direct awards are 66.5 percent of contracts and 14.6 percent of value; open tenders 14.2 percent of contracts and 66.9 percent of value](examples/lisboa-contratos-2025/grafico.svg) | ![Choropleth of Madeira municipalities: direct awards weigh from 4 percent of contracted value in Santa Cruz to 44 percent in Porto Moniz](examples/madeira-ajustes-diretos-2025/mapa.svg) |
| 1067 contracts pulled from Portal BASE with `base-summary.py`, aggregated, charted from the desk template, checked by `render-check.mjs`. | Official CAOP boundaries through `geo-prep.py`, 11 councils' contracts pulled from Portal BASE, joined on INE codes, mapped from the desk template. |

## Install

```
/plugin marketplace add afonsoajrodrigues/newsroom-agents
/plugin install newsroom-core@newsroom-agents
/plugin install pt-public-records@newsroom-agents
/plugin install newsroom-graphics@newsroom-agents
/plugin install osint-toolkit@newsroom-agents
/plugin install fact-check@newsroom-agents
/plugin install financial-corporate@newsroom-agents
/plugin install document-tools@newsroom-agents
```

Each plugin works on its own. `newsroom-core` is the one to start with; it knows how to use the others when they are installed. Installing all seven adds about 4 300 tokens to a session (`claude plugin details <plugin>@newsroom-agents`); an agent's full prompt loads only when it fires. The install path above was tested against this repository on 2026-09-13.

## What you get

| Plugin | Agents | Commands, skills and scripts |
|---|---|---|
| `newsroom-core` | `investigation-lead` (plans, delegates, keeps the evidence log), `timeline-builder`, `data-analyst`, `prepublication-reviewer` | `/newsroom-core:start-investigation <slug>` scaffolds a case folder; `evidence-log` conventions; a hook that logs every URL fetched to `investigations/access-log.tsv` |
| `pt-public-records` | `diario-republica-researcher`, `court-records-pt`, `procurement-watchdog`, `transparency-registers` | `/pt-public-records:lada-request <entity> <docs>` drafts a Lei 26/2016 request; `/pt-public-records:base-summary <entity>` pulls an entity's or supplier's contracts into CSV plus summary; `pt-sources`, a verified directory of 60+ Portuguese sources with their free endpoints and DGSI search URLs; `base-search.sh` queries Portal BASE as JSON; `base-summary.py` pulls an entity's whole contract record into CSV plus a summary |
| `newsroom-graphics` | `chart-builder` (D3 charts), `map-builder` (choropleth, symbols, locator maps with CAOP boundaries), `graphics-reviewer` | `/newsroom-graphics:new-graphic <slug> [chart\|map]` scaffolds from tested templates; `viz-standards` (validated colorblind-safe palette, pt-PT formats, checklist) and `pt-geodata` skills; `geo-prep.py` (any vector file to simplified TopoJSON); `render-check.mjs` (executes the graphic in jsdom, checks the desk rules, exports a self-contained SVG) |
| `osint-toolkit` | `osint-researcher`, `image-geolocation`, `social-media-investigator`, `web-archiver` | `osint-sources` tool map; `archive.sh` saves a page, hashes it, requests a Wayback snapshot and looks up Arquivo.pt |
| `fact-check` | `claim-verifier`, `source-triangulator` | `verification-standards`: shared confidence scale and source-independence test |
| `financial-corporate` | `corporate-structure-mapper`, `offshore-leaks-researcher` | `company-sources`: who owns and runs a company, in the order that works (NIF first, Publicações MJ, RCBE), plus GLEIF, Companies House, ICIJ, OpenSanctions |
| `document-tools` | `pdf-archivist` | `pdf2md.py` cached PDF to Markdown with OCR fallback; `scrub.sh` strips metadata from files before they are shared; a hook that blocks reading PDFs directly |

## A typical investigation

```
/newsroom-core:start-investigation camara-x-contratos "A Câmara X adjudicou por ajuste direto a uma empresa ligada a um vereador"
```

Then describe the story to Claude. The `investigation-lead` restates the hypothesis as a checkable claim, writes a research plan, and dispatches: `procurement-watchdog` pulls the contracts from Portal BASE, `corporate-structure-mapper` maps the company through GLEIF and Publicações MJ, `transparency-registers` finds the councillor's declaration of interests, `web-archiver` preserves every page, `timeline-builder` orders the events, `chart-builder` and `map-builder` turn the contract data into a bar chart and a municipality map, and `prepublication-reviewer` lists every unsupported sentence and everyone still owed a right of reply. Everything lands in `investigations/<slug>/evidence-log.md`, and every URL any agent touched is in `investigations/access-log.tsv`. [`examples/investigation-skeleton/`](examples/investigation-skeleton/) shows the folder with real rows filled in.

You can also just ask in plain language, in Portuguese or English:

> "Verifica se esta foto do protesto foi mesmo tirada em Lisboa esta semana"

Claude routes the task to `image-geolocation` from its description; every agent description carries the Portuguese phrases reporters actually type. To force a specialist: "usa o agente court-records-pt".

## Sources, verified

Every URL and endpoint cited in the plugins was fetched and checked on 2026-09-12, and `scripts/check-sources.sh` re-checks them. No API keys, no paid services. JSON endpoints the agents call directly: Portal BASE (through `base-search.sh`, because it only answers POST), dados.gov.pt, INE, Eurostat, Banco de Portugal BPstat, TED, SNS Transparência, GLEIF, Wikidata, geoapi.pt, Wayback CDX, Arquivo.pt, Open-Meteo, urlscan, OpenSky, EU Sanctions Map. DGSI case law is searched by URL, one database per court, with the view ids in `pt-sources`.

Some sites are JavaScript apps or block automated clients (Diário da República, Publicações MJ, OpenCorporates, ICIJ search, Mais Transparência): the source directory marks them `browser`, and the agents use the Claude in Chrome tools for those. OCCRP Aleph needs a free account. RCBE (beneficial ownership) requires the reporter to log in with Cartão de Cidadão and state a legitimate interest, which investigative journalists have under EU law.

## Requirements

- Claude Code 2.1 or later.
- `pt-public-records`: `curl` and `jq` (for `base-search.sh`); Python 3 for `base-summary.py`.
- `document-tools`: Python 3; the script installs `pymupdf4llm` on first use. For scanned PDFs install `ocrmypdf` (`brew install ocrmypdf`).
- `newsroom-graphics`: Node 18+ for `render-check.mjs` (installs `jsdom` into the plugin data directory on first run, with its own npm cache); Python with `geopandas` and `pyogrio` for `geo-prep.py`, plus `mapshaper` (`npm i -g mapshaper`) for topology-preserving simplification. Graphics themselves are standalone HTML loading only pinned D3 from jsdelivr.
- Optional: `exiftool` for image metadata, `ffmpeg` for video keyframes, `pandas` for `data-analyst` (installed into a venv in the case folder).

## Editorial guardrails

Every agent carries explicit limits: public sources only, no access behind logins that are not the reporter's own, no doxxing of private individuals, data patterns and database matches are leads and never proof, every claim gets a source with an access date, and adverse claims get a right of reply before publication. Two rules are enforced by hooks rather than prompts: PDFs always go through the cached Markdown pipeline, and every fetched URL is logged. Editorial and legal review still apply.

## Contributing

Agents are Markdown files with YAML frontmatter under `plugins/<plugin>/agents/`; shared knowledge and commands are `plugins/<plugin>/skills/<name>/SKILL.md`. See `CLAUDE.md` for the conventions and `CHANGELOG.md` for what changed. Run `scripts/check.sh` before opening a pull request (it validates manifests, self-tests the scripts and renders the templates and examples), `scripts/check-sources.sh` when you touch a source URL, `claude plugin eval plugins/<plugin> --trust-plugin --no-publish` for the eval cases under each plugin's `evals/` (seven cases across six plugins, all passing on 2026-09-13: source routing, confidence scale, web archives, map form, evidence-log rows, pre-publication review, company ownership), and `scripts/smoke.sh` for a real end-to-end run (a non-interactive Claude session loads the plugin, the agent pulls Portal BASE through the script, and the answer is compared with an independent computation; it uses API credits). Investigation working files (`investigations/`, `docs_cache/`, PDFs) are gitignored; keep case material out of this repo.

## License

MIT. See `LICENSE`. Example data: Portal BASE (IMPIC) and CAOP 2025 (DGT, CC BY 4.0).
