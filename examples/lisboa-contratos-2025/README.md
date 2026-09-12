# Ajustes diretos são dois em cada três contratos da Câmara de Lisboa, mas 15 % do valor

A worked example of the graphics pipeline on real public data. Nothing here alleges wrongdoing: direct awards below the legal thresholds are lawful and routine. The point is that the number of contracts and the money behind them tell different stories, and a chart should show both.

- **Source:** Portal BASE (IMPIC), https://www.base.gov.pt, contracts with `adjudicante = Município de Lisboa` and signing date between 2025-01-01 and 2025-12-31, as published up to 2026-09-12. Values are the initial contractual price as declared on BASE; amendments and final values are not included.
- **Data prep:**
  ```
  python3 plugins/pt-public-records/scripts/base-summary.py --adjudicante "Município de Lisboa" --from 2025-01-01 --to 2025-12-31 --out data/base
  ```
  produced `contratos.csv` (1067 rows, not committed here because it names individual contractors) and `resumo.md`. `data/procedimentos.csv` aggregates the procedure types from that CSV; the two framework-agreement articles (258.º and 259.º) are merged, and "Outros" holds "Contratação excluída II" (13 contracts) and one "Concurso limitado por prévia qualificação".
- **Graphic:** `index.html`, built from `plugins/newsroom-graphics/skills/new-graphic/template.html` with the chart block swapped for grouped bars. `grafico.svg` is the static export from `render-check.mjs --svg`.
- **Check:** `node plugins/newsroom-graphics/scripts/render-check.mjs examples/lisboa-contratos-2025/index.html` (all checks pass).
- **Built by:** newsroom-agents, 2026-09-12.

![Grouped bar chart: direct awards are 66.5 percent of contracts and 14.6 percent of value; open tenders 14.2 percent of contracts and 66.9 percent of value](grafico.svg)
