/* Static fallbacks for the interactive exhibits — build-time generator.
 *
 * The exhibit stubs (<div class="fp-exhibit" data-exhibit="...">) are empty in
 * the source; exhibits.js fills them in the browser. This script mounts each
 * widget in a headless DOM (jsdom), captures its initial rendered state, and
 * writes a cleaned, static snapshot to exhibit-fallbacks/<type>.html. split.py
 * injects those into the stubs, so no-JS readers, crawlers, screen readers and
 * the EPUB edition see real content; when JS runs, build() overwrites innerHTML
 * and the live widget takes over — no hydration glue needed.
 *
 * Dev tool, like first-principles-figures/strips.cjs: run locally after editing
 * exhibits.js. The output is committed; CI never runs this.
 *   npm i jsdom && node fallbacks.cjs
 */
const { JSDOM } = require("jsdom");
const fs = require("fs");
const path = require("path");

const TYPES = ["strip", "merge", "select", "canon", "delta", "methods", "reveal", "pipeline"];
const OUT = path.join(__dirname, "exhibit-fallbacks");
const STRIP_LABELS = ["the page, as shipped", "− style off", "− arrangement off", "− selection off"];

/* Option A cleaning: drop the interactive-only chrome (control bars, buttons),
 * render textareas as static <pre> of their seed facts, keep the data panels. */
function clean(d, root, type) {
  // salvage explanatory notes out of the control bars before dropping them
  // (strip is handled separately, with a label per stage)
  if (type !== "strip") {
    root.querySelectorAll(".fp-controls").forEach(function (c) {
      c.querySelectorAll(".fp-note").forEach(function (n) { c.parentNode.insertBefore(n, c); });
    });
  }
  root.querySelectorAll(".fp-controls, button").forEach(function (el) { el.remove(); });

  root.querySelectorAll("textarea").forEach(function (ta) {
    var pre = d.createElement("pre");
    pre.className = "fp-out fp-static";
    pre.textContent = ta.value;
    ta.parentNode.replaceChild(pre, ta);
  });

  // reveal the strip's stacked stages (and any other hidden panel)
  root.querySelectorAll("[hidden]").forEach(function (el) { el.removeAttribute("hidden"); });

  if (type === "strip") {
    var head = root.querySelector(".fp-panel > .fp-head");
    if (head) head.remove();
    for (var i = 0; i < 4; i++) {
      var view = root.querySelector(".fp-view-" + i);
      if (!view) continue;
      var h = d.createElement("div");
      h.className = "fp-head";
      var span = d.createElement("span");
      span.className = "fp-stage-lbl";
      span.textContent = STRIP_LABELS[i];
      h.appendChild(span);
      view.insertBefore(h, view.firstChild);
    }
  }
}

const stubs = TYPES.map(function (t) {
  return '<div class="fp-exhibit" data-exhibit="' + t + '"></div>';
}).join("\n");
const js = fs.readFileSync(path.join(__dirname, "exhibits.js"), "utf8");
const dom = new JSDOM("<!DOCTYPE html><body>" + stubs + "</body>",
  { runScripts: "dangerously", pretendToBeVisual: true });
const script = dom.window.document.createElement("script");
script.textContent = js;
dom.window.document.body.appendChild(script);

// widgets mount on DOMContentLoaded; let the event loop turn, then capture
setTimeout(function () {
  const d = dom.window.document;
  if (!fs.existsSync(OUT)) fs.mkdirSync(OUT);
  TYPES.forEach(function (t) {
    const root = d.querySelector('[data-exhibit="' + t + '"]');
    if (!root || !root.classList.contains("fp-live")) {
      console.error("FAILED to mount:", t);
      process.exitCode = 1;
      return;
    }
    clean(d, root, t);
    fs.writeFileSync(path.join(OUT, t + ".html"), root.innerHTML.trim() + "\n");
    console.log(t.padEnd(9), root.innerHTML.length + " chars");
  });
}, 400);
