---
name: company-sources
description: Where to find who owns, runs and controls a company, in Portugal and abroad, with free sources in the order that works (fix the NIF first, then Publicações MJ, then RCBE) and the access limits of each. Use whenever a reporter asks who owns a company, who its directors or shareholders are, whether it is in a leak or sanctions database, or how to find its NIF. Em português - "quem é o dono desta empresa", "quem são os sócios", "como descubro o NIF", "está nos Panama Papers", "está sancionada".
user-invocable: false
---

# Company records: where to look

URLs checked 2026-09-12. Free, no API keys. `browser` marks sites that block automated fetches; use the Claude in Chrome tools there.

## Order of work
1. **Fix the exact legal name and the NIF/NIPC.** Names are ambiguous ("Construções Vale Verde, Lda" may exist three times). Free ways to get the NIF: Portal BASE entity search (`base-search.sh entidades "texto=<name>"` from pt-public-records, if the company ever had a public contract), GLEIF (`https://api.gleif.org/api/v1/lei-records?filter[entity.legalName]=<name>`), Racius or eInforma, the company's own site or invoices, or the Diário da República.
2. **Publicações MJ** https://publicacoes.mj.pt/Pesquisa.aspx (browser; ASP.NET form). Statutory acts: incorporation with founding shareholders and capital, share transfers, appointments and resignations of gerentes and administradores, capital changes, mergers, dissolutions. Search by name or NIPC. This is the backbone of any ownership chain; each act is a citable document with a date.
3. **RCBE, beneficial owners** https://rcbe.justica.gov.pt (browser, login). Since 27 October 2025 access requires a stated legitimate interest and authentication with Cartão de Cidadão or Chave Móvel Digital; investigative journalists qualify under Directive (EU) 2024/1640, and the reporter must make the request personally. It is not freely searchable. Data is self-declared and often stale: cite it as "declared", never as established.
4. **Certidão permanente** (Registo Comercial) is paid and needs the access code; it is the full current record. Ask the company for its code when negotiating right of reply, or budget for it.

## Other Portuguese sources
- **Diário da República Series II** (browser): notices for public-interest companies, appointments to state-owned firms.
- **CMVM** https://www.cmvm.pt: listed companies, qualifying holdings, board, related parties.
- **Banco de Portugal** https://www.bportugal.pt (browser): supervised entities and sanctions.
- **Tax and social-security debtor lists**: Portal das Finanças (Lista de Devedores) and https://www.seg-social.pt/lista-de-devedores.
- **Citius public notices** https://www.citius.mj.pt/portal/consultas/ConsultasCire.aspx: insolvency, PER, PEAP by name or NIF.
- **Portal BASE** (via pt-public-records' `base-search.sh` / `base-summary.py`): every public contract the company won, with the NIF on the detail record.
- **Registo Nacional de Turismo** https://rnt.turismodeportugal.pt/RNT/ConsultaRegisto.aspx: alojamento local and tourism operators.
- **Racius** https://www.racius.com and **eInforma** https://www.einforma.pt: commercial aggregators, first look only; confirm every fact in Publicações MJ.

## International
- **GLEIF** https://api.gleif.org/api/v1/lei-records (JSON, no key): LEI records with registered address, registration number and reported direct and ultimate parents, 18 000+ Portuguese entities.
- **OpenCorporates** https://opencorporates.com (browser; captcha for automated clients) and the national registry it links to; **UK Companies House** https://find-and-update.company-information.service.gov.uk (PSC register fully public, fetchable); EU **BRIS** via https://e-justice.europa.eu.
- **ICIJ Offshore Leaks** https://offshoreleaks.icij.org (browser for search; full CSV at /pages/database); **OCCRP Aleph** https://aleph.occrp.org (free account).
- **OpenSanctions** https://www.opensanctions.org (web search free; JSON API needs a key; bulk datasets free at `https://data.opensanctions.org/datasets/latest/<dataset>/index.json`); **EU Sanctions Map** https://www.sanctionsmap.eu (`/api/v1/regime` as JSON).
- **Wikidata** SPARQL https://query.wikidata.org/sparql for public figures, offices and dates.

## Rules
- A shared director, address or surname between two companies is a lead, not proof of common control or family.
- Every link in a chain needs a document with a date; ownership on the date that matters to the story is often not ownership today.
- Appearing in a leak or sanctions database is not evidence of wrongdoing; name matches without identifying detail are NAME MATCH ONLY.
