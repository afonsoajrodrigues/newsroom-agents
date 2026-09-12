---
name: new-graphic
description: Scaffold a new standalone D3 graphic (chart or map) from the desk template, with data folder, README and pt-PT locale wired in.
argument-hint: <slug> [chart|map] [one-line finding for the title]
disable-model-invocation: true
allowed-tools: Bash(mkdir *) Bash(cp *) Bash(ls *) Read Write Edit
---

Create `graphics/$0/` (inside the current investigation folder if one is active, otherwise at the project root):

1. `mkdir -p graphics/$0/data` and copy `${CLAUDE_SKILL_DIR}/template.html` to `graphics/$0/index.html`.
2. Set `<title>`, the `h1` title and the subtitle from the finding given after the slug (`$ARGUMENTS`); if none was given, leave the placeholder text and say so.
3. If the second argument is `map`, copy `${CLAUDE_SKILL_DIR}/map-template.html` to `index.html` instead, and copy `${CLAUDE_SKILL_DIR}/sample-boundaries.json` to `data/boundaries.json` so it renders immediately. The sample is the 11 municipalities of Madeira from CAOP 2025 (DGT, CC BY 4.0), simplified; replace it with the real boundaries from `scripts/geo-prep.py` (see the `pt-geodata` skill for sources, join codes and island insets) and replace `VALUES` with rows keyed by the same code.
4. Write `graphics/$0/README.md`:
```
# <title>
Source: <dataset name and URL> (extracted <date>)
Data prep: <script or steps that produced data/>
Built by: <name>, <date>
Evidence log: <E-ids>
```
5. Print the tree and remind: replace `DATA` in `index.html` with the real rows, run the pre-publication checklist from `viz-standards` before handing over, check it with `node "${CLAUDE_PLUGIN_ROOT}/scripts/render-check.mjs" graphics/$0/index.html`, and export the static version with `--svg graphics/$0/grafico.svg` (or `mapa.svg`) when it passes.
