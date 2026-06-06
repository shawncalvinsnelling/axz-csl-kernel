import AXZ.CSL.Core

namespace AXZ.CSL

/--
Remove exactly one occurrence of `(c, a)` and exactly one occurrence of `(c, -a)`.
Lean's `List.erase` uses decidable exact equality, not numerical tolerance.
-/
def kinkTarget {d : Nat} (c : Coord d) (a : Scalar) (s : State d) : List (Coord d × Scalar) :=
  ((s.active.erase (c, a)).erase (c, -a))

/-- Signed scalar mass over active contacts. -/
def scalarMass {d : Nat} (xs : List (Coord d × Scalar)) : Scalar :=
  xs.foldl (fun acc x => acc + x.2) 0

/--
Mathematical local step relation for the launch kernel.

For `kinkElimination c a`, the next state must be exactly the source state with
one `(c, a)` and one `(c, -a)` removed, and signed scalar mass must be preserved.
Unimplemented rule constructors are rejected by returning `False`.
-/
def StepRel {d : Nat} (r : ContactRule d) (s t : State d) : Prop :=
  match r with
  | ContactRule.kinkElimination c a =>
      (c, a) ∈ s.active ∧
      (c, -a) ∈ s.active.erase (c, a) ∧
      t.active = kinkTarget c a s ∧
      scalarMass s.active = scalarMass t.active
  | ContactRule.sphericShift =>
      False
  | ContactRule.dimensionStep =>
      False

instance instDecidableStepRel {d : Nat} (r : ContactRule d) (s t : State d) :
    Decidable (StepRel r s t) := by
  unfold StepRel
  cases r <;> infer_instance

/-- Executable Boolean local step checker. -/
def stepCheck {d : Nat} (r : ContactRule d) (s t : State d) : Bool :=
  decide (StepRel r s t)

/--
AXZ-CSL-L03-KINK.

If the executable local checker accepts a single step, the mathematical local
step relation holds. This is local mutation soundness only.
-/
theorem stepCheck_sound {d : Nat} (r : ContactRule d) (s t : State d)
    (h : stepCheck r s t = true) : StepRel r s t := by
  unfold stepCheck at h
  exact of_decide_eq_true h

end AXZ.CSL
