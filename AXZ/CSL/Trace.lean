import AXZ.CSL.Core

namespace AXZ.CSL

/--
Extract the final state from a replay receipt.
A trace is encoded as `s0 + [(rule₁, s1), (rule₂, s2), ...]`.
-/
def finalState {d : Nat} : State d → List (ContactRule d × State d) → State d
  | s, [] => s
  | _, (_, t) :: rest => finalState t rest

/-- Mathematical validity of every step in a finite replay trace. -/
def TraceValid {d : Nat}
    (StepRel : ContactRule d → State d → State d → Prop) :
    State d → List (ContactRule d × State d) → State d → Prop
  | s, [], sf => StateEq s sf
  | s, (r, t) :: rest, sf => StepRel r s t ∧ TraceValid StepRel t rest sf

/-- Executable Boolean replay checker over a finite trace. -/
def checkTrace {d : Nat}
    (stepCheck : ContactRule d → State d → State d → Bool) :
    State d → List (ContactRule d × State d) → Bool
  | _, [] => true
  | s, (r, t) :: rest => stepCheck r s t && checkTrace stepCheck t rest

/-- End-to-end checker: local replay plus final decoder check. -/
def CSL_Check {d : Nat} {Witness : Type}
    (stepCheck : ContactRule d → State d → State d → Bool)
    (decodeCheck : State d → Witness → Bool)
    (s0 : State d)
    (tr : List (ContactRule d × State d))
    (y : Witness) : Bool :=
  checkTrace stepCheck s0 tr && decodeCheck (finalState s0 tr) y

/--
Inductive replay soundness.

If every accepted local Boolean step is sound with respect to a proposition
`StepRel`, then every accepted finite trace is mathematically `TraceValid`.
-/
theorem checkTrace_sound {d : Nat}
    (stepCheck : ContactRule d → State d → State d → Bool)
    (StepRel : ContactRule d → State d → State d → Prop)
    (hStep : ∀ r s t, stepCheck r s t = true → StepRel r s t) :
    ∀ (s : State d) (tr : List (ContactRule d × State d)),
      checkTrace stepCheck s tr = true → TraceValid StepRel s tr (finalState s tr) := by
  intro s tr
  induction tr generalizing s with
  | nil =>
      intro _
      change StateEq s s
      rfl
  | cons hd rest ih =>
      intro h
      rcases hd with ⟨r, t⟩
      change (stepCheck r s t && checkTrace stepCheck t rest) = true at h
      have hLocal : stepCheck r s t = true := by
        cases hs : stepCheck r s t <;> simp_all
      have hRest : checkTrace stepCheck t rest = true := by
        cases hs : stepCheck r s t <;> simp_all
      change StepRel r s t ∧ TraceValid StepRel t rest (finalState t rest)
      exact ⟨hStep r s t hLocal, ih t hRest⟩

/--
AXZ-CSL-L02-MAIN: bounded trace replay soundness.

If `CSL_Check` accepts, then:
1. the finite trace obeys the declared local transition relation, and
2. the final state satisfies the declared decoder relation.

This theorem does not assert global completeness, asymptotic optimality, P=NP,
RH, or any claim outside the submitted finite trace and declared laws.
-/
theorem AXZ_CSL_L02_sound {d : Nat} {Witness : Type}
    (stepCheck : ContactRule d → State d → State d → Bool)
    (StepRel : ContactRule d → State d → State d → Prop)
    (decodeCheck : State d → Witness → Bool)
    (DecodeRel : State d → Witness → Prop)
    (hStep : ∀ r s t, stepCheck r s t = true → StepRel r s t)
    (hDecode : ∀ sf y, decodeCheck sf y = true → DecodeRel sf y)
    (s0 : State d)
    (tr : List (ContactRule d × State d))
    (y : Witness)
    (h : CSL_Check stepCheck decodeCheck s0 tr y = true) :
    TraceValid StepRel s0 tr (finalState s0 tr) ∧ DecodeRel (finalState s0 tr) y := by
  unfold CSL_Check at h
  have hTrace : checkTrace stepCheck s0 tr = true := by
    cases ht : checkTrace stepCheck s0 tr <;> simp_all
  have hDecodeTrue : decodeCheck (finalState s0 tr) y = true := by
    cases ht : checkTrace stepCheck s0 tr <;> simp_all
  exact
    ⟨ checkTrace_sound stepCheck StepRel hStep s0 tr hTrace,
      hDecode (finalState s0 tr) y hDecodeTrue ⟩

end AXZ.CSL
