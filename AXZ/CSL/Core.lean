import Std

namespace AXZ.CSL

/-- Exact scalar field for the launch kernel. No floats are used. -/
abbrev Scalar := Rat

/-- Fixed-width binary coordinates for bounded sparse-state replay. -/
abbrev Coord (d : Nat) := BitVec d

/--
Core sparse tensor state.

The `sparsity` proof is a native static bound: every state carried inside a
trace must prove that its active contact list is bounded by `d^3`.
-/
structure SparseTensorState (d : Nat) where
  active : List (Coord d × Scalar)
  sparsity : active.length ≤ d ^ 3

abbrev State (d : Nat) := SparseTensorState d

/-- State equality for replay soundness: the kernel tracks active contacts. -/
def StateEq {d : Nat} (s t : State d) : Prop :=
  s.active = t.active

/--
Local contact mutation rule registry.

The launch kernel gives an executable, proven local law for `kinkElimination`.
The other constructors are ontology hooks: they are intentionally rejected until
a corresponding local soundness module is added.
-/
inductive ContactRule (d : Nat) where
  | kinkElimination (c : Coord d) (a : Scalar)
  | sphericShift
  | dimensionStep
deriving Repr, DecidableEq

end AXZ.CSL
