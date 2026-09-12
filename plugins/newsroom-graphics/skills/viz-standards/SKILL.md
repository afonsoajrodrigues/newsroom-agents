---
name: viz-standards
description: The graphics desk standard for charts and maps - form selection, validated palette, mark specs, annotation, interaction, accessibility, pt-PT formatting and the pre-publication checklist. Use whenever building or reviewing a chart, map or interactive graphic, or when asked which chart type, colours or number format to use. Em português - "que gráfico uso para", "que cores", "como formato os números", "este gráfico está bem".
user-invocable: false
---

# Graphics desk standard

A chart is read by people. Get the form and the words right first; color comes last.

## 1. Form: the reader's job picks the chart
| Reader must... | Use | Never |
|---|---|---|
| See one number | hero figure or stat tile | a one-bar chart, a two-slice pie |
| Compare magnitudes | horizontal bar (long labels) or column; heatmap for a grid | pie for close values |
| Follow change over time | line; area only for one series | more than 4 lines without emphasis |
| Tell series apart | grouped or stacked bar, multi-line | more than 8 categories, ever |
| See one series against context | emphasis: one accent hue, the rest gray | rainbow |
| See above/below a baseline | diverging bar or line vs baseline | diverging without a neutral midpoint |
| See part-to-whole | stacked bar (horizontal for many parts) | donut with 12 slices |
| See a distribution | histogram, beeswarm, boxplot with points | averages alone |
| Compare places | map only if geography is the story; otherwise a bar chart of places | a choropleth of raw counts |
| Rank | sorted bar, slope chart for two periods, bump chart for ranks over time | unsorted bars |

Two measures with different scales: two charts or an index (2019 = 100). **Never a dual axis.**

## 2. Words
- **Title is the finding**, written as a sentence a reader can repeat: "Ajustes diretos triplicaram desde 2019", not "Contratos por ano".
- **Subtitle states the measure, unit, population and period.** "Valor dos contratos por ajuste direto da Câmara X, em milhões de euros, 2015 a 2025".
- **Source line**: "Fonte: Portal BASE (IMPIC), extraído em 2026-09-12. Análise: <newsroom>". Every graphic. Link the dataset when embedded.
- **Annotate the story on the chart** (a labelled point, a shaded period, an arrow). If the title makes a claim, the mark that proves it is labelled.
- **Direct labels beat legends**: up to 4 series, label the line end or bar. A legend is still present for 2 or more series so identity is never color alone.
- **Notes** for method choices: inflation adjustment, what "Other" contains, excluded records.

## 3. Numbers and dates (pt-PT)
Use `d3.formatLocale({decimal: ",", thousands: " ", grouping: [3], currency: ["", " €"]})` and `d3.timeFormatLocale` with Portuguese month and day names (see the template). Thousands separator is a space (narrow no-break space in print), decimal is a comma, currency after the number: `1 234,5 €`. Percent: `12,3 %`. Dates: `12 set. 2026` or `12/09/2026`, never `09/12`. Round to what the reader needs: two significant figures in labels, full precision in the table.

## 4. Color (validated, do not eyeball)
Define tokens in a `<style>` block and reference them by role. Light and dark values below were validated for colorblind separation (OKLab, adjacent-pair CVD delta E >= 8) and contrast on their surfaces.

Surfaces: light `#fcfcfb` text `#0b0b0b` / `#52514e` / grid `#e6e5e1`; dark `#1a1a19` text `#ffffff` / `#c3c2b7` / grid `#333331`.

Categorical, fixed slot order (assign by entity, never re-assign on filter; 9th series folds into "Other"):
| Slot | Light | Dark |
|---|---|---|
| 1 blue | `#2a78d6` | `#3987e5` |
| 2 orange | `#eb6834` | `#d95926` |
| 3 aqua | `#1baf7a` | `#199e70` |
| 4 yellow | `#eda100` | `#c98500` |
| 5 magenta | `#e87ba4` | `#d55181` |
| 6 green | `#008300` | `#008300` |
| 7 violet | `#4a3aa7` | `#9085e9` |
| 8 red | `#e34948` | `#e66767` |
Scatter, bubble, choropleth classes and small multiples: cap at the first 3 slots. Slots 3, 4, 5 sit under 3:1 contrast on the light surface: direct labels or a table view are mandatory with them. De-emphasis gray: `#b5b4ae` light, `#5a5955` dark.

Sequential (magnitude, one hue, light to dark): `#cde2fb #9ec5f4 #6da7ec #3987e5 #256abf #1c5cab #104281`. Use 5 to 7 classes; quantiles or Jenks for skewed data, equal intervals only when the reader knows the scale; always print the class breaks in the legend.

Diverging (above/below): blue `#2a78d6` to neutral gray (`#f0efec` light, `#383835` dark) to red `#e34948`, equal steps per arm, the midpoint at the real zero or baseline.

Rules: sequential is the default. Categorical only when the series are the subject. Never a value ramp on nominal categories. Never a hue at the diverging midpoint. Never a rainbow.

## 5. Marks
Bars 60 to 70 percent of the band with a 2px surface gap between adjacent fills; lines 2px, markers >= 8px with a 2px surface ring where they overlap; gridlines solid, light, behind the marks, no dashes; axis lines recessive or absent; no borders around marks; labels never clipped by a too-small bar (move outside). Baseline at zero for bars always; for lines, a non-zero baseline is allowed and must be visibly labelled. Text is always in text tokens, never in the series color.

## 6. Interaction
Every HTML chart ships a hover layer: crosshair plus tooltip on lines and areas, per-mark tooltip on bars, dots, cells and map areas. Hit targets larger than the mark (Voronoi or an invisible band). Tooltip shows the formatted value, the label and the period. Nothing is readable only via tooltip: direct labels or the table view carry the values too. Filters, if any, sit in one row above the chart, not inside it. Keyboard: marks with tooltips are focusable (`tabindex="0"`), and Escape closes.

## 7. Accessibility
`<figure>` with `<figcaption>`; `role="img"` and an `aria-label` that states the finding and the range of values; a `<details>` table view with the data; contrast per section 4; touch targets >= 24px; respects `prefers-reduced-motion` (no entrance animation); works at 360px width (rotate to horizontal bars, drop secondary labels, keep the title and the annotated mark).

## 8. Build and deliver
- Standalone `index.html`, no build step; D3 v7 pinned from jsdelivr (`d3@7.9.0`, `topojson-client@3.1.0`). Data inline as a JSON constant or in `data/` next to it; never fetched from a third party at view time.
- Responsive with `viewBox` plus a `ResizeObserver` redraw; height set from the aspect ratio, never a fixed pixel height that clips the axis.
- Print and static: SVG export by serialising the `<svg>` node (a "Descarregar SVG" button); PNG through a canvas draw of the SVG at 2x. The static version keeps direct labels because there is no hover.
- Embed: the graphic reports its height to a parent with `postMessage` (`{type: "graphic-height", height}`), so a CMS iframe can size it.
- Reproducibility: a `README.md` next to the graphic with the data source URL, extraction date, the script or steps that produced `data/`, and the person who built it.

## 9. Pre-publication checklist
1. Title states the finding; subtitle has measure, unit, population, period.
2. Source line with date; method note if anything was adjusted or excluded.
3. Bars start at zero; no dual axis; log or broken scales labelled.
4. Choropleth shows a rate or share, not a raw count; class breaks visible.
5. Palette from section 4 in slot order; <= 3 slots on all-pairs forms; legend present for >= 2 series and direct labels up to 4.
6. Every number formatted pt-PT; dates unambiguous.
7. Hover layer present; table view present; aria-label states the finding; reduced-motion respected.
8. Renders at 360px and 1200px without overlap or clipping.
9. The annotated mark supports the title's claim, and the evidence log has a row for the dataset.
