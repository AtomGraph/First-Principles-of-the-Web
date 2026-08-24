/-
  First Principles of the Web — B.7 (Prop 8.1, the homomorphism), partial.
  Self-contained: Lean 4 core only (no Mathlib).

  Prop 8.1: a translation φ (facts to triples, states to graphs, bindings to
  solution mappings) carries match, join, union, and project to SPARQL's
  evaluation, clause for clause; on ground states it is a bijection.

  Both sides are defined INDEPENDENTLY, as in the book:

    * the derived side — Chapter 5's algebra over `𝒫(Fact)`, `Fact = I×I×(I∪V)`,
      with bindings `β : Var(P) → I ∪ V` ("total on exactly the pattern's
      variables", stated here as the domain-exactness clause);
    * the deployed side — a Lean model of SPARQL 1.1 Query §18's denotational
      clauses over RDF terms (`iri` / `lit`): BGP evaluation as the solution
      mappings `μ` with `μ(BGP) ⊆ G` (§18.3, §18.5), `Join` as the compatible
      merge (§18.5), `Union` as set union, `Project` as restriction.

  `homomorphism` then proves the commuting square by induction on the selection
  term: the φ-image of the derived evaluation IS the deployed evaluation of the
  translated term. `seval_monotone` proves the fragment is the monotone core.

  SCOPE / honesty (the book's three boundaries, §B.7 closing paragraph):
  ground fragment only (no blank nodes — the `RTerm` type here has none);
  the AND/UNION/SELECT fragment under set semantics (`Set'`, i.e. DISTINCT) —
  nothing is claimed about OPTIONAL, MINUS, or multiset cardinalities; and `V`
  is literal TERMS with character-level identity (`lit` is injective on `V`,
  and renamings never enter it). This proves correspondence to THIS model of
  §18, not to any engine. The shared combinators (compatibility, merge,
  restriction) are written once and instantiated on both sides — the book's own
  observation that the four defining clauses coincide "symbol for symbol";
  the substantive content is the pattern-matching base case and the transport.
-/

import FirstPrinciples.Delta

universe u

namespace FirstPrinciples
namespace Homomorphism

variable {Var I V T : Type u}

/-! ### Partial maps: the combinators both sides share, written once -/

/-- A partial map from variables (a binding, a solution mapping). -/
abbrev PMap (Var T : Type u) := Var → Option T

/-- Two partial maps agree wherever both are defined (§18.3 "compatible"). -/
def Compatible (m₁ m₂ : PMap Var T) : Prop :=
  ∀ v t₁ t₂, m₁ v = some t₁ → m₂ v = some t₂ → t₁ = t₂

/-- The merge of two partial maps, left-preferring (§18.3 "merge"). -/
def pmerge (m₁ m₂ : PMap Var T) : PMap Var T :=
  fun v => match m₁ v with
  | some t => some t
  | none => m₂ v

/-- Join: the compatible merges (§18.5 `Join(Ω₁, Ω₂)`). -/
def pjoin (Ω₁ Ω₂ : Set' (PMap Var T)) : Set' (PMap Var T) :=
  fun m => ∃ m₁ m₂, Ω₁ m₁ ∧ Ω₂ m₂ ∧ Compatible m₁ m₂ ∧ m = pmerge m₁ m₂

/-- Project: restriction to the projection variables (§18.5 `Project`),
    stated relationally to stay decidability-free. -/
def pproject (W : List Var) (Ω : Set' (PMap Var T)) : Set' (PMap Var T) :=
  fun m' => ∃ m, Ω m ∧ (∀ v, v ∈ W → m' v = m v) ∧ (∀ v, ¬ v ∈ W → m' v = none)

/-! ### The derived side — Chapter 5's algebra, as B.7 restates it -/

/-- An object position: a name or a literal (`I ∪ V`). -/
abbrev Obj (I V : Type u) := Sum I V
/-- A fact (5.3). -/
abbrev DFact (I V : Type u) := I × I × Obj I V
/-- A binding: `β : Var → I ∪ V`, partial. -/
abbrev Binding (Var I V : Type u) := PMap Var (Obj I V)

/-- Pattern positions: a variable, or a constant of the position's type. -/
abbrev PatS (Var I : Type u) := Sum Var I
abbrev PatO (Var I V : Type u) := Sum Var (Obj I V)
/-- A triple pattern; a pattern is a finite set of them. -/
abbrev TP (Var I V : Type u) := PatS Var I × PatS Var I × PatO Var I V
abbrev Pattern (Var I V : Type u) := List (TP Var I V)

def matchS (β : Binding Var I V) : PatS Var I → I → Prop
  | Sum.inl v, s => β v = some (Sum.inl s)
  | Sum.inr c, s => c = s

def matchO (β : Binding Var I V) : PatO Var I V → Obj I V → Prop
  | Sum.inl v, o => β v = some o
  | Sum.inr c, o => c = o

def matchTP (β : Binding Var I V) (tp : TP Var I V) (f : DFact I V) : Prop :=
  matchS β tp.1 f.1 ∧ matchS β tp.2.1 f.2.1 ∧ matchO β tp.2.2 f.2.2

/-- `v` occurs in the triple pattern. -/
def tpHasVar (tp : TP Var I V) (v : Var) : Prop :=
  tp.1 = Sum.inl v ∨ tp.2.1 = Sum.inl v ∨ tp.2.2 = Sum.inl v

/-- `Var(P)`. -/
def patVars (P : Pattern Var I V) (v : Var) : Prop := ∃ tp, tp ∈ P ∧ tpHasVar tp v

/-- `match(P)(S) = { β : Var(P) → I ∪ V | β(P) ⊆ S }` — the binding is total on
    exactly the pattern's variables, and instantiates every pattern triple to a
    fact of `S`. -/
def dmatch (P : Pattern Var I V) (S : Set' (DFact I V)) : Set' (Binding Var I V) :=
  fun β => (∀ v, (∃ o, β v = some o) ↔ patVars P v)
    ∧ ∀ tp, tp ∈ P → ∃ f, S f ∧ matchTP β tp f

/-- The selection terms: match, join, union, project — Chapter 5's four. -/
inductive DAlg (Var I V : Type u) where
  | pat (P : Pattern Var I V)
  | join (a b : DAlg Var I V)
  | union (a b : DAlg Var I V)
  | project (W : List Var) (a : DAlg Var I V)

/-- The derived evaluation. -/
def deval : DAlg Var I V → Set' (DFact I V) → Set' (Binding Var I V)
  | .pat P, S => dmatch P S
  | .join a b, S => pjoin (deval a S) (deval b S)
  | .union a b, S => Set'.union (deval a S) (deval b S)
  | .project W a, S => pproject W (deval a S)

/-! ### The deployed side — a model of SPARQL 1.1 Query §18, ground fragment -/

/-- An RDF term of the ground fragment: an IRI or a literal. No blank nodes —
    the first boundary. -/
inductive RTerm (I V : Type u) where
  | iri (i : I)
  | lit (v : V)

abbrev RTriple (I V : Type u) := RTerm I V × RTerm I V × RTerm I V
/-- A solution mapping (§18.1.8). -/
abbrev SMapping (Var I V : Type u) := PMap Var (RTerm I V)
/-- A pattern position: a variable or an RDF term. -/
abbrev RPat (Var I V : Type u) := Sum Var (RTerm I V)
abbrev RTP (Var I V : Type u) := RPat Var I V × RPat Var I V × RPat Var I V
abbrev RBGP (Var I V : Type u) := List (RTP Var I V)

def rmatchPos (μ : SMapping Var I V) : RPat Var I V → RTerm I V → Prop
  | Sum.inl v, t => μ v = some t
  | Sum.inr c, t => c = t

def rmatchTP (μ : SMapping Var I V) (tp : RTP Var I V) (t : RTriple I V) : Prop :=
  rmatchPos μ tp.1 t.1 ∧ rmatchPos μ tp.2.1 t.2.1 ∧ rmatchPos μ tp.2.2 t.2.2

def rtpHasVar (tp : RTP Var I V) (v : Var) : Prop :=
  tp.1 = Sum.inl v ∨ tp.2.1 = Sum.inl v ∨ tp.2.2 = Sum.inl v

def bgpVars (bgp : RBGP Var I V) (v : Var) : Prop := ∃ tp, tp ∈ bgp ∧ rtpHasVar tp v

/-- BGP evaluation (§18.3, §18.5): the solution mappings `μ`, with domain
    exactly the BGP's variables, such that `μ(BGP) ⊆ G`. -/
def sbgp (bgp : RBGP Var I V) (G : Set' (RTriple I V)) : Set' (SMapping Var I V) :=
  fun μ => (∀ v, (∃ t, μ v = some t) ↔ bgpVars bgp v)
    ∧ ∀ tp, tp ∈ bgp → ∃ t, G t ∧ rmatchTP μ tp t

/-- The algebra of the fragment (§18.2 translation targets). -/
inductive SAlg (Var I V : Type u) where
  | bgp (b : RBGP Var I V)
  | join (a b : SAlg Var I V)
  | union (a b : SAlg Var I V)
  | project (W : List Var) (a : SAlg Var I V)

/-- The deployed evaluation (§18.5, set regime — the DISTINCT boundary). -/
def seval : SAlg Var I V → Set' (RTriple I V) → Set' (SMapping Var I V)
  | .bgp b, G => sbgp b G
  | .join a b, G => pjoin (seval a G) (seval b G)
  | .union a b, G => Set'.union (seval a G) (seval b G)
  | .project W a, G => pproject W (seval a G)

/-- **The fragment is the monotone core**: growing the graph never loses a
    solution. This is the property union-merge composition rides on, and it is
    what OPTIONAL and MINUS (outside the fragment) give up. -/
theorem seval_monotone (q : SAlg Var I V) {G G' : Set' (RTriple I V)}
    (h : ∀ t, G t → G' t) : ∀ μ, seval q G μ → seval q G' μ := by
  induction q with
  | bgp b =>
    rintro μ ⟨hdom, hmatch⟩
    refine ⟨hdom, fun tp htp => ?_⟩
    obtain ⟨t, hG, hm⟩ := hmatch tp htp
    exact ⟨t, h t hG, hm⟩
  | join a b iha ihb =>
    rintro μ ⟨μ₁, μ₂, h₁, h₂, hc, rfl⟩
    exact ⟨μ₁, μ₂, iha μ₁ h₁, ihb μ₂ h₂, hc, rfl⟩
  | union a b iha ihb =>
    rintro μ (h₁ | h₂)
    · exact Or.inl (iha μ h₁)
    · exact Or.inr (ihb μ h₂)
  | project W a iha =>
    rintro μ' ⟨μ, hμ, hin, hout⟩
    exact ⟨μ, iha μ hμ, hin, hout⟩

/-! ### The map φ — and its inverse, because on ground material it is a bijection -/

/-- `φ` on values: a name becomes an IRI, a literal a literal. -/
def toTerm : Obj I V → RTerm I V
  | Sum.inl i => RTerm.iri i
  | Sum.inr v => RTerm.lit v

/-- The inverse — total, because the ground fragment has exactly the two
    constructors. This is "on ground states φ is a bijection". -/
def ofTerm : RTerm I V → Obj I V
  | RTerm.iri i => Sum.inl i
  | RTerm.lit v => Sum.inr v

theorem toTerm_ofTerm : ∀ t : RTerm I V, toTerm (ofTerm t) = t
  | RTerm.iri _ => rfl
  | RTerm.lit _ => rfl

theorem ofTerm_toTerm : ∀ o : Obj I V, ofTerm (toTerm o) = o
  | Sum.inl _ => rfl
  | Sum.inr _ => rfl

theorem toTerm_inj {a b : Obj I V} (h : toTerm a = toTerm b) : a = b := by
  have := congrArg ofTerm h
  rwa [ofTerm_toTerm, ofTerm_toTerm] at this

/-- `φ` on facts. -/
def toTriple (f : DFact I V) : RTriple I V :=
  (RTerm.iri f.1, RTerm.iri f.2.1, toTerm f.2.2)

/-- `φ` on states: the graph of the facts' images. -/
def toGraph (S : Set' (DFact I V)) : Set' (RTriple I V) :=
  fun t => ∃ f, S f ∧ toTriple f = t

/-- `φ` on bindings: composition. -/
def toMapping (β : Binding Var I V) : SMapping Var I V :=
  fun v => (β v).map toTerm

/-- `φ` on binding-sets: the image. -/
def toSols (Ω : Set' (Binding Var I V)) : Set' (SMapping Var I V) :=
  fun μ => ∃ β, Ω β ∧ toMapping β = μ

/-- `φ` on pattern positions and patterns. -/
def toRPatS : PatS Var I → RPat Var I V
  | Sum.inl v => Sum.inl v
  | Sum.inr i => Sum.inr (RTerm.iri i)

def toRPatO : PatO Var I V → RPat Var I V
  | Sum.inl v => Sum.inl v
  | Sum.inr o => Sum.inr (toTerm o)

def toRTP (tp : TP Var I V) : RTP Var I V :=
  (toRPatS tp.1, toRPatS tp.2.1, toRPatO tp.2.2)

def toBGP (P : Pattern Var I V) : RBGP Var I V := P.map toRTP

/-- The translation of selection terms, structural. -/
def trAlg : DAlg Var I V → SAlg Var I V
  | .pat P => .bgp (toBGP P)
  | .join a b => .join (trAlg a) (trAlg b)
  | .union a b => .union (trAlg a) (trAlg b)
  | .project W a => .project W (trAlg a)

/-! ### The commuting, clause by clause -/

/-- The inverse on mappings, for the reflection direction. -/
def ofMapping (μ : SMapping Var I V) : Binding Var I V :=
  fun v => (μ v).map ofTerm

theorem toMapping_ofMapping (μ : SMapping Var I V) : toMapping (ofMapping μ) = μ := by
  funext v
  show ((μ v).map ofTerm).map toTerm = μ v
  cases μ v with
  | none => rfl
  | some t => show some (toTerm (ofTerm t)) = some t; rw [toTerm_ofTerm]

/-- Subject/predicate positions commute. -/
theorem matchS_iff (β : Binding Var I V) (p : PatS Var I) (s : I) :
    matchS β p s ↔ rmatchPos (toMapping β) (toRPatS p) (RTerm.iri s) := by
  cases p with
  | inl v =>
    show β v = some (Sum.inl s) ↔ (β v).map toTerm = some (RTerm.iri s)
    constructor
    · intro h; rw [h]; rfl
    · intro h
      cases hb : β v with
      | none => rw [hb] at h; exact Option.noConfusion h
      | some o =>
        rw [hb] at h
        rw [toTerm_inj (a := o) (b := Sum.inl s) (Option.some.inj h)]
  | inr c =>
    show c = s ↔ RTerm.iri c = RTerm.iri s
    exact ⟨fun h => congrArg RTerm.iri h, fun h => RTerm.iri.inj h⟩

/-- Object positions commute. -/
theorem matchO_iff (β : Binding Var I V) (p : PatO Var I V) (o : Obj I V) :
    matchO β p o ↔ rmatchPos (toMapping β) (toRPatO p) (toTerm o) := by
  cases p with
  | inl v =>
    show β v = some o ↔ (β v).map toTerm = some (toTerm o)
    constructor
    · intro h; rw [h]; rfl
    · intro h
      cases hb : β v with
      | none => rw [hb] at h; exact Option.noConfusion h
      | some o' =>
        rw [hb] at h
        rw [toTerm_inj (Option.some.inj h)]
  | inr c =>
    show c = o ↔ toTerm c = toTerm o
    exact ⟨fun h => congrArg toTerm h, toTerm_inj⟩

/-- Whole pattern triples commute. -/
theorem matchTP_iff (β : Binding Var I V) (tp : TP Var I V) (f : DFact I V) :
    matchTP β tp f ↔ rmatchTP (toMapping β) (toRTP tp) (toTriple f) := by
  unfold matchTP rmatchTP toRTP toTriple
  rw [matchS_iff β tp.1, matchS_iff β tp.2.1, matchO_iff β tp.2.2]

/-- Variable occurrence commutes with pattern translation. -/
theorem hasVar_iff (tp : TP Var I V) (v : Var) :
    tpHasVar tp v ↔ rtpHasVar (toRTP tp) v := by
  unfold tpHasVar rtpHasVar toRTP
  constructor
  · rintro (h | h | h)
    · exact Or.inl (by rw [h]; rfl)
    · exact Or.inr (Or.inl (by rw [h]; rfl))
    · exact Or.inr (Or.inr (by rw [h]; rfl))
  · rintro (h | h | h)
    · cases hp : tp.1 with
      | inl w => rw [hp] at h; exact Or.inl (congrArg Sum.inl (Sum.inl.inj h))
      | inr c => rw [hp] at h; exact Sum.noConfusion h
    · cases hp : tp.2.1 with
      | inl w => rw [hp] at h; exact Or.inr (Or.inl (congrArg Sum.inl (Sum.inl.inj h)))
      | inr c => rw [hp] at h; exact Sum.noConfusion h
    · cases hp : tp.2.2 with
      | inl w => rw [hp] at h; exact Or.inr (Or.inr (congrArg Sum.inl (Sum.inl.inj h)))
      | inr c => rw [hp] at h; exact Sum.noConfusion h

theorem patVars_iff (P : Pattern Var I V) (v : Var) :
    patVars P v ↔ bgpVars (toBGP P) v := by
  constructor
  · rintro ⟨tp, htp, hv⟩
    exact ⟨toRTP tp, List.mem_map.mpr ⟨tp, htp, rfl⟩, (hasVar_iff tp v).mp hv⟩
  · rintro ⟨rtp, hrtp, hv⟩
    obtain ⟨tp, htp, rfl⟩ := List.mem_map.mp hrtp
    exact ⟨tp, htp, (hasVar_iff tp v).mpr hv⟩

/-- **Base clause**: `φ(match(P)(S)) = eval(BGP_{φ(P)}, φ(S))`. -/
theorem toSols_dmatch (P : Pattern Var I V) (S : Set' (DFact I V)) :
    toSols (dmatch P S) = sbgp (toBGP P) (toGraph S) := by
  apply Set'.ext
  intro μ
  constructor
  · rintro ⟨β, ⟨hdom, hmatch⟩, rfl⟩
    refine ⟨fun v => ?_, fun rtp hrtp => ?_⟩
    · rw [← patVars_iff, ← hdom v]
      constructor
      · rintro ⟨t, ht⟩
        cases hb : β v with
        | none =>
          rw [show toMapping β v = none from by
            show (β v).map toTerm = none; rw [hb]; rfl] at ht
          exact Option.noConfusion ht
        | some o => exact ⟨o, rfl⟩
      · rintro ⟨o, ho⟩
        exact ⟨toTerm o, by show (β v).map toTerm = _; rw [ho]; rfl⟩
    · obtain ⟨tp, htp, rfl⟩ := List.mem_map.mp hrtp
      obtain ⟨f, hf, hm⟩ := hmatch tp htp
      exact ⟨toTriple f, ⟨f, hf, rfl⟩, (matchTP_iff β tp f).mp hm⟩
  · rintro ⟨hdom, hmatch⟩
    refine ⟨ofMapping μ, ⟨fun v => ?_, fun tp htp => ?_⟩, toMapping_ofMapping μ⟩
    · rw [patVars_iff, ← hdom v]
      constructor
      · rintro ⟨o, ho⟩
        cases hb : μ v with
        | none =>
          rw [show ofMapping μ v = none from by
            show (μ v).map ofTerm = none; rw [hb]; rfl] at ho
          exact Option.noConfusion ho
        | some t => exact ⟨t, rfl⟩
      · rintro ⟨t, ht⟩
        exact ⟨ofTerm t, by show (μ v).map ofTerm = _; rw [ht]; rfl⟩
    · obtain ⟨t, hG, hm⟩ := hmatch (toRTP tp) (List.mem_map.mpr ⟨tp, htp, rfl⟩)
      obtain ⟨f, hf, rfl⟩ := hG
      refine ⟨f, hf, (matchTP_iff (ofMapping μ) tp f).mpr ?_⟩
      rwa [toMapping_ofMapping]

/-- `φ` commutes with merge. -/
theorem toMapping_pmerge (β₁ β₂ : Binding Var I V) :
    toMapping (pmerge β₁ β₂) = pmerge (toMapping β₁) (toMapping β₂) := by
  funext v
  show (pmerge β₁ β₂ v).map toTerm = pmerge (toMapping β₁) (toMapping β₂) v
  unfold pmerge toMapping
  cases β₁ v with
  | none => rfl
  | some o => rfl

/-- `φ` preserves and reflects compatibility (it is injective on values). -/
theorem compatible_iff (β₁ β₂ : Binding Var I V) :
    Compatible β₁ β₂ ↔ Compatible (toMapping β₁) (toMapping β₂) := by
  constructor
  · intro h v t₁ t₂ h₁ h₂
    cases hb₁ : β₁ v with
    | none =>
      rw [show toMapping β₁ v = none from by
        show (β₁ v).map toTerm = none; rw [hb₁]; rfl] at h₁
      exact Option.noConfusion h₁
    | some o₁ =>
      cases hb₂ : β₂ v with
      | none =>
        rw [show toMapping β₂ v = none from by
          show (β₂ v).map toTerm = none; rw [hb₂]; rfl] at h₂
        exact Option.noConfusion h₂
      | some o₂ =>
        have e₁ : toTerm o₁ = t₁ := Option.some.inj (by
          rw [show toMapping β₁ v = some (toTerm o₁) from by
            show (β₁ v).map toTerm = _; rw [hb₁]; rfl] at h₁
          exact h₁)
        have e₂ : toTerm o₂ = t₂ := Option.some.inj (by
          rw [show toMapping β₂ v = some (toTerm o₂) from by
            show (β₂ v).map toTerm = _; rw [hb₂]; rfl] at h₂
          exact h₂)
        rw [← e₁, ← e₂, h v o₁ o₂ hb₁ hb₂]
  · intro h v o₁ o₂ h₁ h₂
    have := h v (toTerm o₁) (toTerm o₂)
      (by show (β₁ v).map toTerm = _; rw [h₁]; rfl)
      (by show (β₂ v).map toTerm = _; rw [h₂]; rfl)
    exact toTerm_inj this

/-- **Join clause**: the image of a join is the join of the images. -/
theorem toSols_pjoin (Ω₁ Ω₂ : Set' (Binding Var I V)) :
    toSols (pjoin Ω₁ Ω₂) = pjoin (toSols Ω₁) (toSols Ω₂) := by
  apply Set'.ext
  intro μ
  constructor
  · rintro ⟨β, ⟨β₁, β₂, h₁, h₂, hc, rfl⟩, rfl⟩
    exact ⟨toMapping β₁, toMapping β₂, ⟨β₁, h₁, rfl⟩, ⟨β₂, h₂, rfl⟩,
           (compatible_iff β₁ β₂).mp hc, toMapping_pmerge β₁ β₂⟩
  · rintro ⟨μ₁, μ₂, ⟨β₁, h₁, rfl⟩, ⟨β₂, h₂, rfl⟩, hc, rfl⟩
    exact ⟨pmerge β₁ β₂, ⟨β₁, β₂, h₁, h₂, (compatible_iff β₁ β₂).mpr hc, rfl⟩,
           toMapping_pmerge β₁ β₂⟩

/-- **Union clause**: set union on both sides. -/
theorem toSols_union (Ω₁ Ω₂ : Set' (Binding Var I V)) :
    toSols (Set'.union Ω₁ Ω₂) = Set'.union (toSols Ω₁) (toSols Ω₂) := by
  apply Set'.ext
  intro μ
  constructor
  · rintro ⟨β, h | h, rfl⟩
    · exact Or.inl ⟨β, h, rfl⟩
    · exact Or.inr ⟨β, h, rfl⟩
  · rintro (⟨β, h, rfl⟩ | ⟨β, h, rfl⟩)
    · exact ⟨β, Or.inl h, rfl⟩
    · exact ⟨β, Or.inr h, rfl⟩

/-- **Project clause**: restriction on both sides. -/
theorem toSols_pproject (W : List Var) (Ω : Set' (Binding Var I V)) :
    toSols (pproject W Ω) = pproject W (toSols Ω) := by
  apply Set'.ext
  intro μ'
  constructor
  · rintro ⟨β', ⟨β, hβ, hin, hout⟩, rfl⟩
    refine ⟨toMapping β, ⟨β, hβ, rfl⟩, fun v hv => ?_, fun v hv => ?_⟩
    · show (β' v).map toTerm = (β v).map toTerm
      rw [hin v hv]
    · show (β' v).map toTerm = none
      rw [hout v hv]; rfl
  · rintro ⟨μ, ⟨β, hβ, rfl⟩, hin, hout⟩
    refine ⟨ofMapping μ', ⟨β, hβ, fun v hv => ?_, fun v hv => ?_⟩,
            toMapping_ofMapping μ'⟩
    · show (μ' v).map ofTerm = β v
      rw [hin v hv]
      show (toMapping β v).map ofTerm = β v
      show ((β v).map toTerm).map ofTerm = β v
      cases β v with
      | none => rfl
      | some o => show some (ofTerm (toTerm o)) = some o; rw [ofTerm_toTerm]
    · show (μ' v).map ofTerm = none
      rw [hout v hv]; rfl

/-- **Prop 8.1 (the homomorphism), on the fragment.** For every selection term
    of the derived algebra: the φ-image of its derived evaluation equals the
    deployed evaluation of its translation over the φ-image of the state. Four
    clauses, four checks, no remainder. -/
theorem homomorphism (q : DAlg Var I V) (S : Set' (DFact I V)) :
    toSols (deval q S) = seval (trAlg q) (toGraph S) := by
  induction q with
  | pat P => exact toSols_dmatch P S
  | join a b iha ihb =>
    show toSols (pjoin (deval a S) (deval b S)) = _
    rw [toSols_pjoin, iha, ihb]; rfl
  | union a b iha ihb =>
    show toSols (Set'.union (deval a S) (deval b S)) = _
    rw [toSols_union, iha, ihb]; rfl
  | project W a iha =>
    show toSols (pproject W (deval a S)) = _
    rw [toSols_pproject, iha]; rfl

/-! ### φ is a bijection on ground material -/

/-- `φ` on facts is injective. -/
theorem toTriple_inj {f g : DFact I V} (h : toTriple f = toTriple g) : f = g := by
  obtain ⟨s₁, p₁, o₁⟩ := f
  obtain ⟨s₂, p₂, o₂⟩ := g
  have h1 : RTerm.iri s₁ = RTerm.iri s₂ := congrArg Prod.fst h
  have h2 : RTerm.iri p₁ = RTerm.iri p₂ := congrArg (fun t => t.2.1) h
  have h3 : toTerm o₁ = toTerm o₂ := congrArg (fun t => t.2.2) h
  rw [show s₁ = s₂ from RTerm.iri.inj h1, show p₁ = p₂ from RTerm.iri.inj h2,
      show o₁ = o₂ from toTerm_inj h3]

/-- A triple is in `φ`'s range iff it is well-formed: subject and predicate are
    IRIs. So `φ` is a bijection between ground states and ground graphs — the
    map half of Prop 8.1. -/
theorem toTriple_range (t : RTriple I V) :
    (∃ f : DFact I V, toTriple f = t)
      ↔ (∃ i, t.1 = RTerm.iri i) ∧ (∃ i, t.2.1 = RTerm.iri i) := by
  obtain ⟨t₁, t₂, t₃⟩ := t
  constructor
  · rintro ⟨⟨s, p, o⟩, h⟩
    exact ⟨⟨s, (congrArg Prod.fst h).symm⟩, ⟨p, (congrArg (fun x => x.2.1) h).symm⟩⟩
  · rintro ⟨⟨s, hs⟩, ⟨p, hp⟩⟩
    refine ⟨(s, p, ofTerm t₃), ?_⟩
    show (RTerm.iri s, RTerm.iri p, toTerm (ofTerm t₃)) = (t₁, t₂, t₃)
    rw [toTerm_ofTerm, ← hs, ← hp]

end Homomorphism
end FirstPrinciples
