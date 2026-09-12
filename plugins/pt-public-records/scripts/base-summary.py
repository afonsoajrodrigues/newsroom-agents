#!/usr/bin/env python3
"""base-summary.py — pull every Portal BASE contract for an entity and summarise it. Stdlib only, no key.

  base-summary.py --adjudicante "Município de Lisboa" --from 2025-01-01 --to 2025-12-31 [--out dir]
  base-summary.py --adjudicataria "Empresa X, Lda" [--details]

Writes <out>/contratos.csv (one row per contract, direct BASE URL per row) and <out>/resumo.md, and prints
the summary: totals by year and by procedure type, top awardees by value with their direct-award count.
--details also fetches each contract's full record (both NIFs, CPV, legal basis, direct-award justification);
it is one request per contract, so use it on a filtered set. Filters are the portal's own: adjudicante,
adjudicataria, texto, desdedatacontrato/atedatacontrato (signing date, YYYY-MM-DD). Pages are 50 rows.
"""
import argparse, csv, json, os, re, subprocess, sys, time, urllib.parse
from collections import defaultdict

API = "https://www.base.gov.pt/Base4/pt/resultados/"
UA = "Mozilla/5.0 (newsroom-agents base-summary.py)"
DIRECT = re.compile(r"ajuste direto", re.I)

def post(data):
    # curl rather than urllib: it uses the system certificate store, which some Python builds lack
    cmd = ["curl", "-sS", "--fail", "--max-time", "60", "-A", UA, "-H", "X-Requested-With: XMLHttpRequest",
           "-H", "Content-Type: application/x-www-form-urlencoded; charset=UTF-8", "-d", urllib.parse.urlencode(data), API]
    for attempt in range(3):
        r = subprocess.run(cmd, capture_output=True, text=True)
        if r.returncode == 0 and r.stdout.strip():
            return json.loads(r.stdout.strip())
        if attempt == 2: sys.exit(f"Portal BASE request failed: {r.stderr.strip() or 'empty response'}")
        time.sleep(2 * (attempt + 1))  # transient portal errors are common

def price(s):
    """'25.084,08 €' -> 25084.08; None/'-' -> None."""
    if not s: return None
    s = re.sub(r"[^\d,]", "", s)
    return float(s.replace(",", ".")) if s else None

def iso(d):
    """'12-09-2026' -> '2026-09-12'; None stays None."""
    return f"{d[6:10]}-{d[3:5]}-{d[0:2]}" if d and len(d) == 10 else d

def fetch_all(query, max_pages):
    rows, page = [], 0
    while True:
        r = post({"type": "search_contratos", "version": "133.0", "query": query,
                  "sort": "-publicationDate", "page": page, "size": 50})
        rows += r.get("items", [])
        total = r.get("total", 0)
        print(f"  page {page + 1}: {len(rows)}/{total}", file=sys.stderr)
        page += 1
        if len(rows) >= total or not r.get("items") or page >= max_pages: break
        time.sleep(0.3)
    return rows, total

def detail(cid):
    return post({"type": "detail_contratos", "version": "133.0", "id": cid})

def eur(v): return f"{v:,.2f}".replace(",", " ").replace(".", ",") + " €"

def summarise(rows, query):
    by_year, by_proc, by_awardee = defaultdict(lambda: [0, 0.0]), defaultdict(lambda: [0, 0.0]), defaultdict(lambda: [0, 0.0, 0])
    total = 0.0
    for r in rows:
        v = r["price_eur"] or 0.0; total += v
        y = (r["signingDate"] or r["publicationDate"] or "????")[:4]
        by_year[y][0] += 1; by_year[y][1] += v
        by_proc[r["procedure"]][0] += 1; by_proc[r["procedure"]][1] += v
        a = by_awardee[r["contracted"]]; a[0] += 1; a[1] += v; a[2] += bool(DIRECT.search(r["procedure"] or ""))
    n = len(rows)
    out = [f"# Portal BASE: {query}", "", f"{n} contratos, {eur(total)} (preço contratual inicial, valores como declarados no BASE, extraído em {time.strftime('%Y-%m-%d')})", "",
           "## Por ano", "| Ano | Contratos | Valor |", "|---|---|---|"]
    out += [f"| {y} | {c} | {eur(v)} |" for y, (c, v) in sorted(by_year.items())]
    out += ["", "## Por tipo de procedimento", "| Procedimento | Contratos | Valor | % do valor |", "|---|---|---|---|"]
    out += [f"| {p} | {c} | {eur(v)} | {100 * v / total if total else 0:.1f} % |" for p, (c, v) in sorted(by_proc.items(), key=lambda kv: -kv[1][1])]
    out += ["", "## Maiores adjudicatários (por valor)", "| Adjudicatário | Contratos | dos quais ajuste direto | Valor | % do valor |", "|---|---|---|---|---|"]
    out += [f"| {a} | {c} | {d} | {eur(v)} | {100 * v / total if total else 0:.1f} % |" for a, (c, v, d) in sorted(by_awardee.items(), key=lambda kv: -kv[1][1])[:20]]
    out += ["", "## Adjudicatários com mais ajustes diretos", "| Adjudicatário | Ajustes diretos | Valor total |", "|---|---|---|"]
    out += [f"| {a} | {d} | {eur(v)} |" for a, (c, v, d) in sorted(by_awardee.items(), key=lambda kv: -kv[1][2])[:20] if d]
    out += ["", "Um padrão (concentração, ajustes diretos repetidos, valores próximos de limiares) é uma pista a verificar junto da entidade e do adjudicatário, não uma conclusão.",
           "Adjudicatários com nome de pessoa singular são particulares (peritos, formadores, artistas): só entram numa peça com justificação de interesse público e direito de resposta."]
    return "\n".join(out)

def selftest():
    assert price("25.084,08 €") == 25084.08 and price("1.332,12 €") == 1332.12 and price("-") is None and price(None) is None
    assert iso("12-09-2026") == "2026-09-12" and iso(None) is None
    rows = [{"price_eur": 100.0, "signingDate": "2025-01-02", "publicationDate": None, "procedure": "Ajuste Direto Regime Geral", "contracted": "A"},
            {"price_eur": 300.0, "signingDate": None, "publicationDate": "2024-12-30", "procedure": "Concurso público", "contracted": "B"}]
    s = summarise(rows, "t")
    assert "| 2025 | 1 | 100,00 € |" in s and "| 2024 | 1 | 300,00 € |" in s and "| A | 1 | 1 |" in s and "75.0 %" in s
    print("selftest ok")

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--adjudicante"); ap.add_argument("--adjudicataria"); ap.add_argument("--texto")
    ap.add_argument("--from", dest="date_from", help="signing date >= YYYY-MM-DD"); ap.add_argument("--to", dest="date_to", help="signing date <= YYYY-MM-DD")
    ap.add_argument("--out", default="base-data"); ap.add_argument("--details", action="store_true", help="fetch the full record of every contract (slow)")
    ap.add_argument("--max-pages", type=int, default=400, help="safety cap (50 contracts per page)")
    ap.add_argument("--selftest", action="store_true")
    a = ap.parse_args()
    if a.selftest: return selftest()
    q = "&".join(f"{k}={v}" for k, v in [("adjudicante", a.adjudicante), ("adjudicataria", a.adjudicataria), ("texto", a.texto),
                                          ("desdedatacontrato", a.date_from), ("atedatacontrato", a.date_to)] if v)
    if not q: sys.exit("give at least one filter (--adjudicante, --adjudicataria, --texto)")
    print(f"query: {q}", file=sys.stderr)
    items, total = fetch_all(q, a.max_pages)
    rows = [{"id": i["id"], "url": f"https://www.base.gov.pt/Base4/pt/detalhe/?type=contratos&id={i['id']}",
             "signingDate": iso(i.get("signingDate")), "publicationDate": iso(i.get("publicationDate")),
             "contracting": i.get("contracting"), "contracted": i.get("contracted"), "procedure": i.get("contractingProcedureType"),
             "price_eur": price(i.get("initialContractualPrice")), "description": i.get("objectBriefDescription")} for i in items]
    if a.details:
        for k, r in enumerate(rows, 1):
            d = detail(r["id"]); time.sleep(0.2)
            r.update({"contracting_nif": ";".join(x["nif"] for x in d.get("contracting") or []), "contracted_nif": ";".join(x["nif"] for x in d.get("contracted") or []),
                      "cpv": d.get("cpvs"), "legal_basis": d.get("contractFundamentationType"), "direct_award_justification": d.get("directAwardFundamentationType"),
                      "execution_place": (d.get("executionPlace") or "").split("<BR/>")[0], "procedure_url": d.get("contractingProcedureUrl")})
            if k % 25 == 0: print(f"  details {k}/{len(rows)}", file=sys.stderr)
    os.makedirs(a.out, exist_ok=True)
    with open(os.path.join(a.out, "contratos.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()) if rows else ["id"]); w.writeheader(); w.writerows(rows)
    md = summarise(rows, q)
    open(os.path.join(a.out, "resumo.md"), "w").write(md + "\n")
    print(md); print(f"\nwrote {a.out}/contratos.csv ({len(rows)} of {total} reported) and {a.out}/resumo.md", file=sys.stderr)

if __name__ == "__main__":
    main()
