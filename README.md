# First Principles of the Web

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21940029.svg)](https://doi.org/10.5281/zenodo.21940029)

*Graphs are not the thing, they are the thing that gets us to the thing.*

A book that derives web application architecture from the web's own specifications — and finds the answer was standardized decades ago.

**Read the book: <https://firstprinciplesoftheweb.org/>**

## The claim

There is exactly one way to build applications that are *of* the web rather than merely *on* it — relative to rules the web itself imposes. The book derives the rules, proves the uniqueness (with named exits and their prices), audits everything the industry runs instead, and shows the derived architecture running.

If you find a statement that is neither a spec definition, a proposition citing earlier propositions, nor a checkable observation, the book has a bug — [file it](https://github.com/AtomGraph/First-Principles-of-the-Web/issues).

## This repository

| file | role |
|---|---|
| [`first-principles-of-the-web.md`](first-principles-of-the-web.md) | **the book — single source of truth** (readable right here on GitHub) |
| `first-principles-figures/` | the Chapter 3 exhibits (screenshot strips) and [`strips.cjs`](first-principles-figures/strips.cjs), the pipeline that reproduces them |
| [`formal-model-of-dynamic-web-documents.md`](formal-model-of-dynamic-web-documents.md) | the book's earliest formal ancestor, preserved as source material |
| `split.py` | build-time projection: splits the source into a [Quarto](https://quarto.org/) book (chapters, parts, config) |
| `exhibits.js`, `exhibits.css` | the online edition's interactive exhibits — dependency-free; in the source they sit as invisible stubs with captions, so the GitHub rendering stays clean |
| `.github/workflows/publish.yml` | renders and publishes the book on every push |

Everything book-shaped — the chapter pages, the config — is generated at build time and never committed. In the book's own notation, the published site is a projection of the source: `read = present ∘ arrange ∘ select`, where `split.py` is the arrange term.

The canonical edition — a linked-data application in which every proposition is a dereferenceable resource — is under construction on [LinkedDataHub](https://github.com/AtomGraph/LinkedDataHub); this repository is the source form.

## Build locally

```sh
python3 split.py && quarto preview
```

## Status

Draft 0.1 — all twenty-one chapters and appendices in prose, proofs B.1–B.9 complete. The full ledger is in the book's Draft-status table. Feedback is most valuable on R1–R3, the arity argument, and the Transposition Thesis (Chapter 5, Appendix B).
