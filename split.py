#!/usr/bin/env python3
"""Build-time projection: split the single-source book into a Quarto book project.

The single markdown file is the source of truth. This script generates, at render
time: index.qmd (front matter), one .qmd per chapter, part intro pages, the
appendices, and _quarto.yml. Generated files are gitignored — edit only the
source file. In the book's own notation: this is an `arrange` term.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).parent
SOURCE = ROOT / "first-principles-of-the-web.md"

# ---- SEO metadata: per-page descriptions (from a tracked sidecar) and
# schema.org JSON-LD built from data this script already holds. Descriptions
# become <meta name=description>/og/twitter via Quarto; the JSON-LD is emitted
# into each page body, which search engines read for structured data.
SITE_URL = "https://firstprinciplesoftheweb.org/"
BOOK_ID = SITE_URL + "#book"
AUTHOR = {"@type": "Person", "name": "Martynas Jusevičius", "url": "https://atomgraph.com"}
PUBLISHER = {"@type": "Organization", "name": "AtomGraph", "url": "https://atomgraph.com"}
SEO = json.loads((ROOT / "seo-descriptions.json").read_text(encoding="utf-8"))

def jsonld_script(obj):
    """A schema.org JSON-LD block, as body-level raw HTML."""
    return ('<script type="application/ld+json">\n'
            + json.dumps(obj, ensure_ascii=False, indent=2)
            + "\n</script>")

def front_matter(description):
    """YAML front matter carrying the page description. json.dumps yields a
    safely-quoted scalar (a JSON string is valid YAML) whatever punctuation the
    text holds; Quarto turns `description` into meta/og/twitter tags."""
    if not description:
        return ""
    return "---\ndescription: " + json.dumps(description, ensure_ascii=False) + "\n---\n\n"

text = SOURCE.read_text(encoding="utf-8")

# Mermaid diagrams are pre-rendered to committed SVGs (render-mermaid.py) so CI
# needs no headless browser, the diagrams are identical across formats, and the
# output avoids Quarto's malformed mermaid figure in EPUB. Replace each
# ```mermaid block with its SVG image, in source order.
_mm_n = [0]
def _mermaid_svg(m):
    _mm_n[0] += 1
    n = f"{_mm_n[0]:02d}"
    # SVG for HTML/EPUB; PNG for Typst, whose SVG renderer can't draw mermaid's
    # foreignObject labels (render-mermaid.py commits both, in source order).
    return (
        '\n::: {.content-visible unless-format="typst"}\n'
        f"![](first-principles-figures/mermaid-{n}.svg){{.fp-diagram}}\n"
        ":::\n"
        '::: {.content-visible when-format="typst"}\n'
        f"![](first-principles-figures/mermaid-{n}.png){{.fp-diagram}}\n"
        ":::\n"
    )
text = re.sub(r"```mermaid.*?```", _mermaid_svg, text, flags=re.S)

# Videos are raw <iframe> embeds: they play in HTML, epub_fix.py swaps them for
# poster links in EPUB, but raw HTML drops in Typst — so append a Typst-only
# poster figure from the committed video-posters/ (same mapping as epub_fix.py).
def _video_poster(m):
    iframe = m.group(0)
    sm = re.search(r'src="([^"]+)"', iframe)
    if not sm:
        return iframe
    tm = re.search(r'title="([^"]*)"', iframe)
    title = tm.group(1) if tm else "Watch the video"
    ym = re.search(r"youtube\.com/embed/([\w-]+)", sm.group(1))
    vm = re.search(r"vimeo\.com/video/(\d+)", sm.group(1))
    if ym:
        poster, watch = f"yt-{ym.group(1)}.jpg", f"https://youtu.be/{ym.group(1)}"
    elif vm:
        poster, watch = f"vimeo-{vm.group(1)}.jpg", f"https://vimeo.com/{vm.group(1)}"
    else:
        return iframe
    return iframe + (
        '\n\n::: {.content-visible when-format="typst"}\n'
        f"[![{title}](video-posters/{poster})]({watch})\n\n"
        f"▶ Watch online: {title} — <{watch}>\n"
        ":::\n"
    )
text = re.sub(r"<iframe\b[^>]*>\s*</iframe>", _video_poster, text, flags=re.S)

# Inject the pre-generated static fallbacks (fallbacks.cjs) into the exhibit
# stubs, wrapped in a raw-HTML block so pandoc passes the markup through
# verbatim. In the browser exhibits.js overwrites innerHTML with the live
# widget; without JS the fallback stands — crawlers, screen readers, EPUB.
FALLBACKS = ROOT / "exhibit-fallbacks"

def _fallback_native(html_path):
    """Convert an exhibit's static HTML fallback to native markdown so the Typst
    (PDF) edition renders it as real, selectable code blocks and tables — the same
    content the EPUB shows — instead of dropping it. Pandoc parses <pre>/<table>/
    <dl> into native blocks; we then strip its layout <div> fences (fp-panel /
    fp-cols / fp-head), which carry only CSS meaning, keeping the labels, code and
    tables. Returns '' if pandoc is unreachable at build time."""
    try:
        out = subprocess.run(
            ["quarto", "pandoc", "-f", "html", "-t", "markdown", str(html_path)],
            capture_output=True, text=True, check=True,
        ).stdout
    except (OSError, subprocess.CalledProcessError):
        return ""
    kept = [ln for ln in out.split("\n") if not ln.lstrip().startswith(":::")]
    return re.sub(r"\n{3,}", "\n\n", "\n".join(kept)).strip()

def _inject_fallback(m):
    t = m.group(1)
    f = FALLBACKS / (t + ".html")
    inner = f.read_text(encoding="utf-8").strip() if f.exists() else ""
    stub = '<div class="fp-exhibit" data-exhibit="' + t + '">\n' + inner + "\n</div>"
    # HTML + EPUB get the styled interactive fallback (raw HTML; drops in Typst).
    html_block = "\n```{=html}\n" + stub + "\n```\n"
    # Typst/PDF gets the same content rendered natively; fall back to a pointer
    # only if pandoc can't be reached during the build.
    native = _fallback_native(f) or (
        f"> **Interactive exhibit** (*{t}*) — explore it in the web edition at "
        "<https://firstprinciplesoftheweb.org/>."
    )
    typst_block = '\n\n::: {.content-visible when-format="typst"}\n' + native + "\n:::\n"
    return html_block + typst_block
text = re.sub(r'<div class="fp-exhibit" data-exhibit="(\w+)"></div>', _inject_fallback, text)

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
    r"\s+(?P<num>B?\.?\d+(?:\.\d+)?)"
)
RS_LINE = re.compile(r"^(?P<pre>(?:>\s*)?)\*\*(?P<rs>[RS][1-4]) — ")
COND_LINE = re.compile(r"^(?P<pre>-\s+)\*\*\((?P<cond>B-\d[a-d]?)\)")
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

_emitted_ids = set()

def _mint(rid):
    """First book-wide sighting of an id returns it; later ones return None.
    A result stated in a chapter and restated in its Appendix B proof would
    otherwise emit the same anchor twice — invalid HTML, and a hard Typst error
    (the single-file PDF has no per-page id scope). The kept anchor is the first
    occurrence, which is exactly where the cross-ref registry (res_page, first
    wins) already points."""
    if rid in _emitted_ids:
        return None
    _emitted_ids.add(rid)
    return rid

def add_anchors(text):
    """Mint fragment ids: an invisible span on each numbered result and each
    R/S requirement, an id attribute on C.N section headings, and an id'd div
    around each numbered-equation code block. Each id is minted at most once
    book-wide (see _mint) — restatements are left unanchored."""
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
            rid = _mint("eq-" + num.replace(".", "-")) if num else None
            if rid:
                out.append("::: {#%s}" % rid)
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
            rid = _mint(result_id(m))
            if rid:
                line = m.group("pre") + "[]{#%s}" % rid + line[len(m.group("pre")):]
        elif m2:
            rid = _mint(m2.group("rs").lower())
            if rid:
                line = m2.group("pre") + "[]{#%s}" % rid + line[len(m2.group("pre")):]
        elif m3:
            rid = _mint(m3.group("cond").lower())
            if rid:
                line = m3.group("pre") + "[]{#%s}" % rid + line[len(m3.group("pre")):]
        elif re.match(r"^## B\.\d+ ", line):
            # section ids: B.1 → #b-sec-1. Dotless (dots in a fragment break
            # navigation in EPUB readers that resolve #frag as a CSS selector),
            # and distinct from the condition anchors B-1 → #b-1.
            sid = _mint("b-sec-" + re.match(r"^## B\.(\d+)", line).group(1))
            if sid:
                line = line + " {#%s}" % sid
        out.append(line)
        i += 1
    return "\n".join(out)

XREF = re.compile(
    r"Chapters (?P<chlist>\d+(?:,\s*\d+)*,?\s*and\s+\d+)"
    r"|Chapter (?P<ch>\d+)"
    r"|(?:(?:Prop|Props|Thm|Def)\.?|Theorem|Definition|Proposition) (?P<pch>\d+)\.(?P<psub>\d+)"
    r"|Lemma (?P<lemc>B\.\d+)"
    r"|Appendix B\.(?P<appcn>\d+)"
    r"|Appendix (?P<app>[A-C])\b"
    r"|\bB\.(?P<csecn>\d+)\b"
    r"|\bB-(?P<ccondn>\d[a-d]?)(?:–[a-d])?\b"
    r"|\bCh (?P<chshort>\d+)\b"
    r"|\((?P<eqn>\d{1,2}\.\d)\)"
    r"|Part (?P<part>[IVX]+)\b"
)

def _anchored(page):
    # Quarto's EPUB writer rewrites .qmd links only when they carry a #fragment;
    # a fragment-less chapter/part/appendix ref stays a dead .qmd in the EPUB.
    # Point it at the page's own clean heading id (added by write()) so it
    # rewrites — the clean id also avoids the dotted auto-ids some readers can't
    # navigate to.
    return page + "#" + page[:-5] if page else page

def _xref_target(m):
    if m.group("pch"):
        key = m.group("pch") + "." + m.group("psub")
        if key in res_page:
            p, f = res_page[key]
            return f"{p}#{f}"
        return _anchored(ch_page.get(int(m.group("pch"))))
    if m.group("eqn"):
        if m.group("eqn") in eq_page:
            p, f = eq_page[m.group("eqn")]
            return f"{p}#{f}"
        return _anchored(ch_page.get(int(m.group("eqn").split(".")[0])))
    if m.group("lemc"):
        if m.group("lemc") in res_page:
            p, f = res_page[m.group("lemc")]
            return f"{p}#{f}"
        return _anchored(app_page.get("B"))
    if m.group("appcn") or m.group("csecn"):
        ap = app_page.get("B")
        return f"{ap}#b-sec-{m.group('appcn') or m.group('csecn')}" if ap else None
    if m.group("ccondn"):
        # each condition has its own anchor on its defining bullet;
        # a range like B-2a–d points at the first of the range
        ap = app_page.get("B")
        return f"{ap}#b-{m.group('ccondn')}" if ap else None
    for g in ("ch", "chshort"):
        if m.group(g):
            return _anchored(ch_page.get(int(m.group(g))))
    if m.group("app"):
        return _anchored(app_page.get(m.group("app")))
    if m.group("part"):
        return _anchored(part_page.get(m.group("part")))
    return None

def _xref_link(label, target):
    """A cross-reference as a markdown link to the .qmd source, so Quarto
    rewrites the href per format — .html for the web, the chapter's .xhtml for
    EPUB. A raw <a href="...html"> is opaque to that rewriting and leaves every
    non-HTML edition with dead links."""
    page, _, frag = target.partition("#")
    if page.endswith(".html"):
        page = page[:-5] + ".qmd"
    return f"[{label}]({page}{'#' + frag if frag else ''}){{.xref}}"

def linkify(text, current=None):
    """Wrap chapter/proposition/appendix references in muted .xref links (markdown
    links to the .qmd source; Quarto resolves the href per format). Skips fenced
    code blocks and headings; a reference to the page it sits on stays plain unless
    it can point to a fragment, and the statement of a result never links to its
    own anchor."""
    own_id = [None]
    def repl(m):
        if m.group("chlist"):
            def one(nm):
                t = _anchored(ch_page.get(int(nm.group(0))))
                if not t or t.partition("#")[0] == current:
                    return nm.group(0)
                return _xref_link(nm.group(0), t)
            return "Chapters " + re.sub(r"\d+", one, m.group("chlist"))
        target = _xref_target(m)
        if not target:
            return m.group(0)
        page, _, frag = target.partition("#")
        if page == current and (not frag or frag == page[:-5]):
            return m.group(0)
        if frag and frag == own_id[0]:
            return m.group(0)
        return _xref_link(m.group(0), target)
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
            if mo:
                own_id[0] = mo.group(1)
            else:
                # A restatement whose anchor was deduped away (see _mint) still
                # must not link to its own result — recover the id from the line.
                rm = RESULT_LINE.match(line)
                r2 = RS_LINE.match(line) if not rm else None
                r3 = COND_LINE.match(line) if not (rm or r2) else None
                own_id[0] = (result_id(rm) if rm else
                             r2.group("rs").lower() if r2 else
                             r3.group("cond").lower() if r3 else None)
            out.append(XREF.sub(repl, line))
    return "\n".join(out)

def promote(body):
    """Within a chapter file the chapter title is h1, so ### becomes h2 and #### becomes h3."""
    out = []
    for l in body:
        if l.startswith("#### "):
            out.append(l[1:])   # #### -> ### (h3)
        elif l.startswith("### "):
            out.append(l[1:])   # ### -> ## (h2)
        else:
            out.append(l)
    return out

def strip_rules(body):
    """Drop trailing horizontal rules; Quarto pages end themselves."""
    out = [l for l in body]
    while out and out[-1].strip() in ("", "---"):
        out.pop()
    return out

def write(name, title, body, tail="", description=None, jsonld=None):
    text = add_anchors("\n".join(strip_rules(promote(body))).strip())
    text = linkify(text, current=name.replace(".qmd", ".html"))
    if tail:
        # raw HTML appended after linkify — "Chapter N" inside it stays literal
        text += "\n\n" + tail
    if jsonld:
        # JSON-LD as body-level raw HTML, passed through like the tail above
        text += "\n\n" + jsonld_script(jsonld)
    anchor = name.rsplit(".", 1)[0]
    content = front_matter(description) + f"# {title} {{#{anchor}}}\n\n" + text + "\n"
    (ROOT / name).write_text(content, encoding="utf-8")
    return name

chapter_files = []

# the Book's ordered chapters for schema.org hasPart, built before index is
# written (index precedes the chapter-writing loop below)
book_chapters = []
for _pt, _in, _chs in parts:
    for _ct, _cb in _chs:
        _m = re.match(r"Chapter (\d+)\.\s*(.*)", _ct)
        _n = int(_m.group(1))
        book_chapters.append({
            "@type": "Chapter",
            "name": _ct,
            "url": SITE_URL + ch_page[_n],
            "position": _n,
        })

book_jsonld = {
    "@context": "https://schema.org",
    "@type": "Book",
    "@id": BOOK_ID,
    "name": "First Principles of the Web",
    "alternativeHeadline": "Graphs are not the thing, they are the thing that gets us to the thing",
    "url": SITE_URL,
    "inLanguage": "en",
    "author": AUTHOR,
    "publisher": PUBLISHER,
    "image": SITE_URL + "first-principles-figures/social-card.png",
    "description": SEO["index"],
    "hasPart": book_chapters,
}

# index.qmd: title block + front sections, headings kept at h2
index = title_block + [""]
for title, body in front:
    index += [f"## {title}", ""] + strip_rules(body) + [""]
index_body = "\n".join(l for l in index if l.strip() != "---" or True)
# drop the h1 title line — _quarto.yml carries the book title
index_body = re.sub(r"^# .*\n", "", index_body, count=1)
index_body = linkify(index_body, current="index.html")
index_content = (front_matter(SEO["index"]) + index_body.strip()
                 + "\n\n" + jsonld_script(book_jsonld) + "\n")
(ROOT / "index.qmd").write_text(index_content, encoding="utf-8")

yml_chapters = ["  chapters:", "    - index.qmd"]
part_no = 0
for part_title, intro, chapters in parts:
    part_no += 1
    pfile = f"part{part_no}.qmd"
    # Quarto's Typst book writer renders a part title as #part[...] and drops its
    # heading id, so references to <partN> would be undefined. Prepend a
    # Typst-only anchor span (dropped in HTML/EPUB, which use the H1 id) so the
    # label exists in the single-file PDF.
    intro = ['::: {.content-visible when-format="typst"}',
             f'[]{{#part{part_no}}}', ':::', ''] + intro
    part_toc = ['<nav class="fp-part-toc">']
    for ch_title, _cb in chapters:
        m = re.match(r"Chapter (\d+)\.\s*(.*)", ch_title)
        part_toc.append(
            f'  <a href="{ch_page[int(m.group(1))]}">'
            f"<span>Chapter {m.group(1)}</span> {m.group(2)}</a>"
        )
    part_toc.append("</nav>")
    part_roman = re.match(r"Part ([IVX]+)", part_title)
    part_desc = SEO["parts"].get(part_roman.group(1)) if part_roman else None
    write(pfile, part_title, intro, tail="\n".join(part_toc), description=part_desc)
    yml_chapters.append(f"    - part: {pfile}")
    yml_chapters.append("      chapters:")
    for ch_title, body in chapters:
        m = re.match(r"Chapter (\d+)\.\s*(.*)", ch_title)
        num, name = m.group(1), m.group(2)
        slug = re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")
        fname = f"ch{int(num):02d}-{slug}.qmd"
        ch_url = SITE_URL + ch_page[int(num)]
        ch_desc = SEO["chapters"].get(num)
        ch_jsonld = {
            "@context": "https://schema.org",
            "@type": "Chapter",
            "@id": ch_url + "#chapter",
            "name": ch_title,
            "url": ch_url,
            "position": int(num),
            "isPartOf": {"@id": BOOK_ID},
            "author": AUTHOR,
            "description": ch_desc,
        }
        write(fname, ch_title, body, description=ch_desc, jsonld=ch_jsonld)
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
        app_url = SITE_URL + f"appendix-{letter}-{slug}.html"
        app_desc = SEO["appendices"].get(letter)
        app_jsonld = {
            "@context": "https://schema.org",
            "@type": "Chapter",
            "@id": app_url + "#chapter",
            "name": f"Appendix {t[0]} — {t.split('. ', 1)[-1]}",
            "url": app_url,
            "isPartOf": {"@id": BOOK_ID},
            "author": AUTHOR,
            "description": app_desc,
        }
        # Quarto prefixes appendix pages with "Appendix X —" itself; drop the source's letter
        write(fname, re.sub(r"^[A-Z]\.\s+", "", t), b, description=app_desc, jsonld=app_jsonld)
        app_files.append(fname)
if status:
    # back matter, not apparatus — keep it out of the lettered appendix sequence
    write("status.qmd", "Draft status", status, description=SEO.get("status"))
    yml_chapters.append("    - status.qmd")

# Colophon: license + edition metadata. Generated boilerplate (not book prose),
# so it lives here, not in the single-source markdown. Written directly (not via
# write()) so cross-ref linkification never touches the license text.
COLOPHON = (
    "*First Principles of the Web* — Draft 0.1.\n\n"
    "© 2026 Martynas Jusevičius. Published by [AtomGraph](https://atomgraph.com).\n\n"
    "This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 "
    "International License (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/). "
    "You may share and adapt it for any purpose, provided you give appropriate credit "
    "and license any derivatives under the same terms.\n\n"
    "Built from a single Markdown source with [Quarto](https://quarto.org/); diagrams are "
    "pre-rendered to SVG. Available as HTML, EPUB, and PDF. Source at "
    "[github.com/AtomGraph/First-Principles-of-the-Web]"
    "(https://github.com/AtomGraph/First-Principles-of-the-Web).\n"
)
(ROOT / "colophon.qmd").write_text("# Colophon {#colophon}\n\n" + COLOPHON, encoding="utf-8")
yml_chapters.append("    - colophon.qmd")

yml = """lang: en
project:
  type: book
  resources:
    - exhibits.js
    - exhibits.css
    - epub.css
    - "first-principles-figures/*.svg"
    - "first-principles-figures/*.png"
    - "video-posters/*.jpg"
    - googleba0fe49aa3922677.html
    - CNAME

book:
  title: "First Principles of the Web"
  subtitle: "Graphs are not the thing, they are the thing that gets us to the thing"
  author:
    - name: "Martynas Jusevičius"
      email: "martynas@atomgraph.com"
      url: "https://atomgraph.com"
  repo-url: https://github.com/AtomGraph/First-Principles-of-the-Web
  repo-actions: [issue]
  downloads: [epub, pdf]
  site-url: https://firstprinciplesoftheweb.org/
  favicon: first-principles-figures/favicon.svg
  image: first-principles-figures/social-card.png
  open-graph:
    image: first-principles-figures/social-card.png
  twitter-card:
    image: first-principles-figures/social-card.png
    card-style: summary_large_image
  search: true
  page-footer: "© 2026 Martynas Jusevičius · Licensed [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) · [Source on GitHub](https://github.com/AtomGraph/First-Principles-of-the-Web)"
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
  epub:
    toc: true
    number-sections: false
    css: epub.css
    cover-image: first-principles-figures/cover.png
  typst:
    toc: true
    number-sections: false
    papersize: a4
    font-paths:
      - fonts
    include-in-header:
      text: |
        // Full-page cover as page 1 (matches the EPUB cover). Emitted before
        // orange-book's #show, so it renders ahead of the template title page.
        #page(margin: 0pt, header: none, footer: none)[
          #set align(center + horizon)
          #image("first-principles-figures/cover.png", height: 100%)
        ]
        // Body in EB Garamond — the web edition's face, committed in fonts/ —
        // falling back to bundled NCM Math for glyphs it lacks (e.g. 𝒫 U+1D4AB).
        #set text(font: ("EB Garamond", "New Computer Modern Math"))
        #show raw: set text(font: ("DejaVu Sans Mono", "New Computer Modern Math"))
    include-before-body:
      text: |
        // Match the online edition's reading feel: orange-book defaults to a
        // cramped 10pt / 0.5em-leading indented-paragraph body; the web uses a
        // generous size, ~1.65 line-height, and block paragraphs (space, no
        // indent). This runs inside the template body, overriding those defaults.
        #set text(size: 12pt)
        #set par(leading: 0.8em, first-line-indent: 0pt, spacing: 1em)
        // Wide tables (esp. the 9-column Properness table) don't fit A4 at 12pt;
        // hold table text at the pre-bump size so columns don't collide.
        #show table: set text(size: 10pt)
"""
(ROOT / "_quarto.yml").write_text(yml, encoding="utf-8")

print(f"index.qmd + {part_no} parts + {len(chapter_files)} chapters + {len(app_files)} appendix pages")
