#!/usr/bin/env python3
"""pdf2md.py INPUT.pdf [docs_cache_dir] -> prints the path of the cached .md.

Converts once; reuses the cache when the PDF is unchanged (sha256 stored beside the .md).
Tries pymupdf4llm (layout-aware), falls back to pdftotext, then ocrmypdf for scans.
"""
import hashlib, os, re, shutil, subprocess, sys

def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()

def convert(pdf, md):
    try:
        import pymupdf4llm  # noqa
    except ImportError:
        subprocess.run([sys.executable, "-m", "pip", "install", "--quiet", "--break-system-packages", "pymupdf4llm"], check=False)
    try:
        import pymupdf4llm
        text = pymupdf4llm.to_markdown(pdf)
        # ponytail: flat threshold to detect scans with no text layer; make it per-page if long scans with a cover page slip through
        if len(text.strip()) >= 40:
            open(md, "w").write(text); return "pymupdf4llm"
    except Exception as e:  # noqa
        print(f"pymupdf4llm failed: {e}", file=sys.stderr)
    if shutil.which("pdftotext"):
        subprocess.run(["pdftotext", "-layout", pdf, md], check=False)
        if os.path.exists(md) and os.path.getsize(md) >= 40:
            return "pdftotext"
    if shutil.which("ocrmypdf"):
        ocr = md[:-3] + "_ocr.pdf"
        subprocess.run(["ocrmypdf", "--force-ocr", "--quiet", pdf, ocr], check=False)
        if os.path.exists(ocr):
            subprocess.run(["pdftotext", "-layout", ocr, md], check=False)
            os.remove(ocr)
            if os.path.exists(md) and os.path.getsize(md) >= 40:
                return "ocrmypdf+pdftotext"
    sys.exit("conversion failed: install pymupdf4llm (pip) or ocrmypdf (brew/apt) for scanned PDFs")

def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    pdf = sys.argv[1]
    cache = sys.argv[2] if len(sys.argv) > 2 else "docs_cache"
    os.makedirs(cache, exist_ok=True)
    slug = re.sub(r"[^A-Za-z0-9._-]+", "_", os.path.splitext(os.path.basename(pdf))[0])
    md, digest_file = os.path.join(cache, slug + ".md"), os.path.join(cache, slug + ".sha256")
    digest = sha256(pdf)
    if os.path.exists(md) and os.path.exists(digest_file) and open(digest_file).read().strip() == digest:
        print(md); return
    tool = convert(pdf, md)
    open(digest_file, "w").write(digest)
    lines = sum(1 for _ in open(md, errors="replace"))
    print(md)
    print(f"# converted with {tool}: {lines} lines, source sha256 {digest[:12]}", file=sys.stderr)

if __name__ == "__main__":
    main()
