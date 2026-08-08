# Content review — *First Principles of the Web*

*2026-08-07 · full-book blind cold-read review per `Content review agent.txt`*

## Method

- **26 blind cold reads** — one independent reviewer per artifact (front matter, Chapters 1–22, Appendices A–C), each adopting the content-reviewer spec verbatim, reading exactly one file, with only spec-allowed environmental context: artifact type + a glossary of terms defined in *earlier* chapters (132 terms extracted from the source in a prior pass), + rendering notes (exhibit stubs, xrefs, epigraphs are build plumbing).
- **7 cross-chapter flow audits** — six per-part auditors (chapter-to-chapter flow, cross-chapter concept-before-dependency, duplication, granularity, relevancy) and one whole-book arc auditor (the One Page vs. the book delivered, part boundaries, promise/payoff).
- **1 synthesis pass** over all findings for cross-cutting patterns.
- **Quote verification**: all 153 block/issue quotes were checked verbatim against the source (`first-principles-of-the-web.md` + generated `.qmd`); 149 matched mechanically, the remaining 4 (composite/cross-file quotes) were confirmed manually at their claimed sites. No hallucinated quotes.

**Coverage**: 26/26 cold reads and 7/7 flow audits returned; nothing unreviewed. Total findings: **376** (317 cold-read: 1 block / 125 issues / 191 flags; 59 flow: 2 blocks / 25 issues / 32 flags).

**Severity semantics** (from the spec): *block* = do not ship without addressing; *issue* = address or consciously decide not to; *flag* = must be surfaced for a conscious decision — lowest triage priority only, never permission to skip.

## Blocks (3)

**Ch 17. Building Up** — concept-before-dependency

> HTML forms encoding graphs (the bridge below)

The chapter promises "the bridge below" twice — in the write row of the build log and again in the figure caption — and then ends without it. The final paragraph covers only the arrange machinery. A reader who remembers Chapter 9 naming the write-side last mile reaches the last line still waiting to learn which bridge closes it and how a form encodes a graph. A promise made twice and never kept is the one thing a cold reader cannot forgive.

*Suggested:* Add the promised passage — name the encoding (Chapter 9's RDF/POST is the natural candidate), show one form field becoming one triple, and close the write-side last mile on the page — or, if the bridge lives in another chapter, repoint both "below"s to where it actually is.

**Part III — The Reveal (flow)** — other

> No W3C recommendation has been cited; no vocabulary from any data-model community has appeared.

False against the book's own earlier text, and only a cross-chapter read can catch it: Chapter 4 cites "Architecture of the World Wide Web, Volume One (W3C Recommendation, 2004; hereafter AWWW)" by name and status, and Chapter 5 leans on "AWWW's global-identifiers principle" in its audit table. Chapter 8 concedes exactly one exception (Ch 3's CSS strip) and claims cleanliness otherwise. The reveal's force rests on the reader being able to verify this claim — and a reader who checks finds it wrong. Chapter 4 already built the correct defense ("AWWW is a witness here, never a premise"); Chapter 8 just overclaims past it.

*Suggested:* Align the claim with Ch 4's witness/premise distinction, e.g.: "No W3C recommendation has entered the derivation as a premise — AWWW appeared as a witness after the fact (Chapter 4), and Chapter 3 turned CSS off by name; no vocabulary from any data-model community has appeared."

**Part IV — The Audit (flow)** — granularity

> It is the shortest audit in the part, and the brevity is the finding

The claim is false by the part's own proportions: Chapter 15 (~861 words by my count, ~915 by the book's) is the longest audit chapter in Part IV — longer than Ch 10 (~859), Ch 11 (~818), Ch 13 (~759), Ch 14 (~649), and more than double Ch 12 (~395). A reader who just finished the 400-word applet chapter three chapters earlier will catch this instantly, and 'the brevity is the finding' makes the false measurement load-bearing rhetoric — in a book whose whole posture is audit-grade precision. A single-chapter cold read cannot see this; the span read can, and it damages the narrator's credibility exactly where the self-audit chapter most needs it.

*Suggested:* Either make the claim true by trimming the chapter (paragraphs 4-5 re-narrate Chapter 9's mismatches — see the duplication finding — and cutting them to row-mappings with citations would bring the chapter under Ch 14's length), or reword to what is actually meant: 'It is the audit with the least new work in it, and that is the finding: every cell below carries a citation to a result already proved, so where the other columns needed scoring, this one needs collecting.'

## Cross-cutting patterns

*(from the synthesis pass; each pattern is repairable as a whole rather than finding-by-finding)*

### Load-bearing sentence collapses under compression

Load-bearing sentence collapses under compression — the book's hardest-to-parse sentence is almost always its most important one (thesis statements, reveal payoffs, chapter first/last lines, theorem prose), tangled by nested em-dash insets, double colons, semicolon chains, and garden paths.

**Affected:** index (thesis + audit sentence), ch01, ch02 (thesis), ch03, ch05, ch06, ch07, ch08 (reveal payoff), ch09, ch10, ch11, ch13 (payoff sentence), ch14 (opener), ch15, ch16 (capstone line), ch17, ch18, ch19 (roadmap sentence), ch20 (Web 3.0 definition + the book's final sentence), ch21 (payoff), ch22 (first sentence), app-a, app-b (synthesis realization), app-c (opener)

**Repair:** One targeted de-compression pass restricted to structurally prominent sentences: every chapter's first and last sentence, every thesis/definition/theorem sentence, every caption punchline. Rule: one idea per sentence, at most one colon, no em-dash inset nested inside another. Split rather than trim — the content is fine; the packing is the defect.

### Self-audit arithmetic that fails its own check

Self-audit arithmetic that fails its own check — counts, superlatives, and universal claims ('every', 'no', 'only', 'shortest', 'twice') contradicted by the very text or table they describe, in a book whose whole posture invites the reader to verify.

**Affected:** ch04 (S4 scope stated 3 ways), ch07 ('every arrow is a numbered proposition'), ch08 ('No W3C recommendation has been cited' — false per ch04/ch05), ch09 ('twice a prediction' vs one; caption contradicts body), ch11 ('moves no score' with S3 never re-run), ch13 ('three columns' vs the part's own count of four; prose vs scorecard), ch14 ('recovered' vs its own ~ scores), ch15 ('shortest audit in the part' — actually the longest), ch16 ('every failure appeared twice'; 'every cell links'), ch17 ('fifth kind of name' with no four-count anywhere), ch22 ('one factor short of the whole' backwards), app-a ('secured four ways' unenumerated), part4/arc flow confirms the class

**Repair:** A mechanical verification pass: grep every self-referential number, superlative, and universal quantifier, and check each against its referent (the table, the chapter lengths, the citation record, the score cells). Correct the claim or scope it explicitly (ch08 already owns the fix: 'AWWW is a witness here, never a premise'). Nothing self-descriptive ships unchecked.

### Verbatim duplication

Verbatim duplication — the reader pays full price twice (or three or four times) for the same result, story, or tagline, both across chapter pairs and within single pages.

**Affected:** ch05/ch07 (delta derived then re-presented), ch05/ch06 (graph-vs-tree handoff twice), ch09/ch18 (RDF/POST mechanism in full twice), ch11/ch14 (hydration/'S1 tax' near-verbatim), ch14/ch16 ('the web rather than an app platform' epigram), ch21/ch22 (two entire Ch22 sections re-tell Ch21), ch09/ch10 (frozen-at-1999), ch16/part5 (closing echo across the seam), ch18 (CERN story ×2, federation tagline ×3), ch15 (caveats-in-citation ×3), ch22 ('asks for facts' ×3, name-resolution ×3), ch02 (mismatch pledge ×4), ch03 ('one skeleton' ×4 figures), app-a (symbols defined twice), app-c (intentcasting glossed twice)

**Repair:** Adopt a second-occurrence rule and sweep once: any later telling of a result, coinage, or story must either cite the first by chapter name and add only what is new, or be cut. Taglines fire exactly once; captions and diagrams may restate a table only if they show something the table cannot.

### The book renames its own vocabulary mid-stream

The book renames its own vocabulary mid-stream — established terms drift, collide with the book's formal names, or get silently swapped, tripping exactly the reader the book has trained to track its apparatus.

**Affected:** ch04 (Style→present, Tree unbridged from Ch3), ch06 (crossing→serialization→seam; facts→atoms), ch07 (match→'pattern' as operation), ch09 (homomorphism→'isomorphism'), ch10 (delta as scalar vs the defined pair), ch11 ('the style' colliding with factor Style), ch12 ('the factorization' meaning fusion), ch14 ('last mile' rebound; S4-tax content drift), ch15 (Ch9 mismatch names re-described), ch17 ('portability of terms' vs mobility of evaluation), ch18 ('exits' reused for a different pair), ch19 ('deployed stack' vs derived stack), ch21 (adapter/wrapper/bridge; machine-legible/readable/consumable cycle), app-b (t renamed x; canon used at two types)

**Repair:** Build a canonical-name ledger from the glossary (one name per defined object) and grep-enforce it: every callback uses the stored name; any deliberate rename gets a one-clause bridge at the rename site ('canon at this type means …'); synonyms with no bridge get reverted.

### Unpaid promises and stale pointers

Unpaid promises and stale pointers — forward references that never cash out and cross-references aimed at targets that moved, most of them scars of the 2026-08 restructures.

**Affected:** ch04 ('Hold that until Prop 4.4' never redeemed), ch07/part3 (write-side inheritance 'through this symmetry' never delivered), ch09 ('first missing requirement' fossil), ch13 ('the audit's last chapter' → actually Ch14), ch17 ('the bridge below' ×2, bridge lives in Ch18), ch18 (three routed promises, one cashed; 'Exhibit pending'), ch22/ch06 (Memex xref to a chapter that never names the Memex), app-a (Transposition row pointing at Appendix A itself; merge-as-union credited against its own results table), plus stale ch22-the-latent-web.qmd / ch23-the-next-web.qmd leftovers in the working tree

**Repair:** Run a promise ledger once: enumerate every 'below', 'later', 'Chapter N will…', and xref; verify the target delivers the promised thing under the promised name; repoint, cash, or cut. Delete the reverted-split qmd leftovers so nothing greps or builds against them.

### First-use gloss debt

First-use gloss debt — terms of art, acronyms, and symbols deployed cold, often at load-bearing moments, in a book that elsewhere runs a strict define-before-depend discipline.

**Affected:** ch01 ('exit'), ch02 ('application space'), ch05 (V, 𝒫, RFC 9111, 'native'), ch06 ('the reveal chapter', t untyped), ch08 (sparql(p); SPARQL/XSLT/RDFC unglossed), ch09 (su/pu/ou/ol, entailment jargon), ch10 (B-2d), ch12+ch14+part4 (principle of least power leaned on before ever stated), ch13 (impedance mismatch), ch17 (ontology, Graph Store Protocol, IXSL), ch18 (GSP again, 'information resource', TAG), ch19 (CMS/CRM/ERP, MDA), ch20 ('retrodiction'), ch22 ('one level down', 'the second era'), app-b (ACI, free theorem, skolemization, ternarity)

**Repair:** One sweep against the defined-terms glossary: every term of art, acronym, and symbol gets a one-clause appositive at first use or an explicit citation to its defining chapter — and the principle of least power gets its one-sentence statement in Ch12, where it first carries weight. Anything that can't earn a gloss gets replaced with plain words.

### The book's maps disagree with the book

The book's maps disagree with the book — part intros, the One Page, and in-chapter roadmaps under-promise, skip parts, or contradict each other about the borders.

**Affected:** part1 (only part with no epigraph), part2 (blurb covers 2 of 5 chapters — no Ch6 crossing, no write side), part3 ('names it' undersells the central theorem + Ch9's audit), part4 (one-column-per-audit promise vs chapters filing 2 or 0), part6 (frame fits Ch22, not Ch21), index (One Page has no sentence for Part V), ch01/ch02 (borders drawn differently; write side and Part VI missing from Ch2's map), app-c (roadmap promises 3 lists, delivers 4)

**Repair:** Rewrite every map artifact against the final 22-chapter/6-part TOC in one sitting: each blurb gets one clause per chapter it governs, all six parts appear in the One Page, both halves of Definition 1.1 get a slot in Ch2's map, and Part I receives the same italic epigraph as Parts II–VI.

### Climaxes buried mid-structure

Climaxes buried mid-structure — the chapter's biggest beat fires in a caption, a parenthetical, or the middle of a section, while the actual ending trails on.

**Affected:** ch01 ('transparent' defined inside a parenthetical, with a competing gloss at the close), ch03 (load-bearing canvas point in an italic caption), ch05 (Transposition Thesis unheaded; exit line fires mid-section then chapter keeps talking), ch07 (arc ends inside a caption), ch09 ('the book's practical thesis' mid-paragraph), ch14 (double ending; audit columns as trailing matter), ch17 (build-log lede displaced by a component essay), ch19 (Ch21 handoff overshoots the part capstone), ch20 (the 'one cost' never stated plainly), app-b (two-paragraph history lodged mid-proof)

**Repair:** One structural pass per chapter: the biggest claim gets its own paragraph or heading; the chapter-exit line is the literal last line; captions describe their figures while prose carries argument; digressions (history, doctrine) move outside proofs and endings.

### Paragraph balloons beside starved siblings

Paragraph balloons beside starved siblings — sections doing five jobs in one 200–330-word block while a parallel section carrying equal argumentative load gets two sentences.

**Affected:** ch05 (R2 over half the chapter vs one-paragraph R1/R3), ch10 (JSON scores get prose, XML's live in cells), ch11 (170-word Web Components block vs 2-sentence R-section), ch17 ('domain as data' one-sentence runt), ch18 (starved closing section), ch19 (330-word 'Computation on the write side'), ch21 (grounding paragraph vs two-paragraph arithmetic), ch22 (two ~230-word blocks vs 3-sentence 'Every action a document'), app-b (B.8 at a third of the appendix; doctrine in chapter register)

**Repair:** A proportion audit per chapter: split any paragraph carrying more than two moves, and bring every starved section up to its siblings' treatment — each parallel claim gets the same minimum kit (one beat of mechanism, one example or dated case). Where imbalance is deliberate, say so on the page.

### Polarity flips

Polarity flips — punchlines and captions whose plainest parse states the opposite of the intended claim.

**Affected:** ch02 ('tables every mismatch' = shelves, to a US ear), ch05 ('the union absorbs everything except new facts'; 'duplicates free'), ch22 ('a personal store that outlived no session'; 'one factor short of the whole'), app-b ('no uniqueness worth disputing'), app-c ('wanting only a cross-party substrate')

**Repair:** An adversarial-parse pass on every aphorism, caption punchline, and scorecard gloss: state the claim back in plain words from the sentence alone; any line whose most natural reading inverts the intent is rewritten with unambiguous polarity, wit preserved second.

## Top priorities (ranked)

1. Fix Ch 8's false independence boast ('No W3C recommendation has been cited') — contradicted by Ch 4's named AWWW citation and Ch 5's audit table, at the exact moment the book claims auditability. One-sentence repair using Ch 4's own defense: cite AWWW as the acknowledged witness-never-premise exception alongside the CSS one. (arc block, highest credibility stakes in the book)
2. Deliver or repoint Ch 17's twice-promised 'bridge below' — the forms-to-deltas bridge lives in Ch 18, so either move the RDF/POST material forward or change both references to 'the bridge in the next chapter.' A promise made twice and never kept is the cold read's one unforgivable. (block)
3. Repair Ch 15's false 'shortest audit in the part' claim by cutting its near-verbatim re-narration of Ch 9's mismatches (the 'billed to whoever chose anonymity' paragraph) — one edit kills a block, a duplication, and may make the superlative true. (block)
4. Divide the agent material between Ch 21 and Ch 22: reduce Ch 22's 'Reading, not scraping' and 'Every action a document' to cited one-paragraph bridges. Restores Ch 21's punch, gives the starved 'Every action' claim its needed development in one place, and pulls the book's largest chapter (2.7× its part-mate) back into proportion.
5. Run the self-audit arithmetic sweep: verify every count, superlative, and universal claim against its referent — Ch 9's 'twice a prediction' and contradictory caption, Ch 7's 'every arrow' caption, Ch 11's un-run S3, Ch 13's 'three columns,' Ch 14's 'recovered' vs ~, Ch 16's two 'every' claims, Ch 4's three-way S4 scope. Each is a one-line fix; together they defend the book's core posture that its bookkeeping is honest.
6. Run the promise/pointer ledger: Ch 13's stale 'the audit's last chapter,' Ch 7's uncashed write-side-inheritance promise (state the inheritance in one sentence at Thm 8.3 or B.8), Ch 4's dangling 'Hold that until Prop 4.4,' App A's self-pointing Transposition row and mis-aimed merge citation, the Ch 22→Ch 6 Memex xref — and delete the stale ch22-the-latent-web.qmd/ch23-the-next-web.qmd leftovers.
7. De-compress the ~15 structurally prominent tangled sentences — index's audit sentence, Ch 2's thesis, Ch 8's reveal payoff ('had arrived where it points'), Ch 13's payoff, Ch 16's capstone chain, Ch 20's Web 3.0 definition and the book's final sentence, Ch 22's opening, App B's 90-word synthesis realization. Highest reader-experience return per word changed in the whole book.
8. Enforce canonical vocabulary at the five worst drift sites: Ch 9's 'isomorphism' (→ homomorphism), Ch 19's 'deployed stack' (→ derived stack), Ch 17's 'portability of terms' (→ mobility of evaluation), Ch 21's adapter/wrapper/bridge and machine-legible/readable/consumable cycles, Ch 18's reuse of 'exits' — then grep the ledger for stragglers.
9. Reconcile the book's maps: add a Part V sentence to the One Page, give Part I its missing epigraph, extend Part II's blurb to cover the crossing and the write side, and align Ch 1/Ch 2's disagreement about which parts answer the question (plus Part VI's absence from Ch 2's map).
10. Fix the polarity flips where the text states the opposite of its claim: Ch 22's 'outlived no session' and 'one factor short of the whole,' Ch 5's 'absorbs everything except new facts' caption, Ch 2's 'tables/tabled' for US readers — four small edits that each currently hand a careful reader the wrong claim verbatim.

## Flow audits

### Part I — The Object (flow)

**Verdict.** This span ships well as a sequence. The entry cascade — Preface states the whole argument in a page, Ch 1 plants an axiom nobody can reject, Ch 2 supplies the method and ends with an earned launch into Part II ("Print both. Now take one apart.") — is the strongest kind of opening: each unit's job is small, stated, and delivered, and the ~940/~1080 word counts are proportionate to those jobs. I checked the apparent reveal-spoiler (the one-pager naming RDF/SPARQL/XSLT/CSS against the book's reveal discipline) and cleared it: the Argument in One Page is a designed summary, and Ch 2 explicitly reconciles with it ("stating a result is not deriving it"). Forward promises the span makes were verified against later chapters and hold: Chapter 5 does name the "exits," and "content" is reused in Ch 3–4 exactly as Ch 1's parenthetical predicts. What needs attention is one real defect and a handful of seams. The defect: part1.qmd is the only part intro of six with no framing epigraph, so the reader enters "The Object" cold while every later part gets a two-sentence orientation — fix that and the entry transition is complete. The seams are map-consistency wobbles (Ch 1 and Ch 2 drawing the book's borders slightly differently; the write side and Part VI missing from Ch 2's otherwise complete map) and one boundary echo the reader pays for twice. Address the issue, take a conscious pass on the flags, and this span is done. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human. Every flag must be surfaced for a conscious decision; severity is triage, never permission to skip.

- **ISSUE** · granularity · `part1.qmd`
  > # Part I — The Object
  Part I is the only part intro of six with no framing prose. Parts II–VI each carry a one-to-two-sentence italic epigraph (Part II: "Part I defined a web application as two functions and refused to say what `State` is. This part derives the answer..."; Part III: "The derivation is complete... This part names it."). Part I offers title, figure, and TOC only, so the reader enters the book's first part with the title "The Object" unglossed — its meaning leans entirely on one clause in the Preface ("treats it as a science, an object whose forced structure can be derived"), which preface-skippers never see. The part intro promises nothing the chapters can deliver against.
  *Suggested:* Add an italic epigraph matching the siblings' pattern, e.g.: *Before anything can be derived, the object of study must be fixed. This part quotes the web's own definitions — a pair of functions — and states the question the rest of the book answers: what must `State` be?*

- **FLAG** · duplication · `ch01-what-the-web-is.qmd, ch02-analysis-and-synthesis.qmd`
  > "The method is old, it has a name, and it is the next chapter." / "The method is old enough to have a name."
  Ch 1's closing paragraph pre-plays Ch 2's opening beats, and the reader pays twice within a single page-turn: Ch 1 dismisses "neither a survey of the industry nor the author's taste", then Ch 2 re-runs the same two dismissals ("Survey fails... Preference fails harder"); Ch 1 teases "the method is old, it has a name", then Ch 2 re-teases nearly verbatim ("The method is old enough to have a name") before finally giving the name. The Ch 2 survey/preference expansion does new work (it supplies reasons) and can stand, but the method-name re-tease is a straight echo — Ch 1 promised the name; Ch 2 should cash the promise, not restate it.
  *Suggested:* In ch02 paragraph 4, cut "The method is old enough to have a name." and open directly: "The Greek geometers called the two directions *analysis* and *synthesis* — Pappus's *Collection* describes the pair..."

- **FLAG** · flow · `ch01-what-the-web-is.qmd`
  > Parts II and III are the answer, and the answer will be forced, not chosen.
  Adjacent pages draw the book's map with different borders. Ch 1 assigns the answer to Parts II and III; Ch 2's map gives the answering role to Part II alone ("Part II is the analysis... Between them, the book... holds the derived structure up against the world"), and Part III's own epigraph agrees with Ch 2 ("This part names it"). A reader who files Ch 1's promise finds Part III doing confirmation-and-naming work, not answering work. Small wobble, but it is the book's own map, stated twice in ten pages, and the two statements should agree.
  *Suggested:* Align Ch 1 with the map the rest of the book uses: "Part II forces the answer; Part III names it — and the answer will be forced, not chosen."

- **FLAG** · flow · `ch02-analysis-and-synthesis.qmd`
  > Part II is the analysis: first performed by hand on real pages, then re-run as theorems that quantify over every page
  Definition 1.1 is two functions, and Ch 1 explicitly defers the write side ("`Body` stays opaque for now; Chapter 7 says what fills it"), but Ch 2's method map — prose and mermaid alike — describes only the read loop: strip Doc to State, build State back to Doc. `write` appears nowhere in the shape-of-the-book paragraph or the diagram, so the derivation path for half the definition is never promised. A reader reaching Ch 7 finds a write-side chapter the map gave no slot to.
  *Suggested:* One clause in the map paragraph, e.g.: "Part II is the analysis: first performed by hand on real pages, then re-run as theorems that quantify over every page — and, once `State` is forced, the write side follows from it."

- **FLAG** · flow · `ch02-analysis-and-synthesis.qmd`
  > Between them, the book does what the method obligates — holds the derived structure up against the world, scores everything the industry runs instead, and tables every mismatch.
  Ch 2's "shape of the book" paragraph accounts for Parts II through V and then stops. The Preface promised a "bill" — agents needing machine-consumable state, the evidence assembling in real time — which is Part VI, and Ch 2's otherwise complete-looking map silently drops it. A reader leaves the method chapter with a book plan that has no slot for the final two chapters.
  *Suggested:* Append a closing clause in voice, e.g.: "...and tables every mismatch — and what the result is worth, the last part tests against the web now arriving."

- **FLAG** · dependency · `ch01-what-the-web-is.qmd`
  > what that shedding costs, Part IV computes exit by exit — Chapter 5 names the exits
  "Exits" is book-internal vocabulary that Chapter 5 introduces (the named requirement-rejections of Theorem 5.4) — I verified the promise is kept there — but in Ch 1 it lands twice in one sentence with no gloss, four chapters before its referent. Other forward references in the chapter carry a clear referent ("Chapter 7 says what fills it" — the body's content); this one deploys an unexplained metaphor a cold reader cannot resolve. Concept-before-dependency, acknowledged but not defused.
  *Suggested:* Add a three-word gloss, e.g.: "...Part IV computes exit by exit — each exit a requirement rejected; Chapter 5 names them."

### Part II — The Analysis (flow)

**Verdict.** This part hangs together — genuinely. The entry transition is among the best seams in the span: Ch 2 ends with the pages printed, the part page interposes cleanly, Ch 3 opens with "the two pages are on the table." Ch 3→4 ("this chapter makes you feel it; the next one proves it" → "stripped two pages by hand and called the result illustration") and Ch 4→5 ("State is still abstract... where the book stops describing and starts forcing" → "We need `State` to stop being abstract") are textbook earned handoffs. The running dashboard example threads through all five chapters doing new work at each appearance — strip-2 as fact-shape evidence in Ch 5, then as `canon`'s output in Ch 6 — which is exactly how a running example should pay rent. Depth is consistent: exhibit-led illustration escalating to proposition-led derivation, and the escalation is announced. The defects cluster in two places: the part blurb promises only the read-side core (three of five chapters fall outside it), and Ch 5's tail leaks — it hands off to Ch 6 mid-section then keeps talking, and it pre-states Ch 7's delta result, so both successors open on ground the reader has already paid for. Nothing blocks. Fix the three issues and this part ships; the five flags are the human's calls to make — flag is triage priority, never permission to skip, so every one of them needs a conscious decision.

- **ISSUE** · flow · `part2.qmd`
  > This part derives the answer: the factorization every `read` admits, the properties that make it real, and the forcing of `State` itself.
  The blurb promises chapters 4-5 only. Three of the part's five chapters fall outside it: Ch 3's hand-strip, Ch 6's graph-to-tree crossing, and all of Ch 7 — the write side, which is half of Definition 1.1. A reader checking the part against its promise finds the promise two chapters short.
  *Suggested:* This part derives the answer: the factorization every `read` admits, the properties that make it real, the forcing of `State` itself — and the write side that closes the loop.

- **ISSUE** · duplication · `ch05-what-state-must-be.qmd, ch06-from-graph-to-tree.qmd`
  > "notice what the theorem has done to the pipeline's types: `State` is now a graph — facts whose references point anywhere" / "Look at the pipeline's types: `State` and `Data` are *graphs* — facts whose references form arbitrary many-to-many webs"
  The graph-vs-tree handoff is made twice, nearly verbatim — once mid-section in Ch 5, once as Ch 6's opening. The cause is placement: Ch 5's version lands three paragraphs before the chapter ends ("That is Chapter 6." is followed by the join-by-hand example and the select exhibit), so the chapter announces its successor and then keeps talking, and Ch 6 must redo the setup from scratch.
  *Suggested:* Move the graph/tree observation to Ch 5's final position, after the join example — the join is itself graph evidence, so the handoff lands harder there — or cut it to a bare pointer and let Ch 6's opening do the setup once.

- **ISSUE** · duplication · `ch05-what-state-must-be.qmd, ch07-the-write-side.qmd`
  > "`write`, by (5.1), reduces to two sets: facts added and facts removed — the *delta*" / "Chapter 5 ended by deriving the delta"
  Ch 5 states the delta result outright, and Ch 7 then presents it as its own Prop 7.1 ("Elements leave; elements arrive. There is no third thing") while crediting the derivation back to Ch 5 — so the reader pays for the result twice and cannot tell whose result it is. The credit is also inaccurate: Ch 5 does not end with the delta; it ends with the join-by-hand and the select exhibit.
  *Suggested:* In Ch 5, demote the sentence to a forward pointer ("what a `write` can do to a set is Chapter 7's subject"); in Ch 7, drop "Chapter 5 ended by deriving the delta" and let Prop 7.1 own the result it proves.

- **FLAG** · flow · `ch03-stripping-the-page.qmd, ch06-from-graph-to-tree.qmd`
  > Chapter 6 will harden this from a concession into a law: if the order is a message, the order is data.
  Ch 6 delivers the promised hardening as a mid-paragraph clause ("an order that carries meaning — Chapter 3's lead story — arrives as data and is honored by `t`") with no callback and nothing law-grade to point at. The mechanism is genuinely there — canon's sort is meaningless by construction, so meaningful order must be data — but a reader arriving with Ch 3's promise in hand finds an aside where a law was advertised.
  *Suggested:* In Ch 6, give the rule its promised prominence with an explicit callback: "Chapter 3's concession is now the law it was promised to become: `canon`'s order is meaningless by construction, so an order that means something can only arrive as data."

- **FLAG** · flow · `ch02-analysis-and-synthesis.qmd`
  > Print both. Now take one apart.
  Ch 3 strips both pages in parallel — the experiment's whole control, argued in this same paragraph, is that whatever survives in *both* is no accident. The singular closer contradicts the two-page design it just finished justifying, and Ch 3's opening ("Strip them") quietly corrects it.
  *Suggested:* Print both. Now take them apart.

- **FLAG** · flow · `ch06-from-graph-to-tree.qmd`
  > The seam is not a research problem; Chapter 9 brings the evidence.
  The chapter — and with it the entire read side of the pipeline — ends on a forward pointer to Part IV territory rather than closing what it just finished. Ch 7 then pivots to the write side from Definition 1.1 with no bridge; its opening works, but one clause marking the read pipeline complete would earn it.
  *Suggested:* The seam is not a research problem; Chapter 9 brings the evidence. And with the crossing fixed, the read side is derived end to end — Definition 1.1 has one component left.

- **FLAG** · dependency · `ch06-from-graph-to-tree.qmd`
  > the reveal chapter will name the spec
  "The reveal chapter" is unglossed here and appears nowhere else in the span — Ch 7 refers to the same destination plainly as "Chapter 8 will name what the industry standardized it as." If "the reveal" is established before Part II this is fine; flagging in case it is workshop vocabulary that leaked into shipped prose.
  *Suggested:* Use the book's standard form: "Chapter 8 will name the spec."

- **FLAG** · granularity · `ch04-the-factorization.qmd`
  > Definition 4.3 has one more consequence, and it can be collected now. Nothing in this chapter has mentioned time.
  At ~2060 words Ch 4 is the part's outlier (its neighbors run 733–1628) because it carries three movements: the factorization with properness, the Fielding genealogy, and the four-timelines time apparatus. The quoted pivot concedes the third movement is a fresh start mid-chapter. Everything is load-bearing (Prop 4.5 feeds Ch 7's five moves), so this is a conscious-decision flag about the chapter's shape, not a claim of dead weight.

### Part III — The Reveal (flow)

**Verdict.** This span is the book's hinge, and mechanically it swings well: Chapter 7 closes the pipeline and names its successor by chapter ("Chapter 8 will name what the industry standardized it as"), the part page's one-liner lands, Chapter 8's ending ("This meeting point is the book's proof") is picked up by Chapter 9's opening sentence, and Chapter 9's last line hands off cleanly to Part IV. Depth is consistent; Chapter 8's brevity (776 words) is earned — the table does the work and the chapter knows it. But the reveal's entire rhetorical machinery is auditability — "a check the reader performs, not a construction the author arranged" — and that is exactly where the one block lives: Chapter 8's blanket claim that "No W3C recommendation has been cited" is contradicted by Chapters 4 and 5, which cite AWWW by name and label it a W3C Recommendation. The author already built the defense (Ch 4: "a witness here, never a premise") — Chapter 8 just fails to use it, and hands a skeptical reader a real objection at the worst possible moment. The issues are apparatus debts: a Chapter 7 promise Part III never cashes (write-side completeness), a proof pointer that undersells the appendix actually carrying the book's central proof, and a proposition-numbering gap (no Prop. 8.1 anywhere) at the chapter under maximum scrutiny. I wouldn't ship the part until the block is fixed — it is a one-sentence repair — and I'd take the issues in the same pass. These findings are for the human to judge with the context I was denied; surface every one, including the flags — flag is a triage rank, not permission to skip.

- **BLOCK** · other · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch08-it-already-exists.qmd`
  > No W3C recommendation has been cited; no vocabulary from any data-model community has appeared.
  False against the book's own earlier text, and only a cross-chapter read can catch it: Chapter 4 cites "Architecture of the World Wide Web, Volume One (W3C Recommendation, 2004; hereafter AWWW)" by name and status, and Chapter 5 leans on "AWWW's global-identifiers principle" in its audit table. Chapter 8 concedes exactly one exception (Ch 3's CSS strip) and claims cleanliness otherwise. The reveal's force rests on the reader being able to verify this claim — and a reader who checks finds it wrong. Chapter 4 already built the correct defense ("AWWW is a witness here, never a premise"); Chapter 8 just overclaims past it.
  *Suggested:* Align the claim with Ch 4's witness/premise distinction, e.g.: "No W3C recommendation has entered the derivation as a premise — AWWW appeared as a witness after the fact (Chapter 4), and Chapter 3 turned CSS off by name; no vocabulary from any data-model community has appeared."

- **ISSUE** · flow · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch07-the-write-side.qmd, /Users/martynas/WebRoot/First-Principles-of-the-Web/ch08-it-already-exists.qmd`
  > When <a class="xref" href="part3.html">Part III</a> proves the read side complete, the write side inherits the result through this symmetry.
  The promise is never cashed. Theorem 8.3 certifies selections, arrangements, presentation, and S4 — read side only — and Appendix B.8's Synthesis proof likewise never mentions the write side. SPARQL Update appears in Part III solely as a row of Table 8.1. A reader who tracks Ch 7's explicit forward promise arrives at the reveal, watches the read side get its theorem, and finds the promised inheritance stated nowhere.
  *Suggested:* Add one clause to Theorem 8.3, e.g.: "…and by Prop. 7.3's symmetry the write side inherits the result: SPARQL Update carries the deltas in the same pattern language, arguments swapped."

- **ISSUE** · other · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch08-it-already-exists.qmd`
  > <a class="xref" href="appendix-b-proofs.html#b.8">Appendix B.8</a> gives the condition.
  The pointer scopes B.8 to the genericity caveat only, but B.8 actually carries the full Synthesis proof ("This section is where the halves meet. ∎"). Prop. 8.2 gets an explicit "Full proof: Appendix B.7"; the sentence the book calls its proof ("This meeting point is the book's proof") gets no visible proof pointer at all. A reader auditing the apparatus concludes the central theorem is asserted, not proved — the opposite of the truth.
  *Suggested:* "Appendix B.8 gives the condition exactly, and carries the full proof." — or mirror Prop. 8.2's form: "Full proof: Appendix B.8."

- **ISSUE** · other · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch08-it-already-exists.qmd`
  > []{#prop-8-2}**Prop. 8.2 (Homomorphism).**
  No Prop. 8.1 exists anywhere in the book (verified by grep). Chapter 8 evidently shares one counter across objects (Table 8.1 → Prop. 8.2 → Thm. 8.3), but the neighboring chapters use separate counters — Ch 7 has both eq (7.1) and Prop. 7.1, Ch 9 numbers Props. 9.1–9.2 and leaves its inventory table unnumbered. A reader tracking the numbered apparatus ("Every arrow is a numbered proposition", Ch 7) hits a gap precisely in the chapter inviting the most scrutiny.
  *Suggested:* Either renumber Chapter 8 to match its neighbors (Table 8.1, Prop. 8.1, Thm. 8.2 — updating the Appendix A/C cross-references) or adopt the shared-counter convention book-wide; the span currently mixes both.

- **FLAG** · flow · `/Users/martynas/WebRoot/First-Principles-of-the-Web/part3.qmd`
  > This part names it. The names are decades old.
  The part-intro promises naming only, but Chapter 9 — over two-thirds of the part by weight (1670 vs 776 words) — measures mismatches, a job the intro never announces. The chapter nav below discloses the title "The Mismatches", and Ch 9's own opening bridges well, so the flow survives; but the one-liner undersells half the part's work, and the honesty audit is part of what makes the reveal credible.
  *Suggested:* "This part names it, then puts the mismatches on the table. The names are decades old."

- **FLAG** · flow · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch09-the-mismatches.qmd`
  > Each is located, measured, and — twice — turned into a prediction.
  Only one mismatch is ever called a prediction: mismatch two ("Here the mismatch becomes a prediction"), and the chapter's own inventory table labels exactly one row "a prediction the standards later honored". If the second prediction is meant to be mismatch one's canon landing honored by RDFC-1.0 in 2024, the text never claims it as such. Borderline for my beat — a careful cold read of the chapter alone could count this — but it collides with the inventory table's labels, so I raise it rather than assume the single-chapter reader caught it.
  *Suggested:* Either change the count ("and — once — turned into a prediction") or claim the second prediction explicitly in mismatch one and label its inventory row to match.

### Part IV — The Audit (flow)

**Verdict.** This span mostly earns its structure. The column device gives every audit chapter the same exit ramp, and the discipline pays off: I checked every cell of Chapter 16's assembled table against the per-chapter columns and all 56 agree, down to the tildes. The entry from Chapter 9 is well-built ("now we audit everyone else's" hands off cleanly), transitions 11→12, 12→13, 14→15, and 15→16 are all earned, depth is consistent, and Chapter 12's extreme brevity is announced and justified by its "zero by construction" job. But I would not ship the span as-is, for one reason above the others: Chapter 15 claims to be "the shortest audit in the part" and it is in fact the longest audit chapter in the part — Chapter 12 is less than half its length — in a book whose entire posture is that it measures things. The claim is self-falsifying and the fix is doubly available: reword the sentence, or trim the chapter's re-narration of Chapter 9 (a duplication I flag separately) until the claim becomes true. Around that block sit a cluster of ledger-arithmetic wounds, most of them plausibly scars from the recent restructure: Chapter 13 hands off to "the audit's last chapter" when three chapters remain, counts "three columns" where the part's own later bookkeeping counts four, and the part intro promises one column per audit while two chapters file two and two audits file none. Plus duplications where Chapter 14 re-pays for Chapter 11's hydration coinage and Chapter 15 re-pays for Chapter 9's mismatch conclusions, nearly verbatim. Every one of these is a small, local fix; none requires restructuring. Address the block, take a pass through the issues, and this part will be the strongest-knit span of the book. These findings are for the human to judge with the full context I was denied — surface every one of them, including the flags, for a conscious decision; do not set any aside on my severity labels alone.

- **BLOCK** · granularity · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch15-the-derived-stack.qmd`
  > It is the shortest audit in the part, and the brevity is the finding
  The claim is false by the part's own proportions: Chapter 15 (~861 words by my count, ~915 by the book's) is the longest audit chapter in Part IV — longer than Ch 10 (~859), Ch 11 (~818), Ch 13 (~759), Ch 14 (~649), and more than double Ch 12 (~395). A reader who just finished the 400-word applet chapter three chapters earlier will catch this instantly, and 'the brevity is the finding' makes the false measurement load-bearing rhetoric — in a book whose whole posture is audit-grade precision. A single-chapter cold read cannot see this; the span read can, and it damages the narrator's credibility exactly where the self-audit chapter most needs it.
  *Suggested:* Either make the claim true by trimming the chapter (paragraphs 4-5 re-narrate Chapter 9's mismatches — see the duplication finding — and cutting them to row-mappings with citations would bring the chapter under Ch 14's length), or reword to what is actually meant: 'It is the audit with the least new work in it, and that is the finding: every cell below carries a citation to a result already proved, so where the other columns needed scoring, this one needs collecting.'

- **ISSUE** · flow · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch13-pre-web-paradigms.qmd`
  > what it did in response is the audit's last chapter
  Stale pointer, almost certainly from the 2026-08-05 restructure that inserted Chapters 15 and 16. The industry's response is Chapter 14 (The Convergence) — the very next chapter — but three chapters of the audit remain after it (14, 15, 16), and Ch 15 explicitly continues the audit ('Five chapters have scored seven columns... One column remains'). The handoff misdraws the reader's map of the part at the exact moment it hands them forward.
  *Suggested:* 'what it did in response is the next chapter.'

- **ISSUE** · duplication · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch11-the-single-page-application.qmd, /Users/martynas/WebRoot/First-Principles-of-the-Web/ch14-the-convergence.qmd`
  > "hydration — shipping the document *and* the program that regenerates it — the S1 tax: the architecture cannot tell its document from its program, so it ships both" (Ch 11) / "**Hydration.** The S1 tax, given its industry name: ship the document *and* the program that regenerates it, because the architecture cannot tell them apart." (Ch 14)
  Near-verbatim duplication three chapters apart, unacknowledged: same coinage ('the S1 tax'), same definition ('the document and the program that regenerates it'), same explanation ('cannot tell them apart'). Ch 14 presents the definition as fresh, so the reader pays full price twice, and the second telling reads as if the book forgot it already made the point.
  *Suggested:* Make the Ch 14 bullet a callback rather than a re-definition: '**Hydration.** Chapter 11's S1 tax, given its industry name — the fix that names the disease instead of curing it.' (Keep whichever phrasing is preferred; the point is that one of the two sites must cite the other and shed the repeated definition.)

- **ISSUE** · duplication · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch09-the-mismatches.qmd, /Users/martynas/WebRoot/First-Principles-of-the-Web/ch15-the-derived-stack.qmd`
  > "this derivation's first missing requirement generates the standard's own later extension" + "named graphs, RDF datasets, TriG, standardized 2014" (Ch 9) / "the derivation's first missing requirement, honored by the standard's own later extension, named graphs, standardized 2014" (Ch 15)
  Chapter 15's paragraph 4 re-narrates Chapter 9's conclusions in Chapter 9's own coinage rather than pointing to them: 'first missing requirement / standard's own later extension / named graphs / 2014' recurs almost verbatim, as does 'billed to whoever chose anonymity' (Ch 9: 'falls exactly on the party that chose anonymity' and the inventory cell 'billed to whoever chose anonymity'; Ch 15: 'billed to whoever chose anonymity'). Ch 15's legitimate job is mapping the mismatches onto rows; the re-narration of what the mismatches ARE is what the reader already paid for six chapters earlier — and it is the main reason the 'shortest audit' claim fails (see the block).
  *Suggested:* Compress Ch 15's mismatch paragraph to the row-mapping only: which row each mismatch grazes, with bare citations to Props. 9.1/9.2 — e.g. 'Blank nodes graze R2: idempotence up to equivalence, priced in Prop. 9.1. The fourth position adds R4 rather than striking a row, met as quads with merge still union (Prop. 9.2).' Drop the retellings of billing, named graphs, and 2014.

- **ISSUE** · flow · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch13-pre-web-paradigms.qmd`
  > Three columns of failures — the bracket stacks (Chapter 10), the single-page application (Chapter 11), and the applet (Chapter 12)
  The count contradicts the part's own later bookkeeping. Chapter 10 filed two columns (XML stack and JSON/REST) — Chapter 15 counts them that way ('Five chapters have scored seven columns') and Chapter 16's table seats them separately. So by Ch 13's opening, four columns of failures exist, not three. In a part whose whole conceit is exact ledger-keeping, a miscount in a transition sentence is the wrong place to be approximate.
  *Suggested:* 'Four columns of failures' (or 'Three chapters of failures' if the chapter-count is the intended unit).

- **ISSUE** · other · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch16-the-properness-table.qmd`
  > every failure in the S-rows has appeared in this part twice: once as a score, once as a compensating industry
  The capstone overclaims what the chapters delivered. The compensating-industry device is fully executed for the pre-web columns (Ch 13: integration, serialization/DTO, testing pyramids) and SPA/JS (Ch 11: state-sync libraries, headless browsers, hydration; Ch 14: SSR). But no compensating industry is ever named for Wasm's S-failures (Ch 12), for XML's or JSON/REST's partial S-failures (Ch 10 itemizes a missing-tooling delta, which is an absence, not a bridge), or for GraphQL's (Ch 14). 'Every' is checkable against the span and fails the check — the same defect class as the Ch 15 brevity claim, at lower stakes.
  *Suggested:* Scope the claim to where it holds ('every pre-web and SPA failure in the S-rows appeared twice...'), or drop the universal: 'And the S-row failures kept appearing in this part twice — once as a score, once as a compensating industry — the bridge built across the gap the row names.' Alternatively, make it true by naming the missing industries in Chs 10/12/14 (e.g. per-API client SDKs for JSON/REST).

- **ISSUE** · dependency · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch12-the-applet-returns.qmd`
  > The principle of least power was the reason then and is the reason now
  First appearance of the principle anywhere in the book (verified by grep: no hits in Chs 1-11 or the part intros), leaned on as the load-bearing explanation for why applets died — yet the text never states what the principle holds. The TAG citation locates it but does not gloss it. The first actual gloss arrives two chapters later, in passing, in Ch 14's islands bullet ('most of the page needs no program'). A reader meets the explanans before its content.
  *Suggested:* Add an appositive at first use: 'The principle of least power — prefer the least expressive language that suffices for the job — was the reason then and is the reason now (the W3C TAG finding The Rule of Least Power, 2006 — not, as often assumed, part of AWWW).'

- **FLAG** · flow · `/Users/martynas/WebRoot/First-Principles-of-the-Web/part4.qmd, /Users/martynas/WebRoot/First-Principles-of-the-Web/ch13-pre-web-paradigms.qmd`
  > Every audit in this part ends by filling in one column of the same table
  The promise is stated more precisely than it is executed, in both directions. Chapters 10 and 13 each file two columns, Ch 14 files one plus a revision — and Ch 13's Imperative and MVC audits file none: both get headed sections and rows in Ch 13's own summary table, but no column reaches Chapter 16, and no sentence excuses them from the ledger (the Imperative section gestures at absorption into Ch 11's column; MVC at 'the paradigms above, assembled' — neither says 'hence no separate column'). Chapter 16's opening 'Every audit in this part ended the same way: a column' repeats the overstated promise. Surface for a conscious decision: this may be acceptable looseness, but the part's authority rests on its arithmetic.
  *Suggested:* Part intro: 'Every audit in this part ends by filling in columns of the same table.' Ch 13, after the MVC section or the summary table: one clause making the absorption explicit — 'Imperative and MVC take no separate column: the first is Chapter 11's column at the language level, the second assembles the others.'

- **FLAG** · duplication · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch14-the-convergence.qmd, /Users/martynas/WebRoot/First-Principles-of-the-Web/ch16-the-properness-table.qmd`
  > "the two properties that make it *the web* rather than an app platform that happens to use browsers" (Ch 14) / "the two that make an architecture the web rather than an app platform that happens to use browsers" (Ch 16)
  The span's best coinage is spent twice, two chapters apart, the second time without acknowledgment that it is a reprise (the surrounding Ch 16 sentence does cite Ch 14 for the stall finding, but the phrase itself is re-presented as new). If this is a deliberate refrain, fine — but as written it reads as accidental reuse, and the reader pays twice for one flourish. Must be surfaced to the human for a conscious decision.
  *Suggested:* If intentional, have Ch 16 own the callback (e.g. 'R3 and S4 — Chapter 14's two that make an architecture the web rather than an app platform'); if not, vary one of the two sites.

- **FLAG** · duplication · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch09-the-mismatches.qmd, /Users/martynas/WebRoot/First-Principles-of-the-Web/ch10-brackets.qmd`
  > "The platform then froze it at that 1999 revision for a quarter of a century" (Ch 9) / "XSLT, frozen at its 1999 revision, still runs in every browser as of this writing" (Ch 10)
  The frozen-at-1999 fact is restated in consecutive chapters with no cross-reference — Ch 9 files it as mismatch three, Ch 10 re-derives it as a longevity aside one chapter later. Mild, but the reader notices the echo across the part boundary, and Ch 10's version also silently omits the scheduled-removal half of the Ch 9 telling. Must be surfaced to the human for a conscious decision.
  *Suggested:* Ch 10 can lean on the filing: 'XSLT — frozen at 1999, as Chapter 9 filed — still runs in every browser as of this writing.'

- **FLAG** · flow · `/Users/martynas/WebRoot/First-Principles-of-the-Web/ch09-the-mismatches.qmd`
  > Ours are; now we audit everyone else's.
  The handoff line (and Ch 9's opening 'Part IV applies the same standard to everyone else's models') promises an audit of everyone ELSE — but Part IV's distinctive honesty move, announced in the very next page's part intro ('and last, the derived stack itself') and executed in Chapter 15, is that the audit does not stop at everyone else. The entry undersells the part's strongest structural claim, and Ch 15's whole opening ('An audit that stopped here... would have exempted exactly the technology the book argues for') exists to correct an expectation Ch 9 set. Must be surfaced to the human for a conscious decision — the current line has real punch and the tension is mild.
  *Suggested:* 'Ours are on the table; now every stack goes on it — ours included, last.'

### Part V — The Synthesis (flow)

**Verdict.** This span is in good shape — the strongest-wired stretch of the book I could ask for. The entry is clean: Chapter 16 closes on the no-failure column and hands it to Part V by name; the part intro promises exactly four things and Chapters 17–20 deliver them in order, one each. The long-range wiring holds under pulling: Chapter 5's scope note really does defer the alignment objection to Chapter 17; Chapter 5's R3 note really does defer the name/address cost to Chapter 18; the four timelines, the synthesis theorem, Chapter 12's leaf, Chapter 7's portable terms, and the strip-2 material all resolve to real anchors upstream. Transitions inside the part are earned — Ch 17→18 explicitly (\"The build log ran on deployed standards end to end\"), Ch 18→19 by a planted forward wire (\"Chapter 19's thesis arriving early\"). Granularity tracks role: this is the heaviest part in the book (17–19 are its three largest non-finale chapters) and its constructive payload justifies that; Ch 20's compression reads as deliberate capstone speed, not starvation. Nothing is off-mission. What needs a pass: two issues — Chapter 17 twice points at \"the bridge below\" when the bridge lives in the next chapter (a restructure leftover, quick fix), and Chapter 18 re-buys Chapter 9's RDF/POST explanation nearly verbatim — plus four flags: the ch16/part-page verbatim echo, the over-teased Chapter 21 demand-side handoff (which also lets Ch 19 overshoot the capstone), the online-edition refrain paid in four consecutive artifacts, and an uncheckable \"fifth kind of name\" tally. Fix the two issues, decide the flags consciously, and this part ships. These findings are for the human to judge with the full context I was denied — surface every one, including the flags; none is the caller's to waive. Note the build pipeline: the .qmd files are generated from the single markdown source, so repairs belong in first-principles-of-the-web.md, not the qmd files the findings anchor to.

- **ISSUE** · dependency · `ch17-building-up.qmd`
  > HTML forms encoding graphs (the bridge below), written through the Graph Store Protocol's unsafe methods
  "The bridge below" appears twice in Chapter 17 (the build-log table's write row and the mermaid caption: "a form (the bridge below) yields a delta"), but nothing below in Chapter 17 delivers a bridge — the chapter ends after the arrange paragraph. The referent is RDF/POST, introduced in Chapter 9 and slotted in during Chapter 18's "Composition, not creation." A reader hunts the rest of the chapter for a bridge section that does not exist. This reads like a leftover from a restructure that moved the bridge material one chapter forward.
  *Suggested:* In both spots, replace "the bridge below" with a real pointer: "HTML forms encoding graphs (Chapter 9's bridge, deployed in Chapter 18), written through the Graph Store Protocol's unsafe methods" — and in the caption, "a form (Chapter 9's bridge) yields a delta".

- **ISSUE** · duplication · `ch09-the-mismatches.qmd, ch18-no-new-standard.qmd`
  > "flattens the triple positions into form keys (`su`, `pu`, `ou`, `ol`, …) so that a plain HTML form, with no script, submits a graph" / "field names are triple positions (`su`, `pu`, `ou`, `ol`, …), the submission is a graph, no script anywhere"
  Chapter 18 re-buys Chapter 9's RDF/POST explanation nearly verbatim — the same key enumeration, the same "no script" point, and the same "encoding rather than an invention" verdict (Ch 9: "It invents nothing: an encoding of the derived model..."). Chapter 18 even cites "as Chapter 9 noted" while restating the full mechanism anyway, so the reader pays for the machinery twice.
  *Suggested:* Compress Chapter 18's recall to the name plus one clause and let the citation carry the mechanism: "For the third seam, Chapter 9's bridge — RDF/POST — slots a plain HTML form into the write side. Specified, not standardized; and, as Chapter 9 showed, an encoding rather than an invention — no new model, no new protocol."

- **FLAG** · duplication · `ch16-the-properness-table.qmd, part5.qmd`
  > "One column has no failures, and Part II proved it could not be otherwise-shaped: that is the book, in one exhibit. Part V builds with it." / "One column of the audit has no failures. This part builds with it"
  Chapter 16's final sentences and the Part V intro page are near-verbatim, and the reader hits them seconds apart — the part page immediately follows the chapter's last line. If this is a deliberate echo across the part boundary, fine; if not, it is the exact sentence paid twice at the book's most prominent seam.
  *Suggested:* If the echo is not intentional, vary one side — e.g. open the part page with "*This part builds with the column that had no failures: the application space, the proof it needs no new standard, its economics, and the result they add up to.*"

- **FLAG** · duplication · `ch17-building-up.qmd, ch19-generic-software.qmd`
  > "Chapter 21 is the demand side arriving." / "Chapter 21 names the demand: users never counted the cost of bespoke code; agents count it per call."
  Part V tees up Chapter 21 as "the demand side" repeatedly: Ch 17's alignment section, Ch 19's browser section ("the arithmetic Chapter 21 will total"), Ch 19's governance aside, and Ch 19's closing sentence — plus two more pointers in Ch 20. The same tease paid this often dilutes Chapter 21's landing, and Ch 19 ending on the Ch 21 handoff also overshoots Chapter 20: the reader is launched at Part VI one chapter before the part's own capstone.
  *Suggested:* Thin the pointers so the demand-side tease lands once in the part's body (Ch 19's close is the natural site) — e.g. cut "Chapter 21 is the demand side arriving." from Ch 17, whose Schema.org paragraph already makes the demand point on its own — and let Ch 20, not Ch 19, carry the final handoff to Part VI.

- **FLAG** · duplication · `ch18-no-new-standard.qmd, ch19-generic-software.qmd`
  > "the online edition of this book is being built on it, keeping the promise the preface made" / "the book's online edition, the promise still outstanding, is a third"
  The preface's online-edition promise is re-announced in four consecutive artifacts: Ch 16 ("this table is the home page"), Ch 18, Ch 19, and Ch 20 ("The canonical edition of this book — under construction, as the preface discloses... the properness table as the home page"). Each mention does slightly different work, but the refrain — and the home-page detail stated verbatim in both Ch 16 and Ch 20 — is paid more times than it earns; Ch 18's "keeping the promise" also sits slightly at odds with Ch 19's "still outstanding."
  *Suggested:* Keep one full recall where the implementation enters (Ch 18) and strip the others to bare mentions: in Ch 19, "and the book's online edition is a third"; in Ch 20, drop "as the preface discloses" and either Ch 20's or Ch 16's "home page" clause.

- **FLAG** · dependency · `ch17-building-up.qmd`
  > An origin is not a fifth kind of name.
  "Fifth" leans on a four-kind tally of names the book never states. A reader can reconstruct candidates (addresses, entity names, attribute names, graph names) from Chapters 4, 5, and 9, but no chapter ever counts them, and Chapter 17's own tuple counts four components — so the arithmetic is uncheckable either way and the sentence trips exactly the careful reader it is written for.
  *Suggested:* "An origin is not a new kind of name." — same claim, no phantom ledger.

### Part VI — The Future (flow)

**Verdict.** This span is the best-stitched stretch of the book I could ask for at the seams: Chapter 20 ends on "it waits to be occupied," the part intro hinges on "once it is occupied," and Chapter 22's opening participle — "The result stated and the era of its machine readers named" — names both predecessors in nine words. Ch20's forward promises are all cashed: "an agent … is only another reader" becomes Ch21's "An agent is a user agent," and the claims-table row for Ch21 is delivered by its closing question and the N+M arithmetic. Ch21→Ch22 handoffs (the wrapper, the silo-as-view, the domain-as-data question answered as "never really a choice") are earned and cited. The defect that matters is in the middle of Ch22: two of its eleven sections — "Reading, not scraping" and "Every action a document" — are Chapter 21 re-told, uncited, which both dulls Ch21's punch on a straight-through read and accounts for much of why Ch22 (~2,658 words) runs 2.7× its part-mate (~988) and 600 words past the book's next-largest chapter. Cut those two to bridges and the length is earned by the capability catalog and its dated exhibits; no split needed. Beyond that: one cross-reference that promises a Memex Chapter 6 never names, and a cluster of flags — the part intro's frame fits Ch22 but not Ch21, "Web 3.0" is defined with fanfare in Ch20 and then never spoken again in the part about that web, "five moves" and "five movements" collide four paragraphs apart, and the final movement is the only one denied headings and a dated case. Housekeeping aside: stale ch22-the-latent-web.qmd and ch23-the-next-web.qmd from the reverted split still sit in the working directory as near-duplicates of the live Ch22 — worth clearing so nothing greps or builds against them. These findings are for the human to judge, with context I was denied; surface every one of them — a flag is a triage rank, not permission to skip — and do not quietly set any aside.

- **ISSUE** · duplication · `ch21-the-agent-era.qmd, ch22-the-next-web.qmd`
  > an agent's entire intended course — what it will read, what it will change, what it will do if the first answer disappoints — can be stated as one document and read before any of it runs / And a whole intended course, every read and change and branch, can be written down and inspected before a step of it runs.
  Ch22's "Every action a document" section restates Ch21's write-side paragraph beat for beat — the delta as two fact-sets, readable-before/reversible-after, the opaque-call contrast ("an opaque API call whose effect is whatever the endpoint's code decided, reversible by nothing" vs "an opaque call reversible by nothing"), and the inspectable plan — roughly 1,500 words after the reader first paid for it, and with no cross-reference, so it presents as new material. Only the closing sentence ("The autonomy that alarms turns out to be the autonomy that can be read") is new.
  *Suggested:* Compress the section to a pointer that cites Chapter 21 and keeps only the new closer — e.g. "A change is a delta and a plan is a document; Chapter 21 derived both. The autonomy that alarms turns out to be the autonomy that can be read." — or cut the heading and fold that closer into the end of "Stating a need".

- **ISSUE** · duplication · `ch21-the-agent-era.qmd, ch22-the-next-web.qmd`
  > a substrate whose answers are computed rather than guessed / Its answers are computed, not guessed: the substrate returns what is held, not what a model interpolated.
  Ch22's "Reading, not scraping" section contains no capability Ch21 hasn't already stated: sentence one recaps the compensating industry ("rendered pixels and private APIs" returns as "parsed rendered pixels and reverse-engineered private interfaces"), sentence two recaps the grounding paragraph, sentence three recaps Ch21's 2001-scenario history box. On a straight-through read the reader pays three times within a chapter and a half; the section exists to give the movement a first heading, not to say anything new.
  *Suggested:* Cut it to a one-to-two-sentence bridge into "A claim carries its source" (the movement's genuinely new content), e.g. "The agent reads rather than scrapes — Chapter 21's diagnosis, flipped to a capability — and every fact it receives arrives carrying something the scraped page never did: its source."

- **ISSUE** · dependency · `ch22-the-next-web.qmd, ch06-from-graph-to-tree.qmd`
  > Bush's Memex (<a class="xref" href="ch06-from-graph-to-tree.html">Chapter 6</a>) wanted a personal store that outlived no session
  The xref promises the Memex was introduced in Chapter 6, but Ch6's history box discusses Bush's 1945 indexing argument without ever naming the Memex — the device name first appears here, dressed as a callback. A reader who follows the link finds Bush but no Memex. (While anchored here: "a personal store that outlived no session" reads inverted — a store that outlives no session dies with every session.)
  *Suggested:* Either name the device in Ch6's history box ("In 1945 Vannevar Bush — his Memex the proposed cure — blamed…") or drop the name in Ch22 ("Bush's 1945 associative store (Chapter 6)"). And repair the inverted clause: "wanted a personal store no session's end would erase."

- **FLAG** · flow · `part6.qmd`
  > Two readings of what the derived web permits once it is occupied
  The frame fits Ch22 but not Ch21, which spends its first half on what the unoccupied web costs its new readers — the scraping industry, the N×M bill — and only its back half on what the derived stack offers. The intro promises two exhibits of the permitted; the part delivers one diagnosis and one exhibit.
  *Suggested:* "Two readings of the web's future: the era its machine readers force, and the web the derived stack permits once it is occupied."

- **FLAG** · flow · `ch20-the-result.qmd, ch22-the-next-web.qmd`
  > Web 3.0, defined: `read` transparent all the way down
  Ch20 spends two paragraphs defining Web 3.0 and re-reading the eras through it, then the term never appears again — not in the part intro, not in Ch21, not in Ch22, the chapter that describes that web. A reader is left to infer whether "the next web" and "Web 3.0" name the same thing.
  *Suggested:* One stitch in Ch22 closes it — e.g. the final paragraph: "So the next web — era three, as Chapter 20 defined it — is not built by a consortium or shipped in a release." (Alternatively, confine the term to Ch20 deliberately and say so there.)

- **FLAG** · other · `ch22-the-next-web.qmd`
  > the five moves are interface primitives … in five movements
  Chapter 7's "five moves" and this chapter's own "five movements" land four paragraphs apart, and the counts match — a reader can reasonably conclude the five movements are the five moves. They aren't: the movements are the chapter's structure, the moves are Ch7's interaction set.
  *Suggested:* Drop the count from the structural device: "Read the properties forward, as capabilities rather than columns — from the application in the reader's hands out to the network that forms when many build one level down." The headings carry the structure without the number.

- **FLAG** · granularity · `ch22-the-next-web.qmd`
  > And once many build this way, the whole becomes more than its origins.
  "The network forms" is the only movement with no subsection and no dated exhibit: one ~340-word paragraph carries four beats (union composition, the mashup era's rise and re-siloing, the network effect, the Ch21 callback), while every other movement gives each capability its own heading and most get a dated history box. At the close of the book's largest chapter this reads as compression fatigue rather than a deliberate coda.
  *Suggested:* Give the composition capability a heading (e.g. "### Combinations no one arranged") with the mashup era as an "In the world, dated 2005" box, and let the final two sentences stand alone as the chapter's coda.

- **FLAG** · dependency · `ch21-the-agent-era.qmd`
  > the integration industry's arithmetic at a new scale
  The definite article treats the integration industry's N×M arithmetic as established — and it was, in one clause of Chapter 17 ("priced N × M forever") — but this is the only load-bearing callback in the part that travels without an xref, in a book where every other one carries its anchor. A reader who missed the Ch17 clause takes "the integration industry's arithmetic" as an orientation tax.
  *Suggested:* "the integration industry's arithmetic (<a class=\"xref\" href=\"ch17-building-up.html\">Chapter 17</a>) at a new scale"

### Whole-book argument arc (flow)

**Verdict.** The arc holds, and holds well. Chapter-to-chapter handoffs are explicit and almost always honored — Ch 1's "it is the next chapter," Ch 2's "Now take one apart," Ch 3's "the next one proves it," Ch 9's "now we audit everyone else's," Ch 16's "Part V builds with it" all land on the promised opening. Part boundaries sit exactly where the argument turns: definition, derivation, naming, scoring, building, projecting. The Preface's promises are all paid: the genre claim returns in Ch 20 as announced, the self-hosting promise is disclosed honestly at every mention, and Ch 22's "It is occupied — origin by origin" answers the Preface's "it waits to be occupied" as a genuine three-beat with Ch 20 in between. The audit's internal bookkeeping is impressively consistent — "five chapters, seven columns" counts out exactly, and the part intros' proposition anchors (Thm 5.4, Prop 4.4) exist and say what the intros claim. What the findings above catch are mostly restructure scars and late-book seam overlap: Ch 13 still points the industry's response at "the audit's last chapter" (it is the next chapter), Ch 15 claims a superlative Ch 12 already owns, Ch 8's independence boast overstates what Chs 4–5 actually cited, the One Page has no sentence for Part V, and Chapters 21 and 22 have not fully divided the agent material — the delta-reviewability argument is paid for in full twice. Fix the issues and this is a book whose skeleton a hostile reader cannot dent. One housekeeping note outside the findings: ch22-the-latent-web.qmd and ch23-the-next-web.qmd — leftovers of the reverted 22/23 split — still sit in the working directory alongside the live ch22-the-next-web.qmd; they are outside _quarto.yml but worth deleting before they confuse a future session. These findings are for the human to judge with the context I was denied; every flag above is surfaced for a conscious decision, not for the caller to waive.

- **ISSUE** · other · `ch08-it-already-exists.qmd, ch04-the-factorization.qmd`
  > "No W3C recommendation has been cited" — but Ch 4: "AWWW is a witness here, never a premise."
  Chapter 8's opening independence claim is contradicted two chapters earlier: Chapter 4 cites AWWW (a W3C Recommendation, by name, with section numbers), and Chapter 5's transposition table cites AWWW's global-identifiers principle. Chapter 8 concedes only the CSS mention. The reveal's whole force is that the reader can verify the derivation's independence; a reader who checks catches the book in an overstatement at exactly the moment it claims auditability.
  *Suggested:* Weaken to the claim Ch 8 itself makes correctly later in the same paragraph: "No W3C recommendation has entered as a premise" (Ch 4 and Ch 5 cite AWWW as witness only, and say so), keeping the CSS concession as is.

- **ISSUE** · flow · `ch13-pre-web-paradigms.qmd`
  > It has spent a decade paying these costs; what it did in response is the audit's last chapter.
  Stale pointer, almost certainly a scar from the restructure that inserted Chapters 15–16. The industry's response is the convergence — Chapter 14, the very next chapter. The audit's last chapter is Chapter 16, the properness table, which is not "what it did in response." The closing promise sends the reader to the wrong place.
  *Suggested:* "It has spent a decade paying these costs; what it did in response is the next chapter."

- **ISSUE** · flow · `index.qmd`
  > one table carries every score. The bill: software agents now need exactly the property the industry never adopted
  "The Argument in One Page" jumps from the audit (Part IV) straight to the bill (Ch 21) and never states the synthesis — Part V has no sentence. Yet Chapter 2 elevates the synthesis to half the proof ("that meeting, not either half, will be the book's proof"), and Part V is four chapters: the dataspace, no new standard, the economics, the result. The One Page currently summarizes a five-part book; the reader who uses it as a map finds a part it never promised.
  *Suggested:* Insert one sentence between the audit and the bill, in the same clipped register — e.g. "The build: from the derived parts alone, an application space assembles on standards already shipped — no new one needed, one generic engine specialized by data rather than code."

- **ISSUE** · flow · `part2.qmd`
  > This part derives the answer: the factorization every `read` admits, the properties that make it real, and the forcing of `State` itself.
  The intro promises the work of Chapters 3–5 and stops. Chapters 6 (the graph-to-tree crossing) and 7 (the write side) — two of the part's five chapters — are unannounced. Part III's own recap knows better: it lists "a data model, an algebra, a crossing, a write side." The part intro under-promises what its chapters deliver.
  *Suggested:* Extend the list: "...the forcing of `State` itself, the one crossing from graph to tree, and the write side that closes the loop."

- **ISSUE** · duplication · `ch11-the-single-page-application.qmd, ch14-the-convergence.qmd`
  > "hydration — shipping the document *and* the program that regenerates it — the S1 tax" / "Hydration. The S1 tax, given its industry name: ship the document *and* the program that regenerates it, because the architecture cannot tell them apart."
  The same gloss, nearly verbatim — same definition, same "S1 tax" label, same "cannot tell document from program" rationale — paid for in full twice, three chapters apart. Chapter 14's list item adds only "An industry term for a category error."
  *Suggested:* Chapter 14 compresses to a citation: "**Hydration.** The S1 tax (Chapter 11), given its industry name — an industry term for a category error."

- **ISSUE** · duplication · `ch21-the-agent-era.qmd, ch22-the-next-web.qmd`
  > "an agent's entire intended course — what it will read, what it will change, what it will do if the first answer disappoints — can be stated as one document" / "And a whole intended course, every read and change and branch, can be written down and inspected before a step of it runs."
  Chapter 22's "Every action a document" section re-states, one chapter later and without citation, both of Chapter 21's write-side points: the delta as a reviewable, invertible object, and the whole plan readable before it runs. The sibling "Reading, not scraping" section also re-treads Ch 21's "computed rather than guessed" grounding point. This is a real part of why Ch 22, at ~2658 words, is the book's largest chapter — and it is the only capability section in Ch 22 with no dated anchor case, which makes it read as a recap rather than a capability.
  *Suggested:* Compress "Every action a document" to a sentence or two citing Chapter 21, or earn the section with its own dated "In the world" anchor as every neighboring section has.

- **ISSUE** · other · `ch15-the-derived-stack.qmd`
  > It is the shortest audit in the part, and the brevity is the finding
  False by the book's own contents: Chapter 12 (Wasm, ~399 words) is an audit in the same part and is less than half Chapter 15's length (~915 words), and Chapter 13's opening plus Chapter 15's own "Five chapters have scored seven columns" both count Ch 12 among the audits. A single-chapter cold read can't see this; a sequential reader can.
  *Suggested:* Drop the superlative: "It is a short audit, and the brevity is the finding: every cell below carries a citation to a result already proved."

- **FLAG** · flow · `ch19-generic-software.qmd`
  > the corollary's adoption path runs through the demand side, and Chapter 21 names the demand
  Chapter 19's closing promise aims one chapter past its successor: Chapter 20 (the Part V capstone) interposes, and its opening picks up Chapter 16's table, not Chapter 19's close. The reader crosses the 19→20 boundary carrying an unresolved handoff and no bridge.
  *Suggested:* Either have Ch 19's close acknowledge the capstone ("once the result is read forward, Chapter 21 names the demand") or give Ch 20's opening a half-sentence acknowledging it sits between the economics and the demand they predict.

- **FLAG** · flow · `ch20-the-result.qmd`
  > And if you put the book down short of that edition, what it leaves behind is a handful of lenses you will find yourself using unbidden.
  A whole-book valediction — the takeaway lenses, then "Beneath the lenses, the sentence" — placed two chapters before the end. The genre bookend with the Preface is earned and the three-beat on "waits to be occupied" (Preface promise, Ch 20 restatement, Ch 22 fulfillment) works, but the lenses paragraph makes the book end rhetorically at Chapter 20, and Part VI must then restart momentum. I know the capstone-then-future structure is deliberate; the valediction paragraph is the one piece doing Chapter 22's job early.
  *Suggested:* Consider moving the lenses paragraph to the end of Chapter 22 (before or after "It is occupied — origin by origin"), leaving Ch 20 to close on the register and the recursion.

- **FLAG** · dependency · `ch11-the-single-page-application.qmd`
  > because Web 3.0 *means* machine-consumable state
  Chapter 11 leans on a definition of Web 3.0 that the book only issues in Chapter 20 ("Web 3.0, defined: ... the table lets this one point"). The inline gloss carries the reader, but the load-bearing prediction ("the paradigm caps at Web 2.0") rests on a definition nine chapters ahead, and Ch 20's "every earlier use of the term outside this book gestured" quietly excludes this earlier in-book use.
  *Suggested:* Forward-cite in the existing sentence: "because Web 3.0 *means* machine-consumable state (the definition Chapter 20 makes exact)" — the sentence already forward-references Chapters 14 and 21.

- **FLAG** · duplication · `ch14-the-convergence.qmd, ch16-the-properness-table.qmd`
  > "the two properties that make it *the web* rather than an app platform that happens to use browsers" / "the two that make an architecture the web rather than an app platform that happens to use browsers"
  The same epigram, verbatim, two chapters apart. Chapter 16 has license to re-state scores — it says so — but it repeats the phrase as its own rather than citing the chapter it names in the same sentence, so the reader pays for the line twice.
  *Suggested:* Ch 16 attributes: "R3 and S4 — the two that, as Chapter 14 put it, make an architecture the web rather than an app platform."

- **FLAG** · flow · `part3.qmd`
  > This part names it. The names are decades old.
  The intro promises naming only. The part also delivers Theorem 8.3 — which Chapter 8 calls "the book's proof" — and Chapter 9's four-mismatch inventory, which Chapter 2 assigned as a standing obligation. The part where the central theorem lands is the part whose intro promises the least.
  *Suggested:* One clause more: "This part names it — the names are decades old — proves the two halves meet, and files every mismatch in the open."

- **FLAG** · flow · `ch05-what-state-must-be.qmd`
  > Somewhere between them, the shape must change. That is Chapter 6.
  The handoff to Chapter 6 is delivered four paragraphs before the chapter ends; the chapter's actual last words are an exhibit caption for the selection algebra. Chapter 6's opening honors the promise, but the reader leaves Chapter 5 on illustration material, not on the turn.
  *Suggested:* Move the graph-versus-tree observation (and its "That is Chapter 6") after the join-by-hand and the exhibit, so the chapter closes on the handoff.

- **FLAG** · granularity · `part1.qmd`
  > # Part I — The Object
  Part I is the only part divider with no orienting intro paragraph — Parts II–VI each carry an italic argument-state summary. Arguably the Preface and One Page immediately precede it, but the asymmetry means the convention the reader is trained on starts one part late.
  *Suggested:* Either add a one-sentence intro in the same register (e.g. "The web defines its own object; this part writes the definition down and chooses the method that fills its one omission.") or accept the asymmetry consciously.

## Cold reads, artifact by artifact

### Front matter — Preface + The Argument in One Page

**Verdict.** This is a strong cold open, and I say that as someone who arrived with the pen already uncapped. The Preface leads with its claim in the first sentence, the one-page argument genuinely fits on a page, and the voice — "the book has a bug, and I would like a report" — is confident without swagger. Nothing here blocks, and there is no exposure of any kind. Every defect the pen caught is one species: compression outrunning the reader at exactly the moments the argument leans hardest. An ambiguous "one" sits inside the definition of a triple — the crux of the theorem; the audit sentence stacks three semicolon clauses and uses the table's rows before the table exists; the load-bearing coinage "compensating industry" floats unanchored and is then leaned on twice. Ship this after a pass: fix the four issues, give each flag a conscious yes-or-no, and this front matter will carry a stranger clean through to Chapter 1. These findings are for the human to judge, with the full context I was denied — surface every one of them, flags included; a flag is a triage rank, not permission to skip. If the human is not available, stop and wait; content review is a compliance gate, and relaxing it is the human's call, not the caller's.

- **ISSUE** · ambiguous-referent · [legibility]
  > two global names and a value that may itself be one
  Two live parses at the crux of the whole argument: "one" can grab "a global name" (presumably intended) or "a triple" from the appositive's head noun. The definition the uniqueness theorem rests on should not garden-path a first-time reader.
  *Suggested:* two global names and a value that may itself be such a name

- **ISSUE** · concept-before-dependency · [legibility]
  > the derived stack, audited last on the same rows, fails nothing; by the audit's last chapter, one table carries every score
  "Rows" arrives before the table exists — the reader meets rows of a table introduced one clause later. And the full sentence runs three semicolon-joined clauses behind a colon header, making it the heaviest sentence on the page at the exact moment the audit's structure is being announced.
  *Suggested:* The audit: everything the industry runs instead fails a named requirement and pays for the failure with a compensating industry. By the audit's last chapter one table carries every score — and the derived stack, scored last on the same rows, fails nothing.

- **ISSUE** · plain-words · [legibility]
  > pays for the failure with a compensating industry
  The coinage lands abstract on first use, and the next sentence leans on it again as "the compensating machinery." A cold reader gets only a fuzzy gist of what a compensating industry is — one short concrete apposition would ground it. The content of that apposition is the author's to pick; the suggestion below is shape, not substance.
  *Suggested:* pays for the failure with a compensating industry — a market that sells back what the failure took

- **ISSUE** · duplication · [legibility]
  > built to practice what it derives: its canonical edition is designed as an application of the very kind the book derives
  "Derives" appears twice in one sentence, and the two halves say the same thing twice — "practice what it derives" and "application of the very kind the book derives" are the same claim, and the reader pays for it both times.
  *Suggested:* One more thing. This book is built to practice what it derives: its canonical edition is designed as an application of that very kind, in which every proposition is a resource with its own address — an instance of its own thesis.

- **FLAG** · undefined-term-on-first-use · [legibility]
  > the structure just derived is RDF, SPARQL, XSLT, and CSS
  The reveal's entire payoff depends on the reader recognizing four unexpanded acronyms, and this front matter has no glossary behind it. For a web-technical audience three of the four land and expanding them would deflate the beat — "standardized between 1996 and 2014" already anchors them as standards. Flagging because a reader who does not know RDF gets no reveal at all, at the page's climax. If your reader is the audience I think it is, this is fine; the call is the human's.

- **FLAG** · terminology-shift · [legibility]
  > style peels off, then arrangement, then selection
  The strip list names style / arrangement / selection, but the factors are present / arrange / select — the reader must map "style" onto "present" unaided, right where the factorization is supposed to feel inevitable. (The ∘ symbol also goes unglossed; likely fine for this audience, but it is the page's only piece of notation.)
  *Suggested:* presentation peels off, then arrangement, then selection, and what remains is state

- **FLAG** · sentence-tangle · [legibility]
  > the book's finding, stated here and argued there, is that each is a partial rediscovery
  The parenthetical earns its keep — it tells the reader "asserted now, proven later" — but it sits inside a sentence already carrying a two-dash appositive and a semicolon, making the opening paragraph's last sentence its hardest. Splitting it costs nothing.
  *Suggested:* Everything else — the JSON APIs, the JavaScript frameworks, the compile-to-browser toolchains — gets scored against those rules in Part IV. The finding, stated here and argued there: each is a partial rediscovery of this way, or a detour from it.

- **FLAG** · plain-words · [legibility]
  > which forces merging by union, over facts that carry their own meaning
  The comma severs "union" from its complement — "merging by union over facts" is one phrase and reads as two. And "carry their own meaning" compresses self-describing data into four words the reader must unpack alone; if the theorem in the next sentences is to feel earned, this clause is carrying more than it can lift.
  *Suggested:* which forces merging by union over facts that carry their own meaning

- **FLAG** · plain-words · [legibility]
  > the factorization matters exactly when the factors are separate, declarative, substitutable, and addressable
  "Exactly when" is the mathematician's if-and-only-if; a general reader hears emphasis, not biconditional. If iff is meant, the phrasing under-signals it; if it isn't, plainer wording exists. The four adjectives also arrive with no anchor — presumably chapters to come, but here they are asserted bare. Which reading is intended is the author's call, so no revision offered.

- **FLAG** · orientation-tax · [legibility]
  > gets scored against those rules in Part IV
  The front matter names Part IV, Chapter 2, Chapter 20, Appendix A, and "the audit's last chapter," but never sketches the book's overall shape — a cold reader has no idea how many parts exist or what arc they trace. One sentence of map would convert these references from decoration into orientation. Content of that map is the author's, so no revision offered.

### Ch 1. What the Web Is

**Verdict.** Glad to report this is mostly the good kind of red ink. The opener earns its swagger, the march from URIs to Definition 1.1 is clean and fast, "That omission is deliberate, and it is the engine of this book" is exactly the sentence Chapter 1 needs, and the closer sets up Chapter 2 without spoiling it. You can ship this after a pass, but not before one: the trouble concentrates almost entirely in the standing-connection paragraph, which settles its counterexample well and then balloons — "exit" arrives as a term of art four chapters early, the chapter's key word "transparent" gets its real definition buried inside a parenthetical aside while the closing paragraph glosses it differently, and the host sentence tangles across three em-dashes. Fix that paragraph, untangle the one nested-aside sentence near the top, and this reads clean end to end; nothing here rises to a block and there is no exposure. Standing directive to my caller: these findings — every one, flags included — are for the human to judge with the context I was denied. Do not make the call yourself and do not quietly set a finding aside; surface this review whole, and if the human is not available, stop here and wait. Content review is a compliance gate — if its friction becomes a nuisance, that is the human's call to revisit, not yours to relax.

- **ISSUE** · undefined term on first use · [legibility]
  > what that shedding costs, Part IV computes exit by exit — Chapter 5 names the exits
  "Exit" is a term of art from four chapters ahead, dropped here with no gloss; the reader is told a later chapter names the very things being counted, which turns the cross-reference from supplementary into required. The host sentence compounds it: three em-dash segments and an inverted clause ("what that shedding costs, Part IV computes") before the full stop. If the author wants "exit" seeded this early, it needs a one-clause gloss here — the content of which is context I was denied.
  *Suggested:* What the channel sheds is not the definition but HTTP's machinery around it: methods, caches, a URI per exchange. Each shed piece has a cost; Part IV computes them one by one, under the names Chapter 5 gives them.

- **ISSUE** · concept-before-dependency (buried definition) · [legibility]
  > is transparent: legible to machines that did not produce it
  The chapter's load-bearing term, "transparent," receives its actual definition inside a parenthetical aside about sockets — and then the closing paragraph, which leans on the term ("its `read` was *transparent*"), glosses it differently ("declarative, addressable, linkable, indexable"). The reader gets two competing glosses, the sharper one hidden in a digression. The same parenthetical stacks two more IOUs ("honest cargo," change having "a normal form") onto a paragraph whose job — settling one counterexample — was already done; it balloons past its work and steals the closing paragraph's thunder.
  *Suggested:* Cut the parenthetical to its first sentence (the Part II teaser) and move the definition to where the term first bears weight: "…because its `read` was *transparent* — legible to machines that did not produce it. Documents were declarative, addressable, linkable, indexable."

- **ISSUE** · sentence-tangle · [legibility]
  > The body may be empty — the empty body is a body, the way an empty set is a set — and on *safe* requests — RFC 9110's word for the methods that only ask, never change — it almost always is.
  Two nested em-dash asides split the sentence's spine; by the time the reader reaches "it almost always is," they must reach back across both interruptions to recover "is [empty]." There is also a small type slip: "safe" is glossed as RFC 9110's word for *methods* while the noun it modifies here is *requests*.
  *Suggested:* The body may be empty; the empty body is a body, the way an empty set is a set. *Safe* requests — RFC 9110's word for the methods that only ask, never change — almost always leave it empty. The unsafe methods are about to show what it is for.

- **FLAG** · orientation tax · [legibility]
  > The model keeps only what the response body carries.
  "The model" has no antecedent inside this chapter — Definition 1.1 is still two paragraphs away. A reader arriving fresh from Chapter 0 probably binds it to the read/write pair defined there; a reader who paused between chapters hits a referent with nothing to attach to. If Chapter 0's model is meant, say so; if Definition 1.1 is meant, point forward.
  *Suggested:* Of the response, the definition below keeps only what the body carries.

- **FLAG** · inverted introduction (use-then-christen) · [legibility]
  > `Doc` lives on the parsed side of that line: the document, the thing a user agent displays. Call that domain `Doc`
  The name is used, glossed by apposition, and then christened a sentence later — the cold reader does a double-take at "Call that domain `Doc`" (we just did). Describe first, then name once.
  *Suggested:* On the parsed side of that line lives the document — the thing a user agent displays. Call that domain `Doc`, and leave its internals alone for now.

- **FLAG** · sentence-tangle (garden-path apposition) · [legibility]
  > the applications built on them, the live dashboard, the collaborative editor, can look like a third kind of thing
  The comma-bounded appositives read momentarily as a continuing list ("them, the live dashboard, the collaborative editor…") before the verb arrives and forces a re-parse. Em-dashes fence the examples off cleanly — and the author already favors them.
  *Suggested:* the applications built on them — the live dashboard, the collaborative editor — can look like a third kind of thing

- **FLAG** · paragraph-granularity · [legibility]
  > Every web application you have ever used, from a static homepage to the heaviest single-page monster
  The post-definition paragraph does two jobs in one wall of six dense sentences: mapping the methods onto the two functions (plus the body's ownership and opacity), then pivoting to the universality claim. The universality claim is the chapter's biggest swing and deserves its own stage.
  *Suggested:* Start a new paragraph at "Every web application you have ever used…" — no wording change needed.

### Ch 2. Analysis and Synthesis

**Verdict.** You can ship this, but a pass would make it stronger — and it deserves the pass, because the bones are excellent. The chapter does exactly what a method chapter must: it earns the method before naming it, states the stakes in checkable form, and ends by starting the experiment. Logical flow is the best thing about it — each paragraph does one job and hands off cleanly to the next, the pedigree paragraph (Pappus, Newton, chemists, clean-room) is the most discretionary passage and still earns its keep, and every cross-reference is glossed inline so a reader never has to follow a link to keep reading. That discipline is rare; keep it. What needs the pass: one load-bearing term ("application space") arrives ungloss ed and is then asked to carry the sufficiency claim, and the thesis sentence of the chapter — the one the reader is invited to hold the book to — is the most tangled sentence in it. The flags are mostly single-word or single-clause: a verb that means the opposite thing to an American ear, a compressed aside that promises a check without saying what it is, and a mismatch-pledge repeated four times on one page. Fix the two issues, glance at the flags, and this chapter reads cold without a stumble. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human. If the human is not available, stop here and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not yours to relax.

- **ISSUE** · Undefined term on first use · [legibility]
  > If a working application space can be constructed from the derived parts alone
  "Application space" appears here cold, recurs twice more ("a full application space, nothing missing"; "the application space rebuilt"), and is the very thing the sufficiency claim quantifies over — yet the reader is never told what a space of applications is, versus simply an application. Since "nothing missing" is measured against this term, its vagueness softens the chapter's central promise. It is not in the glossary of earlier-defined terms, so this chapter owes it a clause. If the term gets a proper definition later in the book, an inline gloss here still pays for itself — correct my guess at its meaning as needed.
  *Suggested:* If a working application space — the full range of applications Definition 1.1 admits, not one rebuilt demo — can be constructed from the derived parts alone, then the skeleton was in the pages, not in the procedure.

- **ISSUE** · sentence-tangle · [legibility]
  > Stated in advance, then, so the reader can hold the book to it: the analysis, if it succeeds, will show that every web application has a certain form
  This is the chapter's thesis sentence and its most tangled: a subjectless herald, a colon, a conditional aside, an em-dash restatement, and then a second colon before "necessity." Two colons doing different jobs in one sentence forces a re-read at exactly the moment the reader should be nodding. The parallel ": necessity" / ": sufficiency" rhyme is worth keeping — the fix is to demote the herald colon so each sentence has only one.
  *Suggested:* Stated in advance, then, so the reader can hold the book to it — the analysis, if it succeeds, will show that every web application has a certain form, that under Definition 1.1 there is nothing else `read` and `State` could be: necessity.

- **FLAG** · ambiguous-verb · [legibility]
  > tables every mismatch
  To an American ear "to table" means to shelve — the exact opposite of the intended meaning. The earlier "go on the table, itemized, not under it" mostly inoculates the body text, but the caption's bare "the gap is not hidden but tabled" has no such anchor nearby. A US reader skimming the figure could take away "mismatches postponed." Same fix in both places. This must be surfaced to the human for a conscious decision.
  *Suggested:* scores everything the industry runs instead, and tabulates every mismatch — and in the caption: the gap is not hidden but tabulated.

- **FLAG** · compressed-aside · [legibility]
  > each removal checkable against deployed reality
  The aside promises that every removal can be checked, but not what the check is or what "deployed reality" supplies. A cold reader can guess (real pages exist that differ in exactly the removed respect while saying the same thing) but the clause makes them do the guessing at speed. My revision assumes that guess is right — if the check is something else, that is itself worth knowing, because the current wording hides it. This must be surfaced to the human for a conscious decision.
  *Suggested:* each removal witnessed by deployed pages that already vary in exactly that way

- **FLAG** · plain-words · [legibility]
  > The opening pages have already stated where the derivation ends
  "Where the derivation ends" is an indirect way to say "the result," and the sentence's job — forestalling "you already told us the answer, so what is left to prove?" — has to be reverse-engineered from it. The in-order reader does know the opening pages, so the antecedent is fair; it is the phrasing that costs a beat. This must be surfaced to the human for a conscious decision.
  *Suggested:* The opening pages have already named the result; stating a result is not deriving it, and the derivation is the part a reader can check.

- **FLAG** · Duplication · [legibility]
  > the mismatches go on the table, itemized, not under it — that is Chapter 9's only job
  The mismatch pledge appears four times within one page: paragraph 5 (the pledge), paragraph 6 ("tables every mismatch"), the diagram node ("mismatches, tabled · Chapter 9 / Part IV"), and the caption ("Chapter 9's one job"). The reader pays each time. The cluster also wobbles on attribution: the body says mismatches are Chapter 9's ONLY job, while the diagram assigns them to "Chapter 9 / Part IV" with no explanation of the pairing — a cold reader cannot place Chapter 9 relative to Part IV. Keep the pledge (P5) and the map (P6); trim or align the figure. This must be surfaced to the human for a conscious decision.
  *Suggested:* Change the diagram node to "mismatches, tabled · Chapter 9" (or explain the Chapter 9 / Part IV pairing in the caption), and let paragraph 6 carry Part IV's scoring role.

- **FLAG** · Concept-before-dependency · [legibility]
  > the two easy ways fail on inspection. Survey fails.
  "The two easy ways" are dispatched before they are named — the reader hits the telegraphic "Survey fails." and must retro-fit the taxonomy {survey, preference} from the explanations that follow. It resolves within two sentences, but naming the pair up front removes the stumble at no cost to the rhythm. This must be surfaced to the human for a conscious decision.
  *Suggested:* Now the omission has to be filled, and the two easy ways — survey and preference — fail on inspection. Survey fails.

### Ch 3. Stripping the Page

**Verdict.** You can ship this, but give it one more pass — it's close to clean and the flags are cheap. This chapter is the book's parallel structure working as designed: three strips with the same gait — imperative lead-in, factorization, one-line justification from the deployed web, exhibit — and an honest close that disclaims exactly what two examples can't prove ("This chapter makes you feel it; the next one proves it" is a lovely, load-bearing sentence). The × notation lands without ceremony because Chapter 1 already taught it on Req, so I uncapped the pen expecting a notation finding and got to put it back — the blind read clearing a suspicion is the system working. What remains: one issue — the 'Order, evicted' paragraph is the chapter's lone dense stretch and its final sentence stacks three clauses where two sentences would hit harder — and six flags: a load-bearing observation living in an italic caption, a slang collision ('chrome'), a passive opener in an imperative chapter, an article page that walks on unannounced, a specimen that drifts out from under the reader mid-sentence ('your dashboard,' months versus the exhibit's hours), and a closing that says 'one skeleton' four figures in a row. Fix the issue, decide each flag consciously, and this ships happily. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human. If the human is not available, stop here and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not yours to relax.

- **ISSUE** · sentence-tangle · [legibility]
  > the front page's judgment does not travel with them, because prominence that lives only in an arrangement is lost on every consumer who receives the content without it
  The closing sentence of the 'Order, evicted' paragraph stacks three clauses, and the third restates the second as a generalization — the reader pays for the same point twice inside one 44-word sentence, at the exact moment the chapter's one dense argument needs to land. Splitting it lets the final clause become the law-like generalization it wants to be.
  *Suggested:* The deployed web already shows what happens otherwise: the same articles travel by feed, and the front page's judgment does not travel with them. Prominence that lives only in an arrangement is lost on every consumer who receives the content without it.

- **FLAG** · caption-ballooning · [legibility]
  > the time-series curves were never in the document at all — they are pixels on a canvas
  The strip-1 caption is the chapter's longest and the only one that advances an argument rather than describing its figure — the canvas asymmetry is a genuinely load-bearing observation, filed for Part IV, living in italics where caption-skimmers will miss it. If Part IV re-establishes the point from scratch, this works as a teaser and is fine; if Part IV leans on the reader having caught it here, promote it to body prose. I can't see Part IV, so this is the human's call.

- **FLAG** · plain-words · [legibility]
  > stripping it from the dashboard leaves mostly chrome
  'Chrome' is UI slang, and it appears in a paragraph about turning off CSS in a browser — some readers will collide with the browser of the same name before recovering the intended sense. If your readership is web developers this is standard usage; flagging in case it isn't, since a plainer phrase costs one word.
  *Suggested:* stripping it from the dashboard leaves mostly the application's shell

- **FLAG** · plain-words · [legibility]
  > One catch should be conceded before the next strip, because a careful reader has already spotted it
  Passive voice ('should be conceded') in a chapter whose every other lead-in is a crisp imperative — 'Strip the style,' 'Turn off CSS' — and the 'because' clause makes the reader do a small double-take about who is conceding what to whom. The imperative register the chapter already owns fixes both.
  *Suggested:* Concede one catch before the next strip — a careful reader has already spotted it: the front page's order *means* something.

- **FLAG** · orientation-tax · [legibility]
  > The article page and the front page draw from the same pool
  The definite article presumes a known article page, but this chapter's specimens on the table are a front page and a dashboard — an article page walks on unannounced. If Chapter 2 introduced one, this reads fine for the sequential reader; flagging in case it didn't. A one-word indefinite fix removes the dependency either way.
  *Suggested:* An article's own page and the front page draw from the same pool

- **FLAG** · specimen-drift · [legibility]
  > your dashboard shows this month, but last month exists
  Two trips in one clause. The chapter's dashboard has been 'the wind-farm dashboard' on the table since sentence one; 'your dashboard' swaps specimens mid-argument. And the exhibit two lines down shows `?from=now-6h` versus `?from=now-7d` — hours and days — so a reader connecting prose to figure hunts for a month toggle that isn't there. If the pivot to the reader's own dashboard is deliberate (echoing 'every device you own'), keep 'your' but align the time windows with the exhibit.
  *Suggested:* the dashboard shows the last six hours, but last week exists

- **FLAG** · duplication · [legibility]
  > Two maximally different sites, three strips, one skeleton — the exhibits above, as a schematic.
  The conclusion renders four times in a row with no prose between: the nested expression, the nested-frames spot image, the mermaid schematic, and the interactive exhibit. Each has a distinct medium and the captions self-justify, but the print reader still crosses three consecutive figures saying 'one skeleton' — and the caption echoes 'maximally different' from the sentence two paragraphs up. Worth a conscious decision on whether both the spot art and the schematic earn their place; the phrase echo, at least, is a cheap fix.
  *Suggested:* Two sites, three strips, one skeleton — the exhibits above, as a schematic.

### Ch 4. The Factorization

**Verdict.** I uncapped the pen expecting more work than I found. This chapter carries a reader who arrived through Chapters 0–3: the opening paragraph is an honest roadmap, the sections are proportioned to the work they do (Properness gets the most floor and deserves it; the Fielding section is announced up front, anchored by the epigraph, and pays off in the table and Prop 4.5; nothing here fails to earn its place), and the prose is mostly plain, active, and confident — "Nothing in this chapter has mentioned time. HTTP has." is exactly the register this book should live in. What keeps me from a clean ship-it is one wobble at the worst possible address: S4's scope is stated three different ways across the caption, the definition, and the dashboard example, inside what the text itself calls the book's central definition — the exacting reader this book is courting will count, get three answers, and dock trust precisely where the chapter asks for it. Fix that, gloss the analysis theorem's hypothesis, hand the reader the Chapter 3-to-4 dictionary, and take a pass over the flags — then this ships happily. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — every flag included — surface this review to the human. If the human is not available, stop here and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not yours to relax.

- **ISSUE** · scope-drift · [legibility]
  > every rounded node is a web resource
  S4's scope is stated three different ways. The pipeline caption says EVERY rounded node is a web resource — which includes Req and State, neither of which is an intermediate value. Definition 4.3's S4 says "every intermediate value" — of which the pipeline has two (Data, Tree). The dashboard paragraph then says "each of those three intermediate values" — three, countable as title/value/card, or as the three factors' outputs including the final Doc, which is not intermediate. This wobble sits inside what the text itself calls "the book's central definition," and the careful reader this book is courting will count, get three different answers, and lose trust exactly where the chapter asks for it.
  *Suggested:* Pick one scope — the outputs of the three factors reads most natural — and use it in all three places. Caption: "…and under S4, the fourth properness condition defined below, each factor's output is a web resource: it has a URI, and a GET on that URI returns it." Dashboard: "each factor's output — the data, the card, the themed page — has its own URL and dereferences."

- **ISSUE** · Undefined term on first use · [legibility]
  > arrange : Data → Tree
  The pipeline promises "Chapter 3's strips, read as function types," but leaves the reader to build the dictionary alone. Chapter 3's factors were Style, Arrangement, Selection; two of the renames are guessable (select, arrange), but `present` silently replaces Style, and `Tree` is a brand-new type — Chapter 3's words were Content and Arrangement. Every other type in (4.1) is established vocabulary; the two new names land in the chapter's spine with no bridge.
  *Suggested:* One bridging sentence after (4.1): "`select`, `arrange`, and `present` are Chapter 3's Selection, Arrangement, and Style, read as functions; `Tree` is the arranged content — Chapter 3's Content, before style touches it."

- **ISSUE** · unglossed-hypothesis · [legibility]
  > depends on `State` only through some finite part
  The chapter's headline theorem arrives carrying a hypothesis with no word about what it excludes. The reader cannot tell whether finiteness is a technicality every real site satisfies or a genuine restriction that carves some reads out of the guarantee — and the section is otherwise so lean that there is nowhere else to find out. One clause would carry it.
  *Suggested:* Add a clause after the statement, e.g.: "The hypothesis is mild: a page renders finitely many facts, so every site you have ever loaded qualifies." (If that gloss is false, the reader needs to be told which reads fall outside — either way, say it.)

- **FLAG** · dangling-callback · [legibility]
  > Hold that until Proposition 4.4
  The reader is told to hold the AWWW thought until Proposition 4.4 — then arrives at 4.4 and finds no mention of AWWW at all. The promissory note is never redeemed where it points; the payoff ("the norms were theorems all along") lives only back in the Properness section, before the theorem exists.
  *Suggested:* One clause in the paragraph after Prop 4.4, e.g.: "And the note held from AWWW comes due: the separation §4.3 could only recommend, every `read` provably affords."

- **FLAG** · Undefined term on first use · [legibility]
  > In the fused factorization of Prop. 4.2
  "Fused" appears here for the first time, wearing a definite article as if it were an established name. Prop 4.2's construction was described as stuffing the application into `arrange` but never christened. The reader can bridge it, but the diagram then leans on the same name ("fused — one timeline"), so the term is doing recurring work without ever being coined.
  *Suggested:* Name it at birth, in Prop 4.2's proof: "…and stuff the entire application into `arrange` — call this the fused factorization. ∎"

- **FLAG** · Concept-before-dependency · [legibility]
  > `I` — one name space; R3, S4
  The collapsed four-clauses table is a deliberate forward-reference package, and the summary line honestly says so ("return here after the pipeline closes") — that mitigates. But the rows are uneven: some carry cross-reference links (Definition 1.1, B-2d), while "R3," "the delta normal form," and "the five moves" are naked names that give a first-pass reader nothing to hold, not even a pointer to where they will be defined.
  *Suggested:* Give every borrowed name the same treatment the linked rows already get — an xref or a two-word gloss: "R3 (Ch 5's naming requirement)", "the five moves (Ch 7)", or plain links.

- **FLAG** · Orientation tax · [legibility]
  > The dashboard makes it concrete
  The definite article assumes a dashboard the reader already knows. If it is the running example from Chapter 3's two stripped pages, this is fine and the article is earned; flagging in case it isn't, because this chapter never introduces one, and the example returns later ("On the dashboard, that independence is one line of daily practice"). Cheap insurance either way.
  *Suggested:* "Chapter 3's dashboard makes it concrete:" — one word buys the orientation.

- **FLAG** · fuzzy-back-reference · [legibility]
  > The corollary is from Fielding's list a few paragraphs back
  The list is not a few paragraphs back — it is two sections back, in Properness. And "the corollary" makes the reader work out which of the four list items is meant before the paragraph's own content repairs it. A busy reader hunts; a precise pointer costs nothing.
  *Suggested:* "The first item on Fielding's list — caching per stage rather than per page — now holds its mechanism."

- **FLAG** · grammar-trip · [legibility]
  > called the result illustration
  Reads as a typo for "called the result an illustration." It is the very first sentence of the chapter; the reader should not have to re-parse before the roadmap starts.
  *Suggested:* "stripped two pages by hand and called the result an illustration"

- **FLAG** · paragraph-overload · [legibility]
  > And one thing that looks like movement is not
  The four-timelines paragraph carries two subjects: the four legitimate movements, then the pivot to what movement is not (navigation travels in the request). Both halves are well written, but at ~150 words with a clean seam between them, each idea deserves its own paragraph — the closing aphorism ("the four timelines belong to the application; navigation belongs to the request") lands harder with room around it.
  *Suggested:* Break the paragraph before "And one thing that looks like movement is not:".

- **FLAG** · layout-dependent-prose · [legibility]
  > Above: each component advances alone
  The caption's "Above"/"Below" bets on the two mermaid subgraphs stacking vertically. In a left-to-right flowchart with no edges between subgraphs, some renderers place them side by side, and the caption would then point the wrong way. Layout-neutral words are safe under any renderer.
  *Suggested:* "Prop. 4.5, drawn. In the proper factorization, each component advances alone, and caches invalidate per component. In the fused one, every change, of whatever kind, is a change to the whole — and invalidates the whole."

### Ch 5. What State Must Be

**Verdict.** This chapter is the real thing — a dense derivation that mostly earns its density, with lines I'd frame ("The exhibit was the theorem, photographed early" is exactly what this book's voice should do). I read it cold as chapter five of twenty-two, leaning only on the glossary, and it carried me: no exposure findings, nothing block-level. But I uncapped the pen twice for real. First, the symbols occasionally outrun their bindings — V lands in a numbered equation with no introduction, 𝒫 is glossed only by implication — and in a book running formal apparatus that is a defect, not pedantry. Second, the structure hides the chapter's two biggest beats: the Transposition Thesis, which the text itself calls the one bridge in the derivation, sits unheaded inside R2's sprawl while R1 and R3 get a paragraph each, and the graph-versus-tree cliffhanger that hands off to Chapter 6 fires mid-section — then the chapter keeps talking for two more paragraphs. Address the issues, take a conscious pass through the flags, and this ships proudly; send me the revision if you restructure and I'll gladly cold-read it again. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human, every finding including the flags: flag is a triage rank, never permission to skip. If the human is not available, stop here and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not the caller's to relax.

- **ISSUE** · granularity-imbalance · [legibility]
  > the passage from "no coordinator" to these merge laws is the one bridge in the derivation
  The chapter's most load-bearing epistemic move — the Transposition Thesis, its scope caveat, and its corroborating table — lives as unheaded paragraphs inside the R2 entry, which balloons to well over half the chapter while R1 and R3 are single paragraphs. A reader scanning the spine (The three requirements / The smallest fact / The uniqueness theorem / Selection and the delta) never sees the one bridge, and R2 stops reading as one requirement among three.
  *Suggested:* Keep R2 itself to the laws and (5.1), then promote the scope paragraph and the Transposition Thesis (with its table) into their own headed section between "The three requirements" and "The smallest fact" — e.g. "## The one bridge" — so the derivation's declared weak point is visible in the chapter's structure. Placement details are the author's call; the point is that the bridge deserves a spine entry.

- **ISSUE** · misplaced-closer · [legibility]
  > Somewhere between them, the shape must change. That is Chapter 6.
  This is a chapter-exit line — it announces the successor and closes the argument — but it fires mid-section, after which the chapter returns to the join-by-hand example and a second exhibit. The handoff deflates: the reader is told to leave, then handed more material.
  *Suggested:* Reorder the closing section: algebra list, then the join-by-hand example and its exhibit, then the delta, and end the chapter on the graph-versus-tree pivot — "Somewhere between them, the shape must change. That is Chapter 6." as the final line.

- **ISSUE** · undefined-term-on-first-use · [legibility]
  > Fact  = I × I × (I ∪ V)
  V appears in a numbered equation with no binding anywhere in the chapter, and it is not in the glossary of earlier-defined terms. The preceding sentence says "atomic literal," so the reader can guess — but a formal apparatus that makes readers guess at a symbol in a display equation undercuts the precision the chapter is selling.
  *Suggested:* The value position is either a reference or an atomic literal — write `V` for the literals:

- **ISSUE** · ambiguous-phrasing · [legibility]
  > the union absorbs everything except new facts
  The caption's punchline can be read exactly backwards — "absorbs everything except new facts" parses as "new facts are excluded from the union," the opposite of the intent (edits vanish; only new facts register). A caption meant to make (5.1) unbreakable should itself be unbreakable.
  *Suggested:* Edit either side, shuffle, duplicate — every edit vanishes into the union except a genuinely new fact, and (5.1) is something you fail to break rather than something you believe.

- **ISSUE** · concept-before-dependency · [legibility]
  > `State` is now a graph — facts whose references point anywhere
  The identification of a set of triples with a graph is asserted in passing. The dash-gloss conveys "non-hierarchical," but the reader is never shown the one-beat mapping (entities as nodes, each fact an edge) that makes the graph-versus-tree contrast — the setup for Chapter 6 — actually land.
  *Suggested:* `State` is now a graph — each fact an edge from entity to value, and references point anywhere — while every document Chapter 3 stripped was a tree.

- **ISSUE** · sentence-tangle · [legibility]
  > what an unjoined union already holds, and what a join takes once someone demands it
  Two compressed noun phrases stacked in one clause; "what a join takes" reads as a riddle on first pass (takes what — time? inputs? agreement?). This sentence is the payoff of the scope paragraph and deserves plain words.
  *Suggested:* A model does control two things: what an unjoined union already holds, and what a join requires once someone demands one.

- **FLAG** · epistemic-whiplash · [legibility]
  > Composition without coordination has laws
  R2 presents the four laws as forced — the parentheticals ("checking compatibility is coordinating") read as proofs. Two paragraphs later the same step is demoted to "the one bridge" and a named Thesis the author merely claims. The reader must retroactively downgrade what they took as established. One signal in R2 that the argument's status is coming would prevent the whiplash; the restructure in the first issue may fix this for free.
  *Suggested:* Composition without coordination has laws — and the step that grants them is flagged in the open below.

- **FLAG** · undefined-term-on-first-use · [legibility]
  > State = 𝒫(Fact)
  The powerset symbol 𝒫 is not in the glossary and gets no introduction; the next sentence's "set of atomic facts" rescues most readers by implication. If Chapters 1–4 introduced 𝒫 with the rest of the apparatus, this is fine; flagging in case they didn't.
  *Suggested:* In the sentence after the equation: State is a *set of atomic facts* — that is all `𝒫(Fact)` says — and two states, from any two parties, anywhere, compose by union.

- **FLAG** · ambiguous-phrasing · [legibility]
  > with duplicates free (tracking copies is coordinating)
  "Duplicates free" can be read as "free of duplicates" rather than "duplicates cost nothing." The parenthetical mostly disambiguates, but the law itself should not need its parenthetical to be parsed.
  *Suggested:* with duplicates costing nothing (tracking copies is coordinating)

- **FLAG** · undefined-term-on-first-use · [legibility]
  > RFC 9111 carries the middle two
  RFC 9111 arrives bare; the glossary shows only RFC 9110 defined earlier. A reader five chapters into a web-architecture book may well know it, and it sits inside a supplementary details block — but a two-word gloss is cheap insurance.
  *Suggested:* RFC 9111 — HTTP caching — carries the middle two

- **FLAG** · orientation-tax · [legibility]
  > The dashboard's strip-2 block
  This presumes the reader recalls Chapter 3's exhibit by its internal stage label. If Ch 3 prominently names its strips "strip-1/strip-2," fine; flagging in case the label lives only in the exhibit's chrome, where a print reader or a reader two chapters on will not retrieve it.
  *Suggested:* The dashboard's second strip — arrangement gone, facts laid bare —

- **FLAG** · sentence-tangle · [legibility]
  > two facts, exactly — writing `⟨·⟩` for a URI, abbreviated to its fragment
  One sentence does three jobs — recalls the exhibit, counts the facts, and introduces the ⟨·⟩ notation — via a dangling "writing" modifier with no subject. Splitting it costs nothing.
  *Suggested:* The dashboard's strip-2 block held one entity and two attributes: two facts, exactly. Writing `⟨·⟩` for a URI abbreviated to its fragment: `(⟨…#panel-14⟩, title, "Current Power")` and `(⟨…#panel-14⟩, value, "15.5 kW")`.

- **FLAG** · duplication · [legibility]
  > is hired-on, or fired-on, or born-on
  Prop 5.2's summary line and the argument body repeat the employee42 example verbatim; a reader who expands the details reads the same clause twice back-to-back. Collapsed, the duplication is invisible — expanded, they pay for it both times.
  *Suggested:* In the body, trim to: A pair `(entity, value)` asserts a relation but cannot say *which*; the meaning lives outside the fact, which R2 forbids — the summary already carries the example.

- **FLAG** · plain-words · [legibility]
  > That this is the only native way sounds like rhetoric
  "Native" appears here for the first time as a term of art standing in for "satisfying R1–R3 / drawn from the web itself," and it is not in the glossary. If earlier chapters established "native," fine; flagging in case the word is coasting on connotation.
  *Suggested:* That (5.3) is the only shape the web itself permits sounds like rhetoric

- **FLAG** · notation-shift · [legibility]
  > ?turbine  feeds  ?panel
  The join example silently switches notation: triples go bare (no parens, no commas, no ⟨·⟩ URI marker) and `?`-prefixed variables appear uncommented, two sections after the chapter insisted the entity and attribute positions are URIs. A sharp reader stops to ask whether `title` and `feeds` are still in I. One clause buys the switch.
  *Suggested:* Merged, the pattern — triples written bare now, URIs still abbreviated, `?` marking a variable —

- **FLAG** · uneven-granularity · [legibility]
  > match a fact pattern with variables; join matches; union alternatives; project variables out
  Of the four algebra operations, three get grounding — pattern and join get pointed-at pages, and match/join/project get the by-hand example — but "union alternatives" gets neither a page nor a turn. The claim "each operation is forced by a page you can point at" is left one example short.
  *Suggested:* (any master–detail page is a join; any search page is a pattern; any page merging two lists — "events from either calendar" — is a union)

- **FLAG** · orientation-tax · [legibility]
  > The operator holds `panel-14 title "Current Power"`; the contractor holds `turbine-3 feeds panel-14`.
  "The operator" and "the contractor" arrive with definite articles as if previously introduced, and "one turbine" appears earlier in the scope paragraph the same way. If Chapter 3's dashboard established this cast, this reads as a welcome callback; flagging in case the characters exist only in the author's head.
  *Suggested:* If the cast is new here: A join, by hand. One party — the dashboard's operator — holds `panel-14 title "Current Power"`; another — the turbine contractor — holds `turbine-3 feeds panel-14`.

### Ch 6. From Graph to Tree

**Verdict.** This is a strong, tight chapter and I enjoyed reading it — the lede lands in the first three sentences, the Bush/Nelson sidebar earns its keep, and the canon/t split is well staged: problem, display, prose, figure, proof, exhibit, closer. Length and granularity are consistent throughout; nothing balloons, nothing starves. But it deserves one more pass before it ships. The pivot sentence — "serialization is a relation, not a function" — momentarily contradicts the arrange : Data → Tree the reader carries from Chapter 4 and resolves the contradiction only by implication; "the reveal chapter" reads like production scaffolding leaking onto the page; and the chapter quietly swaps vocabularies twice, with facts becoming "atoms" in the proof and the crossing becoming "the seam" in the closing line. Every one of these is a sentence-level fix — none is structural. Address the issues, weigh the flags, and this ships clean. These findings — the flags included — are for the human to judge with the full context I was denied; do not make the call for them, and do not quietly set any finding aside. If the human is not available, stop and wait; content review is a compliance gate, and relaxing its friction is the human's call, not the caller's.

- **ISSUE** · concept-before-dependency · [legibility]
  > But the crossing is not yet well-defined: serialization is a *relation*, not a function
  Two trips in the chapter's pivot sentence. First, "serialization" silently substitutes for "the crossing" — a new word standing in for the established one. Second, Chapter 4 typed arrange as a function (Data → Tree), so a reader who remembers that hits "a relation, not a function" as an apparent contradiction; the reconciliation (any fixed arrange is a function, but nothing yet locates the choice among the many possible trees) arrives only implicitly, via the display that follows.
  *Suggested:* But the crossing is not yet well-defined: graph-to-tree serialization is a *relation*, not a function — one graph, many trees (orderings, nestings, groupings) — and Chapter 4 typed `arrange` without saying where the choice among them lives. The fix is canonicalization:

- **ISSUE** · undefined term on first use · [legibility]
  > the reveal chapter will name the spec
  "The reveal chapter" resolves to nothing on the page and nothing in the glossary of terms defined so far. A cold reader cannot tell whether it means Chapter 9 (just named in the same sentence), some other chapter, or a structural device of the book. If earlier chapters established "the reveal" as a reader-facing device, keep it — flagging because nothing anchors it here, and as written it reads like the book's production scaffolding leaking into the prose.
  *Suggested:* has a standardized deterministic answer as of 2024 (a canonical labeling; a later chapter names the spec)

- **ISSUE** · plain-words · [legibility]
  > `canon` is the graph in bare tree form
  A category slip in the sentence that introduces the chapter's key object: `canon` is a function (the display just typed it Data → Tree), but this sentence says the function *is* a form. In a book this precise about types, the metonymy costs a wobble exactly where the reader is building their picture of canon.
  *Suggested:* `canon`'s output is the graph in bare tree form — one block per entity, sorted, no nesting, no sugar.

- **ISSUE** · undefined term on first use · [legibility]
  > order the atoms lexicographically by their three positions
  "Atom" arrives as an unannounced synonym for the fact/triple vocabulary Chapter 5 established, and then does real work — three times in the proof ("the atoms", "the atom set", "defined by the atoms alone") and once in the exhibit caption ("Change an atom and it moves..."). The reader can guess atom = fact, but a proof is the last place to make them guess.
  *Suggested:* Either use "facts" throughout ("order the facts lexicographically by their three positions... the fact set is recoverable..."; caption: "Change a fact and it moves exactly as far as the fact requires"), or tie the synonym once on first use: "order the atoms — the facts of (5.3) — lexicographically".

- **ISSUE** · concept-before-dependency · [legibility]
  > the sole locus of graph→tree structural choice
  The display types canon (Data → Tree) but leaves t untyped — the reader must either infer ⟦t⟧ : Tree → Tree from the composition or wait for the mermaid diagram near the chapter's end to learn t's domain and codomain. A typed display with one untyped participant is a speed bump in exactly the formalism this book teaches readers to lean on.
  *Suggested:* arrange = ⟦t⟧ ∘ canon
canon : Data → Tree      deterministic, lossless, structure-free
⟦t⟧  : Tree → Tree      t: the sole locus of graph→tree structural choice

- **FLAG** · sentence-tangle · [legibility]
  > flagged where it stands and left unnumbered
  A compressed clause the reader has to unpack twice — what is flagged, and where does it stand? The intended meaning (the thesis is marked as a thesis at its point of statement and gets no proposition number) survives, but only after a re-read, and this is the sentence disclaiming the chapter's boldest claim.
  *Suggested:* That is a thesis, not a theorem — like the Transposition Thesis, it is flagged as such and left unnumbered; Part IV returns to it.

- **FLAG** · sentence-tangle · [legibility]
  > Display order included: `canon`'s sort is deliberately meaningless, and an order that carries meaning
  Two ideas and an allusive interruption ("Chapter 3's lead story" — fine if the reader recalls Chapter 3's opening example, opaque if not) in one long sentence, sitting at the end of a paragraph that already does three other jobs (describe canon's output, relocate structural decisions, then the unnamed-entities case). Split the sentence, and consider a paragraph break at "Display order" so each paragraph keeps one subject.
  *Suggested:* Display order included: `canon`'s sort is deliberately meaningless. An order that carries meaning — <a class="xref" href="ch03-stripping-the-page.html">Chapter 3</a>'s lead story — arrives as data and is honored by `t`, never smuggled in the sequence of blocks.

- **FLAG** · sentence-tangle · [legibility]
  > The historically hard case — facts about *unnamed* entities, an extension
  One sentence carrying two em-dash interruptions plus a two-clause parenthetical, with two forward deferrals (Chapter 9 and "the reveal chapter") packed inside. The reader ends it holding four pending obligations. Two plain sentences carry the same freight.
  *Suggested:* The historically hard case is facts about *unnamed* entities — an extension <a class="xref" href="ch09-the-mismatches.html">Chapter 9</a> motivates and prices. As of 2024 it has a standardized deterministic answer: a canonical labeling; a later chapter names the spec.

- **FLAG** · orientation tax · [legibility]
  > And you have already seen `canon`'s output. Strip 2 *is* it
  "Strip 2" and "the dashboard" are backreferences to an earlier chapter's exhibit, named without a cross-reference link — while every other backreference in this chapter gets one. If the earlier exhibit was literally labeled "Strip 2," a sequential reader will likely recall it and this is fine; flagging in case it was never given that name on the page, and suggesting the tie-back get an xref like its siblings.

- **FLAG** · plain-words · [legibility]
  > The seam is not a research problem
  The chapter's closing line swaps "the crossing" — its own word, used five times — for "the seam," a synonym that appears nowhere else in the chapter and is not in the glossary. The reader resolves it in a beat, but the last line is prime real estate and shouldn't cost even a beat. If "seam" is established vocabulary from an earlier chapter, keep it; otherwise use the chapter's own term.
  *Suggested:* The crossing is not a research problem; <a class="xref" href="ch09-the-mismatches.html">Chapter 9</a> brings the evidence.

- **FLAG** · duplication · [legibility]
  > `canon` chooses nothing, `t` chooses everything — and `t` lives in a language, where S2 can hold.
  The mermaid diagram and its caption largely re-render the code block from earlier in this short chapter, and the caption's close repeats the body's "move into the declarative term `t`, where S2 can hold" nearly verbatim — the reader pays for the point twice. The diagram's one genuine addition is ⟦t⟧'s domain and codomain; if the code block gains that type line (see the issue above), consider whether the diagram still earns its place, or trim its caption to what only it shows.
  *Suggested:* *The graph→tree crossing: a relation (one graph, many trees) becomes a function followed by a term.*

### Ch 7. The Write Side

**Verdict.** This is the good kind of chapter to review — short, confident, and shaped so a stranger always knows which proposition they are standing in. The opening paragraph does honest work, the five moves land cleanly, and "The read pipeline ends at a human; the write side begins at one" is the sentence the chapter deserves. Nothing blocks, and nothing personal bled through. But the chapter's own posture — every claim exact, every arrow numbered — invites an audit it does not quite pass: the find/change schematic omits the state it matches against, the selection algebra's first operation has quietly changed names since Chapter 5, the five-inputs count is charged to the reader twice in one section, Prop 7.2 conjures a plural "each set" out of a singular bound pattern, and the closing caption overclaims by exactly one human arrow. All six issues are one-line fixes; the flags are worth one conscious pass, chiefly whether the latency argument deserves its own heading and whether the construction/validation aside tells the reader where it is going. Fix the issues and this ships happily — it is close to the chapter it wants to be. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface every one, flags included; a flag is a triage rank, never permission to skip. If the human is not available, stop here and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not the caller's to relax.

- **ISSUE** · logic-gap · [legibility]
  > mark each set "remove" or "add" and you are holding (7.1)'s delta
  The chain runs "a bound pattern is a set of facts" (singular) straight into "mark each set" (plural). The reader must invent the missing step — that a form binds more than one pattern, or that the pair (D⁻, D⁺) needs two marked sets — inside the statement of a proposition, where precision matters most. The mechanics of how one submission yields both a removal and an addition are never shown, and the running example, which would show it perfectly, sits unused two sections away.
  *Suggested:* Submission binds the fields; each bound pattern is a set of facts; mark every set "remove" or "add" and the marked pair is (7.1)'s delta. On the running example: the edit form arrives holding "15.5 kW"; the user types "16.1"; the stale binding, marked remove, is D⁻, and the fresh one, marked add, is D⁺.

- **ISSUE** · misleading-schematic · [legibility]
  > pattern + variables  →  bindings
  Per Chapter 5, a fact pattern already contains its variables, and bindings come from matching the pattern against facts. So the schematic's first line lists an input that is part of the pattern and omits the input that actually produces bindings — the state. A careful reader who checks the symmetry the section claims finds the "find" line does not type-check against the book's own definitions. The follow-on phrase "running its pattern matcher with the arguments swapped" inherits the confusion.
  *Suggested:* pattern + state     →  bindings                          (find)
pattern + bindings  →  (D⁻, D⁺)                          (change)

- **ISSUE** · vocabulary-drift · [legibility]
  > selection algebra — pattern, join, union, project — is the write side's algebra too
  Chapter 5's selection algebra was defined as match, join, union, project. Here its first operation has silently become "pattern" — which is not an operation but the operand, and which collides with "fact pattern" used correctly elsewhere in this same chapter. A reader who remembers Chapter 5's operator list stops to reconcile the two. If Chapter 5 itself says "match," restore it; if it doesn't, one of the two chapters needs to move.
  *Suggested:* selection algebra — match, join, union, project — is the write side's algebra too

- **ISSUE** · sentence-tangle · [legibility]
  > is the industry's clearest case of this — a whole runtime spent recovering, approximately, what (7.1) gives exactly by subtraction
  The full sentence carries three em-dash segments: a nested parenthetical defining the diffing engine, then the main clause, then an appositive — with a bracketed chapter reference wedged in the middle. The reader loses the subject ("The virtual DOM's diffing engine") before reaching the verb ("is"). One idea per sentence; this one holds three.
  *Suggested:* Trees are the instructive case: two trees have no canonical difference, so deciding what "changed" is a heuristic. The industry's clearest specimen is the virtual DOM's diffing engine (Chapter 11): client-side frameworks re-compare an in-memory copy of the page on every render — a whole runtime spent recovering, approximately, what (7.1) gives exactly by subtraction.

- **ISSUE** · duplication · [legibility]
  > The document has exactly five inputs — the request, the state, and the three factor terms
  This enumeration appears verbatim eight lines earlier ("a value with exactly five inputs: the request r, the state S(τ), and the three factor terms"). The reader pays for the count twice in one section, and the repetition dilutes the punch of "There is no sixth move because there is no sixth input," which is the sentence doing the real work.
  *Suggested:* There is no sixth move because there is no sixth input — Prop. 4.5 counted them.

- **ISSUE** · overclaim · [legibility]
  > Every arrow is a numbered proposition.
  The figure it captions contains the arrow Doc → reader (and arguably reader → form), which no numbered proposition covers — the human is not a proposition. The book's whole posture invites the reader to audit exactly this kind of claim, and the audit fails on the chapter's final, most prominent line. Three words fix it.
  *Suggested:* Every arrow but the human's is a numbered proposition.

- **FLAG** · duplication · [legibility]
  > factors as a pair of fact-sets — a *delta*
  The delta was defined in Chapter 5, yet Prop 7.1 italicizes it like a fresh coinage; the acknowledgment ("Chapter 5 ended by deriving the delta") arrives twenty lines later, at the section's end. A reader who remembers Chapter 5 spends the whole section wondering whether this is the same delta or a new one. Move the hand-off to the front: what is new here is not the delta but its status as a unique normal form.
  *Suggested:* **Prop. 7.1 (Delta normal form).** Every state change factors as Chapter 5's delta — a pair of fact-sets — and the factorization is unique:

- **FLAG** · unkept-promise · [legibility]
  > Proof — extensionality, then minimality.
  The details block's summary promises two steps; the body argues extensionality ("by set extensionality") and then merely asserts minimality and uniqueness. A reader who opened the proof for the minimality argument leaves empty-handed. Either give minimality its one line or trim the summary so it promises only what the body delivers.

- **FLAG** · granularity · [legibility]
  > One honest concession remains, and it too should be met at full strength: latency.
  The latency argument is a second, separable answer living inside "The five moves" — the section carries both the enumeration and the deployment argument, ballooning relative to its neighbors, and a scanner reading the section headings cannot find the chapter's answer to latency at all. It has its own thesis (S2 as a deployment strategy) and would carry its own heading comfortably.
  *Suggested:* Promote the paragraph to its own section in the chapter's heading style, e.g. "## The latency concession".

- **FLAG** · granularity · [legibility]
  > The pipeline is now complete in both directions, and it closes:
  The closing section is one line of prose, a figure, and a caption — the chapter's arc ends inside a caption. The opening paragraph promised to take the objection at full strength and answer it; no sentence ever returns to say the answer landed. One closing line after the figure would balance the section and close the loop the intro opened.
  *Suggested:* Change, the objection said, is where declarative architectures fail. Change is the arrow that closes the diagram.

- **FLAG** · duplication · [legibility]
  > Compare, once more, the industry's arrangement
  This is the chapter's second industry catalog, and it shares half its items with the first ("migration frameworks, state managers" in section one; "a migration DSL, a client-side state manager" here). The compensating-industry motif is legitimate, but repeating the same specimens dulls both tallies. Consider letting each list own its items — e.g. trim the first to "object-relational mappers, undo stacks, reconciliation engines" and leave migration and state management to this one.

- **FLAG** · relevancy · [legibility]
  > A schema drafted to do both jobs at once will do both badly.
  The construction/validation paragraph is a design verdict that nothing else in this chapter uses — it names no culprit and no later section cashes it in, so on a cold read it is an aside interrupting the derivation. If a later chapter needs this distinction, one forward reference would tell the reader why it sits here; if none does, it may not earn its place.

- **FLAG** · plain-words · [legibility]
  > an experiment the web has already scored once
  Two phrases in the latency paragraph trade clarity for wit: "scored" (graded? achieved?) forces a double-take before the Chapter 12 reference rescues it, and "the architecture has not changed by one proposition" reads as a strange unit of measurement before it resolves to "no proposition needs revising." Both are recoverable, but each costs a re-read in the chapter's densest paragraph.
  *Suggested:* "an experiment the web has already run once, and graded (Chapter 12)" — and earlier: "the architecture has not changed: the same terms, the same factors, a different machine — not one proposition revised."

- **FLAG** · plain-words · [legibility]
  > which Chapter 4 already ruled out of the application
  "Ruled out of the application" can misread as "declared illegitimate" when the intended sense is "classified as an argument, not a component." If this echoes Chapter 4's own phrasing it may stand; flagging in case it does not.
  *Suggested:* move 1 is the request — an argument to the application, not a component of it (Chapter 4).

- **FLAG** · plain-words · [legibility]
  > Chapter 8 will name what the industry standardized it as
  The sentence ends in a stacked "what … it as" construction that takes two passes to parse, and the "it" must be traced back across a semicolon to the delta. A minor stumble, but it is the section's exit line.
  *Suggested:* Chapter 5 ended by deriving the delta; it is what fills the request's Body from Chapter 1, and Chapter 8 will give the industry's name for it.

- **FLAG** · orientation-tax · [legibility]
  > On the running example: the wind gusts, and the panel's `value` moves.
  The panel example and the ⟨…#panel-14⟩ URI-elision notation are leaned on without reintroduction. If Chapters 1–6 established both — and "the running example" strongly suggests they did — this is fine; flagging in case an in-order reader still benefits from one clause of re-anchoring (which chapter's panel, and that ⟨…⟩ elides a URI).

### Ch 8. It Already Exists

**Verdict.** This chapter is the reveal, and the reveal lands. The table-first structure is exactly right, "Read the dates first" is a superb instruction, and "Nothing is recomputed. Everything is renamed." is a two-sentence caption most authors would trade a chapter for. You can ship this after a pass, but not before: at ~776 words the chapter runs at maximum compression, and every defect I found lives where the compression is highest — which, unluckily, is the payoff prose. The central equation names a function (`sparql`) the statement never introduces; the theorem billed as "the book's proof" is the only formal statement here without a proof pointer, and it stakes "the entire space" in bold before an italic rider takes a bite out of the claim; and the closing reveal paragraph garden-paths a cold reader twice ("had arrived where it points", "grounds in demand"). All of it is sentence-level — nothing structural, nothing that touches the argument, and the granularity is otherwise well judged for a short capstone. Fix the issues, take a conscious look at each flag, and this chapter does its job with a snap. These findings are for the human to judge, with the full context I was denied. Do not make the call on any of them in my caller's seat, and do not quietly set one aside — every finding here, flags included, must be surfaced to the human for a conscious decision. If the human is not available, stop and wait; content review is a compliance gate, and relaxing its friction is the human's call alone.

- **ISSUE** · Undefined term on first use · [legibility]
  > φ(select(p, S)) = ⟦sparql(p)⟧(φ(S))
  Prop 8.2's prose says φ translates "selection terms to SPARQL terms," then its equation switches to an unintroduced function `sparql(p)`. A careful reader stops in the chapter's central equation to work out whether `sparql` is φ restricted to selection terms or something new.
  *Suggested:* Either write `φ(select(p, S)) = ⟦φ(p)⟧(φ(S))`, or introduce the name inside the statement: "— facts to RDF triples, states to graphs, selection terms to SPARQL terms (write `sparql(p)` for that last translation) —".

- **ISSUE** · missing-proof-pointer · [legibility]
  > This meeting point is the book's proof.
  Prop 8.2 cites Appendix B.7 for its full proof; Theorem 8.3 — the larger claim, billed as the book's proof — cites B.8 only for the caveat's genericity condition. A reader this book has trained to expect proof pointers asks where the completeness claims (SPARQL for selections, XSLT-over-canon for arrangements) are established, and finds nothing.
  *Suggested:* If the completeness claims have a proof, cite it in the theorem the way Prop. 8.2 cites B.7; if the theorem holds by construction, say so explicitly ("Proof: by construction, ...") so the reader knows not to go looking.

- **ISSUE** · claim-then-retraction · [legibility]
  > The stack realizes the entire space of proper factorizations
  The bold statement stakes "the entire space," then an italic rider inside the same theorem immediately shrinks the class ("excludes smuggling"). The reader gets whiplash and cannot tell whether the caveat is formal content of the theorem or commentary riding inside it.
  *Suggested:* Fold the condition into the claim and move the commentary out: "The stack realizes the entire space of proper factorizations whose `arrange` is generic — invariant under URI renaming, singling out no particular URI (Appendix B.8): SPARQL is complete for the selections, XSLT-over-canon for the arrangements, CSS for presentation, and S4 holds by construction." Then let the data-drivenness / URI-opacity gloss follow as prose outside the theorem.

- **ISSUE** · sentence-tangle · [legibility]
  > the people who standardized them in 1999 had arrived where it points
  "It" has no working antecedent — the nearest candidate, "a position," doesn't point at anything, and the thing that does point (the derivation) lives two sentences back. The reveal's payoff sentence forces a re-read.
  *Suggested:* they occupy a position that was *forced*, and the people who standardized them in 1999 had already arrived there.

- **ISSUE** · garden-path · [legibility]
  > a reading Chapter 17 grounds in demand
  "In demand" parses first as the idiom (popular, sought-after), not as "grounds ... in demand[-side evidence]," and the reduced relative ("a reading [that] Chapter 17 grounds") compounds it. The paragraph's final clause misparses on first read.
  *Suggested:* the machines were twenty years out — Chapter 17 makes the demand-side case.

- **FLAG** · Undefined term on first use · [legibility]
  > SPARQL algebra, §18 (Basic Graph Pattern, Join, Union, Project)
  RDF and Turtle get identifying glosses; SPARQL, XSLT, RDFC-1.0, and Graph Store Protocol never do. The reveal only lands where the revealed name is recognized — a reader who dismissed the semantic web decades ago may know RDF but not the rest. If your reader knows the stack this is fine; flagging in case they don't.
  *Suggested:* One identifying clause each at first appearance — e.g. "SPARQL (the standard's query language)", "XSLT (the standard's tree-transformation language)" — and expand RDFC-1.0 and the Graph Store Protocol the same way.

- **FLAG** · plain-words · [legibility]
  > ibid.
  Scholarly Latin in a table cell: the reader who doesn't know it stalls, and the reader who does still has to look back up a row. The dates it stands for are barely longer than the abbreviation.
  *Suggested:* Repeat the dates: "1999 / RDF 1.1 2014".

- **FLAG** · sentence-tangle · [legibility]
  > turns CSS off by name, the act every reader knows it by
  The clause is a small riddle — "the act" is the turning-off, "it" is CSS, and "knows it by" arrives out of order. Solvable, but this sentence is already carrying the sole exception to the chapter's headline claim.
  *Suggested:* Chapter 3 turns CSS off by name — switching it off being the act by which every reader knows it.

- **FLAG** · relevancy · [legibility]
  > Contrast the specs that define no formal semantics
  The reader is told to contrast, but against nothing nameable — no spec is identified, so the jab lands as mood rather than evidence. In an aside whose job is to show why the check is possible here, the sentence doesn't earn its clause.
  *Suggested:* Name the target — "Contrast [spec], which shipped no formal semantics and reaped a decade of implementer disagreement" — or cut the sentence.

- **FLAG** · metaphor-before-definition · [legibility]
  > the completeness class for `arrange` excludes smuggling
  "Smuggling" arrives one sentence before the reader learns what is being smuggled (knowledge of particular URIs). The next sentence rescues it, but the trip is avoidable by naming the contraband up front.
  *Suggested:* the completeness class for `arrange` excludes transforms that smuggle in knowledge of particular URIs.

- **FLAG** · sentence-tangle · [legibility]
  > stated as mathematics, and AWWW §2.5's URI opacity made exact
  The second half of the parallel ("and ... made exact") reads at first as a new clause missing its verb; the reader must back up to recover the "X stated-as, Y made-exact" structure.
  *Suggested:* That is the practitioners' data-drivenness stated as mathematics — and AWWW §2.5's URI opacity made exact.

- **FLAG** · Orientation tax · [legibility]
  > three RFC-level definitions and three requirements
  "Three requirements" resolves instantly (R1–R3); "three RFC-level definitions" asks the reader to pick exactly three from Chapter 1's larger cast. If an earlier chapter already tallied precisely three, this is fine; flagging in case the count is new here.
  *Suggested:* Name them in apposition: "three RFC-level definitions — [name], [name], [name] — and three requirements, R1–R3."

- **FLAG** · Duplication · [legibility]
  > the mapping is a homomorphism, not a pun
  Prop 8.2 already closed on the same beat ("a *homomorphism*, not a coincidence of shapes"); the diagram caption replays it within one screen, and the reader pays for the joke twice.
  *Suggested:* Keep whichever version you prefer and end the other flat — e.g. let the caption close at "The square commutes."

### Ch 9. The Mismatches

**Verdict.** This chapter does exactly what it promises — drags its own mismatches into the light — and mostly does it with real craft: the lede is immediate, the four-part structure is clean, the disclosure in mismatch four is the kind of honesty that buys a reader's trust, and "Ours are; now we audit everyone else's" is a closer other chapters should envy. But a chapter whose entire thesis is "we count our mismatches honestly" cannot afford loose arithmetic in its own ledger, and I found some: the intro promises two predictions and the body labels one; the caption flips the surplus direction the body argued and calls a never-standardized bridge a maintenance failure; "the isomorphism" names a thing Chapter 8 called a homomorphism. None of this is structural — every fix is a sentence — but each one hands ammunition to precisely the suspicious reader this chapter exists to disarm. Fix the five issues, give the flags a conscious pass, and this ships proudly. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review, flags included, to the human. If the human is not available, stop here and wait; content review is a compliance gate, and relaxing its friction is the human's call, not yours.

- **ISSUE** · stale-counter · [legibility]
  > Each is located, measured, and — twice — turned into a prediction.
  The body labels exactly one prediction. Mismatch two announces "Here the mismatch becomes a prediction"; the table scores one row as "a prediction the standards later honored"; the caption counts one. A reader who takes the intro at its word hunts for the second prediction and comes back empty-handed. The same fossil appears later: "this derivation's first missing requirement" promises a second missing requirement that never arrives. Both read as survivors of a cut passage. "Measured" also overpromises — mismatches three and four are located and narrated, but nothing in them is measured.
  *Suggested:* Each is located and measured, and one is turned into a prediction the standard later honored. (Or: label the intended second prediction explicitly in the body, and keep the count. Either way, drop "first" from "this derivation's first missing requirement" or deliver the second.)

- **ISSUE** · summary-contradicts-body · [legibility]
  > the model's surplus met by the standard — a motivated extension and a prediction later honored; the two platform-side are maintenance failures
  The caption's accounting contradicts the body twice. First, blank nodes are the STANDARD's surplus over the model — "nothing in Chapter 5 forced them" — so "the model's surplus" flips the direction the body argued (and mismatch two isn't surplus at all; it's the model's missing requirement). Second, "the two platform-side are maintenance failures" overwrites the table one row up, which calls mismatch four "a bridge specified, never standardized" — a standards gap the body bills to "the W3C Recommendation stack," not lapsed upkeep. The table's "belongs to" column has the same wobble: the intro promised seams BETWEEN layers, then the table assigns each mismatch to a single layer. In a chapter whose thesis is honest bookkeeping, the summary exhibits must not miscount.
  *Suggested:* Recaption along the body's own lines — e.g.: "The two model-side mismatches (Props. 9.1–9.2) sit at the model–standard seam: a surplus the standard permits and the model never forced, and a requirement the model missed and the standard later honored. The two at the standard–platform seam are an abandonment and a bridge never standardized — neither a research problem." Consider renaming the table column from "belongs to" to the seam it names (model ↔ standard / standard ↔ platform).

- **ISSUE** · term-drift · [legibility]
  > The isomorphism is not exact.
  The book's established name for the correspondence is "the homomorphism" (Prop. 8.2); "the isomorphism," definite article, points at a term the book never minted. Worse, an inexact isomorphism is a contradiction in terms — an isomorphism is exact by definition — and the mathematically-attentive reader this chapter is explicitly courting will trip on it in sentence four, right where the chapter is claiming rigor about its own fit.
  *Suggested:* The fit is not exact. (Or, using the book's own machinery: "Prop. 8.2's homomorphism is not an isomorphism.")

- **ISSUE** · required-not-supplementary reference · [legibility]
  > Over ground facts, ⊕ = ∪ satisfies B-2a–d on the nose.
  Prop. 9.1's entire content is "satisfies four conditions filed in Appendix B" — the reader must leave the chapter to learn what was just claimed. The proof names two of the four (idempotence, atomicity), which is a tease, not a gloss. The merge symbol ⊕ also lands unannounced: Chapter 5's union law says merge is set union, but nothing before this line mints the symbol. If Chapter 5's prose walked through the B-2 labels by name, downgrade me — but they are not in the glossary, so I tripped.
  *Suggested:* Over ground facts, merge is plain set union and the merge laws hold on the nose: ⊕ = ∪ satisfies B-2a–d exactly. (Gloss ⊕ at first use, and name the laws inline — the proposition should assert something legible without opening Appendix B.)

- **ISSUE** · buried lede · [legibility]
  > Generalized, that is the book's practical thesis
  The book's practical thesis — its own words — surfaces mid-paragraph, six sentences deep in a single-block section, sandwiched between a maintenance narrative and a vendor rebuttal. A skimming reader, the kind who reads for theses, will miss it entirely. The same block also says "not a research problem" twice in three sentences, so the paragraph pays for its biggest claim with repetition instead of prominence.
  *Suggested:* Break the paragraph before "Generalized," and let the thesis sentence open its own paragraph: "Generalized, that is the book's practical thesis: what separates the modern web from the derived one is abandoned technology — a maintenance failure, not a research problem." Then let that single "not a research problem" carry the point and trim the earlier one.

- **FLAG** · sentence-tangle · [legibility]
  > Forms run backwards want submissions that denote deltas
  Garden path: "run" reads as the main verb until "want" arrives and forces a re-parse. It is the first sentence of its section, so the reader starts mismatch four by reading twice. Two commas cue Chapter 7's inverse-transform reading immediately.
  *Suggested:* Forms, run backwards, want submissions that denote deltas (Prop. 7.2) — and the W3C Recommendation stack stops one step short:

- **FLAG** · duplication · [legibility]
  > Order is the recurring case: state it as facts and it merges like facts; fold it into shape and it costs what shape costs.
  The sentence immediately before it already made this point ("State the order as data instead … and it merges like any other fact") — the reader pays twice in consecutive sentences, at the end of a paragraph already carrying six moves in one block.
  *Suggested:* Merge the two: "Order is the recurring case: state it as facts — a rank per member, Chapter 3's lead story — and it merges like facts; fold it into shape and it costs what shape costs." Consider a paragraph break at "The deployed stack's own list idiom" to give the block air.

- **FLAG** · duplication · [legibility]
  > None touches the derivation: no proposition of Part II is weakened by anything in this inventory.
  The caption directly above already closes with "None weakens a proposition of Part II" — the same sentence twice on one screen. More broadly, the inventory states each mismatch's tagline three times: table row, diagram node, caption. Table-plus-diagram may be deliberate belt-and-braces for skimmers — that is the human's call — but the adjacent verbatim repeat is pure double-billing.
  *Suggested:* Cut the caption's final sentence and let the closing paragraph carry it. Then decide consciously whether the table and the diagram both earn their place, or whether the diagram's seam topology alone can do the work.

- **FLAG** · word-collision · [legibility]
  > Part IV applies the same standard to everyone else's models.
  "Standard" has meant the deployed standard (RDF et al.) twice in this same paragraph; on first parse "the same standard" reads as the RDF standard being applied to rivals, not the same scrutiny. One word of a different color fixes it.
  *Suggested:* Part IV holds everyone else's models to the same test.

- **FLAG** · undefined term on first use · [legibility]
  > (`su`, `pu`, `ou`, `ol`, …)
  A pattern across the chapter: specialist names land without the two-word gloss that would make them free. The RDF/POST keys are opaque unless the reader guesses subject/predicate/object/literal. Same pattern: "simple entailment," "named graphs, RDF datasets, TriG," "RDF 1.2's triple term," "template rules," and the proof-internal "standardize them apart" and "coNP-complete." If your reader lives in RDF, all of these are free; flagging in case they don't. The repair is uniform: a short appositive at each first use, nothing more.
  *Suggested:* For the anchor case: "…which flattens the triple positions into form keys — `su`, `pu`, `ou`, `ol`, …: subject, predicate, object, literal — so that a plain HTML form, with no script, submits a graph." Apply the same appositive treatment to the other names listed, where a gloss is cheap.

- **FLAG** · sentence-tangle · [legibility]
  > either also present as a plain atom — in which case it is asserted outright and the attribution is defeated — or absent
  Four em-dashes, two of them nesting an aside inside the first arm of an either/or; the reader must bracket-match to find "or absent." It sits inside a collapsed proof, so the stakes are lower — but this is the sentence doing the proof's key work.
  *Suggested:* The described fact is then either also present as a plain atom, in which case it is asserted outright and the attribution defeated; or absent, in which case it is attributed but never stated — quoted rather than asserted.

- **FLAG** · parenthetical-overload · [legibility]
  > a convenience, and honest as one — but syntax is not a property
  The closing parenthetical of mismatch two makes three moves in one breath — name the rival device, dismiss it, justify the dismissal via a forward reference to Part IV's audit table — across three em-dashes. It defends against an expert objection at a comprehension cost to everyone else.
  *Suggested:* (RDF 1.2's annotation syntax — the triple term — only re-serializes what reification already expressed. A convenience, and honest as one; but syntax is not a property, and Part IV's audit table scores properties.)

- **FLAG** · withheld-referent · [legibility]
  > the transformation language was standardized in 1999 and shipped in every browser
  Chapter 8 already performed the reveal, so the reader owns the name XSLT — yet the section talks around it ("the transformation language … froze it … remove it") for three sentences before dropping "XSLT 3.0" mid-paragraph as if previously introduced. The coyness has no payoff; naming it at first mention is plainer.
  *Suggested:* The deployed stack had both, and the transformation language — XSLT — was standardized in 1999 and shipped in every browser.

- **FLAG** · orientation tax · [legibility]
  > two more between the standard and the platform that ships it
  "The platform" carries the chapter's second seam but goes unglossed until the diagram at the very end whispers "what ships (the browser)" — the chapter's own admission that the gloss is needed. The intro is where it belongs.
  *Suggested:* and two more between the standard and the platform — the browser — that ships it.

### Ch 10. Brackets

**Verdict.** You can ship this, but a pass would make it noticeably stronger. The chapter is a pleasure to read cold: the opening table is a genuinely great lede, the sarcastic caption earns its keep, and "Lateral, by the numbers" is a closer most chapters would envy. No blocks, and nothing smells of session bleed. But the issues cluster around a single weakness: the chapter repeatedly asks the reader to do bookkeeping it should do itself — figure out which format owns which ✗, run the diff between two tables separated by two hundred words, supply the unstated premise that frameworks are JSON's transformation layer, and know what B-2d says without a gloss. Each fix is a clause, not a rewrite. The flags are smaller — mostly headings and terms that lean on conventions I could not verify from inside this one chapter. All findings below, flags included, are for the human to judge with the full context I was denied; none may be quietly set aside by any caller between me and them.

- **ISSUE** · sentence-tangle · [legibility]
  > a change of syntax presented as a change of substance — and the instrument is the seven properties
  The colon promises the claim to check, but the final "and" clause is not part of the claim — it names the methodology. Spliced together, the reader briefly parses the instrument as something being claimed.
  *Suggested:* The claim to check: XML→JSON was lateral — a change of syntax presented as a change of substance. The instrument: the seven properties.

- **ISSUE** · ambiguous-referent · [legibility]
  > apply to the structure, so the scores transfer
  The blanket "the scores transfer" is contradicted a few paragraphs later: XML scores R3 "~" while JSON scores "✗". Worse, each audit paragraph ends in a bare ✗ with no owner — the R3 paragraph discusses XML's partial credit at length and then stamps a ✗ that turns out to be JSON's alone, which the reader only learns when the column tables arrive.
  *Suggested:* Scope the claim — "Chapter 5's requirements apply to the structure, so the scores transfer wherever a requirement sees only the tree; R3 is the exception, and the formats part ways there" — and give the R3 verdict an owner, e.g. end that paragraph "✗ for the destination format; the origin salvages a ~."

- **ISSUE** · required-not-supplementary reference · [legibility]
  > which rejects B-2d
  B.1 gets an inline gloss ("the proof behind the union law") but B-2d gets nothing, so this clause is opaque unless the reader opens Appendix B mid-sentence. The sentence's payoff survives, but the reader pays a toll on the way.
  *Suggested:* Give B-2d the same courtesy B.1 received — a short appositive stating its one-line condition: "which rejects B-2d (⟨the condition it names⟩)". I cannot supply the content from here; the author can, in five words.

- **ISSUE** · garden-path · [legibility]
  > AWWW §4.4 had named link identification, Web-wide linking, and hypertext links as good practices
  "had named link identification" first parses as a noun pile — "named-link identification" — and the list structure only emerges two items later. The reader backtracks to re-parse.
  *Suggested:* AWWW §4.4 named three good practices in 2004 — link identification, Web-wide linking, hypertext links — and all three fail in the format the industry migrated *to*.

- **ISSUE** · missing-link · [legibility]
  > most JavaScript frameworks of 2010 have already been retired
  Frameworks appear from nowhere — the JSON column of the tooling table never mentions them. The implied premise (frameworks are the JSON world's de facto transformation layer, filling the table's "—" cell) is exactly the right point, but the chapter leaves the reader to supply it.
  *Suggested:* And longevity ran the other way: the JSON column's empty transformation cell is filled by whatever framework is current, and most JavaScript frameworks of 2010 have already been retired; XSLT, frozen at its 1999 revision, still runs in every browser as of this writing.

- **ISSUE** · unshown-evidence · [legibility]
  > the cells that moved, moved down
  Verifying the chapter's central verdict requires the reader to diff two single-column tables separated by two hundred words of prose. The claim is true (R3 ~→✗, S2 ✓→✗, S3 ✓→~) but the chapter makes the reader run the diff at the exact moment it should be landing the punch.
  *Suggested:* the cells that moved — R3, S2, S3 — moved down. Lateral, by the numbers.

- **FLAG** · orientation-tax · [legibility]
  > **Column: XML stack.**
  "Column" of what? The heading presumes a master table whose columns the audit chapters contribute — a table this chapter never shows. If an earlier audit chapter established the device, fine; flagging in case this is its first appearance, where a stranger reads "Column:" as a typo for "Table:".

- **FLAG** · orientation-tax · [legibility]
  > **The S-properties of the deployment style.**
  No style has been named when the heading lands — JSON is a format, and REST arrives only in the next sentence. Additionally, if REST-the-name was not introduced alongside Fielding earlier in the book, this is its first naked use; if it was, ignore that half.
  *Suggested:* Name the style in the heading: "The S-properties of the deployment style — REST as practiced."

- **FLAG** · plain-words · [legibility]
  > There is a term worth repurposing for activity of this shape
  "Repurposing" implies the term already exists with another job, which sends the reader hunting for the original; and "activity" does double duty in the same sentence ("activity of this shape… the kind of activity that…").
  *Suggested:* There is a term for activity of this shape: **lateral churn** — motion that looks like innovation but isn't.

- **FLAG** · term-collision · [legibility]
  > The migration's tooling delta was negative
  The book has trained its reader that "delta" means a pair of fact-sets (D⁻, D⁺); here it is a signed scalar. A reader fluent in the book's own vocabulary stumbles on the collision — precisely the reader this chapter is written for.
  *Suggested:* If the collision is not deliberate: "The tooling gap, itemized." / "The migration's tooling gap was negative for two decades and remains negative today."

- **FLAG** · starved-section · [legibility]
  > ~ — vocabulary separated by schema; arrangement and data still fuse
  XML's four S-scores are asserted in table cells alone, while JSON's S-scores get a full prose paragraph. The asymmetry can read as the XML side being waved through. If the audit's established convention is that cells carry the argument, this is fine — flagging the imbalance for a conscious call.

- **FLAG** · undefined-term-on-first-use · [legibility]
  > the instrument is the seven properties
  The reader knows R1–R3 and S1–S4 individually, but may never have seen them counted together as "the seven properties." If the collective was minted in an earlier chapter, this is fine; flagging in case the reader must do the arithmetic mid-sentence.

### Ch 11. The Single-Page Application

**Verdict.** This chapter is the audit voice working at close to full power — terse scores, a real counterargument given a fair hearing, a table that closes the loop, and at ~836 words almost nothing that fails to earn its place. I read it as its eleventh-chapter stranger, glossary in hand, and I was carried: every formal term it leans on is one the book has already paid for, and the corollary lands because the scores above it did the work. What keeps it from shipping as-is is seam-level, not structural. The Web Components paragraph balloons to five jobs in one block and buckles mid-sentence; the Fielding lead-in writes a check the bullets never cash; the "moves no score" claim re-runs only three scores of four; "the style" collides with the book's own capital-S Style at the worst possible moment; and the R-properties get two sentences where every S got a paragraph. Address the issues, weigh the flags, and this ships proudly — the bones are excellent. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human. If the human is not available, stop here and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not yours to relax.

- **ISSUE** · paragraph-balloon · [legibility]
  > The standard standardizes the seam *around* the term, not a seam *through* it: a component boundary is not a factor boundary, and moving the component model from framework to platform moves no score
  The Web Components paragraph is one ~170-word block doing five jobs — escape hypothesis, test case, three re-scores, verdict, and the Chapter 13 teaser — while every other section in the chapter is a terse audit entry. It balloons relative to its neighbors, and this four-clause sentence is where it buckles: the reader is holding the seam metaphor, the score claim, the Chapter 1 callback, and the experiment framing all at once.
  *Suggested:* Break the paragraph at "Run the scores:" and again before "What shadow DOM does standardize", and split the quoted sentence in two: "The standard standardizes a seam *around* the term, not a seam *through* it: a component boundary is not a factor boundary. Moving the component model from framework to platform moves no score — Chapter 1 filed the framework as an implementation detail, and this is the confirming experiment."

- **ISSUE** · incomplete-enumeration · [legibility]
  > moving the component model from framework to platform moves no score
  "Run the scores" re-scores S2, S1, and S4 — and then claims no score moves. S3 is never re-run. In an audit chapter, rigor is the genre, and the careful reader notices the missing cell immediately. S3 does follow from S1 by the chapter's own earlier argument (no boundary, nothing to swap across), but the reader is left to make that inference unprompted.
  *Suggested:* Close the enumeration with one clause after the S4 re-score: "...no URI reaches it, and now no selector either (S4); and no factor boundary appeared, so substitution still means rewriting the class (S3)."

- **ISSUE** · promised-mapping-not-delivered · [legibility]
  > The consequences, each one a property from Fielding's own list:
  The lead-in promises each bullet is a named property from Fielding's list, but no bullet names one. The reader who takes the promise seriously and tries the mapping stalls — caching maps cleanly enough, but which Fielding property is hydration? The glossary shows Fielding entered in Chapter 4 via the uniform interface; even if his property list was reproduced there, the sentence assigns the reader homework it never checks.
  *Suggested:* Either name the forfeited property in each bullet ("caching degrades to bundle-level (efficiency)...", "crawling requires headless browsers (visibility)..."), or soften the promise to what the bullets actually deliver: "The consequences, each one a property Fielding's constraints were chosen to induce:"

- **ISSUE** · term-collision · [legibility]
  > the style's own architecture diagrams draw the threading as a feature
  "Style" is one of the book's own defined factors (Ch 3: Doc = Style × Content). Here "the style" means the SPA architectural style in Fielding's sense — but for a beat the sentence reads as if appearance-Style owns architecture diagrams, and the reader must back up to disambiguate. Colliding with the book's central formal vocabulary inside a scored audit entry is the worst place for this.
  *Suggested:* "the paradigm's own architecture diagrams draw the threading as a feature" — "paradigm" is already this chapter's word for the thing (it appears three times later).

- **ISSUE** · sentence-tangle · [legibility]
  > R2 and R3 fail together: component state merges by nothing — state-synchronization libraries are the compensating industry — and references are pointers, machine-local by definition.
  Three claims in one sentence with an em-dash inset wedged between two of them: R2's failure, its compensating-industry evidence, and R3's failure. "Merges by nothing" is a stumble on first read. The R-section is also starved relative to the S-scores — two sentences total where each S got its own paragraph — so the tangle has no room to breathe.
  *Suggested:* "R2 and R3 fail together. Component state has no merge law — state-synchronization libraries are the compensating industry. And references are pointers: machine-local by definition."

- **FLAG** · concept-before-dependency · [legibility]
  > The corollary adds nothing to the column
  "The column" (and "score", first seen mid-chapter as "Run the scores") arrive as established audit conventions, but the column itself only appears at the chapter's end. If Part IV's earlier chapters set up the running-table convention, this reads fine — flagging in case Chapter 10 did not, because then the forward reference puzzles until the table lands two paragraphs later.
  *Suggested:* If the convention is not already established: "The corollary adds nothing to the column below" — or move the "Column: SPA/JS" table ahead of the corollary paragraph so the summary follows the cells it summarizes.

- **FLAG** · compressed-recall · [legibility]
  > stripping style from the dashboard left chrome, because the curves were pixels on a canvas
  This leans on the reader recalling a specific Chapter 3 exhibit eight chapters back, and the recap is compressed to the point of telegraphy. "Chrome" lands unqualified — UI-shell jargon that can also momentarily misread as the browser. A reader who has forgotten the exhibit gets the gist, but pays a re-read for it.
  *Suggested:* "stripping style from the dashboard left only chrome — the frame with no facts in it — because the curves were pixels on a canvas"

- **FLAG** · citation-without-anchor · [legibility]
  > 4.5's corollary, now an operating cost
  Cited as a known result, but bare — every neighboring citation in the chapter gets an xref link, and this one doesn't. If Chapter 4 stated a corollary to Prop 4.5 (whole-bundle invalidation), the reader can resolve it; flagging in case there is nothing at the other end of the reference, and because the inconsistent citation treatment itself reads as an oversight.
  *Suggested:* Give it the same treatment as its neighbors: <a class="xref" href="ch04-the-factorization.html#prop-4-5">4.5's corollary</a> (pointed at the corollary's actual anchor if it has one).

- **FLAG** · sentence-tangle · [legibility]
  > hydration — shipping the document *and* the program that regenerates it — the S1 tax
  The bullet is a verbless noun phrase with two nested em-dash insets, while its three siblings are clausal ("caching degrades...", "crawling requires...", "reuse requires..."). The broken parallelism plus the double inset forces a second parse to find where the definition ends and the verdict begins.
  *Suggested:* "hydration — shipping the document *and* the program that regenerates it — is the S1 tax: the architecture cannot tell its document from its program, so it ships both."

- **FLAG** · plain-words · [legibility]
  > each score names the property to take it up with
  The idea is simple — dispute a specific cell, not the summary — but the phrasing is a twist: the reader must unwind what "it" is and where the trailing "with" attaches. A plainer clause delivers the same punch without the double take.
  *Suggested:* "rejecting it means rejecting a score, and each score names the property you must argue against."

- **FLAG** · term-ambiguity · [legibility]
  > Web 3.0 *means* machine-consumable state
  To a sizable slice of today's readership, "Web 3.0" collides with blockchain "web3" before the inline gloss corrects them — the definition arrives, but after the trip. If earlier chapters have not already claimed the term in its original semantic-web sense, a two-word nod would prevent the misread entirely.
  *Suggested:* "because Web 3.0 — in its original sense — *means* machine-consumable state"

### Ch 12. The Applet Returns

**Verdict.** This chapter is close, and mostly a pleasure — 399 words that know exactly what they are doing, a historical paragraph that lands its punch, and a scorecard that closes the case with a click. But the two load-bearing sentences both wobble: the thesis sentence calls total fusion "the extreme case of the factorization" — the one phrase in this book's vocabulary that momentarily means the opposite — and the least-power sentence hangs the entire historical argument on a principle it never states, then buries the citation under nested parentheses. Fix those two, decide where the black-box-binaries punch actually belongs, and everything else is a precision pass: eight small flags, each honest, none expensive. I'd ship after that pass, not before it. These findings are for the human to judge, with the full context I was denied — surface every one of them, flags included; a flag is triage priority, never permission to skip. If the human is not available, stop here and wait.

- **ISSUE** · ambiguous-referent · [legibility]
  > It is the extreme case of the factorization: everything collapsed into one term
  In this book's vocabulary "the factorization" names the proper pipeline — the good thing — so for a beat the thesis sentence reads as praise, and the reader must wait for the colon-clause to learn it means the opposite. The book already owns the exact words for this: "fusion" and "the trivial factorization."
  *Suggested:* It is the extreme case of fusion: everything collapsed into one term, zero on all of S1–S4 *by construction*.

- **ISSUE** · required-not-supplementary-reference · [legibility]
  > The principle of least power was the reason then and is the reason now
  The chapter's whole historical argument hangs on this principle, but the text never says what it holds — a reader who hasn't met it must follow the link to complete the sentence. Hedging honestly: if an earlier chapter stated the principle this dissolves, but it is not in the glossary I was given, so I trip on it here.
  *Suggested:* The principle of least power — prefer the least powerful language that will do the job — was the reason then and is the reason now.

- **ISSUE** · sentence-tangle · [legibility]
  > (the W3C Technical Architecture Group (TAG) finding [*The Rule of Least Power*](https://www.w3.org/2001/tag/doc/leastPower.html), 2006 — not, as often assumed, part of AWWW)
  Parentheses nested inside parentheses, a dash-aside, a date, and a silent name shift (principle of least *power* vs. *Rule* of Least Power) — four jobs crammed into one bracket, and the "(TAG)" expansion is never used again. Splitting the citation into its own sentence fixes this and pairs with the previous finding's revision.
  *Suggested:* The W3C Technical Architecture Group made it a formal finding in 2006: [*The Rule of Least Power*](https://www.w3.org/2001/tag/doc/leastPower.html) — a TAG finding, not, as often assumed, part of AWWW.

- **ISSUE** · one-subject-per-paragraph · [legibility]
  > Black-box binaries served by corporations invert the property that let every reader of the early web become an author by viewing source; the inversion is the business model.
  The paragraph is framed as the concession — Wasm-as-leaf is harmless — but its final sentence swings back to the indictment and opens a wholly new theme (view-source authorship, business incentive) that gets one clause and no development. The chapter's hardest punch is thrown from inside the paragraph whose job is being fair.
  *Suggested:* Break before "Black-box binaries" and let the sentence stand as its own closing paragraph, so the concession ends cleanly and the punch lands on its own feet.

- **FLAG** · ambiguous-referent · [legibility]
  > WebAssembly as a paradigm — Wasm — treats the browser
  The abbreviation lands inside the phrase "as a paradigm," so on first read "Wasm" names the paradigm rather than the format — but three paragraphs later "Wasm as a *leaf*" depends on Wasm meaning the format.
  *Suggested:* WebAssembly — Wasm — as a paradigm treats the browser as a virtual machine and the application as one compiled binary.

- **FLAG** · orientation-tax · [legibility]
  > One step separates this column from the last.
  Within this chapter, "column" goes unexplained until the table arrives some 250 words later; the sentence banks on the audit's column convention being established in Chapters 10–11. If it was, this reads fine — flagging in case it wasn't.

- **FLAG** · plain-words · [legibility]
  > The historical control has already run.
  In experimental vocabulary a control is the untreated baseline; Java applets are a prior run of the same treatment. The readers most fluent in the vocabulary this word borrows are exactly the ones who will stub a toe on it.
  *Suggested:* History has already run this experiment.

- **FLAG** · plain-words · [legibility]
  > and then it was called Java applets
  "Then" means "at that time" but first parses as sequence ("and afterwards") — a one-beat garden path placed exactly on the paragraph's punchline.
  *Suggested:* the description fits 1996 as well as it fits today; in 1996, its name was Java applets.

- **FLAG** · plain-words · [legibility]
  > ✗ — linear memory merges by nothing
  If this echoes Chapter 5's "merge is set union" (states merge by union; linear memory merges by — nothing), it's a lovely construction many readers will miss; read cold, "merges by nothing" is a riddle in a scorecard cell that should be instant.
  *Suggested:* ✗ — linear memory has no merge

- **FLAG** · silent-remapping · [legibility]
  > ✓ — computes anything
  R1 was defined as State hosting any domain; this cell justifies the check with computational universality — a different property — and the mapping from Wasm's linear memory onto State is never voiced. If earlier audit columns established the looser reading of R1, this is fine; flagging in case.
  *Suggested:* ✓ — linear memory hosts any domain

- **FLAG** · inconsistent-label · [legibility]
  > **Column: Wasm.**
  The chapter just spent a paragraph separating Wasm-as-leaf (harmless) from Wasm-as-paradigm (the defendant), and the table header keeps that distinction — but the column label drops it.
  *Suggested:* **Column: Wasm-as-paradigm.**

- **FLAG** · duplication · [legibility]
  > S1 through S4, zero by construction: the terminal state of fusion, scored.
  The closer restates paragraph 1's "zero on all of S1–S4 by construction" and paragraph 2's "The terminal state of fusion" verbatim — in a 399-word chapter the reader pays for each phrase twice, and for "by construction" a sixth time counting the table cells. It reads like a deliberate cadence, and it may well be one; flagging so the echo is a choice, not an accident.

### Ch 13. Pre-Web Paradigms

**Verdict.** This chapter is close, and most of it is a pleasure to read cold — the compression suits an audit, the "nobody builds a bridge across a gap that isn't there" line earns its figure, and every section pays off a term the book has already banked. What stops me short of "ship it" is the scorecard region: a bold "Columns:" line that reads like a leftover editorial note, a table that scores two of the five paradigms without saying why the other three sit out, and two spots where the prose and the table give different accounts of the same score. Those are issues, not blocks — address them or decide not to, then give the flags below a pass. And a reminder to my caller: every finding here, flags included, goes to the human with the context I was denied; none is yours to waive. If the human is not available, stop and wait.

- **ISSUE** · orientation tax · [legibility]
  > **Columns: Relational, OOP/ORM.**
  Two defects share this anchor. First, the bold line reads as scaffolding: it announces the table's headers, which the table then supplies one line later — in print it looks like an unfinished caption stub. Second, it silently restricts the scorecard to two of the chapter's five paradigms; a cold reader immediately asks where the Imperative and MVC columns went, and the chapter never says.
  *Suggested:* Replace the bold line with a working lead-in that also explains the selection, e.g.: "Only the two state models need full columns — Imperative fails S2 outright, and MVC's column is the union of the others:"

- **ISSUE** · sentence-tangle · [legibility]
  > each part has a derived generic replacement — the model by the shape of a fact
  The grammar forces the reader to supply an elided "is replaced": "has a replacement — the model by X" doesn't parse on first read. "Deconstructed" also dangles — it modifies MVC, not "each part." This is the chapter's payoff sentence and it stumbles at the finish.
  *Suggested:* Take it apart and each part has a derived generic replacement: the model gives way to the shape of a fact (5.3), the view to ⟦t⟧ and ⟦s⟧, the controller to `read` and `write` themselves — which HTTP had already provided.

- **ISSUE** · sentence-tangle · [legibility]
  > which drags R2 down with it, since composition then requires a schema authority
  The host sentence carries five ideas — R3 fails totally, keys are database-scoped, reference stops at the connection string, uncoordinated databases share no names, and R2 falls as a consequence — across a colon, two coordinated clauses, a which-clause, and a since-clause. The R2 consequence deserves its own sentence; buried in the tail, it's the part a skimming reader loses.
  *Suggested:* The failure is R3, and it is total: keys are database-scoped, so reference stops at the connection string, and two databases that never coordinated share no name for anything. R2 goes down with it: composition now requires a schema authority.

- **FLAG** · prose-table mismatch · [legibility]
  > ✗ — a schema authority is the model's premise
  Two places where the prose and the scorecard tell different stories about the same cell. The prose says R2 falls *because* R3 drags it down; the table grounds R2 independently, as the model's premise. And the prose calls OOP's R1 "inverted" — total-sounding — while the table scores it a partial "~". Both are reconcilable, but each costs the careful reader a beat of arbitration between two authorities.
  *Suggested:* Align each pair in whichever direction is true to the argument — e.g. the R2 cell could read "✗ — no shared names, so composition needs a schema authority," matching the prose's causal account.

- **FLAG** · duplication · [legibility]
  > keys are database-scoped
  This exact phrase appears three times in an ~800-word chapter: in the Relational prose, in the summary table's Fails column, and in the scorecard's R3 row. A scoreboard chapter may earn some repetition by design, but verbatim-times-three is the reader paying full price thrice. This is the human's call — surfacing it for a conscious decision.
  *Suggested:* Vary one instance, e.g. the summary-table cell: "R3 — reference stops at the connection string".

- **FLAG** · vagueness · [legibility]
  > Each side fails a different requirement, and the mapping inherits both.
  The requirements go unnamed — the reader must backtrack to the two prior sections to reconstruct that it's R1 on the object side and R3 on the relational. The summary table compounds it: every other Fails cell names a property; the ORM row gives a characterization instead, so the column stops being scannable exactly there.
  *Suggested:* Each side fails a different requirement — R1 on the object side, R3 on the relational — and the mapping inherits both. (And in the table: "R1 + R3, inherited".)

- **FLAG** · unanchored referent · [legibility]
  > It has spent a decade paying these costs
  Which decade, and why only one? The paradigms date to the 1960s–70s and their compensating industries are decades old, so "a decade" reads as pointing at something specific — presumably the period the next chapter covers — but the reader can't resolve it. "It" (= the industry at large) also shimmers briefly against "compensating industry," the chapter's term of art.

- **FLAG** · orientation tax · [legibility]
  > Three columns of failures
  The opening leans on "columns" and "the scores" as an established device — the audit's running scoreboard from Chapters 10–12. If those chapters literally built per-paradigm score columns, this lands perfectly; flagging in case the device there is looser and "columns" asks the reader to picture a table they were never shown.

- **FLAG** · undefined term on first use · [legibility]
  > imperative languages, and MVC all predate the web
  ORM gets a parenthetical expansion in this same sentence; MVC (and OOP, in the tables) never does. Your reader almost certainly knows MVC — flagging for parity with the treatment ORM received, and in case the book's convention is to expand every acronym once.
  *Suggested:* imperative languages, and MVC (model–view–controller) all predate the web

- **FLAG** · undefined term on first use · [legibility]
  > The impedance-mismatch literature is its own measurement.
  "Impedance mismatch" is a term of art from the object-relational world, not in the book's own glossary. A reader from that world glides past; one from outside it hits a closed door in a three-sentence section. Softly flagged — the audience for Chapter 13 likely knows it.
  *Suggested:* The object-relational impedance-mismatch literature is its own measurement.

### Ch 14. The Convergence

**Verdict.** This chapter is close, and most of it is a pleasure to read cold — 684 words that carry a reader who has done Chapters 0 through 13 without a single new-term pothole, and the best lines ("The factor returned; its resource did not") are the book at its sharpest. Two things earn the red pen before it ships. First, the architecture of the ending: "One closing observation" is followed by a third of the chapter — the spot illustration, two audit columns, and the actual final line — so the chapter ends twice and its measurement apparatus reads like trailing matter. Second, a consistency snag: the caption and closing prose say S1 and S2 are "recovered" while the chapter's own column scores them "~" and the coda calls the convergence "incomplete." Fix those two, take the sentence-level tangles in the same pass, and this ships. The flags are individually small and cheap to resolve — but every one of them goes to the human. These findings are for the author to judge with the full context I was denied; none may be quietly set aside, and if the human is not available, stop and wait. Content review is a compliance gate; whether its friction is worth relaxing is the human's call, not the caller's.

- **ISSUE** · double-ending · [legibility]
  > One closing observation:
  The 'closing observation' is followed by a third of the chapter: a decorative spot illustration, two scorecard columns, and the actual final line. The chapter ends twice, and the audit columns — the measurement apparatus a Part IV chapter lives on, and which 'Its column is below' promised — read like an appendix that missed the bus. The stranded coda 'Asymptotic, incomplete, and in the predicted order.' also forward-depends on 'the predicted order,' which only the closing paragraph explains.
  *Suggested:* Move both columns up to sit directly after the timeline caption — where 'Its column is below' points — then let the closing observation actually close, absorbing the coda: '…the properties that reward the public wait. Asymptotic, incomplete, and in the predicted order.' End on the spot illustration.

- **ISSUE** · internal-inconsistency · [legibility]
  > S1 and S2 recovered; R3 and S4 still ahead.
  The caption and the closing paragraph ('the convergence recovers S1 and S2') both say recovered, flatly — but the chapter's own SPA/JS (2026) column scores S1 and S2 as '~', and the final line calls the whole thing 'incomplete.' A reader who checks the prose against the table catches the chapter contradicting itself in miniature.
  *Suggested:* In both places, concede the tilde: caption — 'S1 and S2 recovered to tildes; R3 and S4 still ahead.' Prose — 'the convergence recovers S1 and S2 — to a tilde, not a check — but stalls before R3 and S4'.

- **ISSUE** · sentence-tangle · [legibility]
  > The evidence chapter: the JavaScript ecosystem
  The chapter's first sentence carries two colons (one opening the label, one opening the list) with a nested em-dash pair between them. The reader has to re-scan to find which colon introduces the list. The fragment-label device is fine; the double colon is the snag.
  *Suggested:* The evidence chapter. The JavaScript ecosystem — no exposure to the derivation, moved by nothing but its own costs — has spent a decade converging back toward the proper factorization, one rediscovery at a time:

- **ISSUE** · sentence-tangle · [legibility]
  > Declarative queries over a graph model returning projections
  One sentence does five jobs — what GraphQL is, what it rebuilds, what it lacks, what that predicts, and the confirmation — and opens with a garden path: 'returning projections' can attach to 'model' instead of 'queries.' The subject never gets a verb until 'it stops,' three clauses in.
  *Suggested:* Declarative queries over a graph model, returning projections — `select` and R1, rebuilt without global identifiers. So it stops at the silo wall, exactly where the missing R3 predicts: federation works within one organization and no further. Its column is below.

- **FLAG** · garden-path · [legibility]
  > The properties that reward the vendor privately return first
  'privately' sits between two verbs and briefly attaches to the wrong one — a reader can parse 'privately return first.' This is the chapter's closing aphorism; a stumble here costs the landing.
  *Suggested:* The properties that privately reward the vendor return first; the properties that reward the public wait.

- **FLAG** · term-collision · [legibility]
  > the last mile helps everyone except the vendor walking it
  Chapter 9 defined 'the write-side last mile' as a specific gap (forms to deltas). Here 'the last mile' means the remaining distance to R3 and S4 generally. A reader who remembers the defined term may bind this to the wrong referent. If the echo is deliberate resonance, keep it — flagging in case it isn't.
  *Suggested:* the last stretch helps everyone except the vendor walking it

- **FLAG** · term-drift · [legibility]
  > The S4 tax — crawlers blind, first paint late — landed exactly as predicted
  Chapter 11 billed the S4 tax as blind crawlers plus per-integrator reverse-engineering. Here its second cost has silently become 'first paint late' — which reads like the fused-rendering cost, not an addressability cost. Whether the attribution is right is not my call; the drift from the defined term's content is, and a reader who recalls Ch 11's billing will trip on it.

- **FLAG** · list-logic · [legibility]
  > The S1 tax, given its industry name
  The list is announced as rediscoveries converging back toward the proper factorization — but this bullet is the tax being named, not a step toward the factorization. It sits in the list as the very category error it diagnoses. Also, Chapter 11 already did the naming ('hydration is its name'), so 'given its industry name' can read as if the christening is news here.
  *Suggested:* **Hydration.** Not a step but the toll, rediscovered: the S1 tax — ship the document *and* the program that regenerates it, because the architecture cannot tell them apart. An industry term for a category error.

- **FLAG** · undefined term on first use · [legibility]
  > The principle of least power, rederived from the costs
  'The principle of least power' is not in the glossary of earlier-defined terms. The bullet's second half does explain the content plainly, so the damage is contained — but 'rederived' implies a first derivation the reader should recognize. If the principle was introduced in an earlier chapter, this is fine; flagging in case it wasn't.
  *Suggested:* **Islands.** The principle of least power — use the least expressive language that suffices — rederived from the costs: most of the page needs no program, so most of the page stops being one.

- **FLAG** · unclear-referent · [legibility]
  > Chapter 7's instrument
  Singular 'instrument' sits in apposition to three nouns — documents, links, and forms. If the instrument is specifically forms (Chapter 7 being the write side), the apposition points at the wrong span; if all three are meant, the number disagrees. Either way the reader pauses to arbitrate.
  *Suggested:* documents, links, and forms — the last of them Chapter 7's instrument — argued back into fashion on their original merits.

- **FLAG** · granularity · [legibility]
  > Column: SPA/JS, revised.
  The revised column shows four of the seven properties; the GraphQL column beside it shows all seven. A reader who flips back to Chapter 11's full column will wonder whether R1, R2, and S3 changed or were dropped. One line settles it.
  *Suggested:* Add a caption line under the table: '*R1, R2, S3: unchanged from Chapter 11's column.*' — assuming that is true.

- **FLAG** · duplication · [legibility]
  > The lineages here had no contact with the derivation.
  The opening sentence already made this exact point ('with no exposure to any derivation, moved by nothing but its own costs') nine lines earlier. The reader pays for the independence claim twice in a 684-word chapter. The second passage earns its place only through its final clause, which is new.
  *Suggested:* The lineages had contact with nothing but the costs — and the costs are the derivation's predictions.

### Ch 15. The Derived Stack

**Verdict.** You can ship this after one more pass, and I'd genuinely like to see the revision — the architecture is the best thing here. "The brevity is the finding" is exactly the right frame, the R2/R3/R1 ordering justifies itself, the self-audit worry is met head-on, and the closer hands off cleanly to the comparison chapter. What's dragging on the read is sentence-level compression debt: three sentences where the author's shorthand outruns the reader (a garden-path list at the R4 moment, a verbless S4 fragment, a dangling "it"), one idea — caveats travel inside citations — that the reader pays for three times in 915 words, and a scatter of small consistency slips in and around the table. Nothing blocks; nothing is exposure. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human, including every flag: a flag is low triage priority, never permission to skip. If the human is not available, stop here and wait; content review is a compliance gate, and relaxing its friction is the human's call, not the caller's.

- **ISSUE** · sentence-tangle · [legibility]
  > the web demands R4, attribution, and the column meets it as quads with merge still union
  Garden path: "demands R4, attribution, and the column" parses as a three-item list before the reader recovers, and the sentence then stacks an em-dash appositive plus three trailing comma appositives ("extension, named graphs, standardized 2014") onto the same spine. One sentence, four ideas, at the chapter's most load-bearing concession.
  *Suggested:* The fourth position adds a requirement rather than striking one: the web demands R4 — attribution — and the column meets it as quads, merge still union (Prop. 9.2). That was the derivation's first missing requirement, and the standard's own later extension honored it: named graphs, standardized 2014.

- **ISSUE** · sentence-tangle · [legibility]
  > S4 draws on both halves: the separation that requires every stage value to be addressable
  After the colon comes a verbless noun-phrase apposition ("the separation that requires…, delivered by construction because…") and the reader must reconstruct the requirement-versus-delivery structure on their own. The parallel S1/S2/S3 sentences all have working verbs; this one goes limp exactly where the two halves are supposed to meet.
  *Suggested:* S4 draws on both halves: the factorization requires every stage value to be addressable (4.3), and the stack delivers it by construction — the graph, the query result, and the document each dereference (8.3).

- **ISSUE** · plain-words · [legibility]
  > each naming the property to take it up with
  The "it" dangles — take what up with the property? The reader has to back-derive that a disputed score should be argued against the named property, not the prose. Seven words doing the work of a full clause.
  *Suggested:* the scores were assessments — argued in prose, each naming the property it rested on, so a dispute had an address.

- **ISSUE** · duplication · [legibility]
  > every cell below cites a result that carries its own caveats with it
  The caveats-ride-inside-the-citation idea is stated three times: "One honest asterisk carries over with the theorem" (para 4), "the asterisk travels inside the citation: the cell names the theorem, and the theorem states its own caveat" (para 4, same paragraph), and this closing instance in para 6. In a 915-word chapter the reader pays for one idea three times. Keep the introduction and the closing trust-argument; cut the middle restatement.
  *Suggested:* End the S-cells paragraph at "The S2 and S3 checks are checks on that class, not on arbitrary code." — deleting "— and the asterisk travels inside the citation: the cell names the theorem, and the theorem states its own caveat." Paragraph 6's closing line then carries the point once, where it earns the trust claim.

- **FLAG** · term-drift · [legibility]
  > An abandoned transformation seam and an unstandardized form bridge
  Chapter 9 named these mismatches — "the abandoned seam" and "the write-side last mile" — and this sentence re-describes them in fresh words, so the reader must re-map descriptions to the names they memorized. The paragraph does say "mismatches three and four" two sentences later, but the recovery aid arrives after the trip.
  *Suggested:* The abandoned seam and the write-side last mile — mismatches three and four — are deployment failures, and deployment failure is what this part has priced in every other column's compensating industry.

- **FLAG** · plain-words · [legibility]
  > What would make the column suspect is not its author but its omissions
  "Its author" asks the reader to unpack the conflict-of-interest concern — the book scoring its own favored technology — from two words, and columns don't obviously have authors. This is the paragraph's justification for existing; it deserves one plain beat.
  *Suggested:* What would make the column suspect is not who scored it but what the scoring left out, and Chapter 9 already filed the omissions.

- **FLAG** · misattached-modifier · [legibility]
  > One column remains — the stack Part III revealed, on the same seven rows
  "On the same seven rows" attaches ambiguously to "revealed" (revealed on the rows?) rather than to the scoring, and coming one clause after "seven columns" the doubled numeral makes the reader pause to confirm rows and columns are different dimensions.
  *Suggested:* One column remains, scored on the same seven rows: the stack Part III revealed.

- **FLAG** · metaphor-overreach · [legibility]
  > The four S-cells are the two halves of Part III's meeting point
  The copula promises a 2+2 split, but the actual mapping is S1 from analysis, S2–S3 from synthesis, S4 from both — the reader recalibrates mid-paragraph when the arithmetic doesn't land.
  *Suggested:* The four S-cells draw on the two halves of Part III's meeting point.

- **FLAG** · duplication · [legibility]
  > **Column: Derived stack.**
  The bold lead-in immediately precedes a table whose header cell also reads "Derived stack" — the reader gets the label twice in two lines.
  *Suggested:* Delete the bold lead-in; the table's header cell already names the column.

- **FLAG** · inconsistent-citation-markup · [legibility]
  > ✓ — encodes any domain; the model is forced (5.2, 5.4)
  Five of the seven table cells wrap their citations in xref links; the R1 cell's (5.2, 5.4) and the S4 cell's (4.3, 8.3) are plain text. In the published book some citations will be clickable and some dead — it reads as an authoring slip, and this chapter's whole method is the citation.
  *Suggested:* Wrap the R1 and S4 citations in the same xref links the other five cells use — (5.2, 5.4) to the Chapter 5 anchors, (4.3, 8.3) to the Chapter 4 and Chapter 8 anchors.

### Ch 16. The Properness Table

**Verdict.** You can ship this after one pass, and it will be worth the pass — the bones are excellent. The chapter knows exactly what it is (a ledger, not an argument), the row-wise reading in the penultimate paragraph is the payoff the whole part has been building toward, and "The industries are the measurement; the table is the ledger" earns its place. Every load-bearing term is defined upstream; a reader who has come through Chapters 4–15 is carried. The friction is all in the apparatus prose: paragraph 1 explains its citation scheme twice through one badly tangled sentence, the notes paragraph promises a format it doesn't deliver, and two of the summary sentences chain four claims where three sentences would let each one land. None of it is a hard stop — it's the difference between a ledger you read and a ledger you decode. Fix the issues, glance at the flags (two are fact-checks only the author can run: is the table really the home page, and does every cell really get a link?), and this chapter does its job in under a page, which is exactly as long as it should be. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human. If the human is not available, stop here and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not yours to relax.

- **ISSUE** · sentence-tangle · [legibility]
  > Each column cites the chapter that scores it — the derived column two, proved in 8 and audited in 15; rows are the seven derived properties
  Three separate ideas — column citations, row identity, and the legend — are spliced into one sentence with semicolons, and "the derived column two" elides its verb, so it momentarily reads as a label ("column two") before the reader recovers the intended "cites two." Bare numerals ("in 8," "in 15") compound the stumble.
  *Suggested:* Each column header cites the chapter that scores it; the derived column cites two — Chapter 8, which proved it, and Chapter 15, which audited it. The rows are the seven derived properties: R1–R3 on state, S1–S4 on architecture. ✓ is satisfied, ~ partial, ✗ failed.

- **ISSUE** · duplication · [legibility]
  > In the derived column a parenthetical cites the scoring result; for the others, the evidence lives in the chapter the header cites.
  Paragraph 1 explains the citation scheme twice — once in the tangled sentence before this and once here — so the reader pays for the plumbing twice before seeing the table. On a 614-word chapter, spending most of the opening paragraph on citation apparatus is ballooned granularity for the work it does.
  *Suggested:* Merge into one pass, e.g.: "Each column header cites its audit chapter — the derived column two: proved in Chapter 8, audited in Chapter 15 — and each derived-column cell adds a parenthetical citing the scoring result." Then delete this sentence.

- **ISSUE** · format-promise-mismatch · [legibility]
  > Notes, one per line where a cell needs it.
  The lead-in promises one note per line, but what follows is a single wrapped prose paragraph — the reader expects a list, gets a block, and has to re-read to find where one note ends and the next begins.
  *Suggested:* Either deliver the promise — set the three notes as an actual list, one per line — or reword the lead-in to match the paragraph: "Three cells need notes."

- **ISSUE** · sentence-tangle · [legibility]
  > SPA/JS is scored at its consolidated form; Chapter 14 revises S1 and S2 to `~` as of 2026 and leaves R3, S4 unchanged — the revision is the chapter's finding, so the column keeps its 2013 values here with the 2026 deltas in Ch 14's table.
  One sentence carries the scoring basis, the revision, the rationale for not applying it, and a pointer to another table. Also "leaves R3, S4 unchanged" accounts for only four of the seven rows, inviting the careful reader to wonder whether R1 and R2 were revised too.
  *Suggested:* SPA/JS is scored at its consolidated form. Chapter 14 revises S1 and S2 to ~ as of 2026 and leaves the rest unchanged. That revision is Chapter 14's finding, so the column keeps its 2013 values here; the 2026 deltas live in Ch 14's table.

- **ISSUE** · sentence-tangle · [legibility]
  > R2, R3, and S4 — the machine-spanning properties — fail or fall partial in every column but one, and R3 and S4 are the two that make an architecture the web rather than an app platform that happens to use browsers: <a class="xref" href="ch13-pre-web-paradigms.html">Chapter 13</a> found the highest pre-web score failing exactly the machine-spanning three
  Four claims are chained through "and"s and a colon in a single breath, and the chapter's strongest line — "the web rather than an app platform that happens to use browsers" — is buried mid-chain instead of ending a sentence.
  *Suggested:* R2, R3, and S4 — the machine-spanning properties — fail or fall partial in every column but one. R3 and S4 are the two that make an architecture the web rather than an app platform that happens to use browsers. Chapter 13 found the highest pre-web score failing exactly the machine-spanning three; Chapter 14 found the convergence stalled before R3 and S4, the two still ahead.

- **ISSUE** · plain-words · [legibility]
  > Part II proved it could not be otherwise-shaped
  "Otherwise-shaped" is an invented compound where a plain phrase does the same work; the reader trips on the coinage right at the capstone line, where friction costs the most.
  *Suggested:* One column has no failures, and Part II proved that shape was forced: that is the book, in one exhibit.

- **FLAG** · ambiguous-claim · [legibility]
  > this table is the home page
  Literal or figurative? If the online edition's landing page genuinely is this table, the line is a delight; if it is a metaphor, readers will take it literally and go looking. I cannot check which — flagging so the author confirms the fact matches the sentence.

- **FLAG** · ambiguous-claim · [legibility]
  > In the online edition every cell links to its proposition
  In the source, only the derived column's cells carry links; the other 49 cells are bare marks. If the build does not supply the remaining links, this sentence overpromises and the online reader will notice. Possibly handled by the build — flagging in case it isn't.

- **FLAG** · colliding-senses · [legibility]
  > fragment addressing — standardized fragments of the properties
  "Fragment" changes meaning mid-sentence, from URI fragments to partial pieces; a reader can parse "standardized fragments" as more URI machinery before backtracking.
  *Suggested:* XML's R3 and S4 are ~ for namespaces, xml:id, and fragment addressing — standardized slivers of the properties, largely unused (Ch 10).

- **FLAG** · orientation-tax · [legibility]
  > SPA/JS is scored at its consolidated form
  "Consolidated form" and the later "its 2013 values" both lean on Chapter 11 having pinned the SPA audit to a 2013 consolidation under that name. If Chapter 11 established both, a sequential reader is carried; flagging in case the reader must reconstruct where 2013 comes from.
  *Suggested:* SPA/JS is scored as Chapter 11 audited it, at its 2013 consolidated form; Chapter 14 revises S1 and S2 to ~ as of 2026…

### Ch 17. Building Up

**Verdict.** This is close, and most of it is genuinely good work — the dataspace definition lands fast and clean, the alignment objection is met head-on instead of waved away, and nearly every dense clause carries an anchor back to the result that earned it. A reader who has walked Chapters 0–16 will mostly be carried; the density is the earned kind. But I wouldn't ship it yet: the chapter promises "the bridge below" twice — the forms-to-deltas encoding a Chapter 9 reader is specifically waiting for — and then ends without delivering it. That one break turns the ending from a payoff into a pothole. Fix the bridge, give the Graph Store Protocol and "ontology" the one-clause introductions the book's own define-before-depend discipline demands, untangle the two garden-path sentences, and split the alignment mega-paragraph; then this reads like the capstone-adjacent chapter it wants to be. Glad you sent it — address the block and the issues, and send me the revision for a second look. The flags below are each small, and every one of them is the human's call to make with the context I was denied, not anyone else's to waive.

- **BLOCK** · concept-before-dependency · [legibility]
  > HTML forms encoding graphs (the bridge below)
  The chapter promises "the bridge below" twice — in the write row of the build log and again in the figure caption — and then ends without it. The final paragraph covers only the arrange machinery. A reader who remembers Chapter 9 naming the write-side last mile reaches the last line still waiting to learn which bridge closes it and how a form encodes a graph. A promise made twice and never kept is the one thing a cold reader cannot forgive.
  *Suggested:* Add the promised passage — name the encoding (Chapter 9's RDF/POST is the natural candidate), show one form field becoming one triple, and close the write-side last mile on the page — or, if the bridge lives in another chapter, repoint both "below"s to where it actually is.

- **ISSUE** · granularity-starvation · [legibility]
  > S(ont) is schema in the shape of (5.3).
  "Domain as data" is the one-sentence runt among the four law sections — and it sits exactly where "ontology," a component of the chapter's central definition and a term the book has not defined, owes the reader its introduction. The table gloss ("what the domain is, stated as one namespace") and this sentence are fragments; the real explanation arrives two sections later, at the top of the build log. The reader pays orientation tax at the tuple, at the table, and at this heading before the debt is finally settled.
  *Suggested:* S(ont) is schema in the shape of (5.3): the domain's classes and properties, stated as facts — state like any other, composed by the same law. The build log below shows what reads it. (The build-log opening can then shed its restatement.)

- **ISSUE** · undefined-term-on-first-use · [legibility]
  > a triplestore behind the Graph Store Protocol's direct graph identification
  The Graph Store Protocol debuts inside a table cell, already carrying its own spec jargon ("direct graph identification"), and then does load-bearing work in the write row and the figure. Chapter 8's reveal named RDF, SPARQL, XSLT, CSS — this standard was never revealed, and the book's discipline is to introduce before it depends. A reader who doesn't know the SPARQL 1.1 suite has no way in.
  *Suggested:* a triplestore behind the Graph Store Protocol — the SPARQL suite's HTTP companion, whose direct graph identification makes the request URI the graph name — one named graph per document

- **ISSUE** · sentence-tangle · [legibility]
  > And the union law returns with the one proof obligation federation adds discharged by the types
  "adds discharged" is a hard garden path: three clauses stack without a joint, and the reader must re-parse to find that federation adds the obligation and the types discharge it. This is the sentence that carries the section's punchline — it deserves to be readable at speed.
  *Suggested:* And the union law returns. Federation adds one proof obligation, and the types discharge it (B.9): distinct origins are disjoint regions of I, so two dataspaces' graph names never collide, and the union of their states is again well-formed — every document still under exactly one origin, attribution surviving the merge because the fourth position carries it.

- **ISSUE** · paragraph-balloon · [legibility]
  > Before aligning: the unaligned union is well-formed state
  One paragraph carries three movements — what you hold before aligning, what aligning yields, and the failure-mode comparison with the identity link — in roughly two hundred words of nested clauses. The previous paragraph promised a clean before/after skeleton; this paragraph has it, but buries it, and the reader loses the frame mid-way through the integration-industry contrast.
  *Suggested:* Break the paragraph at "After aligning:" and again at "Even the failure mode improves." The skeleton is already in the prose — let the reader see it.

- **ISSUE** · renamed-callback · [legibility]
  > Chapter 7's portability of terms, running.
  Chapter 7's result is named mobility of evaluation — closed terms evaluate identically anywhere. Calling it "portability of terms" here forces the reader to audit whether this is that result or a new, undefined one. A callback only pays if it uses the name the reader stored.
  *Suggested:* Chapter 7's mobility of evaluation, running.

- **FLAG** · plain-words · [legibility]
  > compose a working application space
  "Application space" in the chapter's very first sentence is either a coinage (the space of possible applications?) or a stray word, and either way the reader stumbles on word three of the chapter. Nothing later depends on "space."
  *Suggested:* Start with the derived atoms and compose a working application

- **FLAG** · orientation-tax · [legibility]
  > An origin is not a fifth kind of name.
  The count has no anchor. The reader pauses to reconstruct which four kinds of name precede it — the quad's four positions? the tuple's components, which haven't appeared yet? The sentence's real point (nothing new is being smuggled in) doesn't need the arithmetic.
  *Suggested:* An origin is not a new kind of name.

- **FLAG** · sentence-tangle · [legibility]
  > The layered term treats specially exactly what the dataspace's ontology declares
  "treats specially exactly what" piles three adverb-ish words between verb and object; the reader takes two runs at it. Small, but it opens the chapter's densest paragraph.
  *Suggested:* The layered term specializes exactly what the dataspace's ontology declares — B.8's relative genericity, deployed

- **FLAG** · undefined-term-on-first-use · [legibility]
  > Saxon runs the first, SaxonJS with IXSL the second
  Three product names and an unexpanded acronym in one clause. Naming the deployed processors fits Part V's game, and Saxon/SaxonJS are self-explaining by apposition — but IXSL gets no gloss anywhere. If your reader lives in the XSLT world this is fine; flagging in case they don't.
  *Suggested:* Saxon runs the first, SaxonJS with IXSL — its interactive extension — the second; two processors, one set of terms.

- **FLAG** · orientation-tax · [legibility]
  > it is what makes the generic engine generic
  "The generic engine" arrives with a definite article, presuming an engine already on stage; none has been named in this chapter, and "generic" (B.8) was defined for transforms, not engines. The reader can infer, but the article claims a prior introduction that didn't happen.
  *Suggested:* it is what makes a generic engine possible: the domain travels in the state, so nothing domain-shaped remains to be hardcoded.

- **FLAG** · callback-mismatch · [legibility]
  > data, layout, and style invalidate independently
  Three items are made to stand for the four timelines (state, select, arrange, present); the careful reader — the one this book has trained — stops to recount and finds one missing. The closing image deserves an exact fit.
  *Suggested:* state, selection, layout, and style invalidate independently, per factor, cache entry by cache entry — the four timelines, running as infrastructure.

- **FLAG** · concept-before-dependency · [legibility]
  > read-write linked data at every document under it
  "Linked data" lands in the table as a settled proper term before the Documents section earns the word "linked" one paragraph later. If the book introduced Linked Data by name earlier, this is fine — flagging in case Chapter 8's reveal named only RDF, SPARQL, XSLT, and CSS, in which case the famous phrase debuts here unannounced.

- **FLAG** · orientation-tax · [legibility]
  > GET …/panel-14 returns the graph of facts about that panel
  The panel — and the turbine two sections later — arrives as a familiar running example ("that panel"). If the book has carried this example since earlier chapters, fine; flagging in case this is its debut, where the definite reference presumes an object never set up.

- **FLAG** · buried-lede · [legibility]
  > The ontology is the component the derivation predicts and the industry outsources to code
  The section titled "The build log" opens with a one-factor deep-dive; the log itself arrives a paragraph later, and arrange gets its parallel deep-dive after the table. The fronting is defensible — the table's domain row leans on the ontology — but the section lede is displaced, and a reader scanning for the log stalls on a component essay.
  *Suggested:* Either open the section with "The build log, factor by factor:" and seat the ontology close-up beside the arrange one after the table, or keep the fronting and add one orienting line telling the reader the least familiar factor goes first.

### Ch 18. No New Standard

**Verdict.** Hold this for one focused pass, then ship it with my blessing — the spine is excellent. The roadmap pays off section by section, the LDP subtraction argument is a genuine pleasure, the self-federation test is vividly told, and the closing line earns its swagger. Nothing blocks, and the authorship disclosure is handled exactly right — no exposure concerns anywhere. What the pen caught is local: the opening sentence leans on "the build log," a term I can't resolve from where I sit; the CERN origin story is told twice within half a page, nearly clause for clause; the federation tagline plays three times on one spread; and a handful of back-references — "both exits," "the four components," "the term" — each point at two things at once, which trips precisely the reader this book has spent seventeen chapters training to track its apparatus. The closing section also starves: three earlier promises are routed to the reference implementation and only one is visibly cashed. All of it is fixable in an hour without touching the argument. Several flags are conditional on context I was deliberately denied and may dissolve the moment the human checks an earlier chapter — but that check is theirs to make. These findings are for the human to judge with the full context I was denied: surface every one of them, flags included; none is mine or my caller's to set aside, and if the human is not available, stop and wait.

- **ISSUE** · orientation-tax · [legibility]
  > The build log ran on deployed standards end to end
  The chapter's very first referent, "the build log," is not in the glossary of earlier-defined terms. If Chapter 17 coined it, this opener lands; if it didn't, the reader starts the chapter unable to resolve the subject of its first sentence — and the whole opening claim ("nothing more is needed") hangs off it. Anchoring it to its chapter costs three words and works either way.
  *Suggested:* Chapter 17's build log ran on deployed standards end to end, and this chapter shows that nothing more is needed.

- **ISSUE** · duplication · [legibility]
  > The write side was there on day one, then lost for a generation
  The CERN origin story is told twice within half a page, nearly clause for clause: the paragraph before the history box already has "interoperated with each other before there was anyone else to interoperate with," "that browser was an editor," and "lost for a generation" — then the box repeats all three ("before there was a third program in the world," "was also an editor," "lost for a generation"). The reader pays for the story twice, and the box's genuinely new material (1990, info.cern.ch, NeXT, the Nexus renaming) gets buried in the replay.
  *Suggested:* Compress the paragraph to its one new move and let the box carry the story: "The document web bootstrapped exactly this way — the box below dates it. The pattern, one level down: a server+client pair whose self-interoperability is the first running instance of a protocol anyone may join." Keep the history box as-is; it owns the names and dates.

- **ISSUE** · duplication · [legibility]
  > every capability crosses the wire or fails visibly
  This tagline plays three times on one spread: in the prose paragraph, in the mermaid diagram's closing note, and again as the caption's final sentence ("no in-process shortcut" likewise appears twice). It lands beautifully once; by the third hearing it's a jingle, and the caption — which otherwise does real work — ends on a rerun.
  *Suggested:* Keep the line in the prose and the diagram's short note (a label may echo); end the caption at "…the meeting surface is the specifications' surface alone."

- **ISSUE** · ambiguous-referent · [legibility]
  > The exhibits took both exits without instruction.
  Two trips in one clause. First, the preceding sentence enumerates three wire-level options (coincide, fragment, redirect) and its "either way" means fragment-or-redirect — so "both exits" names a different pair (collapse vs. fragment) that the reader must reconstruct. Second, "exits" is Chapter 5's term of art for the named costs of rejecting a requirement; reusing it here for something else misleads exactly the reader the book has trained on its vocabulary. The follow-on "That fragment is the exit the reference implementation adopts" compounds both.
  *Suggested:* The exhibits resolved the question both ways without instruction. […] That fragment is the convention the reference implementation adopts: one `GET` serves entity and description alike.

- **ISSUE** · undefined-term-on-first-use · [legibility]
  > an article *is* an information resource
  "Information resource" is httpRange-14's own jargon, deployed one sentence after the chapter declines the httpRange-14 framing in favor of "a shorter account." A reader outside the W3C saga meets an undefined category term in the very aside meant to reassure them the collapse is harmless — the shorter account should stay in its own words.
  *Suggested:* The Guardian's articles collapse the two harmlessly — an article *is* its own description — while the wind farm's panels sit one hash away as fragments (`#panel-14`).

- **ISSUE** · ambiguous-referent · [legibility]
  > a server publishing the four components
  Two fours are live by Chapter 18: the four independently-evolving timelines (state, select, arrange, present) and Chapter 17's dataspace quadruple (o, ont, e, x). The forced-shape argument is load-bearing here, and the reader can't tell which four the server publishes. Name them.
  *Suggested:* both halves — a server publishing state, selection, arrangement, and presentation, a client consuming anyone's. (If the dataspace quadruple is the intended referent, name that instead.)

- **ISSUE** · undefined-term-on-first-use · [legibility]
  > the already-standardized Graph Store Protocol
  The LDP subtraction argument — "subtract the containers and nothing remains that the Graph Store Protocol does not already do" — only lands if the reader knows what the Graph Store Protocol does, and it is not in the glossary of earlier-defined terms. If a prior chapter introduced it, ignore me; flagging because the paragraph's whole verdict rests on it, and a one-clause gloss is cheap insurance.
  *Suggested:* the already-standardized Graph Store Protocol — HTTP's methods addressed to whole graphs —

- **ISSUE** · unpaid-promise · [legibility]
  > federating the way the section above requires
  Earlier sections route three concrete claims to the reference implementation — the fragment convention ("the exit the reference implementation adopts"), WebID and WebAccessControl ("the reference implementation below runs both"), and RDF/POST — but the closing section confirms only the federation shape. The chapter's destination paragraph is also its thinnest; the section starves relative to the roadmap's promise, and one enumerating clause pays every debt.
  *Suggested:* …federating the way the section above requires: instance to instance, its client half consuming what its server half serves — and cashing the chapter's other promises: WebID and WebAccessControl running, RDF/POST accepted, entity and description served one hash apart.

- **ISSUE** · sentence-tangle · [legibility]
  > instance meeting instance as strangers, the first federation its own
  Three appositives stack at the end of one sentence, and the last ("the first federation its own") is compressed past first-read parsing. This is the densest paragraph in the chapter doing its most important work; the one tangle in it deserves a split.
  *Suggested:* This is the strategy itself, not a stunt. Interoperating with itself is how the implementation does federation: two instances meet as strangers, and the first federation is its own.

- **ISSUE** · draft-marker · [legibility]
  > Exhibit pending
  To a cold reader, "(Exhibit pending, as Chapter 3's once was.)" is a manuscript TODO shipping in the prose, and the caption doubles down ("a miniature of the pending exhibit"). It is internally consistent and may be a deliberate built-in-the-open device — but it hands a reader grounds to wonder whether they're reading a draft, at the exact moment the chapter claims completeness. Decide consciously whether "pending" ships; if it does, phrase it as intent rather than absence.
  *Suggested:* *(The full-scale reconstruction is being built in the open, as Chapter 3's exhibit once was; the miniature below runs the derivation today.)*

- **FLAG** · mis-anchored-xref · [legibility]
  > typed apart since
  "Typed apart since Chapter 4" immediately cites R3, which the glossary dates to Chapter 5. A reader who flips back to Chapter 4 for the naming half of the split won't find it. If the roles genuinely part ways in Chapter 4, ignore me — this is exactly the kind of anchor the book's trained reader will check.
  *Suggested:* typed apart since Chapters 4 and 5: a URI in a fact position *names* (R3); a URI addressing a projection *locates* (S4)

- **FLAG** · ambiguous-referent · [legibility]
  > swap the data, the selection, the term, or the stylesheet
  In the book's vocabulary q, t, and s are all "terms" — so "the term" under-specifies for precisely the reader trained by Chapter 4. The list wants the four factors by name.
  *Suggested:* swap the data, the selection, the arrangement, or the stylesheet

- **FLAG** · one-subject-per-paragraph · [legibility]
  > The model here has a shorter account.
  The httpRange-14 paragraph runs ~200 words and does two jobs — the decade of W3C history, then the model's resolution. It tracks, but it's the chapter's longest block and its pivot sentence is buried mid-paragraph. A break here gives each job its own paragraph and lets the pivot land.
  *Suggested:* Start a new paragraph at "The model here has a shorter account."

- **FLAG** · undefined-term-on-first-use · [legibility]
  > filed at the TAG as
  If the W3C's Technical Architecture Group hasn't been expanded in an earlier chapter, the acronym lands cold at the top of the chapter's first argument. Flagging softly — the glossary may simply not list it.
  *Suggested:* filed at the TAG — the W3C's Technical Architecture Group — as httpRange-14

- **FLAG** · undefined-term-on-first-use · [legibility]
  > the strip-2 fact lists loaded as state
  "Strip-2" reads as an internal exhibit label. If Chapter 3's exhibit named its strips in prose, this lands for the in-order reader; flagging in case the label never left the build apparatus.
  *Suggested:* the fact lists from Chapter 3's second strip loaded as state

- **FLAG** · inconsistent-term · [legibility]
  > Three seams lack recommendations
  The opening paragraph capitalizes the W3C term of art ("no Recommendation covers"); lowercase here blurs it toward generic advice, when the sentence means W3C-track documents specifically. Pick the capital and keep it.
  *Suggested:* Three seams lack Recommendations: identity, access control, and the form-native write.

- **FLAG** · undefined-term-on-first-use · [legibility]
  > since adopted by
  "Solid" arrives as a bare proper noun with only a link — a supplementary reference, so this is soft, but a reader who doesn't know Solid gets provenance color they can't use without leaving the page. If Solid is safely famous for this audience, fine; a short appositive covers the rest.
  *Suggested:* since adopted by Solid, the web's re-decentralization project

### Ch 19. Generic Software

**Verdict.** This chapter is close to shippable and I enjoyed the read — the argument runs clean from corollary to existence proofs to consequences to motive, the lede leads, the spreadsheet passage ("a million silos named final_v2.xlsx") is the kind of vivid the book earns, and nothing here fails to pull its weight. But I wouldn't ship it as-is: "Computation on the write side" packs four paragraphs of argument into one unbroken 330-word block — the single worst legibility defect in the chapter and exactly the granularity balloon the rest of the chapter avoids; the opening roadmap sentence smuggles a counter-force into a list of consequences; and the browser/spreadsheet climax builds a halves metaphor and then resolves it with "intersection," the wrong operation for halves, in a book that trades on saying exactly what it means. Fix those three, then run the flags past your own memory of Chapters 4, 12, and 17 — most are one-phrase callbacks betting that the reader's recall survives a seven-chapter gap, and only someone with the earlier chapters in hand knows which bets pay. Send me the revision if you want a second look at the computation section; the rest I trust you with. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human. If the human is not available, stop here and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not yours to relax.

- **ISSUE** · ballooned-paragraph · [legibility]
  > One objection lands here with real force
  The entire "Computation on the write side" section is one ~330-word paragraph carrying at least six distinct moves: the objection, Definition 1.1's answer, agents as callers, the rule as declarative carrier, the open orchestration seam, and the three-way division of domain logic. Every sentence inside is individually clear, but the reader gets no white space to bank one move before the next arrives — this is the granularity balloon the chapter's other sections avoid.
  *Suggested:* Break the block at the seams it already has — new paragraph at "The derivation step even has a declarative carrier on the shelf.", at "What lacks a recommendation is *when* such a term runs", and at "So the domain's logic divides cleanly." Four paragraphs, no prose changes: objection and answer, the rule, the open seam, the division.

- **ISSUE** · sentence-tangle · [legibility]
  > and the consequences follow — domain functionality shipped as data, computation arriving through the same `write`, and the incentives that keep bespoke code in place.
  The chapter's second sentence is a three-clause semicolon chain whose final list breaks parallelism: the first two items are consequences of the corollary, but "the incentives that keep bespoke code in place" is the force working against it — the chapter itself treats incentives as the answer to why the consequence has not arrived. The reader's very first sentence of orientation files a counter-force under "consequences."
  *Suggested:* This chapter converts the derivation into economics. A one-line corollary collapses every domain application into one generic engine specialized by data; the browser and the spreadsheet are the existence proofs. The consequences follow — domain functionality shipped as data, computation arriving through the same `write` — and the chapter closes on the incentives that keep bespoke code in place despite them.

- **ISSUE** · metaphor-clash · [legibility]
  > The application this chapter describes is their intersection
  The preceding sentence sets up "each proof carries half the claim" — and halves combine by union, not intersection. "Intersection" is correct only under a silent lift from two objects (the browser, the spreadsheet) to two classes of application (things with the web's properties, things generic over domains), and "their" points at the objects, whose intersection is meaningless. The exact readers this book has trained to think in sets will stall at the climax sentence of the section.
  *Suggested:* The application this chapter describes holds both halves at once — generic over domains, with the web's properties — and it was sitting in the standards all along.

- **FLAG** · unglossed-callback · [legibility]
  > the solver, the optimizer, Chapter 12's leaf
  A pattern, four instances: one-phrase callbacks that bet the reader's memory survives a long gap. "Chapter 12's leaf" (seven chapters back — leaf of what?); "Chapter 17's build log" (was Ch 17's exhibit framed as a build log?); "the book's online edition, the promise still outstanding" (where was the promise made?); "B.8's relativization result" (mildest — the gloss follows the colon, but "relativization" itself may be new here). Each lands if the earlier chapter made the phrase memorable; each is a stall if it didn't. I cannot check the earlier chapters — that verification is precisely the human's half of this finding.
  *Suggested:* For each callback, either confirm the phrase appears near-verbatim in the chapter it points to, or add a few-word gloss at the point of use — e.g. "Chapter 12's leaf, the one opaque computation the audit allowed" (adjust to what Ch 12 actually says).

- **FLAG** · ambiguous-referent · [legibility]
  > typed the four clauses that won it
  Which four? Two candidates fit: S1–S4 (the properness clauses, defined in Ch 4) or the uniform interface's four constraints (also Ch 4's territory). If Ch 4 coined "the four clauses" as a standing phrase, this lands clean; if not, the reader spends the rest of the paragraph carrying an unresolved pointer through an already dense passage.

- **FLAG** · terminology-drift · [legibility]
  > The deployed stack already ships it as an update term whose delta is computed by its own query.
  The book's established name is "the derived stack" (Ch 8). "The deployed stack" may be deliberate — echoing Ch 18's deployed-standards doctrine, and "already ships" leans on it — but if it is drift rather than a distinct term, a careful reader will wonder whether a new stack just entered the argument.
  *Suggested:* If unintentional: "The derived stack already ships it as an update term whose delta is computed by its own query." If "deployed" is doing deliberate work, keep it.

- **FLAG** · section-title-scope · [legibility]
  > The idea has also failed before, and the failure instructs.
  The section titled "The browser and the spreadsheet" spends its third paragraph on model-driven architecture, which is neither. The signpost sentence carries the reader through, so this is not a stall — but the title under-announces its contents, and the MDA paragraph is a counter-proof, not an existence proof.
  *Suggested:* Either retitle the section to cover its third resident — e.g. "Two proofs and a failure" — or give the MDA paragraph its own short heading.

- **FLAG** · acronym-pairing · [legibility]
  > Model-driven architecture promised applications generated from models
  The full name appears here, but the abbreviation "MDA" arrives three sentences later without ever being paired to it. The bridge is short and most readers will make it, but the standard pairing costs five characters and removes the beat entirely.
  *Suggested:* Model-driven architecture (MDA) promised applications generated from models, and broke on its own compiler

- **FLAG** · undefined term on first use · [legibility]
  > the difference between a CMS, a CRM, and an ERP is data
  CMS, CRM, ERP — plus CRUD in the same paragraph and API in the next section — arrive unexpanded, and none is in the book's defined-terms ledger. If your reader builds or buys enterprise software, these are furniture and this is fine; flagging in case the book's audience is broader than that, since a book this fastidious about definitions is conspicuous when it borrows industry shorthand cold.

### Ch 20. The Result

**Verdict.** You can ship this, and most of it is a pleasure — the coda register earns its keep, the lenses paragraph is the best sendoff move in the chapter, and "QED, dereferenced" is worth the whole page. But it deserves one more pass before it closes the book: the chapter's compression garden-paths the reader at exactly the two spots that can least afford it — the sentence that defines Web 3.0 and the book's final summary sentence — and the one paragraph that promises to state a cost never quite states it plainly. Granularity and relevancy are otherwise excellent: every paragraph does one job, nothing balloons, nothing begs to be cut. Fix the three issues, weigh the flags, and this ends the book the way the previous nineteen chapters deserve. These findings are for the human to judge with the full context I was denied — surface every one of them, including the flags; none is the caller's to waive.

- **ISSUE** · sentence-tangle · [legibility]
  > the table lets this one point
  Garden path at the chapter's headline moment: "this one point" reads first as a noun phrase ("this single point"), and the reader must back up to recover "point" as a verb — in the very sentence that delivers the book's definition of Web 3.0.
  *Suggested:* Every earlier use of the term outside this book gestured; the table lets this one *point*.

- **ISSUE** · sentence-tangle · [legibility]
  > three requirements the web already meets force what it must be made of
  The elided relative pronoun puts "meets force" adjacent and the reader stalls mid-parse — in the final summary sentence of the entire book, the worst possible place to stumble. "It" is also ambiguous (the web? the page?).
  *Suggested:* three requirements that the web already meets force what its state must be made of

- **ISSUE** · buried lede · [legibility]
  > The web can be advanced or it can be lowest-common-denominator friendly
  The paragraph opens "One cost remains, and it needs stating only once" — then never states the cost; the reader must extract it from a disjunction, and the compound adjective "lowest-common-denominator friendly" is a mouthful doing the naming work a plain clause should do.
  *Suggested:* One cost remains, and it needs stating only once: the advanced web forfeits the lowest common denominator. The two goals pull in different directions, and the book has priced both — Part II derived what advancing requires, Part IV what refusing it costs; Chapter 16 is the ledger between them. Choosing is the reader's business; pricing was the book's.

- **FLAG** · undefined term on first use · [legibility]
  > Retrodictions — quads, the JS convergence — are marked as such where they occur
  "Retrodiction" is philosophy-of-science vocabulary, not in the book's defined-term inventory. If earlier chapters already marked these "as such" using this word, fine — flagging in case this is its first appearance and the reader meets it cold in the closing chapter.
  *Suggested:* Retrodictions — claims history had already graded, like quads and the JS convergence — are marked as such where they occur; this table lists only what is still open.

- **FLAG** · concept-before-dependency · [legibility]
  > agent infrastructure stabilizing permanently on per-application protocol servers
  This row registers Chapter 21's claim one chapter before Chapter 21 makes it, and its falsifier leans on "per-application protocol servers" — landscape the reader has not yet toured. The xref makes the forward dependence explicit, so this may be deliberate; either accept it consciously or recast the falsifier in vocabulary the reader already owns (adapters, compensating machinery).

- **FLAG** · plain-words · [legibility]
  > this chapter reads it forward
  The direction metaphor is unexplained — forward as opposed to what? A cold reader can guess (Chapter 16 assembled the table looking back; this chapter draws consequences), but the guess costs a beat in the opening paragraph.
  *Suggested:* The table is the book, as the opening argument promised; this chapter reads off its consequences.

- **FLAG** · plain-words · [legibility]
  > An object whose structure is forced asks to be treated as a science instead
  A precision slip in the paragraph about precision: an object is not treated *as* a science — its study is a science. The careful reader (the one this paragraph is courting) trips on exactly the kind of category error the sentence is arguing against.
  *Suggested:* An object whose structure is forced asks for science instead — derivation, proof, and falsifiable claims like the ones just registered.

- **FLAG** · compression-register · [legibility]
  > The audit table, completed —
  A pattern, not one spot: nearly every paragraph opens on a verbless fragment ("The audit table, completed —", "Web 3.0, defined:", "Closing recursion.", "Beneath the lenses, the sentence:") and the whole chapter runs on apposition chains and em-dash insertions with no plain-syntax sentences as rest stops. As a coda register it is a legitimate choice and mostly it sings — but the two garden paths above are the accumulated cost showing. Not asking for homogenization: consider giving each paragraph one plainly built subject-verb-object sentence, so the fragments read as chosen rather than compulsory.

- **FLAG** · inconsistent-capitalization · [legibility]
  > the properness table as the home page
  Lowercase here, but the artifact elsewhere treats it as a titled object (Chapter 16's Properness Table); within one chapter the same referent should carry one casing.
  *Suggested:* the Properness Table as the home page

### Ch 21. The Agent Era

**Verdict.** This is a strong close-of-argument chapter, and short in the way earned brevity is short: the N-times-M arithmetic lands, the 2001 Scientific American box is exactly the right historical anchor, and "An agent is a user agent" is the best sentence in it — five words that cash out the whole book. You can ship it after one focused pass. No blocks, but four issues deserve real attention: the central N × M claim leaves its most obvious objection (a shared protocol looks like N + M) hanging one clause away from its own answer; the exit paragraph's payoff sentence tangles precisely where it should snap; "the hybrid" arrives unintroduced; and the grounding paragraph — the chapter's boldest forward claim — asserts a promotion loop in a book that derives everything else. The flags are burrs, each a one-line fix, but two of them (the nameless "emerging convention," the machine-legible/readable/consumable wobble) touch the chapter's terminology spine and want a conscious decision, not a shrug. Send me the revision if you rework the arithmetic paragraph — the rest I trust you with. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human. If the human is not available, stop here and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not yours to relax.

- **ISSUE** · unanswered-objection · [legibility]
  > the per-application protocol server, the emerging convention as of this writing, is the `N × M` answer shipped in real time
  The chapter's central arithmetic invites an obvious rebuttal it never answers: a shared protocol with one server per application looks like N + M on its face, not N × M. Your own criterion — 'one model and one query semantics' — is the answer (the transport is shared, the semantics are not), but the text never connects the two, so the knowledgeable reader raises the objection at the load-bearing claim and finds silence.
  *Suggested:* the per-application protocol server, the emerging convention as of this writing, is the `N × M` answer shipped in real time — the protocol is shared, but the model and query semantics are not: each server exposes its own vocabulary, so every agent still learns every application one at a time; the derived stack is the `N + M` answer, shipped since 1999.

- **ISSUE** · sentence-tangle · [legibility]
  > The compensating machinery the industry builds around every silo, pointed inward instead of out, once per silo, is the bridge.
  The paragraph's payoff sentence buries its subject under two interposed modifiers before a two-word predicate, and 'pointed inward instead of out' is a spatial metaphor that doesn't resolve on a cold read — inward toward the silo's data? toward the common model? The reader arrives at 'is the bridge' unsure what just got claimed.
  *Suggested:* The industry already builds compensating machinery around every silo. Point it at the common model — once per silo, not once per consumer — and that machinery becomes the bridge. (If 'inward instead of out' carries a specific direction, say it plainly; the metaphor alone doesn't deliver it.)

- **ISSUE** · orientation-tax · [legibility]
  > The hybrid has a specific shape.
  No hybrid has been introduced. The prior sentences describe a substrate beneath statistical models, but never name the pairing as a hybrid, so the definite article asks the reader to recognize a thing they haven't met. One appositive fixes it.
  *Suggested:* The hybrid of the two — statistical model above, fact-set substrate below — has a specific shape.

- **ISSUE** · starved-section · [legibility]
  > What proves valuable there gets promoted into a governed core — the fact-set substrate — so integration becomes something you accumulate rather than redo
  The grounding paragraph is the chapter's most forward-looking architectural claim — hallucination, the hybrid, and a promotion loop — delivered in three sentences with no mechanism: who governs the 'governed core' (a term coined here in passing), and what promotes a fact? In a book that derives everything, this paragraph asserts; it starves relative to its work while the N × M arithmetic gets two paragraphs and a figure. Either give promotion a few sentences of mechanism or scale the claim to what the chapter defends.

- **FLAG** · term-drift · [legibility]
  > the wrapper offers a choice the silo never did
  One artifact wears three names inside a single paragraph: it enters as 'an adapter', becomes 'the wrapper' two sentences later, and exits as 'the bridge'. Each rename is a small toll; the reader must keep verifying these are the same thing.
  *Suggested:* Hold one name through the paragraph — 'An adapter… the adapter offers… the adapter's answers' — and let 'the bridge' land in the closing sentence as the adapter's role, explicitly named as such.

- **FLAG** · term-drift · [legibility]
  > "Machine-consumable" unpacks to nothing new
  The chapter cycles through 'machine-legible', 'machine-readable', 'machine consumption', and 'machine-consumable' as if interchangeable; a careful reader wonders whether these are distinct terms of art. Only 'machine-consumable' is tied to the requirement (R1–R3, S4) and quoted like a term.
  *Suggested:* Reserve the quoted 'machine-consumable' for the requirement it names and use one casual form — 'machine-readable' — everywhere else, or unify outright.

- **FLAG** · dated-unnamed-reference · [legibility]
  > the emerging convention as of this writing
  The per-application protocol server is described but never named. Readers who can map the phrase to a real protocol will wonder why it goes nameless; readers who can't have nothing to look up; and 'as of this writing' dates the passage without anchoring it. If the namelessness is deliberate book-longevity policy, fine — flagging in case it isn't. (I am inferring the referent; the author holds the name.)
  *Suggested:* If it has a name, give it once in a parenthetical — 'the per-application protocol server (MCP, the emerging convention as of this writing)' — and keep the generic phrase as the working term.

- **FLAG** · duplication · [legibility]
  > with `N` growing by the month
  Paragraph one already ends on 'its cost now growing by the month'; the identical phrase recurs in the next paragraph. If the echo is deliberate it reads accidental, and the reader pays for the phrase twice in adjacent paragraphs.
  *Suggested:* Vary one instance — e.g. end paragraph one at 'its cost still compounding' and keep 'growing by the month' for `N`, where the monthly clock does the most work.

- **FLAG** · plain-words · [legibility]
  > The industry's response is a compensating industry assembling itself in real time
  'Industry's… industry' double trips the ear in the chapter's second sentence. 'Compensating industry' is the defined term, so the first occurrence is the one to drop.
  *Suggested:* The response is a compensating industry assembling itself in real time

- **FLAG** · plain-words · [legibility]
  > Now the bill arrives: software agents are trying to read the web, and what they find is what <a class="xref" href="part4.html">Part IV</a> measured: rendered pixels and private APIs.
  Two colons in one sentence force a re-parse, and 'what they find is what Part IV measured' is a passive-shaped detour around a direct verb.
  *Suggested:* Now the bill arrives: software agents are trying to read the web, and they find what Part IV measured — rendered pixels and private APIs.

- **FLAG** · compressed-referent · [legibility]
  > where they outlive the account that produced them
  The answers were produced by the wrapper, not by an account; 'the account' — the user's account on the silo — appears here for the first time, so the reader must reverse-engineer the referent of an evocative closing clause.
  *Suggested:* where they outlive the silo account they were drawn from

- **FLAG** · comma-pileup · [legibility]
  > both derive from the same requirement, machine-consumable, mergeable, globally referenced state.
  In the book's final-paragraph closer for this chapter, the comma before the list makes 'machine-consumable' read momentarily as an appositive to 'requirement' rather than the start of its unpacking; a colon marks the relation. ('derived — necessarily: both derive' also repeats the verb within the sentence — worth an ear-check.)
  *Suggested:* both derive from the same requirement: machine-consumable, mergeable, globally referenced state.

### Ch 22. The Next Web

**Verdict.** Glasses on, pen mostly capped: this is a strong closing chapter. The five-movement architecture is sound and delivered in the promised order, the section ledes are consistent one-liners, the dated precedents earn their boxes, the LinkedDataHub disclosure is handled cleanly, and the final paragraph lands the whole book. No exposure concerns anywhere. But the compression that gives the chapter its voice tips over in a handful of places into clauses that say the opposite of what they mean ("a personal store that outlived no session"), or that a cold reader cannot resolve ("parses a page pretending to be one"; "one factor short of the whole"); the front door demands two re-reads before the reader is even inside; and the two longest movements run five ideas to a single paragraph while "Every action a document" starves. You can ship this after one focused pass — nothing structural is broken — but I would not ship it before that pass: fix the issues, and put a human eye on every flag. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review, flags included (a flag is triage priority, never permission to skip). If the human is not available, stop and wait.

- **ISSUE** · semantic-inversion · [legibility]
  > wanted a personal store that outlived no session
  As written, the store outlives nothing — it dies with every session, the exact opposite of the persistence Memex wanted and the paragraph argues. The intended inversion is that no session outlived the store. This is the clearest defect in the chapter: a reader who parses it carefully gets the wrong claim.
  *Suggested:* wanted a personal store no session outlived

- **ISSUE** · ambiguous-referent · [legibility]
  > not one that parses a page pretending to be one
  Two "one"s, neither with a clear antecedent. Is the agent pretending to be a page? A person? Is the page pretending to be a fact source? The sentence carries the chapter's central contrast — reading versus scraping — and the reader stalls exactly there. If the intent is the scraper passing for a human reader, say so.
  *Suggested:* not one that scrapes the page while passing for a person reading it

- **ISSUE** · backwards-idiom · [legibility]
  > this independence, one factor short of the whole
  The idiom "one X short of the whole" means "all but one" — but Zen Garden freed exactly one factor of the skeleton, not all but one. The phrase states the arithmetic backwards, and a reader who knows the four factors does a double-take.
  *Suggested:* this independence at a single factor, the rest of the skeleton still fused

- **ISSUE** · sentence-tangle · [legibility]
  > The result stated and the era of its machine readers named, what remains is the web they compose
  A double absolute construction plus a pronoun ("they") whose antecedent could be the machine readers, or the result-and-era pair, in the first sentence of the chapter. The reader's very first act is a re-read. The book's voice tolerates compression, but the front door should open on the first push.
  *Suggested:* Chapter 20 stated the result; Chapter 21 named its machine readers. What remains is the web they compose together — not a forecast but a reading of what the three requirements already permit.

- **ISSUE** · concept-before-dependency · [legibility]
  > Occupied, it does a handful of things no fused web can.
  "Occupied" arrives with no grounding — occupied by whom, how? The word is only paid off in the final paragraph ("It is occupied — origin by origin"). At line two it reads as a dangling participle; the bookend works only if the first instance carries its own gloss.
  *Suggested:* Occupied — taken up origin by origin rather than built and shipped — it does a handful of things no fused web can.

- **ISSUE** · paragraph-balloon · [legibility]
  > The record even reaches the words themselves
  "What outlives the software" is one ~230-word paragraph carrying at least five ideas: durability of state, the fused web's losses, agent memory, conversation-as-state, and two historical precedents. The conversation-as-state capability — a genuine addition, not a restatement — is buried mid-breath where a skimming reader will miss it entirely.
  *Suggested:* Split into paragraphs: break before "What dies on the fused web", before "The record even reaches the words themselves", and before "The principle is old". No prose changes needed — the sentences are good; they are just sharing one breath.

- **ISSUE** · paragraph-balloon · [legibility]
  > A domain the agent has never seen needs no new system either
  "The network forms" is another single ~230-word paragraph, and its last two sentences swerve from network effects to the generic-engine point — a different subject — with an "either" that has no preceding parallel to lean on. The movement's real climax (the compounding loop) and the appended agent point blur together.
  *Suggested:* Break the paragraph before "And the loop compounds", give the last two sentences their own paragraph, and drop the unanchored "either": "A domain the agent has never seen needs no new system: it states the domain as facts over the one generic engine, and is done."

- **ISSUE** · duplication · [legibility]
  > asks for facts and receives them
  The phrase appears three times in ~120 words: in the movement lede ("it asks for facts and receives them, each carrying its source"), again opening the section ("it asks and receives facts"), and a third time in the Semantic Web callback. The callback echo is the point; the middle occurrence just makes the reader pay twice before it.
  *Suggested:* Vary the middle instance, e.g.: "The agent reads rather than scrapes — the query answered from state, where its predecessors parsed rendered pixels and reverse-engineered private interfaces..." — keeping the lede and the deliberate Semantic Web echo.

- **ISSUE** · granularity-starvation · [legibility]
  > The autonomy that alarms turns out to be the autonomy that can be read.
  "Every action a document" is three sentences with no example, no precedent, and no named actor — whose "intended course"? whose "autonomy"? The agent is never mentioned in the section. Every sibling capability gets a concrete beat or a dated case; this one, arguably the claim agent-era readers most need slowed down, gets the least room in the chapter.
  *Suggested:* Name the actor and give the plan one concrete beat: "And an agent's whole intended course — every read, change, and branch — can be written down as a document and inspected before a step of it runs." Consider a precedent or worked example to match the sibling sections.

- **FLAG** · duplication · [legibility]
  > What it gives the end user, because the end user was always the point.
  This paragraph's trio (navigation, forking via S3, federation) previews three of the five movements almost verbatim, and the roadmap sentence two paragraphs later orients the reader again — so the reader is oriented twice and meets each capability twice before the first section. If this is a deliberate overture, fine; flagging so it's a conscious choice rather than an accident of drafting.

- **FLAG** · undefined-term-on-first-use · [legibility]
  > the next thing built be built one level down
  "One level down" is a coined spatial metaphor, used three times and load-bearing in the book's closing sentence, but never grounded — down from what, to what? If an earlier chapter established it, this is fine; flagging in case it didn't, because the whole close rests on the phrase.
  *Suggested:* Ground it at first use: "the next thing built be built one level down — on the state the pages are views of, not on the pages."

- **FLAG** · undefined-term-on-first-use · [legibility]
  > the layer the second era hid
  "The second era" presumes a numbered era scheme. The book defined Web 3.0, so a reader can do the arithmetic — but they shouldn't have to do it mid-flourish, inside the chapter's longest sentence. If earlier chapters numbered the eras explicitly, this clears; flagging in case they didn't.

- **FLAG** · framing-inconsistency · [legibility]
  > a reading of what the three requirements already permit
  The opening credits the three requirements, but the capabilities that follow lean at least as hard on S1, S3, and S4 — and two paragraphs later the chapter itself says "Read the properties forward... rather than columns." A careful reader wonders which basis governs the chapter.
  *Suggested:* a reading of what the derived properties already permit

- **FLAG** · orientation-tax · [legibility]
  > This section's personal dataspace has an earlier name.
  The section never uses the phrase "personal dataspace" — it says "a body of facts a party keeps under its own origin." The box attributes to the section a label it didn't set, and the reader flips back looking for it.
  *Suggested:* Either introduce the term in the section body ("...composes, under one model and one law of merge, into a personal dataspace: a body of facts a party keeps under its own origin...") or open the box with "The owner-held state this section describes has an earlier name."

- **FLAG** · duplication · [legibility]
  > a name that resolves to its owner's own current answer
  This distinctive phrase appears near-verbatim in "State stops being scattered" ("a name resolves to its owner's own current answer") and again closing "What outlives the software" — which also contains "a name that still resolves" earlier in the same paragraph. Three name-resolution echoes across two adjacent sections reads as accidental self-quotation rather than refrain.
  *Suggested:* Keep the first instance; vary or trim the later ones, e.g. end the Memex sentence "...both wanted what owner-held state supplies: a name that still answers, durable past the software that reads it."

### Appendix A. Method, notation, and reading order

**Verdict.** This appendix does honest work and much of it lands — the crib table alone is worth the price of admission, and "Persuasion is what you need when you don't have a proof" is a proper opening line. But an appendix whose job is to point must point true, and twice it doesn't: merge-as-union is credited to Prop. 9.1 while this appendix's own results table files that result under the union law (5.1), and the Transposition Thesis row sends the reader to Appendix A — which is where they already are, holding nothing but a passing mention. Beyond the pointers, the compression that gives the chapters their snap runs unsupervised here: the fifth paragraph does five jobs, reading order is split across two locations with notation wedged between them, and half the symbol definitions are paid for twice — once in prose, once in the crib. Several flags below are one instance of a single habit — clauses squeezed until a verb or an antecedent falls out — so one deliberate de-compression pass clears most of them at once. I wouldn't ship this without that pass: fix the two pointers, split the big paragraph, let the table be the only crib, then it ships happily. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human, flags included: every flag requires a conscious human decision, and if the human is not available, stop and wait. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit, not the caller's to relax.

- **ISSUE** · mis-aimed-reference · [legibility]
  > the merge of two states, which Prop. 9.1 shows is their set union
  This appendix's own named-results table files merge-as-set-union under the union law (5.1) and files Prop. 9.1 under 'the bill for anonymity' — yet both the prose symbol list and the crib row for s ⊕ s′ cite Prop. 9.1 for merge-as-union. A reader who follows the pointer expecting the union result lands on something filed under a different name. If Prop. 9.1 is the deliberate citation (say, because it qualifies the union under anonymity), the appendix must say what 9.1 adds; as written, the apparatus contradicts itself in two places (the prose sentence and the crib table row).
  *Suggested:* ⊕ the merge of two states — their set union ∪, by the union law (5.1). (And in the crib row: "set union of their facts (5.1)".)

- **ISSUE** · dead-end-reference · [legibility]
  > Ch 5; Appendix A; B.2
  The Transposition Thesis row lists Appendix A as one of its locations — but Appendix A is this document, and the thesis appears here only as a passing mention in paragraph one ('secured four ways there and in the appendices'). A reader consulting the index to find the thesis's securing is sent to the very page they are holding and finds nothing to hold onto. Either the row is stale or the appendix is missing content it promises; that is the author's call, so no single revision fits.

- **ISSUE** · duplication · [legibility]
  > `O` the set of origins (RFC 6454), `I∣o` the URIs under origin `o`
  The prose symbol inventory and the crib table define the same symbols twice in different words: O, I∣o, 𝒫, ∖, ⊕, ⟦·⟧, and τ all appear in both, while I, V, and ⊔ appear only in prose and never make the table. The reader pays for each overlap twice and has two differently-worded places to check when looking a symbol up — the worst arrangement for a reference. Let the table be the single crib; keep in prose only the prerequisites and the two conventions the table cannot carry.
  *Suggested:* Trim the prose to: "Sets, tuples, total functions, and composition ∘ — first-year material, as promised. Two conventions: ⟦·⟧ is a denotation function and always someone else's, cited from the governing specification, never defined here; t names the arrange term (S2), so time is written τ. The crib below carries the symbols." Then add rows for I, V, and ⊔ to the crib table.

- **ISSUE** · section-sprawl · [legibility]
  > Reading order: Parts I–III linearly
  The title promises three topics — method, notation, reading order — but the fifth paragraph alone does five jobs: prerequisites, a prose symbol inventory, the numbering scheme, reading order, and the skippability of formulas. Worse, reading-order content is split across two non-adjacent locations (the three-tracks paragraph, then this sentence buried mid-notation), with notation wedged between. A reader hunting for the reading order will not think to look inside the notation paragraph.
  *Suggested:* Reorder to match the title: method (the first two paragraphs), notation (the trimmed symbol prose plus the crib), then reading order (the three tracks and the 'Reading order:' sentence together, closing with 'The formulas are skippable...'), with the named-results table last.

- **ISSUE** · sentence-tangle · [legibility]
  > and a fourth category corroborates without ever serving as premise: *witnesses*
  One sentence carries four ideas — the three source kinds, the existence of a fourth category, the definition of witnesses, and the strike-them-all invariance — across a dash-parenthetical, a colon, an appositive, and a semicolon-spliced final clause. Each idea is good; stacked, they force a re-read.
  *Suggested:* A statement's sources come in the three kinds the preface names: spec definitions, earlier propositions, checkable observations. A fourth kind corroborates but never serves as premise — *witnesses*, documents that stated as norms what this book derives as theorems. Strike every witness and no proof changes.

- **ISSUE** · sentence-tangle · [legibility]
  > building things — add Chapters 7, 14, and 19; refereeing — Chapter 5 and Appendix B
  A three-item list is crammed into one sentence with inconsistent verbs, and the inconsistency creates a real fork: 'building things' says *add* (cumulative with the hurry track), but 'refereeing' drops the verb — does the referee read only Chapter 5 and Appendix B, or add them to a track? Also, 'the opening pages' is vague for the one reader explicitly in a hurry: name them. Bulletize, and make each track's relationship to the others explicit (the author must confirm whether refereeing is standalone).
  *Suggested:* Three tracks, if you are choosing a path:

- In a hurry: the opening pages, then Chapters 3, 8, 16, and 21.
- Building things: the hurry track, plus Chapters 7, 14, and 19.
- Refereeing: Chapter 5 and Appendix B, where the load-bearing walls are.

- **FLAG** · orientation-tax · [legibility]
  > secured four ways there and in the appendices, proved never
  'Four ways' is a count the reader cannot audit: the four securings are neither named nor individually pointed to, and 'the appendices' is plural where the results table names only B.2 (and, problematically, Appendix A itself — see the dead-end finding). In the one document whose whole job is telling readers where things live, an unanchored count invites a hunt. Enumerate the four or point at them precisely.

- **FLAG** · ambiguity · [legibility]
  > Chapters 10–14 in any order after Chapter 8
  'Parts I–III linearly' implies Chapter 9 is read before anything branches, yet 'after Chapter 8' implies the branch opens one chapter earlier — so is Chapter 9 a prerequisite for Chapters 10–14 or not? A reader planning a path cannot tell which chapter unlocks the audit.
  *Suggested:* Chapters 10–14 depend only on Chapter 8 — read them in any order (if that is the claim; if Chapter 9 is also required, write 'after Part III').

- **FLAG** · over-compression · [legibility]
  > B-conditions the formalizations in Appendix B
  The elided 'are' makes 'conditions' momentarily parse as a verb ('B-conditions the formalizations'), in a paragraph already running at maximum density. This fragment is also the term's only definition in the book's apparatus guide, so it must parse on the first pass.
  *Suggested:* the B-conditions are the formalizations in Appendix B

- **FLAG** · sentence-tangle · [legibility]
  > audits what the industry runs instead and, last, the derived stack itself
  The double-comma interruption 'and, last,' forces a stutter mid-clause, and the object it delays ('the derived stack itself') is the sentence's surprise — the audit turning on the book's own conclusion — which deserves a cleaner landing.
  *Suggested:* Part IV, between them, audits what the industry runs instead, ending with the derived stack itself — no editorializing, only scores against Part II's seven properties.

- **FLAG** · over-compression · [legibility]
  > Part V after Part III suffices
  Compressed past the point of first-pass parse: the reader must reconstruct that this means Part V requires nothing from Part IV. The inversion ('suffices' governing a prepositional phrase) reads like a proof step, not a reading instruction.
  *Suggested:* Part V needs nothing past Part III.

- **FLAG** · misplaced-content · [legibility]
  > Three tracks, if you are choosing a path
  Path-choosing guidance lives in back matter, where only readers who have already finished the book will find it — the one audience that no longer needs it. This is fine if the preface signposts Appendix A as the place to pick a track before starting; flagging in case it doesn't, since I cannot see the preface.

### Appendix B. Proofs

**Verdict.** This appendix is, for a proofs appendix read cold, genuinely good company — the connective prose is confident, the honesty paragraphs ("what this proof does and does not give," "two boundaries, stated rather than buried") deliver exactly what they advertise, and B.4 and B.9 are models of economy I'd hold up to the other sections. I found no blocks and nothing under the exposure lens. What I did find is structural friction of the kind a proofs appendix can least afford: a condition-labeling scheme that collides with the appendix's own section numbers and is never explained, four sections that prove statements they never state, a two-paragraph history lesson lodged inside the proof of the book's most important proposition, and one ninety-word sentence asked to deliver the synthesis theorem's entire realization. None of the issues is a rewrite — most are a sentence added, a paragraph moved, or a sentence split — and the flags are largely one-line fixes, with a few hedged on context only the author holds (whether "the audit table" is the Properness Table, whether Chapter 9 introduced "skolemization," whether the reader knows Wadler). Fix the issues, run the flags, and send me the revision for a second look — this is close. These findings are for the human to judge, with the full context I was denied. Do not make the call yourself, and do not quietly set a finding aside — surface this review to the human, every flag included; a flag is triage priority, never permission to skip. If the human is not available, stop here and wait.

- **ISSUE** · orientation-tax · [legibility]
  > Both sides first, then the map, then the commuting, clause by clause.
  B.2, B.6, B.7, and B.8 dive into their proofs without ever stating the proposition being proved — the reader must recall Prop 5.2, 4.5, 8.2, or Thm 8.3 from chapters ago or flip back. B.3 and B.9 restate their claims first and are markedly easier to enter cold; the inconsistency makes half the appendix harder than it needs to be.
  *Suggested:* Open each proof section the way B.3 and B.9 open — one restated line before the work begins, e.g. for B.7: "**Prop. 8.2 (restated).** φ carries match, join, union, project to SPARQL's evaluation, clause for clause."

- **ISSUE** · label-collision · [legibility]
  > Let (M, ⊕) satisfy B-2a–d, B-0, B-1, B-3, and among such models be arity-minimal.
  Three near-identical names circulate: condition B-1, section B.1, and Lemma B.1 — distinguished only by hyphen versus period, in an appendix where all three are cited constantly (this very sentence cites condition B-1 two lines after Lemma B.1 appears in the proof). The scheme that would rescue the reader — conditions are numbered after the requirements they formalize, B-2a–d for R2, B-1 for R1, B-3 for R3 — is inferable from parentheticals but never stated.
  *Suggested:* Add one sentence before the four laws in B.1: "Conditions carry the number of the requirement they formalize — B-2a–d for R2, B-1 for R1, B-3 for R3, B-0 for the form-level ground — hyphenated to keep them apart from the section numbers." And consider whether the hyphen alone is enough distance from "Lemma B.1."

- **ISSUE** · misplaced-digression · [legibility]
  > The mathematics here has a pedigree and a trap, and both belong on the table.
  Two substantial paragraphs of intellectual history — Peirce, Löwenheim, Quine, Skidmore, Robertson — sit inside the proof of Prop 5.2, between "Minimality pins three" and "Positions, typed," whose ∎ closes the proof. The history earns its place in the appendix, but lodged mid-proof it forces the reader to hold an open argument through a literature review.
  *Suggested:* Move "Scope, and the history that shapes it" and the Robertson paragraph below the ∎ that closes "Positions, typed." The proof then runs unbroken from arities to typing, and the history reads as the remark it is.

- **ISSUE** · sentence-tangle · [legibility]
  > Realize the three factors in the deployed stack: the selection is a term of the derived algebra
  The synthesis realization is one ninety-word sentence: three semicolon-joined factor cases, the middle one carrying two nested em-dash asides about genericity and relativization. This is the sentence the whole section exists to deliver, and it is the hardest one in the appendix to parse.
  *Suggested:* Realize the three factors in the deployed stack. The selection is a term of the derived algebra, hence by the homomorphism (B.7) a SPARQL term evaluating identically. `canon` exists and is deterministic (Prop. 6.1, RDFC-1.0 for the unnamed). `T` is a computable tree-to-tree function and XSLT is computationally complete on trees, so a term `t` with `⟦t⟧ = T` exists. Genericity is preserved by writing `t` with no URI literals outside `V₀`, names otherwise held opaque — and it relativizes intact: base plus declared overrides realizes the class generic relative to `W`, with the relativized free-theorem clause as the check that nothing was smuggled. `present` is a stylesheet by S2's own requirement.

- **ISSUE** · overloaded-term · [legibility]
  > arrange(D)    =  canon(read(dec(D)))
  Chapter 6's `canon` serializes a graph, and B.8 uses it that way (`T ∘ canon` on states) — but here it consumes `read`'s output, a Doc, and `present` then renders "a canonical tree." A type-tracking reader stalls at the central construction of the analysis theorem, inventing a second `canon : Doc → Tree` the text never acknowledges; one clause stating what `canon` means at this type, or a separate name for it, repairs the stall.

- **ISSUE** · notation-drift · [legibility]
  > (S(τ), q_τ, x_τ, s_τ)
  Chapter 4 named the three factor terms q, t, s, with t the arrange term; B.6 silently renames it x — presumably to keep it clear of the time index τ — and a reader arriving from the chapters wonders whether x is something new.
  *Suggested:* (S(τ), q_τ, x_τ, s_τ) — x is Chapter 4's arrange term t, renamed to stay clear of the time index τ.

- **ISSUE** · sentence-tangle · [legibility]
  > the surplus would live in an arrangement, some union would fail to preserve it, and its interpretation would need agreeing on
  The B-2d bullet already does quadruple duty — defines ≤, ∅, and atom, states two requirements, then argues — and its closing sentence chains three consequences ending in the ungainly passive-gerund "would need agreeing on." The most load-bearing condition in the appendix deserves the cleanest landing.
  *Suggested:* …the surplus would live in an arrangement; some union would fail to preserve it; and the parties would have to agree on its interpretation — coordination again.

- **FLAG** · orientation-tax · [legibility]
  > 5.2 and 5.4 first — the two results everything downstream rests on
  The appendix opens on a verbless fragment of bare numbers — no "Prop."/"Thm.", and no hint that reaching them means passing through B.1's formalization of R2 first, so the roadmap's first landmark (B.1) is unannounced.
  *Suggested:* Prop. 5.2 and Thm. 5.4 first — reached through B.1's formalization of R2 — the two results everything downstream rests on, so they get the most care…

- **FLAG** · inconsistent-naming · [legibility]
  > The audit table already tells you what each rejection costs.
  "The audit table" names nothing the book's established vocabulary contains; if this is Chapter 16's Properness Table, the reader shouldn't have to guess — and my having to guess proves the point. If it is some other table, the reference is more orphaned still.
  *Suggested:* The Properness Table already tells you what each rejection costs.

- **FLAG** · ambiguous-gloss · [legibility]
  > Write `s ≤ s′` for `s ⊕ s′ = s′` ("contains at most")
  The gloss "contains at most" names neither operand, so the direction of the order is left to the reader to reconstruct from the equation.
  *Suggested:* Write `s ≤ s′` for `s ⊕ s′ = s′` ("s says at most what s′ says").

- **FLAG** · duplication · [legibility]
  > The exits are visible already: documents and trees reject B-2d
  The exits are catalogued twice — previewed at the end of B.1, then restated in full with chapters and costs after Theorem 5.4 in B.3 — and the reader pays for the list both times, three sections apart.
  *Suggested:* Trim B.1's version to a forward gesture: "The exits are visible already — each law rejected is a deployed model, catalogued after Theorem 5.4."

- **FLAG** · sentence-tangle · [legibility]
  > The encoding: a binary fact `R(a,b)` becomes `(a, R, b)`
  The three-case encoding is one very long semicolon-and-em-dash sentence; each case carries its own parenthetical licensing argument, and the n-ary case nests two asides. A displayed three-item list would let each case land alone.
  *Suggested:* The encoding, case by case:
- a binary fact `R(a,b)` becomes `(a, R, b)`;
- a unary classification `P(a)` becomes `(a, kind, P)` — `kind` licensed like the reading itself: one form-level convention, agreed once;
- an n-ary fact `R(a₁, …, aₙ)` becomes a fresh entity `e` with atoms `(e, rel, R)` and `(e, roleᵢ, aᵢ)` — minting fresh names is free (RFC 3986's authority component), and `R`'s owner publishes the role names alongside `R`.

- **FLAG** · undefined-term · [legibility]
  > puts the ternarity of a non-degenerate n-ary relation at exactly `n − 2`
  "Ternarity" as a quantitative measure is used without definition; a reader who hasn't read Koshkin cannot parse what quantity equals n − 2, and the clause is color rather than load-bearing — gloss it or cut it.

- **FLAG** · required-not-supplementary reference · [legibility]
  > the restriction is the Transposition Thesis's fourth row
  The reader must recall the row order of a table stated chapters ago to know which invariant answers the gerrymandering charge; naming the row's content would make the sentence self-supporting. If the fourth row is self-containment, say so.
  *Suggested:* the restriction is the Transposition Thesis's fourth row — facts carry their meaning with them — a deployed invariant of the web, adopted for reasons that predate any question about arity.

- **FLAG** · plain-words · [legibility]
  > a renaming of the reading, and no uniqueness worth disputing
  The clause means the residual non-uniqueness isn't worth disputing, but as written it says the opposite-shaped thing — "no uniqueness worth disputing" — and the reader loops once to unpack it.
  *Suggested:* a renaming of the reading, and not a distinction worth disputing

- **FLAG** · undefined-term · [legibility]
  > to *arbitrary* lattices with ACI merge
  ACI is never expanded; B-2b and B-2c spell the laws out in words, so the acronym appears exactly once, unannounced, in the one sentence that leans on it.
  *Suggested:* to *arbitrary* lattices with associative, commutative, idempotent merge — counters, maps, booleans

- **FLAG** · undefined-term · [legibility]
  > is the skolemization the bill already covers
  "Skolemization" arrives as if previously established ("the skolemization"); if Chapter 9's bill for anonymity introduced the word, this reads fine — flagging in case it didn't, because the definite article promises an antecedent I cannot verify.

- **FLAG** · inconsistent-citation · [legibility]
  > Fletcher et al. restated it for search queries
  Every citation in the appendix carries a year except Fletcher et al. and Hogan, both in the genericity pedigree; the inconsistency is small but conspicuous in a passage whose point is citing exactly.

- **FLAG** · undefined-term · [legibility]
  > The free-theorem consequence — "cannot hardcode identifiers," made exact.
  "Free theorem" is a term of art (Wadler's) used three times with a definite article and no citation or gloss; PL-adjacent readers will smile, others meet an antecedent that never appeared. If your reader knows Wadler this is fine — flagging in case they don't.
  *Suggested:* The free-theorem consequence (in Wadler's sense) — "cannot hardcode identifiers," made exact.

- **FLAG** · plain-words · [legibility]
  > honesty is checkable by reading the term twice
  "Twice" is cryptic — presumably one read for spelled names, one for opaque usage — and the reader stops to wonder what the second reading is for when the point is simply that the check is syntactic.
  *Suggested:* honesty is checkable from the term's text alone — the names it spells must lie in `V₀ ∪ W`, and the names it does not spell it may use only opaquely, matched by equality and copied, never inspected as strings

- **FLAG** · granularity · [legibility]
  > There is no third place for a domain to hide.
  B.8 runs to a third of the appendix, and its layering and doors paragraphs argue design doctrine in chapter register ("should not be," "no third place to hide") while the synthesis proof that names the section lands last, in one paragraph. Both paragraphs feed the proof, so this is a conscious call: whether they belong here at this length, or tightened with the doctrine returned to Chapters 8/17.

- **FLAG** · grammar-slip · [legibility]
  > So the stack realizes the factorization — and only proper ones
  Singular "the factorization" jams against plural "only proper ones," and the reader re-reads to separate the two claims (this one is realized; only proper ones ever are).
  *Suggested:* So the stack realizes the factorization — and realizes only proper ones:

- **FLAG** · inconsistent-naming · [legibility]
  > B.9 Federation closure (17.1)
  Sibling headings carry a genus — "(Prop. 4.4)", "(Prop. 8.2)", "(Thm. 8.3)" — but B.9's bare "(17.1)" leaves the reader unsure whether 17.1 is an equation, a proposition, or something else; the body cites it as an equation reference, deepening the puzzle.

### Appendix C. References

**Verdict.** This appendix mostly earns its keep. The best annotations are little proofs that a reference list can carry argument — LDP's "containers as canned selections; subtract them and the Graph Store Protocol remains," the WHATWG issue scored "in the platform's own words," Parr pinned as "the priority citation for formalized separation." The five-list discipline holds and the telegraphic house style suits the genre. What needs a pass is the front door and the currency paragraph, where compression tips into knot: the opening sentence is a verbless tangle that names the artifact "the spec concordance" while the first list is labeled "Axioms," the roadmap promises three following lists and delivers four, and the RFC 3986 sentence nests a dash inside a parenthesis inside a dash. One parenthetical — "the 2026 prior-art sweep" — reads like internal process bleeding into a shipped page, and it promises "scores" the list never visibly shows. Nothing here is a block. Fix the issues, take the flags one by one, and this ships; I'd want a second look only at the reworked opening, since it is the sentence every reader meets first. These findings are for the human to judge, with the full context I was denied — every flag included; none may be quietly set aside, and if the human is not available, stop and wait.

- **ISSUE** · sentence-tangle · [legibility]
  > The spec concordance: the book's external dependency list, and deliberately its only one
  The appendix opens on a verbless fragment carrying three ideas, and it names the artifact "the spec concordance" while the first list is labeled "Axioms" — the reader must connect the two names unaided, and must guess what "its only one" attaches to (the book's only dependency list? its only dependencies?).
  *Suggested:* The spec concordance. The axioms below are the book's external dependencies — deliberately its only ones. Four lists follow, kept separate per the discipline of Appendix A: the witnesses, the candidates, the prior art, and the works the audit examines.

- **ISSUE** · roadmap-mismatch · [legibility]
  > followed by the witnesses, the candidates, and the works the audit examines
  The roadmap announces three lists after the axioms; the artifact contains four — Prior art is never promised, so the reader hits an entire section the front door said nothing about.
  *Suggested:* followed by the witnesses, the candidates, the prior art, and the works the audit examines

- **ISSUE** · internal-process-reference · [legibility]
  > (scores per the 2026 prior-art sweep)
  "The 2026 prior-art sweep" is a process artifact the reader has no access to — it reads as the project's internal workflow leaking into the shipped page — and it promises "scores" that the entries never visibly deliver (they carry characterizations, not scores). If the sweep is described somewhere in the book, cite it the way the book names it; otherwise this parenthetical only raises questions.
  *Suggested:* *Prior art — the formal neighbors of Appendix B, cited so the boundaries can be checked:*

- **ISSUE** · unlabeled-section · [legibility]
  > Currency, checked July 2026.
  Every other block in the appendix gets an italic lead-in naming its role; this paragraph floats between the axioms table and the witnesses with only a two-word verbless fragment to orient it. A reader scanning by the list discipline attaches it to nothing.
  *Suggested:* *Currency — checked July 2026:* RFC 3986 remains Internet Standard 66 …

- **ISSUE** · sentence-tangle · [legibility]
  > RFC 3986 remains Internet Standard 66 — updated, never obsoleted, by BCP 190
  The sentence nests a parenthesis inside an em-dash clause and then opens another em-dash inside the parenthesis ("…by BCP 190 (RFC 8820, which adds guidance on URI ownership and changes no syntax — the minting doctrine of B.2, in BCP form)"). Three levels deep, the reader has lost which clause is being closed.
  *Suggested:* RFC 3986 remains Internet Standard 66 — updated, never obsoleted. The update is BCP 190 (RFC 8820): guidance on URI *ownership*, no change to syntax — B.2's minting doctrine, in BCP form.

- **ISSUE** · inconsistent-discipline · [legibility]
  > WebID — W3C Incubator, 2005–; identity as a dereferenceable URI.
  The appendix's own discipline is source → where the book uses it: the axioms table has a "first used" column, and the witnesses, prior art, and audited lists all point into chapters. Three of the four candidates (WebID, WebAccessControl, RDF/POST) carry no where-used pointer at all; only SaxonJS does. The list quietly breaks the pattern the rest of the page trained the reader on.
  *Suggested:* Add each candidate's pointer, matching the other lists — e.g. for RDF/POST: "— community spec, AtomGraph, building on Sergei Egorov's original draft; the write-side last mile (Ch 9)." WebID and WebAccessControl need their chapters supplied by the author.

- **FLAG** · over-compression · [legibility]
  > Chapter 9's annotation-syntax contrast, scored there
  Two riddles back to back: a feature "is" a contrast (metonymy the reader must unpack — it serves as the contrast case Ch 9 scores), and the following sentence, "The prediction registry notes: RDF 1.2 keeps named graphs," never says why the registry cares — which prediction this bears on is left to guesswork.
  *Suggested:* its headline addition, the triple term, is the annotation syntax Chapter 9 contrasts and scores. (The registry sentence needs one more clause naming the prediction that named-graph survival bears on.)

- **FLAG** · header-contents-mismatch · [legibility]
  > Audited — works Part IV examines, cited to be scored
  The header stakes the list's principle on Part IV, but two entries point only elsewhere — LDP's sole pointer is Ch 18, the WHATWG issue's is Ch 9 — so the entries visibly fail the header's own test. I cannot verify part boundaries from this page; if Chs 9 and 18 sit outside Part IV, the header overpromises.
  *Suggested:* *Audited — works the book examines to score, chiefly in Part IV:*

- **FLAG** · starved-annotation · [legibility]
  > The Rule of Least Power, TAG finding, 2006 — Ch 12.
  Every other witness says what it corroborates; this one is the only entry with no annotation at all — a bare chapter number. The artifact's job is annotations that pull weight, and this one pulls none: the reader must open Ch 12 to learn what the finding witnesses.
  *Suggested:* *The Rule of Least Power*, TAG finding, 2006 — less power, more analyzability: the norm behind Ch 12's scoring.

- **FLAG** · ambiguous-attribution · [legibility]
  > the positioning ("the second half of a derivation")
  Whose words, and what is positioned as what? The reader cannot tell whether Fielding's dissertation is being positioned as the second half of a derivation, or the book positions itself as the half Fielding lacked — and the quotation marks suggest a source that is never named.

- **FLAG** · duplication · [legibility]
  > *intentcasting* (structured demand published to a market)
  Intentcasting is glossed twice in adjacent entries — Siegel's ("structured demand published to a market") and Searls's ("customers broadcasting qualified intent for vendors to answer") — and both entries close on the same phrase, "from the demand side." The reader pays for the definition twice and the echo reads as an oversight, not a refrain.
  *Suggested:* In the Siegel entry: "and *intentcasting* (Searls's coinage — next entry)"; keep the full gloss with Searls, and let only one of the two entries close on "from the demand side."

- **FLAG** · grammar-trip · [legibility]
  > until the APIs metered and re-siloed
  "Metered" and "re-siloed" read as intransitive here — as if the APIs did it to themselves. The reader stumbles, backtracks, and supplies the missing passive.
  *Suggested:* until the APIs were metered and re-siloed

- **FLAG** · plain-words · [legibility]
  > wanting only a cross-party substrate
  "Wanting" in the archaic sense of "lacking" — a modern reader's first parse is "desiring," which briefly makes HyperCard yearn. Plain word available at no cost.
  *Suggested:* lacking only a cross-party substrate

- **FLAG** · nominalization · [legibility]
  > The arrange seam's client-side occupancy
  A double-possessive noun stack where a verb would do — the reader must reverse-engineer "this software occupies the arrange seam on the client side" from four stacked nouns.
  *Suggested:* The arrange seam, occupied client-side (Ch 9; Ch 17).

- **FLAG** · garden-path · [legibility]
  > the dyadic-reduction results B.2's scope note answers
  A zero-relative clause butting into a possessive: the eye reads "results B.2's…" as a possessive chain before recovering the missing "that." Same pattern later in "the practice B.8's definition departs from." One word repairs both.
  *Suggested:* the dyadic-reduction results that B.2's scope note answers … the practice that B.8's definition departs from

## Standing directive

From the reviewer spec, issued by every reviewer and honored here: these findings are for the human to judge, with the full context the reviewers were denied. No finding has been set aside; every flag in this file requires a conscious yes-or-no. Content review is a compliance gate; if its friction becomes a nuisance, that is the human's call to revisit.
