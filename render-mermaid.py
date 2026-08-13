#!/usr/bin/env python3
"""Pre-render the book's mermaid diagrams to committed SVGs.

Mermaid is NOT rendered at build time: it would make CI depend on a headless
browser (fragile, and the source of long hangs) and Quarto's EPUB writer emits
malformed markup for mermaid cells. Instead the diagrams are pre-rendered here
to SVG files that split.py references as ordinary images — identical across
HTML and EPUB, browser-free in CI. Same pattern as strips.cjs / fallbacks.cjs:
a local dev tool whose output is committed.

Run locally when a ```mermaid block changes:
    npm install -g @mermaid-js/mermaid-cli    # provides `mmdc`
    python3 render-mermaid.py

Theme colors come from mermaid-theme.json (kept in sync with editorial.scss's
$mermaid-* palette so the diagrams match the HTML edition).
"""
import re, subprocess, sys, tempfile, pathlib

ROOT = pathlib.Path(__file__).parent
SOURCE = ROOT / "first-principles-of-the-web.md"
FIGURES = ROOT / "first-principles-figures"
THEME = ROOT / "mermaid-theme.json"

blocks = re.findall(r"```mermaid\n(.*?)```", SOURCE.read_text(encoding="utf-8"), re.S)
if not blocks:
    sys.exit("no mermaid blocks found")

for i, code in enumerate(blocks, 1):
    with tempfile.NamedTemporaryFile("w", suffix=".mmd", delete=False) as tf:
        tf.write(code)
        mmd = tf.name
    # SVG for the HTML + EPUB editions (crisp, scalable). Typst's SVG renderer
    # (resvg) can't draw mermaid's foreignObject HTML labels, and re-rendering
    # with htmlLabels:false collapses the spaces in wrapped labels — so ALSO emit
    # a browser-rasterized PNG (labels and spacing intact) for the PDF/Typst
    # edition. split.py picks svg vs png per output format.
    for ext, extra in ((".svg", []), (".png", ["-s", "3"])):
        subprocess.run(
            ["mmdc", "-i", mmd, "-o", str(FIGURES / f"mermaid-{i:02d}{ext}"),
             "-c", str(THEME), "-b", "white", *extra],
            check=True,
        )
    print(f"mermaid-{i:02d}.svg + .png")

print(f"rendered {len(blocks)} diagrams (svg + png)")
