---
name: pt-sources
description: Directory of Portuguese public-record sources for investigations - what each holds, the URL, the free API or query URL where one exists, and whether WebFetch can read it or a browser is needed. Use when deciding where to look for a Portuguese law, company, contract, court decision, official's declaration or public dataset.
user-invocable: false
---

# Portuguese public records: where to look

Every URL and endpoint below was fetched and checked on 2026-09-12. None needs an API key or a paid account. Always cite the direct document URL, not the search page.

**Fetchability.** `fetch` = WebFetch or curl returns the content. `browser` = the site is a JavaScript app or blocks automated clients (Cloudflare, captcha): use the Claude in Chrome tools, or WebSearch with `site:` and then open the result in the browser. `POST` = only answers POST requests, so use the script named.

## Official gazette and law
- **Diário da República** https://diariodarepublica.pt (browser). Series I laws and decrees; Series II appointments, exonerations, notices, company acts. Advanced search at /dr/pesquisa-avancada; consolidated law under /dr/legislacao-consolidada. The site is an OutSystems app: WebFetch gets an empty shell. Route: WebSearch `site:diariodarepublica.pt <terms>`, then open the `/dr/detalhe/...` URL in the browser. Detail URLs are stable and are what you cite.
- **dre.tretas.org** https://dre.tretas.org (browser; Cloudflare blocks curl). Full-text mirror with JSON dumps, useful for old material.
- **PGDL** https://www.pgdlisboa.pt/leis/lei_main.php (fetch). Consolidated codes with article-level cross-references.
- **Regional gazettes**: JORAM (Madeira) https://joram.madeira.gov.pt/joram/ (fetch); Jornal Oficial dos Açores https://jo.azores.gov.pt (browser).
- **EUR-Lex** https://eur-lex.europa.eu (fetch) for EU law and infringement decisions.

## Courts
- **DGSI** https://www.dgsi.pt (fetch). Selected decisions of the higher courts. Search by URL, one database per court: `https://www.dgsi.pt/<db>.nsf/<view>?SearchView&Query=<terms>&SearchMax=50`. Verified view ids: STJ `jstj` / `954f0ce6ad9dd8b980256b5f003fa814`; Relação Lisboa `jtrl` / `33182fc732316039802565fa00497eec`; Porto `jtrp` / `56a6e7121657f91e80257cda00381fdf`; Coimbra `jtrc` / `8fe0e606d8f56b22802576c0005637dc`; Évora `jtre` / `134973db04f39bf2802579bf005f080b`; Guimarães `jtrg` / `86c25a698e4e7cb7802579ec004d3832`; STA `jsta` / `35fbbbf22e1bb1e680256f8e003ea931`; TCA Sul `jtca` / `170589492546a7fb802575c3004c6d7d`; TCA Norte `jtcn` / `89d1c0288c2dd49c802575c8003279c7`; Constitucional `jcon` / `35fbbbf22e1bb1e680256f8e003ea931`. Query syntax is Lotus Domino: `"ajuste direto" AND município`. Each hit is an `?OpenDocument` URL to cite. First-instance files are not online.
- **Tribunal Constitucional** https://www.tribunalconstitucional.pt (fetch). Decisions; also hosts the Entidade para a Transparência and the ECFP.
- **Citius, public notices** https://www.citius.mj.pt/portal/consultas/ConsultasCire.aspx (fetch). Insolvency, PER, PEAP and PEVE notices searchable by name or NIF. The case-management portal itself (citius.tribunaisnet.mj.pt) is login-only.
- **Ministério Público** https://www.ministeriopublico.pt (fetch). Press notes after secrecy is lifted.
- **Tribunal de Contas decisions** https://www.tcontas.pt/pt-pt/ProdutosTC/Decisoes/Pages/Decisoes-do-Tribunal-de-Contas.aspx (fetch). Prior-approval (visto) refusals and financial-responsibility rulings; audit reports under /pt-pt/ProdutosTC/Pages/Produtos-do-Tribunal.aspx.
- Ongoing criminal proceedings are under **segredo de justiça** until lifted. Do not imply a file is findable.

## Companies and people
- **Publicações MJ** https://publicacoes.mj.pt/Pesquisa.aspx (browser; ASP.NET form). Statutory company acts: incorporation, share transfers, director changes, dissolutions. Search by name or NIF/NIPC. This is the backbone of any ownership chain.
- **RCBE** https://rcbe.justica.gov.pt (browser, login). Beneficial owners. Since 27 Oct 2025 access requires a stated legitimate interest and Cartão de Cidadão / Chave Móvel Digital; investigative journalists qualify under Directive (EU) 2024/1640 and the reporter must request personally. Self-declared data.
- **Portal das Finanças, tax debtors** https://www.portaldasfinancas.gov.pt/pt/main.jsp?body=/external/lista-devedores/lista.jsp (fetch). **Segurança Social debtors** https://www.seg-social.pt/lista-de-devedores (fetch).
- **CMVM** https://www.cmvm.pt (fetch). Listed companies: qualifying holdings, insider dealings, sanctions.
- **Banco de Portugal** https://www.bportugal.pt (browser; 403 to curl). Supervised entities and sanctions. Statistics through **BPstat API** https://bpstat.bportugal.pt/data/v1/ (fetch, JSON, no key), docs at https://bpstat.bportugal.pt/data/docs.
- **GLEIF LEI records** https://api.gleif.org/api/v1/lei-records?filter[entity.legalName]=<name> (fetch, JSON, no key). Legal Entity Identifiers with registered address, registration number and, where reported, direct and ultimate parent. 18 000+ Portuguese entities. Fast first pass before Publicações MJ.
- **Racius** https://www.racius.com and **eInforma** https://www.einforma.pt (fetch). Commercial aggregators; first look only, confirm in Publicações MJ.
- **Registo Nacional de Turismo** https://rnt.turismodeportugal.pt/RNT/ConsultaRegisto.aspx (fetch). Alojamento local and tourism operators by name, number or holder.
- **Ordem dos Advogados** https://portal.oa.pt/advogados/pesquisa-de-advogados/ (fetch). Lawyer registration status.
- International: **OpenCorporates** https://opencorporates.com (browser; captcha on curl); **UK Companies House** https://find-and-update.company-information.service.gov.uk (fetch, PSC register fully public); EU **BRIS** via https://e-justice.europa.eu; **Wikidata** SPARQL https://query.wikidata.org/sparql (fetch) for public figures, offices and dates.

## Public money
- **Portal BASE** https://www.base.gov.pt (POST). Every public contract above threshold. Use `"${CLAUDE_PLUGIN_ROOT}/scripts/base-search.sh" contratos "adjudicante=<entity>&adjudicataria=<company>"` (also `texto=`), `anuncios`, `entidades "texto=<name>"` to get NIFs, and `detalhe <id>` for the full record (NIFs, CPV, legal basis, direct-award justification, documents, procedure URL). Cite `https://www.base.gov.pt/Base4/pt/detalhe/?type=contratos&id=<id>`. For an entity's or supplier's whole record, `python3 "${CLAUDE_PLUGIN_ROOT}/scripts/base-summary.py" --adjudicante "<name>" --from YYYY-MM-DD --to YYYY-MM-DD` writes a CSV and a Markdown summary (by year, by procedure, top awardees, direct-award counts). Bulk: OCDS and weekly dumps at https://dados.gov.pt/datasets/ocds-portal-base-www-base-gov-pt.
- **dados.gov.pt** https://dados.gov.pt (fetch). National open-data portal; API https://dados.gov.pt/api/1/datasets/?q=<terms> (JSON, no key) returns dataset pages and resource download URLs.
- **Mais Transparência** https://transparencia.gov.pt (browser; Next.js app). Government spending, PRR, public employment dashboards.
- **Tribunal de Contas** https://www.tcontas.pt (fetch). See Courts for decisions and reports.
- **IGF** https://igf.gov.pt (fetch). Inspeção-Geral de Finanças reports.
- **Portal Autárquico (DGAL)** https://portalautarquico.dgal.gov.pt (fetch). Municipal finance and staff data.
- **TED** https://ted.europa.eu (fetch). EU-threshold tenders. Search API: POST JSON to https://api.ted.europa.eu/v3/notices/search with `{"query":"place-of-performance=PRT AND buyer-name=<name>","limit":20}` (no key).
- **SNS Transparência** https://transparencia.sns.gov.pt (fetch). Health-service datasets; Opendatasoft API at /api/explore/v2.1/catalog/datasets (JSON, no key).
- **EU funds**: Kohesio https://kohesio.ec.europa.eu/en/projects?country=Portugal (fetch) lists cohesion-funded projects and beneficiaries; the Commission's Financial Transparency System https://ec.europa.eu/budget/financial-transparency-system/ (fetch) lists direct EU payments; PRR beneficiaries and projects are searchable at https://transparencia.gov.pt/pt/fundos-europeus/prr/pesquisar/beneficiario/ (browser); Portugal 2030 operation lists are published per programme as spreadsheets, e.g. https://alentejo.portugal2030.pt/lista-de-operacoes-aprovadas/ and https://lisboa.portugal2030.pt/documentos/ (fetch), so check the regional or thematic programme site for the region in question.

## Politicians, officials and interests
- **Entidade para a Transparência** https://www.tribunalconstitucional.pt/tc/entidade.html and https://entidadetransparencia.pt (fetch). Single declarations of income, assets and interests of office holders (Lei 52/2019). Consultation is on request through the platform, not bulk-searchable.
- **Parlamento** https://www.parlamento.pt (fetch). MPs' pages and interest registers at /DeputadoGP/Paginas/Deputados.aspx; votes and committee records; open data (JSON/XML files) at /Cidadania/Paginas/DadosAbertos.aspx.
- **Governo** https://portugal.gov.pt and https://www.sg.pcm.gov.pt/o-governo/transparencia/ (fetch). Ministers' CVs, transparency page.
- **ECFP** https://www.tribunalconstitucional.pt/tc/ecfp/ (fetch). Party and campaign accounts and decisions (Entidade das Contas e Financiamentos Políticos). Do not use ecfp.pt: that domain now belongs to a school.
- **Elections**: results https://www.eleicoes.mai.gov.pt (fetch); CNE https://www.cne.pt (fetch) for candidacies and rulings; SGMAI electoral administration https://www.sg.mai.gov.pt/AdministracaoEleitoral/ (fetch).
- **EU Transparency Register** https://transparency-register.europa.eu (fetch). Lobbyists at EU level.
- **Autoridade da Concorrência** https://www.concorrencia.pt (fetch). Merger and cartel decisions.

## Media ownership
- **ERC Portal da Transparência** https://portaltransparencia.erc.pt (fetch). Ownership and financing of media outlets (Lei 78/2015).

## Data and statistics
- **INE** https://www.ine.pt (fetch). JSON API, no key: `https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd=<indicator code>&lang=PT` (add `Dim1=` for the period, e.g. `S7A2023`, and `Dim2=` for the geography; the codes are INE's own, not DICO codes, and are listed on each indicator's page under "API" or in the "Códigos" view of the selection screen; a wrong code returns a JSON error naming the dimension). Example indicator: resident population, `varcd=0004167`. Docs: https://www.ine.pt/xportal/xmain?xpid=INE&xpgid=ine_api. Census 2021 by parish at https://censos.ine.pt; metadata at https://smi.ine.pt.
- **Pordata** https://www.pordata.pt (fetch, downloads only). **Eurostat** API https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/<dataset>?geo=PT (fetch, JSON-stat, no key).
- **geoapi.pt** https://json.geoapi.pt (fetch, no key). Municipalities, parishes, postal codes (`/cp/<código postal>`), reverse geocoding (`/gps/<lat>,<lon>`) with official codes.

## Web archives (for Portuguese pages)
- **Arquivo.pt** https://arquivo.pt (fetch). The Portuguese web archive since 1996, often has .pt pages Wayback lacks. Full-text API `https://arquivo.pt/textsearch?q=<terms>&maxItems=20`; captures `https://arquivo.pt/wayback/cdx?url=<url>&output=json`; replay `https://arquivo.pt/wayback/<timestamp>/<url>`.

## Access to information
- **LADA**, Lei 26/2016 — any person may request administrative documents without stating a reason; the entity must respond within 10 working days; refusal or silence can be complained to **CADA** https://www.cada.pt (fetch) within 20 days. Use the `/pt-public-records:lada-request` command to draft one.

## Re-verifying this list
Run `scripts/check-sources.sh` at the repository root: it fetches every URL cited in the plugins and prints the ones that do not return 200. A 403 or an empty body from curl usually means "browser", not "dead".
