/* Interactive exhibits — online edition only.
 *
 * Self-contained: no dependencies, no network, no build step. The pattern
 * engine below is deliberately small — the book claims the selection algebra
 * is four operations, and the claim is checkable by reading this file.
 * Arrangement is a small tree transform in JS here; the LinkedDataHub edition
 * refactors it to IXSL.
 *
 * Widgets mount into <div class="fp-exhibit" data-exhibit="..."> stubs in the
 * source; without this script the stubs are invisible and the captions stand.
 */
(function () {
  "use strict";

  /* ——————— fact model: one fact per line, `entity attribute value` ——————— */

  var DATA_NS = "https://wind.example/farm#";
  var VOCAB_NS = "https://wind.example/vocab#";

  function parseFacts(text) {
    var facts = [];
    text.split("\n").forEach(function (line) {
      var s = line.trim();
      if (!s) return;
      var m = s.match(/^(\S+)\s+(\S+)\s+(.+)$/);
      if (m) facts.push({ s: m[1], p: m[2], o: m[3].trim() });
    });
    return facts;
  }
  function key(f) { return f.s + " " + f.p + " " + f.o; }
  function isVar(t) { return t.charAt(0) === "?"; }
  function isLit(t) { return t.charAt(0) === '"'; }
  function esc(s) {
    return String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }

  /* ——————— two skins: the derivation's notation, and what shipped ——————— */

  function term(t, pos, skin) {
    if (isVar(t)) return '<span class="fp-tok-var">' + esc(t) + "</span>";
    if (isLit(t)) return '<span class="fp-tok-lit">' + esc(t) + "</span>";
    if (skin === "shipped") {
      if (pos === "p") {
        return t === "type" ? '<span class="fp-tok-kw">a</span>'
          : '<span class="fp-tok-name">w:' + esc(t) + "</span>";
      }
      var pre = pos === "o" && /^[A-Z]/.test(t) ? "w:" : "d:";
      return '<span class="fp-tok-name">' + pre + esc(t) + "</span>";
    }
    if (pos === "p") return '<span class="fp-tok-name">' + esc(t) + "</span>";
    return '<span class="fp-tok-name">⟨…#' + esc(t) + "⟩</span>";
  }

  function factLine(f, skin, cls) {
    var open = cls ? '<span class="' + cls + '">' : "<span>";
    if (skin === "shipped") {
      return open + term(f.s, "s", skin) + " " + term(f.p, "p", skin) + " " +
        term(f.o, "o", skin) + " .</span>";
    }
    return open + "(" + term(f.s, "s", skin) + ", " + term(f.p, "p", skin) + ", " +
      term(f.o, "o", skin) + ")</span>";
  }

  function prefixHeader() {
    return '<span class="fp-tok-kw">@prefix d: &lt;' + DATA_NS +
      "&gt; .\n@prefix w: &lt;" + VOCAB_NS + "&gt; .</span>\n\n";
  }

  function stateHTML(facts, skin, marks) {
    marks = marks || {};
    var head = skin === "shipped" ? prefixHeader() : "";
    return head + facts.map(function (f) {
      var k = key(f);
      var cls = marks.dup && marks.dup.has(k) ? "fp-dup"
        : marks.add && marks.add.has(k) ? "fp-add"
        : marks.hot && marks.hot.has(k) ? "fp-new"
        : marks.dimUnless && !marks.dimUnless.has(k) ? "fp-dim" : "";
      return factLine(f, skin, cls);
    }).join("\n");
  }

  /* ——————— canon: deduplicate, sort, one block per entity ——————— */

  function canonMap(facts) {
    var seen = {}, unique = [];
    facts.forEach(function (f) {
      var k = key(f);
      if (!seen[k]) { seen[k] = true; unique.push(f); }
    });
    unique.sort(function (a, b) {
      return a.s < b.s ? -1 : a.s > b.s ? 1 : a.p < b.p ? -1 : a.p > b.p ? 1 :
        a.o < b.o ? -1 : a.o > b.o ? 1 : 0;
    });
    var order = [], by = {};
    unique.forEach(function (f) {
      if (!by[f.s]) { by[f.s] = []; order.push(f.s); }
      by[f.s].push(f);
    });
    return { order: order, by: by };
  }

  function canonHTML(cm, skin) {
    if (!cm.order.length) return '<span class="fp-tok-kw">∅ — nothing selected</span>';
    var head = skin === "shipped" ? prefixHeader() : "";
    return head + cm.order.map(function (s) {
      var fs = cm.by[s];
      if (skin === "shipped") {
        return term(s, "s", skin) + "\n" + fs.map(function (f, i) {
          return "    " + term(f.p, "p", skin) + " " + term(f.o, "o", skin) +
            (i === fs.length - 1 ? " ." : " ;");
        }).join("\n");
      }
      return term(s, "s", skin) + "\n" + fs.map(function (f) {
        return "    " + term(f.p, "p", skin) + " · " + term(f.o, "o", skin);
      }).join("\n");
    }).join("\n\n");
  }

  /* ——————— the selection algebra: pattern, join, union, project ——————— */

  function unify(pat, f, sol) {
    var out = { s: null }, k;
    out = {};
    for (k in sol) out[k] = sol[k];
    var poss = ["s", "p", "o"];
    for (var i = 0; i < 3; i++) {
      var pos = poss[i], t = pat[pos], v = f[pos];
      if (isVar(t)) {
        if (t in out && out[t] !== v) return null;
        out[t] = v;
      } else if (t !== v) return null;
    }
    return out;
  }

  function evalPattern(text, facts) {
    var pats = parseFacts(text);
    var sols = [{}], touched = {};
    pats.forEach(function (pat) {
      var next = [];
      sols.forEach(function (sol) {
        facts.forEach(function (f) {
          var b = unify(pat, f, sol);
          if (b) { next.push(b); touched[key(f)] = true; }
        });
      });
      sols = next;
    });
    var vars = [], seen = {};
    pats.forEach(function (p) {
      [p.s, p.p, p.o].forEach(function (t) {
        if (isVar(t) && !seen[t]) { seen[t] = true; vars.push(t); }
      });
    });
    return {
      sols: sols, vars: vars, empty: !pats.length,
      touched: { has: function (k) { return !!touched[k]; } }
    };
  }

  /* ——————— the write side: write(r, S) = (S ∖ D⁻) ∪ D⁺ ——————— */

  function applyDelta(S, dMinus, dPlus) {
    var minus = {}, present = {};
    dMinus.forEach(function (f) { minus[key(f)] = true; });
    S.forEach(function (f) { present[key(f)] = true; });
    var next = S.filter(function (f) { return !minus[key(f)]; });
    var added = {};
    dPlus.forEach(function (f) {
      var k = key(f);
      if (!present[k] || minus[k]) {
        if (!next.some(function (g) { return key(g) === k; })) {
          next.push(f); added[k] = true;
        }
      }
    });
    return { next: next, added: { has: function (k) { return !!added[k]; } } };
  }

  /* ——————— arrange = ⟦t⟧ ∘ canon — the term t, as a small tree transform ——————— */

  function arrangeHTML(cm, which) {
    function val(f) { return isLit(f.o) ? f.o.replace(/^"|"$/g, "") : f.o; }
    if (which === "table") {
      var rows = "";
      cm.order.forEach(function (s) {
        cm.by[s].forEach(function (f) {
          rows += "<tr><td>" + esc(s) + "</td><td>" + esc(f.p) +
            "</td><td>" + esc(val(f)) + "</td></tr>";
        });
      });
      return "<table><tr><th>entity</th><th>attribute</th><th>value</th></tr>" +
        rows + "</table>";
    }
    var out = "";
    cm.order.forEach(function (s) {
      var fs = cm.by[s];
      function pick(attr) {
        for (var i = 0; i < fs.length; i++) if (fs[i].p === attr) return val(fs[i]);
        return null;
      }
      var heading = pick("title") || pick("label") || pick("name") || s;
      var dl = "";
      fs.forEach(function (f) {
        if (f.p !== "title" && f.p !== "type") {
          dl += "<dt>" + esc(f.p) + "</dt><dd>" + esc(val(f)) + "</dd>";
        }
      });
      out += '<div class="fp-card"><h3>' + esc(heading) + "</h3><dl>" + dl + "</dl></div>";
    });
    return "<div>" + out + "</div>";
  }

  /* ——————— the state, drawn as the graph it is ——————— */

  function drawGraph(facts, box) {
    var nodes = {}, order = [], edges = [];
    function add(id, lit) {
      if (!nodes[id]) { nodes[id] = { id: id, lit: lit }; order.push(nodes[id]); }
      return nodes[id];
    }
    facts.forEach(function (f) {
      if (f.p === "type") { add(f.s, false); return; }
      edges.push({ a: add(f.s, false), b: add(f.o, isLit(f.o)), p: f.p });
    });
    var N = order, W = 900, H = Math.max(280, N.length * 24);
    N.forEach(function (n, i) {
      var ang = (i / Math.max(N.length, 1)) * Math.PI * 2;
      n.x = W / 2 + Math.cos(ang) * W / 3.2;
      n.y = H / 2 + Math.sin(ang) * H / 3;
    });
    for (var it = 0; it < 160; it++) {
      N.forEach(function (a) {
        N.forEach(function (b) {
          if (a === b) return;
          var dx = a.x - b.x, dy = a.y - b.y, d2 = Math.max(dx * dx + dy * dy, 40);
          var f = 5200 / d2, d = Math.sqrt(d2);
          a.x += dx / d * f; a.y += dy / d * f;
        });
      });
      edges.forEach(function (e) {
        var dx = e.b.x - e.a.x, dy = e.b.y - e.a.y, d = Math.max(Math.sqrt(dx * dx + dy * dy), 1);
        var f = (d - 125) * 0.04;
        e.a.x += dx / d * f; e.a.y += dy / d * f;
        e.b.x -= dx / d * f; e.b.y -= dy / d * f;
      });
      N.forEach(function (n) {
        n.x += (W / 2 - n.x) * 0.012; n.y += (H / 2 - n.y) * 0.012;
        n.x = Math.min(W - 90, Math.max(90, n.x));
        n.y = Math.min(H - 24, Math.max(24, n.y));
      });
    }
    var s = '<svg class="fp-graph" viewBox="0 0 ' + W + " " + H +
      '" role="img" aria-label="The state as a graph">';
    edges.forEach(function (e) {
      var mx = (e.a.x + e.b.x) / 2, my = (e.a.y + e.b.y) / 2;
      s += '<line class="fp-edge" x1="' + e.a.x + '" y1="' + e.a.y +
        '" x2="' + e.b.x + '" y2="' + e.b.y + '"></line>' +
        '<text class="fp-edge-lbl" x="' + mx + '" y="' + (my - 4) +
        '" text-anchor="middle">' + esc(e.p) + "</text>";
    });
    N.forEach(function (n) {
      var label = n.lit ? n.id.replace(/^"|"$/g, "") : n.id;
      var short = label.length > 17 ? label.slice(0, 16) + "…" : label;
      if (n.lit) {
        var w = short.length * 6.4 + 14;
        s += '<g class="fp-lit"><rect x="' + (n.x - w / 2) + '" y="' + (n.y - 11) +
          '" width="' + w + '" height="22" rx="3"></rect>' +
          '<text class="fp-n-lbl" x="' + n.x + '" y="' + (n.y + 3.5) +
          '" text-anchor="middle">' + esc(short) + "</text></g>";
      } else {
        s += '<circle cx="' + n.x + '" cy="' + n.y + '" r="7"></circle>' +
          '<text class="fp-n-lbl" x="' + n.x + '" y="' + (n.y - 12) +
          '" text-anchor="middle">' + esc(short) + "</text>";
      }
    });
    box.innerHTML = s + "</svg>";
  }

  /* ——————— seed data: the running example, and the second site ——————— */

  var SEED = {
    A: "panel-14 type Panel\npanel-14 title \"Current Power\"\npanel-14 value \"15.5 kW\"\n" +
      "panel-7 type Panel\npanel-7 title \"Wind Speed\"\npanel-7 value \"8.2 m/s\"\n" +
      "farm name \"Anholt Offshore\"\npanel-14 partOf farm\npanel-7 partOf farm",
    B: "panel-14 value \"15.5 kW\"\npanel-14 unit \"kW\"\n" +
      "turbine-3 type Turbine\nturbine-3 label \"A-03\"\nturbine-3 feeds panel-14\n" +
      "farm operator \"Ørsted A/S\"",
    Q1: "?p type Panel\n?p title ?t\n?p value ?v",
    Q2: "?turbine feeds ?p\n?turbine label ?id\n?p title ?t",
    POOL: "panel-14 type Panel\npanel-14 title \"Current Power\"\npanel-14 value \"15.5 kW\"\n" +
      "panel-14 partOf overview\n" +
      "panel-7 type Panel\npanel-7 title \"Wind Speed\"\npanel-7 value \"8.2 m/s\"\n" +
      "panel-7 partOf overview\n" +
      "panel-3 type Panel\npanel-3 title \"Grid Frequency\"\npanel-3 value \"49.98 Hz\"\n" +
      "panel-3 partOf archive\n" +
      "farm name \"Anholt Offshore\"",
    WINDOW: "?p partOf overview\n?p title ?t\n?p value ?v",
    NEWS: "story-1 type Article\nstory-1 title \"Storm front reaches the Baltic\"\n" +
      "story-1 section \"World\"\nstory-1 standfirst \"Gusts of 31 m/s off Anholt as the front tracks east.\"\n" +
      "story-2 type Article\nstory-2 title \"Grid operator reports record wind output\"\n" +
      "story-2 section \"Business\"\nstory-2 standfirst \"Offshore farms covered 71% of demand overnight.\"\n" +
      "story-3 type Article\nstory-3 title \"What a turbine knows\"\n" +
      "story-3 section \"Science\"\nstory-3 standfirst \"Inside the telemetry of a modern wind farm.\"",
    NEWSQ: "?a type Article\n?a title ?t\n?a section ?s\n?a standfirst ?f",
    DELTA_S: "panel-14 title \"Current Power\"\npanel-14 value \"15.5 kW\"\n" +
      "panel-7 title \"Wind Speed\"\npanel-7 value \"8.2 m/s\"",
    DMINUS: "panel-14 value \"15.5 kW\"",
    DPLUS: "panel-14 value \"16.1 kW\""
  };

  function mergedSeed() {
    var cm = canonMap(parseFacts(SEED.A).concat(parseFacts(SEED.B)));
    var out = [];
    cm.order.forEach(function (s) { cm.by[s].forEach(function (f) { out.push(f); }); });
    return out;
  }

  /* ——————— DOM helpers ——————— */

  var uid = 0;
  function q(root, sel) { return root.querySelector(sel); }
  function qa(root, sel) {
    return Array.prototype.slice.call(root.querySelectorAll(sel));
  }
  function on(root, sel, ev, fn) {
    qa(root, sel).forEach(function (el) { el.addEventListener(ev, fn); });
  }
  function debounce(fn) {
    var t;
    return function () { clearTimeout(t); t = setTimeout(fn, 250); };
  }
  function seg(name, options, checkedValue) {
    return '<div class="fp-seg" role="radiogroup">' + options.map(function (o) {
      return "<label><input type=\"radio\" name=\"" + name + "\" value=\"" + o.v + "\"" +
        (o.v === checkedValue ? " checked" : "") + "><span>" + o.l + "</span></label>";
    }).join("") + "</div>";
  }
  function segValue(root, name) {
    var el = q(root, 'input[name="' + name + '"]:checked');
    return el ? el.value : null;
  }
  function shuffleLines(text) {
    var lines = text.split("\n").filter(function (l) { return l.trim(); });
    for (var i = lines.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var tmp = lines[i]; lines[i] = lines[j]; lines[j] = tmp;
    }
    return lines.join("\n");
  }

  /* a channel between widgets on the same page (Chapter 5) */
  var shared = { merged: null };

  /* ——————— Chapter 3: the strip, performable ——————— */

  function wStrip(root) {
    var id = "fps" + (++uid);
    var pool = parseFacts(SEED.POOL);
    var sel = evalPattern(SEED.WINDOW, pool);
    var windowFacts = pool.filter(function (f) { return sel.touched.has(key(f)); });
    var cm = canonMap(windowFacts);
    root.innerHTML =
      '<div class="fp-controls">' +
      seg(id, [
        { v: "0", l: "the page, as shipped" }, { v: "1", l: "− style" },
        { v: "2", l: "− arrangement" }, { v: "3", l: "− selection" }
      ], "0") +
      '<span class="fp-note fp-hint"></span></div>' +
      '<div class="fp-panel"><div class="fp-head"><span class="fp-stage-lbl"></span></div>' +
      '<div class="fp-view-0 fp-render fp-theme-console"><div class="fp-rendered"></div></div>' +
      '<div class="fp-view-1 fp-render fp-plain" hidden><div class="fp-rendered"></div></div>' +
      '<div class="fp-view-2" hidden><pre class="fp-out"></pre></div>' +
      '<div class="fp-view-3" hidden><pre class="fp-out"></pre></div>' +
      "</div>";
    q(root, ".fp-view-0 .fp-rendered").innerHTML = arrangeHTML(cm, "cards");
    q(root, ".fp-view-1 .fp-rendered").innerHTML = arrangeHTML(cm, "cards");
    q(root, ".fp-view-2 pre").innerHTML = canonHTML(cm, "derived");
    var winKeys = { has: sel.touched.has };
    q(root, ".fp-view-3 pre").innerHTML =
      '<span class="fp-tok-kw">selection: ?p partOf overview · ?p title ?t · ?p value ?v</span>\n\n' +
      stateHTML(pool, "derived", { dimUnless: sel.touched });
    var HINTS = [
      ["wind-farm dashboard · ?panels=overview", "style, arrangement, selection — all in place."],
      ["same document, stylesheet off", "it looks different; nothing it says changes. Doc = (Style, Content)"],
      ["same content, arrangement off — one block per entity, sorted", "Content = (Arrangement, Data)"],
      ["the pool — the page was a window, not the world", "the dimmed facts exist; the selection just never asked. Data = (Selection, State)"]
    ];
    function show() {
      var v = segValue(root, id) || "0";
      for (var i = 0; i < 4; i++) q(root, ".fp-view-" + i).hidden = String(i) !== v;
      q(root, ".fp-stage-lbl").textContent = HINTS[+v][0];
      q(root, ".fp-hint").textContent = HINTS[+v][1];
    }
    on(root, 'input[name="' + id + '"]', "change", show);
    show();
  }

  /* ——————— Chapter 5: merge is union ——————— */

  function wMerge(root) {
    root.innerHTML =
      '<div class="fp-cols">' +
      '<div class="fp-panel"><div class="fp-head"><span>party A — the operator</span>' +
      '<span class="fp-btns"><button type="button" class="fp-shuffle">shuffle lines</button>' +
      '<button type="button" class="fp-dup-btn">duplicate a fact</button></span></div>' +
      '<textarea class="fp-a" spellcheck="false" aria-label="Party A facts"></textarea></div>' +
      '<div class="fp-panel"><div class="fp-head"><span>party B — the contractor</span></div>' +
      '<textarea class="fp-b" spellcheck="false" aria-label="Party B facts"></textarea></div>' +
      "</div>" +
      '<div class="fp-note fp-count"></div>' +
      '<div class="fp-panel"><div class="fp-head"><span>A ∪ B — one state; no coordinator was consulted</span></div>' +
      '<pre class="fp-out fp-merged"></pre></div>' +
      '<div class="fp-panel"><div class="fp-head"><span>the same state, as the graph it is</span></div>' +
      '<div class="fp-body fp-graph-box"></div></div>';
    q(root, ".fp-a").value = SEED.A;
    q(root, ".fp-b").value = SEED.B;
    function recompute() {
      var all = parseFacts(q(root, ".fp-a").value).concat(parseFacts(q(root, ".fp-b").value));
      var seen = {}, dup = {}, merged = [];
      all.forEach(function (f) {
        var k = key(f);
        if (seen[k]) { dup[k] = true; return; }
        seen[k] = true; merged.push(f);
      });
      var dupSet = { has: function (k) { return !!dup[k]; } };
      q(root, ".fp-merged").innerHTML = stateHTML(all, "derived", { dup: dupSet });
      var dn = all.length - merged.length;
      q(root, ".fp-count").textContent = all.length + " facts asserted → |A ∪ B| = " +
        merged.length + (dn ? " — " + dn + " duplicate" + (dn > 1 ? "s" : "") +
        " collapsed; ∪ is idempotent, order never mattered" : " — shuffle or duplicate; the union will not move");
      drawGraph(merged, q(root, ".fp-graph-box"));
      shared.merged = merged;
      document.dispatchEvent(new CustomEvent("fp:state"));
    }
    q(root, ".fp-shuffle").addEventListener("click", function () {
      q(root, ".fp-a").value = shuffleLines(q(root, ".fp-a").value); recompute();
    });
    q(root, ".fp-dup-btn").addEventListener("click", function () {
      var lines = q(root, ".fp-a").value.split("\n").filter(function (l) { return l.trim(); });
      if (lines.length) {
        lines.push(lines[Math.floor(Math.random() * lines.length)]);
        q(root, ".fp-a").value = lines.join("\n");
      }
      recompute();
    });
    on(root, "textarea", "input", debounce(recompute));
    recompute();
  }

  /* ——————— Chapter 5: the selection algebra, exercised ——————— */

  function wSelect(root) {
    root.innerHTML =
      '<div class="fp-cols">' +
      '<div class="fp-panel"><div class="fp-head"><span>pattern — ?x binds</span>' +
      '<span class="fp-btns"><button type="button" class="fp-q1">panels &amp; values</button>' +
      '<button type="button" class="fp-q2">cross-party join</button></span></div>' +
      '<textarea class="fp-q fp-short" spellcheck="false" aria-label="Pattern"></textarea></div>' +
      '<div class="fp-panel"><div class="fp-head"><span class="fp-sols-head">solutions</span></div>' +
      '<div class="fp-body fp-sols"></div></div>' +
      "</div>" +
      '<div class="fp-panel"><div class="fp-head"><span>Data — the sub-state the solutions touched</span></div>' +
      '<pre class="fp-out fp-window"></pre></div>';
    q(root, ".fp-q").value = SEED.Q1;
    function facts() { return shared.merged || mergedSeed(); }
    function recompute() {
      var fs = facts();
      var r = evalPattern(q(root, ".fp-q").value, fs);
      q(root, ".fp-sols-head").textContent = "solutions — " + r.sols.length +
        " row" + (r.sols.length === 1 ? "" : "s") + " · join of " +
        parseFacts(q(root, ".fp-q").value).length + " pattern" +
        (parseFacts(q(root, ".fp-q").value).length === 1 ? "" : "s");
      if (r.empty || !r.vars.length) {
        q(root, ".fp-sols").innerHTML =
          '<p class="fp-note">one pattern per line; <code>?x</code> is a variable.</p>';
      } else {
        var h = '<table class="fp-res"><tr>' + r.vars.map(function (v) {
          return "<th>" + esc(v) + "</th>";
        }).join("") + "</tr>";
        r.sols.forEach(function (sol) {
          h += "<tr>" + r.vars.map(function (v) {
            var t = sol[v] || "";
            return "<td>" + (t ? term(t, isLit(t) ? "o" : "s", "derived") : "") + "</td>";
          }).join("") + "</tr>";
        });
        q(root, ".fp-sols").innerHTML = h + "</table>";
      }
      var win = fs.filter(function (f) { return r.touched.has(key(f)); });
      q(root, ".fp-window").innerHTML = win.length ? stateHTML(win, "derived")
        : '<span class="fp-tok-kw">∅ — no pattern matched</span>';
    }
    q(root, ".fp-q1").addEventListener("click", function () {
      q(root, ".fp-q").value = SEED.Q1; recompute();
    });
    q(root, ".fp-q2").addEventListener("click", function () {
      q(root, ".fp-q").value = SEED.Q2; recompute();
    });
    on(root, "textarea", "input", debounce(recompute));
    document.addEventListener("fp:state", recompute);
    recompute();
  }

  /* ——————— Chapter 6: canon does not move ——————— */

  function wCanon(root) {
    root.innerHTML =
      '<div class="fp-cols">' +
      '<div class="fp-panel"><div class="fp-head"><span>facts, in arrival order</span>' +
      '<span class="fp-btns"><button type="button" class="fp-shuffle">shuffle</button></span></div>' +
      '<textarea class="fp-in" spellcheck="false" aria-label="Facts"></textarea></div>' +
      '<div class="fp-panel"><div class="fp-head"><span>canon — one block per entity, sorted, no nesting</span></div>' +
      '<pre class="fp-out fp-canon"></pre></div>' +
      "</div>" +
      '<div class="fp-note fp-c-note">canon is a function of the atoms alone — not of their order, grouping, or provenance.</div>';
    var seedText = mergedSeed().map(function (f) { return f.s + " " + f.p + " " + f.o; }).join("\n");
    q(root, ".fp-in").value = seedText;
    var shuffles = 0, last = "";
    function recompute(fromShuffle) {
      var html = canonHTML(canonMap(parseFacts(q(root, ".fp-in").value)), "derived");
      var moved = last && html !== last;
      q(root, ".fp-canon").innerHTML = html;
      if (fromShuffle) {
        shuffles++;
        q(root, ".fp-c-note").textContent = moved
          ? "the atoms changed, so canon changed — as it should."
          : "shuffled " + shuffles + " time" + (shuffles > 1 ? "s" : "") +
            " — canon has not moved. Deterministic, lossless, structure-free.";
      }
      last = html;
    }
    q(root, ".fp-shuffle").addEventListener("click", function () {
      q(root, ".fp-in").value = shuffleLines(q(root, ".fp-in").value);
      recompute(true);
    });
    on(root, "textarea", "input", debounce(function () { shuffles = 0; recompute(false); }));
    recompute(false);
  }

  /* ——————— Chapter 7: the delta, applied ——————— */

  function wDelta(root) {
    root.innerHTML =
      '<div class="fp-panel"><div class="fp-head"><span class="fp-s-head">S — the state</span></div>' +
      '<pre class="fp-out fp-s"></pre></div>' +
      '<div class="fp-cols">' +
      '<div class="fp-panel"><div class="fp-head"><span>D⁻ — the facts removed</span></div>' +
      '<textarea class="fp-dm fp-short" spellcheck="false" aria-label="Facts removed"></textarea></div>' +
      '<div class="fp-panel"><div class="fp-head"><span>D⁺ — the facts added</span></div>' +
      '<textarea class="fp-dp fp-short" spellcheck="false" aria-label="Facts added"></textarea></div>' +
      "</div>" +
      '<div class="fp-controls"><button type="button" class="fp-apply">apply: (S ∖ D⁻) ∪ D⁺</button>' +
      '<button type="button" class="fp-reset">reset</button>' +
      '<span class="fp-note fp-d-note">the wind gusts; the delta is two one-element sets.</span></div>';
    var S = parseFacts(SEED.DELTA_S), gen = 0;
    q(root, ".fp-dm").value = SEED.DMINUS;
    q(root, ".fp-dp").value = SEED.DPLUS;
    function render(marks) {
      q(root, ".fp-s-head").textContent = gen === 0 ? "S — the state" :
        "S" + "′".repeat(Math.min(gen, 4)) + " — the state, after " + gen +
        " delta" + (gen > 1 ? "s" : "");
      q(root, ".fp-s").innerHTML = stateHTML(S, "derived", marks || {});
    }
    q(root, ".fp-apply").addEventListener("click", function () {
      var dm = parseFacts(q(root, ".fp-dm").value);
      var dp = parseFacts(q(root, ".fp-dp").value);
      var before = S.map(key).sort().join("|");
      var r = applyDelta(S, dm, dp);
      var after = r.next.map(key).sort().join("|");
      S = r.next;
      if (before === after) {
        q(root, ".fp-d-note").textContent =
          "nothing changed: the removals were already gone, the additions already present. Applying a delta twice is applying it once.";
        render({});
      } else {
        gen++;
        q(root, ".fp-d-note").textContent =
          "applied. Transport included, that was the entire update. Apply it again.";
        render({ add: r.added });
      }
    });
    q(root, ".fp-reset").addEventListener("click", function () {
      S = parseFacts(SEED.DELTA_S); gen = 0;
      q(root, ".fp-dm").value = SEED.DMINUS;
      q(root, ".fp-dp").value = SEED.DPLUS;
      q(root, ".fp-d-note").textContent = "the wind gusts; the delta is two one-element sets.";
      render({});
    });
    render({});
  }

  /* ——————— Chapter 17: the write methods — POST/PUT/DELETE as PATCH at a fixed delta ——————— */

  function wMethods(root) {
    var id = "fpm" + (++uid);
    var SEED_G =
      'panel-14 type Panel\n' +
      'panel-14 title "Current Power"\n' +
      'panel-14 value "15.5 kW"\n' +
      'panel-14 partOf farm';
    var POST_P = 'panel-14 unit "kW"';
    var PUT_P =
      'panel-14 type Panel\n' +
      'panel-14 title "Current Power"\n' +
      'panel-14 value "16.1 kW"';
    var PATCH_M = 'panel-14 value "15.5 kW"';
    var PATCH_P = 'panel-14 value "16.1 kW"';
    var NOTES = {
      GET: "GET reads. It returns S and writes nothing — D⁻ = D⁺ = ∅.",
      POST: "POST fixes D⁻ = ∅ — additions only, a merge into the graph.",
      PUT: "PUT fixes D⁻ = S(u) — the whole graph out, D⁺ in. Replace, creating it if absent.",
      DELETE: "DELETE fixes D⁻ = S(u), D⁺ = ∅ — the graph removed.",
      PATCH: "PATCH — any D⁻, D⁺. The general write; the other three are it at a fixed delta."
    };

    root.innerHTML =
      '<div class="fp-controls">' +
      seg(id, [
        { v: "GET", l: "GET" }, { v: "POST", l: "POST" }, { v: "PUT", l: "PUT" },
        { v: "DELETE", l: "DELETE" }, { v: "PATCH", l: "PATCH" }
      ], "PATCH") +
      '<span class="fp-note fp-m-note"></span></div>' +
      '<div class="fp-panel"><div class="fp-head"><span class="fp-s-head"></span></div>' +
      '<pre class="fp-out fp-s"></pre></div>' +
      '<div class="fp-cols">' +
      '<div class="fp-panel"><div class="fp-head"><span>D⁻ — removed</span></div>' +
      '<textarea class="fp-dm fp-short" spellcheck="false" aria-label="Facts removed"></textarea></div>' +
      '<div class="fp-panel"><div class="fp-head"><span>D⁺ — added</span></div>' +
      '<textarea class="fp-dp fp-short" spellcheck="false" aria-label="Facts added"></textarea></div>' +
      "</div>" +
      '<div class="fp-controls"><button type="button" class="fp-apply">apply: (S ∖ D⁻) ∪ D⁺</button>' +
      '<button type="button" class="fp-reset">reset</button></div>';

    var S, gen;
    var dm = q(root, ".fp-dm"), dp = q(root, ".fp-dp"), apply = q(root, ".fp-apply");

    function serialize(facts) {
      return facts.map(function (f) { return f.s + " " + f.p + " " + f.o; }).join("\n");
    }
    function method() { return segValue(root, id) || "PATCH"; }

    function snap() {
      var m = method();
      dm.readOnly = false; dp.readOnly = false;
      if (m === "GET") { dm.value = ""; dp.value = ""; dm.readOnly = dp.readOnly = true; }
      else if (m === "POST") { dm.value = ""; dm.readOnly = true; dp.value = POST_P; }
      else if (m === "PUT") { dm.value = serialize(S); dm.readOnly = true; dp.value = PUT_P; }
      else if (m === "DELETE") { dm.value = serialize(S); dm.readOnly = true; dp.value = ""; dp.readOnly = true; }
      else { dm.value = PATCH_M; dp.value = PATCH_P; }
      apply.disabled = (m === "GET");
      q(root, ".fp-m-note").textContent = NOTES[m];
    }

    function renderS(marks) {
      q(root, ".fp-s-head").innerHTML =
        (gen === 0 ? "S" : "S" + "′".repeat(Math.min(gen, 4))) + " — the graph …/panel-14";
      q(root, ".fp-s").innerHTML = S.length
        ? stateHTML(S, "derived", marks || {})
        : '<span class="fp-tok-kw">∅ — the graph is gone</span>';
    }

    apply.addEventListener("click", function () {
      var before = S.map(key).sort().join("|");
      var r = applyDelta(S, parseFacts(dm.value), parseFacts(dp.value));
      S = r.next;
      if (before !== S.map(key).sort().join("|")) gen++;
      renderS({ add: r.added });
      var m = method();
      if (m === "PUT" || m === "DELETE") dm.value = serialize(S);
    });
    q(root, ".fp-reset").addEventListener("click", function () {
      S = parseFacts(SEED_G); gen = 0; snap(); renderS({});
    });
    on(root, 'input[name="' + id + '"]', "change", function () { snap(); renderS({}); });

    S = parseFacts(SEED_G); gen = 0; snap(); renderS({});
  }

  /* ——————— Chapter 8: the reveal — nothing recomputed, only renamed ——————— */

  function wReveal(root) {
    var id = "fps" + (++uid);
    var facts = parseFacts(SEED.DELTA_S);
    var HEADS = {
      derived: ["State = 𝒫(Fact) — (5.3)", "the selection algebra — pattern, join, project", "the delta — (7.1)"],
      shipped: ["an RDF graph — Turtle", "SPARQL", "SPARQL Update"]
    };
    var SELECTION = {
      derived: "(?p, type, Panel)\n(?p, title, ?t)\n(?p, value, ?v)",
      shipped: "PREFIX w: <" + VOCAB_NS + ">\nSELECT ?p ?t ?v WHERE {\n" +
        "  ?p a w:Panel ;\n     w:title ?t ;\n     w:value ?v .\n}"
    };
    var CHANGE = {
      derived: "D⁻ = { (⟨…#panel-14⟩, value, \"15.5 kW\") }\n" +
        "D⁺ = { (⟨…#panel-14⟩, value, \"16.1 kW\") }",
      shipped: "PREFIX d: <" + DATA_NS + ">\nPREFIX w: <" + VOCAB_NS + ">\n" +
        "DELETE DATA { d:panel-14 w:value \"15.5 kW\" } ;\n" +
        "INSERT DATA { d:panel-14 w:value \"16.1 kW\" }"
    };
    root.innerHTML =
      '<div class="fp-controls">' +
      seg(id, [
        { v: "derived", l: "as derived (Ch. 1–7)" },
        { v: "shipped", l: "as shipped (1996–2014)" }
      ], "derived") +
      '<span class="fp-note fp-r-note"></span></div>' +
      '<div class="fp-panel"><div class="fp-head"><span class="fp-h1"></span></div><pre class="fp-out fp-p1"></pre></div>' +
      '<div class="fp-cols">' +
      '<div class="fp-panel"><div class="fp-head"><span class="fp-h2"></span></div><pre class="fp-out fp-p2"></pre></div>' +
      '<div class="fp-panel"><div class="fp-head"><span class="fp-h3"></span></div><pre class="fp-out fp-p3"></pre></div>' +
      "</div>";
    function render() {
      var skin = segValue(root, id) || "derived";
      q(root, ".fp-h1").textContent = HEADS[skin][0];
      q(root, ".fp-h2").textContent = HEADS[skin][1];
      q(root, ".fp-h3").textContent = HEADS[skin][2];
      q(root, ".fp-p1").innerHTML = stateHTML(facts, skin);
      q(root, ".fp-p2").textContent = "";
      q(root, ".fp-p2").innerHTML = skin === "derived"
        ? parseFacts(SELECTION.derived.replace(/[(),]/g, " ")).map(function (f) {
            return factLine(f, "derived", "");
          }).join("\n")
        : esc(SELECTION.shipped);
      q(root, ".fp-p3").innerHTML = skin === "derived" ? esc(CHANGE.derived) : esc(CHANGE.shipped);
      q(root, ".fp-r-note").textContent = skin === "derived"
        ? "the objects, as the derivation wrote them"
        : "the same objects. Nothing was recomputed — only renamed.";
    }
    on(root, 'input[name="' + id + '"]', "change", render);
    render();
  }

  /* ——————— Chapter 15: two dataspaces, one generic machine ——————— */

  function wPipeline(root) {
    var id = "fpd" + (++uid), idT = "fpt" + uid, idC = "fpc" + uid;
    var store = {
      wind: { facts: SEED.POOL, query: SEED.WINDOW, css: "console" },
      news: { facts: SEED.NEWS, query: SEED.NEWSQ, css: "editorial" }
    };
    var current = "wind";
    root.innerHTML =
      '<div class="fp-controls">' +
      seg(id, [{ v: "wind", l: "the wind farm" }, { v: "news", l: "the front page" }], "wind") +
      '<span class="fp-note">two datasets — the domain travels in the state</span></div>' +
      '<div class="fp-cols">' +
      '<div class="fp-panel"><div class="fp-head"><span>state — the domain lives here</span></div>' +
      '<textarea class="fp-facts" spellcheck="false" aria-label="State"></textarea></div>' +
      '<div class="fp-panel"><div class="fp-head"><span>select — the window</span>' +
      '<span class="fp-btns"><button type="button" class="fp-q-reset">reset</button></span></div>' +
      '<textarea class="fp-query" spellcheck="false" aria-label="Selection"></textarea></div>' +
      "</div>" +
      '<div class="fp-panel"><div class="fp-head"><span>canon(Data) — the canonical serialization</span></div>' +
      '<pre class="fp-out fp-canon"></pre></div>' +
      '<div class="fp-controls">' +
      '<span class="fp-note">arrange — the term t:</span>' +
      seg(idT, [{ v: "cards", l: "t₁ · cards" }, { v: "table", l: "t₂ · table" }], "cards") +
      '<span class="fp-note">present — the stylesheet:</span>' +
      seg(idC, [{ v: "editorial", l: "editorial" }, { v: "console", l: "console" }], "console") +
      "</div>" +
      '<div class="fp-panel"><div class="fp-head"><span class="fp-r-head">read(r, S) — the document</span></div>' +
      '<div class="fp-render fp-theme-console"><div class="fp-rendered fp-target"></div></div></div>' +
      '<div class="fp-note">swap any factor — data, selection, term, stylesheet — and the others hold still.</div>';
    q(root, ".fp-facts").value = store.wind.facts;
    q(root, ".fp-query").value = store.wind.query;
    function setCss(v) {
      var el = q(root, 'input[name="' + idC + '"][value="' + v + '"]');
      if (el) el.checked = true;
    }
    function recompute() {
      var facts = parseFacts(q(root, ".fp-facts").value);
      var r = evalPattern(q(root, ".fp-query").value, facts);
      var win = facts.filter(function (f) { return r.touched.has(key(f)); });
      var cm = canonMap(win);
      q(root, ".fp-canon").innerHTML = canonHTML(cm, "shipped");
      q(root, ".fp-target").innerHTML = arrangeHTML(cm, segValue(root, idT) || "cards");
      q(root, ".fp-render").className = "fp-render fp-theme-" + (segValue(root, idC) || "console");
    }
    on(root, 'input[name="' + id + '"]', "change", function () {
      store[current].facts = q(root, ".fp-facts").value;
      store[current].query = q(root, ".fp-query").value;
      store[current].css = segValue(root, idC) || store[current].css;
      current = segValue(root, id) || "wind";
      q(root, ".fp-facts").value = store[current].facts;
      q(root, ".fp-query").value = store[current].query;
      setCss(store[current].css);
      recompute();
    });
    q(root, ".fp-q-reset").addEventListener("click", function () {
      q(root, ".fp-query").value = current === "wind" ? SEED.WINDOW : SEED.NEWSQ;
      recompute();
    });
    on(root, 'input[name="' + idT + '"]', "change", recompute);
    on(root, 'input[name="' + idC + '"]', "change", recompute);
    on(root, "textarea", "input", debounce(recompute));
    recompute();
  }

  /* ——————— mount ——————— */

  var WIDGETS = {
    strip: wStrip, merge: wMerge, select: wSelect, canon: wCanon,
    delta: wDelta, methods: wMethods, reveal: wReveal, pipeline: wPipeline
  };

  function init() {
    qa(document, ".fp-exhibit").forEach(function (el) {
      var build = WIDGETS[el.getAttribute("data-exhibit")];
      if (!build) return;
      el.classList.add("fp-live");
      try { build(el); } catch (e) {
        el.classList.remove("fp-live");
        if (typeof console !== "undefined") console.error("exhibit failed:", e);
      }
    });
  }

  if (typeof document !== "undefined") {
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", init);
    } else {
      init();
    }
  }

  if (typeof module !== "undefined" && module.exports) {
    module.exports = {
      parseFacts: parseFacts, evalPattern: evalPattern, canonMap: canonMap,
      canonHTML: canonHTML, applyDelta: applyDelta, stateHTML: stateHTML, key: key
    };
  }
})();
