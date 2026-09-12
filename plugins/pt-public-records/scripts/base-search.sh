#!/usr/bin/env bash
# base-search.sh — query Portal BASE (base.gov.pt) public-contract data as JSON. No API key.
#   base-search.sh contratos "<filters>" [page] [size] [sort]   list contracts
#   base-search.sh anuncios  "<filters>" [page] [size]          list tender announcements
#   base-search.sh entidades "<filters>" [page] [size]          list entities (name, NIF, id)
#   base-search.sh detalhe   <contract id>                       full contract record (NIFs, CPV, justification, documents)
# Filters are the portal's own, joined with "&":  texto=<free text>  adjudicante=<contracting entity>
#   adjudicataria=<awardee>  (verified 2026-09-12). Example:
#   base-search.sh contratos "adjudicante=Município de Lisboa&adjudicataria=Centrocar" 0 50 -publicationDate
# Output is the portal's JSON: {"total": N, "items": [...]}. Pipe to jq. Each item's id opens
#   https://www.base.gov.pt/Base4/pt/detalhe/?type=contratos&id=<id>
# The endpoint only answers POST, which is why WebFetch cannot call it directly.
set -euo pipefail
kind="${1:?usage: base-search.sh contratos|anuncios|entidades|detalhe ...}"
q="${2:-}"; page="${3:-0}"; size="${4:-25}"
enc() { jq -rn --arg s "$1" '$s|@uri'; }
case "$kind" in
  contratos) data="type=search_contratos&version=133.0&query=$(enc "$q")&sort=$(enc "${5:--publicationDate}")&page=$page&size=$size" ;;
  anuncios)  data="type=search_anuncios&version=133.0&query=$(enc "$q")&sort=-drPublicationDate&page=$page&size=$size" ;;
  entidades) data="type=search_entidades&version=133.0&query=$(enc "$q")&page=$page&size=$size" ;;
  detalhe)   data="type=detail_contratos&version=133.0&id=${q:?contract id}" ;;
  *) echo "unknown kind: $kind" >&2; exit 2 ;;
esac
curl -sS --fail --max-time 60 -A "Mozilla/5.0 (newsroom-agents base-search.sh)" \
  -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "X-Requested-With: XMLHttpRequest" \
  -d "$data" "https://www.base.gov.pt/Base4/pt/resultados/" | sed 's/^[[:space:]]*//'
