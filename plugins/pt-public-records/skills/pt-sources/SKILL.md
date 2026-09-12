---
name: pt-sources
description: Directory of Portuguese public-record sources for investigations - what each holds, the URL, and access limits. Use when deciding where to look for a Portuguese law, company, contract, court decision, official's declaration or public dataset.
user-invocable: false
---

# Portuguese public records: where to look

URLs verified 2026-09. Always cite the direct document URL, not the search page.

## Official gazette and law
- **Diário da República** https://diariodarepublica.pt — laws, decree-laws, portarias, despachos, appointments and dismissals (Series II), company notices. Advanced search at /dr/pesquisa-avancada; consolidated law under /dr/legislacao-consolidada. Historical dumps: https://dre.tretas.org.
- **PGDL** https://www.pgdlisboa.pt — consolidated codes with cross-references.

## Courts
- **DGSI** https://www.dgsi.pt — published decisions of the Supreme Court, Courts of Appeal, Supreme Administrative Court, and more. Only selected appellate decisions; first-instance files are not online.
- **Tribunal Constitucional** https://www.tribunalconstitucional.pt — decisions; also hosts the Entidade para a Transparência.
- **Citius** https://citius.tribunaisnet.mj.pt — case-management portal; public part is limited to insolvency notices and some publications, not case files.
- **Ministério Público** https://www.ministeriopublico.pt — press notes on investigations after secrecy is lifted.
- Ongoing criminal proceedings are under **segredo de justiça** until lifted. Do not imply a file is findable.

## Companies and people
- **Publicações MJ** https://publicacoes.mj.pt — statutory company acts: incorporation, share transfers, director changes, dissolutions. Free, searchable by name or NIF/NIPC.
- **RCBE** (beneficial ownership) https://rcbe.justica.gov.pt — since 27 Oct 2025 access requires a stated **legitimate interest** and authentication (Cartão de Cidadão / Chave Móvel Digital). Investigative journalists qualify under Directive (EU) 2024/1640; the reporter must make the request personally. Data is self-declared.
- **Portal das Finanças** https://www.portaldasfinancas.gov.pt — public list of tax debtors (lista de devedores), NIF validation.
- **CMVM** https://www.cmvm.pt — listed companies' disclosures, qualifying holdings, insider dealings.
- **Banco de Portugal** https://www.bportugal.pt — supervised entities register, sanctions decisions.
- **Racius** https://www.racius.com and **eInforma** https://www.einforma.pt — commercial aggregators; useful for a first look, always confirm in Publicações MJ.
- International: **OpenCorporates** https://opencorporates.com; EU **BRIS** via https://e-justice.europa.eu (business registers interconnection).

## Public money
- **Portal BASE** https://www.base.gov.pt — every public contract above threshold: contracting entity, awardee, value, procedure type, justification. Bulk data: weekly xlsx/json and OCDS at https://dados.gov.pt (organisation IMPIC); an API exists but needs IMPIC authorisation.
- **Mais Transparência** https://transparencia.gov.pt — government spending, PRR funds, public employment dashboards.
- **Tribunal de Contas** https://www.tcontas.pt — audit reports, prior-approval (visto) decisions, financial-responsibility rulings.
- **IGF** https://www.igf.gov.pt — Inspeção-Geral de Finanças audit reports.
- **TED** https://ted.europa.eu — EU-level tender notices.
- **SNS Transparência** https://transparencia.sns.gov.pt — health-service data.
- **DGAL** https://www.dgal.gov.pt — municipal finance data.

## Politicians, officials and interests
- **Entidade para a Transparência** https://www.tribunalconstitucional.pt/tc/entidade.html (also https://entidadetransparencia.pt) — single declarations of income, assets, interests and incompatibilities of political office holders and senior officials (Lei 52/2019). Consultation is public but on request through the platform; not bulk-searchable.
- **Parlamento** https://www.parlamento.pt — MPs' interest registers, votes, committee records, and open data at /Cidadania/paginas/dadosabertos.aspx.
- **Governo** https://www.portugal.gov.pt and https://www.sg.pcm.gov.pt/o-governo/transparencia/ — ministers' CVs, transparency page.
- **ECFP** https://www.ecfp.pt — party and campaign finance accounts (Entidade das Contas e Financiamentos Políticos, at the Constitutional Court).
- **CNE** https://www.cne.pt — election results and candidacies.
- **EU Transparency Register** https://ec.europa.eu/transparencyregister — lobbyists at EU level.

## Media ownership
- **ERC Portal da Transparência** https://portaltransparencia.erc.pt — ownership and financing of media outlets (Lei 78/2015).

## Data and statistics
- **dados.gov.pt** https://dados.gov.pt — national open-data portal.
- **INE** https://www.ine.pt; **Pordata** https://www.pordata.pt; **Eurostat** https://ec.europa.eu/eurostat.

## Access to information
- **LADA**, Lei 26/2016 — any person may request administrative documents without stating a reason; the entity must respond within 10 working days; refusal or silence can be complained to **CADA** https://www.cada.pt within 20 days. Use the `/pt-public-records:lada-request` command to draft one.
