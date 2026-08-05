#!/usr/bin/env python3
"""Build-time projection: split the single-source book into a Quarto book project.

The single markdown file is the source of truth. This script generates, at render
time: index.qmd (front matter), one .qmd per chapter, part intro pages, the
appendices, and _quarto.yml. Generated files are gitignored — edit only the
source file. In the book's own notation: this is an `arrange` term.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).parent
SOURCE = ROOT / "first-principles-of-the-web.md"

text = SOURCE.read_text(encoding="utf-8")

# Quarto renders mermaid only in executable-style fences
text = text.replace("```mermaid", "```{mermaid}")

lines = text.split("\n")

# ---- parse: title block, then h2 front sections, then h1 parts containing h2 chapters
front = []          # (title, body) before the first "# Part"
parts = []          # (part_title, part_intro, [(chapter_title, body), ...])
appendices = None   # (title, body)
status = None       # Draft status body

i = 0
# skip the title block up to the first "## "
title_block = []
while i < len(lines) and not lines[i].startswith("## "):
    title_block.append(lines[i])
    i += 1

def collect_until(i, stops):
    body = []
    while i < len(lines) and not any(lines[i].startswith(s) for s in stops):
        body.append(lines[i])
        i += 1
    return body, i

# front matter sections (## Preface, ## How to Read..., ## The Argument...)
while i < len(lines) and lines[i].startswith("## "):
    title = lines[i][3:].strip()
    i += 1
    body, i = collect_until(i, ("## ", "# "))
    front.append((title, body))

# parts and chapters
while i < len(lines):
    line = lines[i]
    if line.startswith("# Appendices"):
        i += 1
        body, i = collect_until(i, ("## Draft status",))
        appendices = body
        continue
    if line.startswith("## Draft status"):
        i += 1
        status, i = collect_until(i, ("# NEVER",))
        continue
    if line.startswith("# "):
        part_title = line[2:].strip()
        i += 1
        intro, i = collect_until(i, ("## ", "# "))
        chapters = []
        while i < len(lines) and lines[i].startswith("## "):
            ch_title = lines[i][3:].strip()
            i += 1
            body, i = collect_until(i, ("## ", "# "))
            chapters.append((ch_title, body))
        parts.append((part_title, intro, chapters))
        continue
    i += 1

# ---- cross-references: label → page map, applied at write time.
# The source stays plain markdown; the links exist only in the projection,
# like the chapter files themselves. Self-references are left unlinked.

ch_page = {}
part_page = {}
for _pn, (_ptitle, _pintro, _pchapters) in enumerate(parts, start=1):
    m = re.match(r"Part ([IVX]+)", _ptitle)
    if m:
        part_page[m.group(1)] = f"part{_pn}.html"
    for _ct, _cb in _pchapters:
        m = re.match(r"Chapter (\d+)\.\s*(.*)", _ct)
        _slug = re.sub(r"[^a-z0-9]+", "-", m.group(2).lower()).strip("-")
        ch_page[int(m.group(1))] = f"ch{int(m.group(1)):02d}-{_slug}.html"

app_page = {}
if appendices:
    for _l in appendices:
        if _l.startswith("## "):
            _t = _l[3:].strip()
            _slug = re.sub(r"[^a-z0-9]+", "-", _t.split(". ", 1)[-1].lower()).strip("-")
            app_page[_t[0]] = f"appendix-{_t[0].lower()}-{_slug}.html"

# Every numbered result gets a fragment id in the projection — propositions
# as addressable resources, one hash short of the canonical edition.
RESULT_LINE = re.compile(
    r"^(?P<pre>(?:>\s*)?)\*\*(?P<kind>Prop(?:osition)?|Props|Thm|Theorem|Def(?:inition)?|Lemma)\.?"
    r"\s+(?P<num>C?\.?\d+(?:\.\d+)?)"
)
RS_LINE = re.compile(r"^(?P<pre>(?:>\s*)?)\*\*(?P<rs>[RS][1-4]) — ")
COND_LINE = re.compile(r"^(?P<pre>-\s+)\*\*\((?P<cond>C-\d[a-d]?)\)")
EQ_NUM = re.compile(r"\((\d+\.\d+)\)\s*$")
KIND_ID = {"prop": "prop", "props": "prop", "proposition": "prop",
           "thm": "thm", "theorem": "thm", "def": "def", "definition": "def",
           "lemma": "lemma"}

def result_id(m):
    return KIND_ID[m.group("kind").lower()] + "-" + m.group("num").lower().replace(".", "-")

res_page = {}   # "4.2" → (page, "prop-4-2"); first statement wins, restatements don't
eq_page = {}    # "5.1" → (page, "eq-5-1")

def _scan_registry(body_lines, page):
    fence = False
    for line in body_lines:
        if line.lstrip().startswith("```"):
            fence = not fence
            continue
        if fence:
            m = EQ_NUM.search(line)
            if m:
                eq_page.setdefault(m.group(1), (page, "eq-" + m.group(1).replace(".", "-")))
            continue
        m = RESULT_LINE.match(line)
        if m:
            res_page.setdefault(m.group("num"), (page, result_id(m)))

for _pt, _in, _chs in parts:
    for _ct, _cb in _chs:
        m = re.match(r"Chapter (\d+)\.", _ct)
        _scan_registry(_cb, ch_page[int(m.group(1))])
if appendices:
    _asubs, _cur = {}, None
    for _l in appendices:
        if _l.startswith("## "):
            _cur = _l[3]
            _asubs.setdefault(_cur, [])
        elif _cur:
            _asubs[_cur].append(_l)
    for _k, _ls in _asubs.items():
        if _k in app_page:
            _scan_registry(_ls, app_page[_k])

def add_anchors(text):
    """Mint fragment ids: an invisible span on each numbered result and each
    R/S requirement, an id attribute on C.N section headings, and an id'd div
    around each numbered-equation code block."""
    lines, out, i = text.split("\n"), [], 0
    while i < len(lines):
        line = lines[i]
        if line.lstrip().startswith("```"):
            j = i + 1
            while j < len(lines) and not lines[j].lstrip().startswith("```"):
                j += 1
            num = None
            for l in lines[i + 1:j]:
                m = EQ_NUM.search(l)
                if m:
                    num = m.group(1)
                    break
            if num:
                out.append("::: {#eq-%s}" % num.replace(".", "-"))
                out.extend(lines[i:j + 1])
                out.append(":::")
            else:
                out.extend(lines[i:j + 1])
            i = j + 1
            continue
        m = RESULT_LINE.match(line)
        m2 = RS_LINE.match(line) if not m else None
        m3 = COND_LINE.match(line) if not (m or m2) else None
        if m:
            line = m.group("pre") + "[]{#%s}" % result_id(m) + line[len(m.group("pre")):]
        elif m2:
            line = m2.group("pre") + "[]{#%s}" % m2.group("rs").lower() + line[len(m2.group("pre")):]
        elif m3:
            line = m3.group("pre") + "[]{#%s}" % m3.group("cond").lower() + line[len(m3.group("pre")):]
        elif re.match(r"^## C\.\d+ ", line):
            # section ids keep the label's own spelling: C.1 → #c.1 (the
            # condition C-1 → #c-1 would otherwise collide)
            line = line + " {#c.%s}" % re.match(r"^## C\.(\d+)", line).group(1)
        out.append(line)
        i += 1
    return "\n".join(out)

XREF = re.compile(
    r"Chapters (?P<chlist>\d+(?:,\s*\d+)*,?\s*and\s+\d+)"
    r"|Chapter (?P<ch>\d+)"
    r"|(?:(?:Prop|Props|Thm|Def)\.?|Theorem|Definition|Proposition) (?P<pch>\d+)\.(?P<psub>\d+)"
    r"|Lemma (?P<lemc>C\.\d+)"
    r"|Appendix C\.(?P<appcn>\d+)"
    r"|Appendix (?P<app>[A-D])\b"
    r"|\bC\.(?P<csecn>\d+)\b"
    r"|\bC-(?P<ccondn>\d[a-d]?)(?:–[a-d])?\b"
    r"|\bCh (?P<chshort>\d+)\b"
    r"|\((?P<eqn>\d{1,2}\.\d)\)"
    r"|Part (?P<part>[IVX]+)\b"
)

def _xref_target(m):
    if m.group("pch"):
        key = m.group("pch") + "." + m.group("psub")
        if key in res_page:
            p, f = res_page[key]
            return f"{p}#{f}"
        return ch_page.get(int(m.group("pch")))
    if m.group("eqn"):
        if m.group("eqn") in eq_page:
            p, f = eq_page[m.group("eqn")]
            return f"{p}#{f}"
        return ch_page.get(int(m.group("eqn").split(".")[0]))
    if m.group("lemc"):
        if m.group("lemc") in res_page:
            p, f = res_page[m.group("lemc")]
            return f"{p}#{f}"
        return app_page.get("C")
    if m.group("appcn") or m.group("csecn"):
        ap = app_page.get("C")
        return f"{ap}#c.{m.group('appcn') or m.group('csecn')}" if ap else None
    if m.group("ccondn"):
        # each condition has its own anchor on its defining bullet;
        # a range like C-2a–d points at the first of the range
        ap = app_page.get("C")
        return f"{ap}#c-{m.group('ccondn')}" if ap else None
    for g in ("ch", "chshort"):
        if m.group(g):
            return ch_page.get(int(m.group(g)))
    if m.group("app"):
        return app_page.get(m.group("app"))
    if m.group("part"):
        return part_page.get(m.group("part"))
    return None

def linkify(text, current=None):
    """Wrap chapter/proposition/appendix references in muted <a class="xref">
    links. Skips fenced code blocks and headings; a reference to the page it
    sits on stays plain unless it can point to a fragment, and the statement
    of a result never links to its own anchor."""
    own_id = [None]
    def repl(m):
        if m.group("chlist"):
            def one(nm):
                t = ch_page.get(int(nm.group(0)))
                if not t or t == current:
                    return nm.group(0)
                return f'<a class="xref" href="{t}">{nm.group(0)}</a>'
            return "Chapters " + re.sub(r"\d+", one, m.group("chlist"))
        target = _xref_target(m)
        if not target:
            return m.group(0)
        page, _, frag = target.partition("#")
        if page == current and not frag:
            return m.group(0)
        if frag and frag == own_id[0]:
            return m.group(0)
        return f'<a class="xref" href="{target}">{m.group(0)}</a>'
    out, fence = [], False
    for line in text.split("\n"):
        s = line.lstrip()
        if s.startswith("```") or s.startswith(":::"):
            fence = not fence if s.startswith("```") else fence
            out.append(line)
        elif fence or s.startswith("#"):
            out.append(line)
        else:
            mo = re.match(r"^(?:>\s*|-\s+)?\[\]\{#([\w.-]+)\}", line)
            own_id[0] = mo.group(1) if mo else None
            out.append(XREF.sub(repl, line))
    return "\n".join(out)

def promote(body):
    """Within a chapter file the chapter title is h1, so ### becomes h2."""
    return [re.sub(r"^### ", "## ", l) for l in body]

def strip_rules(body):
    """Drop trailing horizontal rules; Quarto pages end themselves."""
    out = [l for l in body]
    while out and out[-1].strip() in ("", "---"):
        out.pop()
    return out

def write(name, title, body, tail=""):
    text = add_anchors("\n".join(strip_rules(promote(body))).strip())
    text = linkify(text, current=name.replace(".qmd", ".html"))
    if tail:
        # raw HTML appended after linkify — "Chapter N" inside it stays literal
        text += "\n\n" + tail
    content = f"# {title}\n\n" + text + "\n"
    (ROOT / name).write_text(content, encoding="utf-8")
    return name

chapter_files = []

# index.qmd: title block + front sections, headings kept at h2
index = title_block + [""]
for title, body in front:
    index += [f"## {title}", ""] + strip_rules(body) + [""]
index_body = "\n".join(l for l in index if l.strip() != "---" or True)
# drop the h1 title line — _quarto.yml carries the book title
index_body = re.sub(r"^# .*\n", "", index_body, count=1)
index_body = linkify(index_body, current="index.html")
(ROOT / "index.qmd").write_text(index_body.strip() + "\n", encoding="utf-8")

yml_chapters = ["  chapters:", "    - index.qmd"]
part_no = 0
for part_title, intro, chapters in parts:
    part_no += 1
    pfile = f"part{part_no}.qmd"
    part_toc = ['<nav class="fp-part-toc">']
    for ch_title, _cb in chapters:
        m = re.match(r"Chapter (\d+)\.\s*(.*)", ch_title)
        part_toc.append(
            f'  <a href="{ch_page[int(m.group(1))]}">'
            f"<span>Chapter {m.group(1)}</span> {m.group(2)}</a>"
        )
    part_toc.append("</nav>")
    write(pfile, part_title, intro, tail="\n".join(part_toc))
    yml_chapters.append(f"    - part: {pfile}")
    yml_chapters.append("      chapters:")
    for ch_title, body in chapters:
        m = re.match(r"Chapter (\d+)\.\s*(.*)", ch_title)
        num, name = m.group(1), m.group(2)
        slug = re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")
        fname = f"ch{int(num):02d}-{slug}.qmd"
        write(fname, ch_title, body)
        yml_chapters.append(f"        - {fname}")
        chapter_files.append(fname)

app_files = []
if appendices:
    # one page per "## X. Title" appendix, so each appears in the book's navigation
    subs, cur_title, cur_body = [], None, []
    for l in appendices:
        if l.startswith("## "):
            if cur_title:
                subs.append((cur_title, cur_body))
            cur_title, cur_body = l[3:].strip(), []
        elif cur_title:
            cur_body.append(l)
    if cur_title:
        subs.append((cur_title, cur_body))
    for t, b in subs:
        letter = t[0].lower()
        slug = re.sub(r"[^a-z0-9]+", "-", t.split(". ", 1)[-1].lower()).strip("-")
        fname = f"appendix-{letter}-{slug}.qmd"
        # Quarto prefixes appendix pages with "Appendix X —" itself; drop the source's letter
        write(fname, re.sub(r"^[A-Z]\.\s+", "", t), b)
        app_files.append(fname)
if status:
    # back matter, not apparatus — keep it out of the lettered appendix sequence
    write("status.qmd", "Draft status", status)
    yml_chapters.append("    - status.qmd")

yml = """project:
  type: book
  resources:
    - exhibits.js
    - exhibits.css
    - "first-principles-figures/*.svg"

book:
  title: "First Principles of the Web"
  subtitle: "Graphs are not the thing, they are the thing that gets us to the thing"
  author:
    - name: "Martynas Jusevičius"
      email: "martynas@atomgraph.com"
      url: "https://atomgraph.com"
  repo-url: https://github.com/AtomGraph/First-Principles-of-the-Web
  repo-actions: [issue]
  site-url: https://atomgraph.github.io/First-Principles-of-the-Web/
  favicon: first-principles-figures/favicon.svg
  open-graph: true
  twitter-card: true
  search: true
""" + "\n".join(yml_chapters) + """
  appendices:
""" + "\n".join(f"    - {f}" for f in app_files) + """

format:
  html:
    theme: [cosmo, editorial.scss]
    toc: true
    number-sections: false
    code-overflow: wrap
    filters:
      - abbr.lua
    include-in-header:
      text: |
        <link rel="stylesheet" href="exhibits.css">
        <script defer src="exhibits.js"></script>
"""
(ROOT / "_quarto.yml").write_text(yml, encoding="utf-8")

print(f"index.qmd + {part_no} parts + {len(chapter_files)} chapters + {len(app_files)} appendix pages")
