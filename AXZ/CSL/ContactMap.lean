import AXZ.CSL.Core

namespace AXZ.CSL

/--
Formal ontology layer corresponding to the Snelling Contact--Defect Totality Map.
This is a classification registry, not a global complexity theorem.
-/
inductive ContactKind where
  | origin
  | smoothSpheric
  | anisotropic
  | conePointed
  | edge
  | corner
  | kink
  | flat
  | dimensionBoundary
deriving Repr, DecidableEq

/-- Human-readable names for external receipts and JSON metadata. -/
def ContactKind.label : ContactKind → String
  | origin => "origin"
  | smoothSpheric => "smooth-spheric"
  | anisotropic => "anisotropic"
  | conePointed => "cone-pointed"
  | edge => "edge"
  | corner => "corner"
  | kink => "kink"
  | flat => "flat"
  | dimensionBoundary => "dimension-boundary"

/-- Map executable contact rules into the ontology registry. -/
def ContactRule.kind {d : Nat} : ContactRule d → ContactKind
  | ContactRule.kinkElimination _ _ => ContactKind.kink
  | ContactRule.sphericShift => ContactKind.smoothSpheric
  | ContactRule.dimensionStep => ContactKind.dimensionBoundary

/--
Receipt discipline: every public claim must be backed by a finite replay trace
and the theorem that accepted traces obey the declared rule relation.
-/
def receiptDiscipline : String :=
  "finite trace + declared local laws + Boolean acceptance + Lean soundness theorem"

end AXZ.CSL
