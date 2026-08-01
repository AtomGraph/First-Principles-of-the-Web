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

XREF = re.compile(
    r"Chapters (?P<chlist>\d+(?:,\s*\d+)*,?\s*and\s+\d+)"
    r"|Chapter (?P<ch>\d+)"
    r"|(?:(?:Prop|Props|Thm|Def)\.?|Theorem|Definition|Proposition) (?P<pch>\d+)\.\d+"
    r"|Lemma (?P<lemc>C)\.\d+"
    r"|Appendix (?P<appc>C)\.\d+"
    r"|Appendix (?P<app>[A-D])\b"
    r"|\b(?P<csec>C)\.\d+\b"
    r"|\b(?P<ccond>C)-\d[a-d]?(?:–[a-d])?\b"
    r"|\bCh (?P<chshort>\d+)\b"
    r"|\((?P<eqch>\d{1,2})\.\d\)"
    r"|Part (?P<part>[IVX]+)\b"
)

def _xref_target(m):
    for g in ("ch", "pch", "chshort", "eqch"):
        if m.group(g):
            return ch_page.get(int(m.group(g)))
    if m.group("lemc") or m.group("appc") or m.group("csec") or m.group("ccond"):
        return app_page.get("C")
    if m.group("app"):
        return app_page.get(m.group("app"))
    if m.group("part"):
        return part_page.get(m.group("part"))
    return None

def linkify(text, current=None):
    """Wrap chapter/proposition/appendix references in muted <a class="xref">
    links. Skips fenced code blocks and headings; leaves self-references plain."""
    def repl(m):
        if m.group("chlist"):
            def one(nm):
                t = ch_page.get(int(nm.group(0)))
                if not t or t == current:
                    return nm.group(0)
                return f'<a class="xref" href="{t}">{nm.group(0)}</a>'
            return "Chapters " + re.sub(r"\d+", one, m.group("chlist"))
        target = _xref_target(m)
        if not target or target == current:
            return m.group(0)
        return f'<a class="xref" href="{target}">{m.group(0)}</a>'
    out, fence = [], False
    for line in text.split("\n"):
        s = line.lstrip()
        if s.startswith("```"):
            fence = not fence
            out.append(line)
        elif fence or s.startswith("#"):
            out.append(line)
        else:
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

def write(name, title, body):
    text = linkify("\n".join(strip_rules(promote(body))).strip(),
                   current=name.replace(".qmd", ".html"))
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
    write(pfile, part_title, intro)
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
    write("status.qmd", "Draft status", status)
    app_files.append("status.qmd")

yml = """project:
  type: book
  resources:
    - exhibits.js
    - exhibits.css

book:
  title: "First Principles of the Web"
  subtitle: "Graphs are not the thing, they are the thing that gets us to the thing"
  author:
    - name: "Martynas Jusevičius"
      email: "martynas@atomgraph.com"
      url: "https://atomgraph.com"
  repo-url: https://github.com/AtomGraph/First-Principles-of-the-Web
  repo-actions: [issue]
  search: true
""" + "\n".join(yml_chapters) + """
  appendices:
""" + "\n".join(f"    - {f}" for f in app_files) + """

format:
  html:
    theme: cosmo
    toc: true
    number-sections: false
    code-overflow: wrap
    include-in-header:
      text: |
        <link rel="stylesheet" href="exhibits.css">
        <script defer src="exhibits.js"></script>
"""
(ROOT / "_quarto.yml").write_text(yml, encoding="utf-8")

print(f"index.qmd + {part_no} parts + {len(chapter_files)} chapters + {len(app_files)} appendix pages")
