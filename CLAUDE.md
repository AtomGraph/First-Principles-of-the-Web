# CLAUDE.md

## Prose rules for first-principles-of-the-web.md (binding, book-wide)

The book's chronic failure mode is over-complication: each model pass adds insets, citations, and cleverness until sentences collapse. These rules apply to EVERY edit and draft, whole book:

1. **Plain sentences win.** One idea per sentence. At most one colon. No em-dash inset nested inside another. A sentence over ~35 words is suspect; split it. Restore dropped "because"/"so" and concrete referents rather than compressing further.
2. **Never lengthen without orders.** Any edit that makes a sentence or passage longer than what it replaces needs an explicit reason. Default direction is plainer and equal-or-shorter.
3. **No drive-by rewrites.** Touch only the sentences a specific finding or instruction targets. Never re-polish neighboring prose that wasn't asked about — that is how the ratchet turns.
4. **When Martynas sketches wording: transcribe, don't elaborate.** His beats, his order, his sentence count; hard cap 1.2× his word count; add nothing (no citations, appositives, parallel constructions).
5. **No imported metaphors.** Finance verbs (pay/buy/spend/cash) as metaphor are banned; the book's own cost-audit content (costs, the bill, the S4 tax, N × M) is fine. No meta-narration, no drumroll, no staged questions.
6. **Propose old→new in chat before applying targeted edits;** whole-book sweeps go on a branch as one PR. Never commit to main — fresh branch + PR, always.

Self-check before presenting ANY drafted prose: is it longer than what it replaces? Does any sentence break rule 1? If yes, fix before showing.

Full history and rationale: auto-memory `book-prose-editing.md`.

## Build

- `first-principles-of-the-web.md` is the single source; `split.py` generates the gitignored `.qmd` files; `quarto render` builds `_book/`.
- Reveal discipline: no RDF/SPARQL/XSLT names in Chapters 1–7 or Part I–III intros.
