#!/usr/bin/env node
// render-check.mjs <index.html> — executes a standalone graphic in jsdom and checks the desk's structural rules.
// Needs jsdom: first run installs it into $CLAUDE_PLUGIN_DATA (or ./node_modules if present).
import { createRequire } from "node:module";
import { execSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { resolve, dirname } from "node:path";
import { pathToFileURL } from "node:url";

const file = process.argv[2];
if (!file) { console.error("usage: render-check.mjs <index.html> [--svg out.svg]"); process.exit(2); }
const svgOut = process.argv.includes("--svg") ? process.argv[process.argv.indexOf("--svg") + 1] : null;

const dataDir = process.env.CLAUDE_PLUGIN_DATA || resolve(process.cwd(), ".render-check");
let JSDOM;
const tryLoad = () => {
  for (const base of [process.cwd(), dataDir, dirname(new URL(import.meta.url).pathname)]) {
    try { ({ JSDOM } = createRequire(resolve(base, "package.json"))("jsdom")); return true; } catch {}
  }
  try { ({ JSDOM } = createRequire(import.meta.url)("jsdom")); return true; } catch { return false; }
};
if (!tryLoad()) {
  console.error(`installing jsdom into ${dataDir} (one time)…`);
  try {
    execSync(`mkdir -p "${dataDir}" && cd "${dataDir}" && npm init -y >/dev/null && npm install --no-audit --no-fund jsdom`, { stdio: "inherit" });
  } catch {}
  if (!tryLoad()) {
    console.error(`could not install jsdom automatically. Run: npm install jsdom (in the project, or in ${dataDir}) and re-run.`);
    process.exit(2);
  }
}

const html = readFileSync(file, "utf8");
const errors = [];
const dom = new JSDOM(html, {
  runScripts: "dangerously", resources: "usable", pretendToBeVisual: true,
  url: pathToFileURL(resolve(file)).href,
  beforeParse(w) {
    w.ResizeObserver = class { observe(){} unobserve(){} disconnect(){} };
    // jsdom has no fetch: serve local files (data/…) from disk, delegate http(s) to Node.
    w.fetch = async (url, init) => {
      const u = new URL(String(url), w.location.href);
      if (u.protocol === "file:") {
        try { const t = readFileSync(u, "utf8"); return { ok: true, status: 200, url: u.href, text: async () => t, json: async () => JSON.parse(t) }; }
        catch (e) { return { ok: false, status: 404, url: u.href, text: async () => "", json: async () => { throw e; } }; }
      }
      return fetch(u, init);
    };
  }
});
dom.window.addEventListener("error", e => errors.push(String(e.error || e.message)));
dom.window.console.error = (...a) => errors.push(a.join(" "));
await new Promise(r => dom.window.addEventListener("load", r));
await new Promise(r => setTimeout(r, 1500)); // let deferred draws run

const d = dom.window.document;
const q = s => d.querySelector(s);
const text = s => (q(s)?.textContent || "").trim();
const checks = [
  ["no script errors", errors.length === 0, errors.join("; ")],
  ["<title> set", !!text("title") && !/^(TÍTULO|TITLE|Untitled)/i.test(text("title"))],
  ["title is a sentence (h1, > 3 words)", text("h1").split(/\s+/).length > 3],
  ["subtitle present", text(".subtitle").length > 10],
  ["source line present", /fonte|source/i.test(text(".source"))],
  ["figure with aria-label", !!q("figure[role='img'][aria-label]") && (q("figure").getAttribute("aria-label") || "").length > 20],
  ["table view present", !!q("details table tbody tr")],
  ["svg has marks", (q("svg")?.querySelectorAll("path, rect, circle, line").length || 0) > 2],
  ["axes or legend text rendered", (q("svg")?.querySelectorAll("text").length || 0) > 2],
  ["placeholder DATA replaced", !/\bDATA\s*=\s*\[\s*\]/.test(html)],
  ["pinned D3 from jsdelivr", /cdn\.jsdelivr\.net\/npm\/d3@7\.\d+\.\d+/.test(html)],
  ["no dual y-axis", (d.querySelectorAll(".y-axis, [class*='y-axis']").length) <= 1],
  ["reduced motion respected", /prefers-reduced-motion/.test(html)],
];
if (svgOut && q("svg")) { (await import("node:fs")).writeFileSync(svgOut, q("svg").outerHTML); console.log(`svg written to ${svgOut}`); }
let fail = 0;
for (const [name, ok, detail] of checks) {
  console.log(`${ok ? "PASS" : "FAIL"}  ${name}${!ok && detail ? " — " + detail : ""}`);
  if (!ok) fail++;
}
console.log(fail ? `\n${fail} check(s) failed` : "\nall render checks passed");
dom.window.close();
process.exit(fail ? 1 : 0);
