#!/usr/bin/env python3
"""Post-process a Quarto-rendered EPUB into a valid, self-contained, shareable
file. Runs after `quarto render --to epub`, on the .epub itself:

  1. quote the valueless boolean attribute   (allowfullscreen -> allowfullscreen="")
  2. replace dead external video iframes with a linked poster + caption, and embed
     the poster (external <iframe> won't play in most readers and makes some
     readers silently truncate the rest of the chapter)
  3. repair Quarto's malformed mermaid figure (<p><figure class></p>) if present
     — a safety no-op now that diagrams are pre-rendered SVGs (see render-mermaid.py)

Browser-free (pure stdlib), so CI needs no headless Chrome.

    python3 epub_fix.py _book/First-Principles-of-the-Web.epub video-posters
"""
import re, sys, shutil, pathlib, tempfile, zipfile

epub_path = pathlib.Path(sys.argv[1])
posters = pathlib.Path(sys.argv[2])

work = pathlib.Path(tempfile.mkdtemp())
with zipfile.ZipFile(epub_path) as z:
    names = z.namelist()
    z.extractall(work)

text_dir = work / "EPUB" / "text"
media = work / "EPUB" / "media"
opf = work / "EPUB" / "content.opf"

def video_meta(src):
    m = re.search(r"youtube\.com/embed/([\w-]+)", src)
    if m: return f"yt-{m.group(1)}.jpg", f"https://youtu.be/{m.group(1)}"
    m = re.search(r"vimeo\.com/video/(\d+)", src)
    if m: return f"vimeo-{m.group(1)}.jpg", f"https://vimeo.com/{m.group(1)}"
    return None, None

used = set()
IFRAME = re.compile(r'<iframe\b([^>]*)>\s*</iframe>', re.S)

def repl_iframe(m):
    attrs = m.group(1)
    sm = re.search(r'src="([^"]+)"', attrs)
    if not sm: return m.group(0)
    tm = re.search(r'title="([^"]*)"', attrs)
    title = tm.group(1) if tm else "Watch the video"
    poster, watch = video_meta(sm.group(1))
    if not poster: return m.group(0)
    used.add(poster)
    return (
        '<figure class="fp-video">'
        f'<a href="{watch}"><img src="../media/{poster}" alt="{title}" style="width:100%;border:0" /></a>'
        f'<figcaption>▶ Watch online: {title} — <a href="{watch}">{watch}</a></figcaption>'
        '</figure>'
    )

for f in sorted(text_dir.glob("*.xhtml")):
    s = orig = f.read_text(encoding="utf-8")
    s = s.replace("<p><figure class></p>", "<figure>").replace("<p></figure></p>", "</figure>")
    s = re.sub(r' allowfullscreen(?=[ >])', ' allowfullscreen=""', s)
    s = IFRAME.sub(repl_iframe, s)
    if s != orig:
        f.write_text(s, encoding="utf-8")

# embed the posters actually used and register them in the OPF manifest
if used:
    media.mkdir(exist_ok=True)
    o = opf.read_text(encoding="utf-8")
    items = []
    for i, p in enumerate(sorted(used), 1):
        shutil.copy(posters / p, media / p)
        if f'href="media/{p}"' not in o:
            items.append(f'<item id="fpvideo{i}" href="media/{p}" media-type="image/jpeg"/>')
    if items:
        o = o.replace("</manifest>", "\n".join(items) + "\n</manifest>")
        opf.write_text(o, encoding="utf-8")

# repackage: mimetype first + stored, everything else deflated (EPUB requirement)
with zipfile.ZipFile(epub_path, "w") as z:
    z.write(work / "mimetype", "mimetype", compress_type=zipfile.ZIP_STORED)
    for p in sorted(work.rglob("*")):
        if p.is_file() and p != work / "mimetype":
            z.write(p, p.relative_to(work), compress_type=zipfile.ZIP_DEFLATED)

shutil.rmtree(work, ignore_errors=True)
print(f"epub_fix: {len(used)} video posters embedded ->", sorted(used))
