---
name: evidence-log
description: Conventions for the investigation evidence log (evidence-log.md), the single ledger every finding must be entered in before it can be used in a story. Use when recording, citing, or auditing evidence, or when asked how to log a source. Em português - "regista isto no registo de provas", "como cito esta fonte", "o que falta no evidence log".
user-invocable: false
---

# Evidence log conventions

Every investigation keeps one ledger: `evidence-log.md` in the investigation folder. Nothing goes into a draft unless it has a row here.

## Row format

| ID | Date accessed | What it shows (one sentence) | Source | Type | Confidence | Archive | Notes |
|---|---|---|---|---|---|---|---|
| E-001 | 2026-09-12 | Company X won 14 direct awards from Municipality Y in 2024 | https://www.base.gov.pt/... | primary/official | CONFIRMED | archive.org link + sha256 | Cross-checked with dados.gov.pt OCDS dump |

- **ID**: `E-` plus a zero-padded sequence. Never reuse or renumber. Drafts cite evidence as `[E-001]`.
- **Type**: `primary/official` (registry, gazette, court, contract), `primary/document` (leaked or obtained document), `primary/witness` (on-record interview), `secondary` (press, reports citing something else), `anonymous` (attributed but unnamed).
- **Confidence**: `CONFIRMED` (two independent primary sources or one official record), `LIKELY` (one credible source), `UNVERIFIED` (claim only), `DISPUTED` (credible sources conflict).
- **Archive**: for web sources, the Wayback or archive.ph link plus the sha256 of the saved copy. For documents, the path under `docs/` and its sha256. An unarchived web source is not CONFIRMED.

## Rules

1. One fact per row. A source that supports three facts gets three rows.
2. Record the access date in ISO form. Pages change.
3. Independence check before counting a second source: two outlets citing the same wire story are one source.
4. Anything about a private individual needs a `public-interest:` note in Notes explaining why it is in the log at all.
5. When a row is superseded or found wrong, do not delete it. Set Confidence to `RETRACTED` and add what replaced it. The log is an audit trail.
6. `investigations/access-log.tsv` is written automatically by the plugin's hook: every URL fetched with WebFetch, with a UTC timestamp, whether or not it was cited. It is the provenance trail behind the evidence log; do not edit it by hand.
