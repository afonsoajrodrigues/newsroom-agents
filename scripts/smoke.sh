#!/usr/bin/env bash
# End-to-end smoke test: loads pt-public-records into a non-interactive Claude session and asks the
# procurement-watchdog a question whose answer the script can compute independently. Uses API credits;
# run by hand, not in CI. Expected on 2026-09-12: 56 contracts, 43,5 % of value by direct award.
set -euo pipefail
cd "$(dirname "$0")/.."
tmp="$(mktemp -d)"; cd "$tmp"
claude -p --plugin-dir "$OLDPWD/plugins/pt-public-records" --permission-mode dontAsk \
  --allowedTools "Bash,Read,Agent,Grep,Glob,WebFetch,WebSearch" --output-format text \
  "Usa o agente procurement-watchdog. Quantos contratos assinou o Município do Porto Moniz em 2025 segundo o Portal BASE, e que percentagem do valor total foi adjudicada por ajuste direto? Usa o script base-summary.py do plugin. Responde em português, no máximo 5 linhas, com os números e a query usada."
echo; echo "independent check:"
python3 "$OLDPWD/plugins/pt-public-records/scripts/base-summary.py" --adjudicante "Município do Porto Moniz" --from 2025-01-01 --to 2025-12-31 --out "$tmp/check" 2>/dev/null | sed -n '3p;/Ajuste Direto/p' | head -3
