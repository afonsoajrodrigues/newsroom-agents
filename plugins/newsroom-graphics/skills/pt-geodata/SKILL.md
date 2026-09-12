---
name: pt-geodata
description: Where to get and how to prepare boundaries and geodata for Portuguese and international maps - CAOP (official municipalities and parishes), NUTS, world layers, join codes, projections and insets for the islands. Use when building any map or when asked where to get Portuguese municipality or parish boundaries, NUTS or world layers, or how to join statistics to them. Em português - "onde arranjo os limites dos concelhos", "shapefile das freguesias", "CAOP", "mapa por concelho".
user-invocable: false
---

# Geodata for maps

URLs verified 2026-09.

## Portugal: official administrative boundaries (CAOP, DGT)
Carta Administrativa Oficial de Portugal, Direção-Geral do Território, CC BY 4.0, updated yearly. GeoPackage zips with one file per region:
- Mainland: https://geo2.dgterritorio.gov.pt/caop/CAOP_Continente_2025-gpkg.zip
- Azores: https://geo2.dgterritorio.gov.pt/caop/CAOP_RAA_2025-gpkg.zip
- Madeira: https://geo2.dgterritorio.gov.pt/caop/CAOP_RAM_2025-gpkg.zip
Landing page and older editions: https://www.dgterritorio.gov.pt/atividades/cartografia/cartografia-tematica/caop; also on https://dados.gov.pt (search "CAOP") and the SNIG geoportal https://snig.dgterritorio.gov.pt.

Layers are prefixed by region (`ram_`, `raa_`, `cont_`): `<prefix>_distritos`, `<prefix>_municipios`, `<prefix>_freguesias`, `<prefix>_nuts1/2/3`, `<prefix>_areas_administrativas` (attribute table). List them with `pyogrio.list_layers(path)`.

Key fields: `dtmn` (4-digit district+municipality code, the DICO code INE uses), `dtmnfr` (6-digit parish code), `municipio`, `freguesia`, `distrito_ilha`, `nuts3_cod`, `area_ha`. **Join on `dtmn` / `dtmnfr`, never on names** (accents, "Vila Nova de..." variants).

Native CRS: mainland EPSG:3763 (PT-TM06/ETRS89), Madeira EPSG:5016, Azores EPSG:5014 (west/central) and 5015 (east). Reproject to EPSG:4326 for D3: `scripts/geo-prep.py` does it.

Distant islets stretch a fitted projection: the Selvagens belong to the Funchal municipality but lie 250 km south, so a Madeira map fitted to the raw layer shrinks the islands to a corner. Clip with `--bbox=-17.3,32.3,-16.2,33.2` and say so in the note; likewise the Formigas for the Azores.

Sizes: mainland parishes are heavy (tens of MB). Simplify for the web: municipalities to ~5 to 10 percent of vertices, parishes to ~2 to 5 percent, and check the coastline still looks right at the display size.

## Europe and world
- Eurostat GISCO NUTS (2024) GeoJSON, WGS84, scales 01M/03M/10M/20M/60M: `https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/NUTS_RG_<scale>_2024_4326_LEVL_<0-3>.geojson`; countries: `.../countries/geojson/CNTR_RG_20M_2024_4326.geojson`. Portugal NUTS3 here matches INE regional statistics.
- World: `https://cdn.jsdelivr.net/npm/world-atlas@2.0.2/countries-50m.json` (TopoJSON, Natural Earth); country IDs are ISO 3166-1 numeric.
- Natural Earth (public domain) for physical features, rivers, populated places: https://github.com/nvkelso/natural-earth-vector.
- geoBoundaries (CC BY) as an alternative for any country: `https://www.geoboundaries.org/api/current/gbOpen/<ISO3>/ADM<n>/`.
- OpenStreetMap for streets, buildings and points of interest (ODbL, attribute "© OpenStreetMap contributors"); Overpass API for extracts; never bulk-download without need.

## Statistics to join
- INE (ine.pt) publishes municipal indicators keyed by DICO code; JSON API `https://www.ine.pt/ine/json_indicador/pindica.jsp?op=2&varcd=<code>&lang=PT` (no key); census 2021 by parish at censos.ine.pt; ready-made thematic maps at mapas.ine.pt. Pordata mirrors many series with municipality names; prefer INE codes.
- geoapi.pt (`https://json.geoapi.pt/municipios`, `/municipio/<name>`, `/cp/<postal code>`, `/gps/<lat>,<lon>`) maps names, postal codes and coordinates to official municipality and parish codes; no key.
- Portal BASE contracts have the contracting entity's municipality in the entity record, not always as a code: geocode via the entity's registered municipality name against `municipio`, then verify by hand.
- Eurostat regional data by NUTS code.

## Projections in D3
- Portugal mainland: `d3.geoConicConformal().parallels([38, 41]).rotate([8.13, 0])` or simply `d3.geoMercator()` fitted with `fitSize`. The template uses `fitExtent` so any projection works.
- Islands: draw Azores and Madeira as **insets** with their own fitted projections and a thin frame, labelled, at a consistent scale note ("Açores e Madeira fora de escala") or at true scale if space allows. Never stretch the mainland to fit them.
- Europe: `d3.geoConicConformal` (ETRS89-LCC, parallels 35 and 65, center 10, 52) or GISCO's EPSG:3035 look; world: `d3.geoNaturalEarth1` or `geoEqualEarth` (equal-area) for thematic maps, never Mercator for area comparison.

## Map types
- **Choropleth**: rates, shares, per-capita, densities. Raw counts on areas are an anti-pattern (big areas dominate). 5 to 7 classes, sequential ramp, class breaks in the legend, a "no data" hatch or gray that is not in the ramp.
- **Proportional symbols**: counts and totals. Area scales with value (`d3.scaleSqrt`), symbols sorted large to small so small ones are on top, a legend with 3 reference circles.
- **Locator map**: a point or area with just enough context (coast, main roads or towns, a label), one accent color, everything else recessive.
- **Cartogram / hex map** only when equal visual weight per unit is the point and the reader knows the shapes.
- Basemap tiles are usually unnecessary; boundaries plus a few labels are cleaner and load without third-party requests.

## Preparation script
`python3 "${CLAUDE_PLUGIN_ROOT}/scripts/geo-prep.py" <input.gpkg|.shp|.geojson> <out.json> [--layer NAME] [--keep dtmn,municipio] [--simplify 0.05] [--where "expr"] [--bbox minx,miny,maxx,maxy]` reads with geopandas, reprojects to WGS84, keeps the named fields, and writes TopoJSON via mapshaper (topology-preserving simplification) when mapshaper is available, GeoJSON otherwise. The map template accepts either. Verified on CAOP 2025 Madeira (`--layer ram_municipios`): 11 features, 0.1 MB.
