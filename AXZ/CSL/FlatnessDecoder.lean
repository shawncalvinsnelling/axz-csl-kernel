import AXZ.CSL.Core

namespace AXZ.CSL

/-- Launch-grade flatness witness: the active contact list has emptied. -/
inductive FlatWitness where
  | empty
deriving Repr, DecidableEq

/-- Boolean decoder for the simplest flatness limit. -/
def flatDecodeCheck {d : Nat} (sf : State d) (y : FlatWitness) : Bool :=
  decide (sf.active = [] ∧ y = FlatWitness.empty)

/-- Mathematical decoder relation matching `flatDecodeCheck`. -/
def FlatDecodeRel {d : Nat} (sf : State d) (y : FlatWitness) : Prop :=
  sf.active = [] ∧ y = FlatWitness.empty

/-- Decoder soundness: Boolean flatness acceptance implies the mathematical relation. -/
theorem flatDecode_sound {d : Nat} :
    ∀ (sf : State d) (y : FlatWitness),
      flatDecodeCheck sf y = true → FlatDecodeRel sf y := by
  intro sf y h
  unfold flatDecodeCheck FlatDecodeRel at *
  exact of_decide_eq_true h

end AXZ.CSL
