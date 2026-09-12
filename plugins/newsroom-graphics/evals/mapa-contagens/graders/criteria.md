---
type: llm
weight: 1
---

The response must push back on a choropleth of raw counts (big or populous municipalities dominate) and recommend either a rate (per capita, per 1000 inhabitants, share of contracts or of value) for a choropleth, or proportional symbols for the counts. It must name CAOP (Direção-Geral do Território) as the boundary source and say to join on the municipality code (dtmn / DICO), not on names. Mentioning INE population as the denominator, island insets, or the geo-prep script is a plus. It must be in Portuguese. Fail if it simply agrees to colour municipalities by count, if it suggests joining on names, or if it names a boundary source other than CAOP/DGT, GISCO or geoapi.pt for Portuguese municipalities.
