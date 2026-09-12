# Na Madeira, o ajuste direto pesa de 4 % do valor contratado em Santa Cruz a 44 % no Porto Moniz

A worked example of the map pipeline end to end on real public data: official boundaries, contracts pulled from Portal BASE, a choropleth of a rate (never a raw count), island projection, printed class breaks, table view and a static export. Nothing here alleges wrongdoing: direct awards below the legal thresholds are lawful, and with 32 to 105 contracts per municipality a single large tender moves the share a lot. That caveat is in the subtitle on purpose.

- **Boundaries:** CAOP 2025, Direção-Geral do Território, CC BY 4.0, https://geo2.dgterritorio.gov.pt/caop/CAOP_RAM_2025-gpkg.zip, layer `ram_municipios`, prepared with
  ```
  python3 plugins/newsroom-graphics/scripts/geo-prep.py ArqMadeira_CAOP2025.gpkg data/boundaries.json --layer ram_municipios --keep dtmn,municipio --simplify 0.05 --bbox=-17.3,32.3,-16.2,33.2
  ```
  (mapshaper on PATH, 5 % of vertices kept, TopoJSON, 0.08 MB). The bounding box drops the Selvagens, which belong to the Funchal municipality but lie 250 km to the south; without the clip the fitted projection shrinks the islands to a corner.
- **Values:** for each of the 11 municipalities, the exact Portal BASE entity name was found from the câmara's NIF (`json.geoapi.pt/municipio/<name>` gives the NIF; `base-search.sh entidades "texto=<NIF>"` gives the name), then
  ```
  python3 plugins/pt-public-records/scripts/base-summary.py --adjudicante "<entity name>" --from 2025-01-01 --to 2025-12-31
  ```
  and the share of the initial contractual price awarded by "Ajuste Direto Regime Geral" was computed per municipality. `data/valores.csv` has the counts, totals and shares; the per-contract CSVs are not committed because they name individual contractors.
- **Join key:** `dtmn` (INE DICO code), never names.
- **Graphic:** `index.html` from `plugins/newsroom-graphics/skills/new-graphic/map-template.html` with values, breaks (10, 20, 30, 40), legend title and centroid labels. `mapa.svg` is the static export from `render-check.mjs --svg`.
- **Check:** `node plugins/newsroom-graphics/scripts/render-check.mjs examples/madeira-ajustes-diretos-2025/index.html` (all checks pass).
- **Built by:** newsroom-agents, 2026-09-12.

![Choropleth of Madeira and Porto Santo municipalities, five blue classes; Porto Moniz and Câmara de Lobos darkest, Santa Cruz and Funchal lightest](mapa.svg)
