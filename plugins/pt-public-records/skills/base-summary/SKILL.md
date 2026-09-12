---
name: base-summary
description: Pull every Portal BASE public contract for a contracting entity or a supplier into a CSV with a summary (by year, by procedure, top awardees, direct awards).
argument-hint: <entity or supplier name> [from YYYY-MM-DD] [to YYYY-MM-DD]
disable-model-invocation: true
allowed-tools: Bash(python3 *) Bash(mkdir *) Read
---

Pull the Portal BASE record for **$0** (dates, if given: $ARGUMENTS).

1. Decide whether $0 is a contracting entity (câmara, ministério, hospital, instituto) or a supplier; run the script with `--adjudicante` for the first and `--adjudicataria` for the second. If unsure, run `"${CLAUDE_PLUGIN_ROOT}/scripts/base-search.sh" entidades "texto=$0" 0 5` first and use the exact `description` returned.
2. Run, inside the current investigation folder if one is active (`investigations/<slug>/data/base`), otherwise `./base-data`:
   ```
   python3 "${CLAUDE_PLUGIN_ROOT}/scripts/base-summary.py" --adjudicante "<exact name>" --from <from> --to <to> --out <folder>
   ```
   Fifty contracts per request, about ten seconds each; tell the reporter the expected time when `total` is large and suggest a date range.
3. Print `resumo.md`, then in three sentences say what stands out (concentration, share of direct awards, the largest contracts) and what would need checking before any of it is written: the contract pages themselves, the entity and the awardee (right of reply), amendments and final values.
4. Add a row to `evidence-log.md` for the dataset: source Portal BASE, the exact query, extraction date, path of `contratos.csv`.

Never call a pattern irregular; the summary lists leads.
