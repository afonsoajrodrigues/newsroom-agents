#!/usr/bin/env python3
"""geo-prep.py INPUT OUTPUT [--layer NAME] [--keep f1,f2] [--simplify 0.05] [--where "expr"]

Reads any vector file geopandas can open (GeoPackage, Shapefile, GeoJSON), reprojects to
WGS84, keeps only the named attribute fields, and writes:
  - TopoJSON with topology-preserving simplification when mapshaper is on PATH or in
    node_modules (recommended: `npm i mapshaper` in the project, or `npm i -g mapshaper`),
  - otherwise GeoJSON simplified with shapely (topology not preserved; fine for small maps).
"""
import argparse, os, shutil, subprocess, sys

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("input"); ap.add_argument("output")
    ap.add_argument("--layer"); ap.add_argument("--keep", help="comma-separated fields to keep")
    ap.add_argument("--simplify", type=float, default=0.05, help="fraction of vertices to keep (mapshaper) or tolerance in degrees (fallback)")
    ap.add_argument("--where", help='pandas query, e.g. "distrito_ilha == \'Lisboa\'"')
    a = ap.parse_args()
    try:
        import geopandas as gpd
    except ImportError:
        sys.exit("pip install geopandas pyogrio")
    g = gpd.read_file(a.input, layer=a.layer) if a.layer else gpd.read_file(a.input)
    if a.where:
        g = g.query(a.where)
    if g.crs is None:
        print("warning: input has no CRS, assuming EPSG:4326", file=sys.stderr)
        g = g.set_crs(4326)
    g = g.to_crs(4326)
    if a.keep:
        g = g[[c for c in a.keep.split(",")] + ["geometry"]]
    print(f"{len(g)} features, fields: {[c for c in g.columns if c != 'geometry']}", file=sys.stderr)

    ms = shutil.which("mapshaper") or next((p for p in ("node_modules/.bin/mapshaper", os.path.expanduser("~/node_modules/.bin/mapshaper")) if os.path.exists(p)), None)
    if ms:
        tmp = a.output + ".tmp.geojson"
        g.to_file(tmp, driver="GeoJSON")
        subprocess.run([ms, tmp, "-simplify", f"{a.simplify*100:g}%", "keep-shapes", "-rename-layers", "boundaries", "-o", "format=topojson", a.output], check=True)
        os.remove(tmp)
        print(f"wrote {a.output} (TopoJSON via mapshaper, {a.simplify:g} of vertices kept)", file=sys.stderr)
    else:
        # ponytail: shapely simplify is not topology-preserving; gaps can appear between neighbours. Install mapshaper for real maps.
        g["geometry"] = g.geometry.simplify(a.simplify, preserve_topology=True)
        g.to_file(a.output, driver="GeoJSON")
        print(f"wrote {a.output} (GeoJSON, shapely simplify tolerance {a.simplify:g}; install mapshaper for topology-preserving TopoJSON)", file=sys.stderr)
    print(f"{os.path.getsize(a.output)/1e6:.2f} MB", file=sys.stderr)

if __name__ == "__main__":
    main()
