import AXZ.CSL.Main

namespace AXZ.CSL

/-- Tiny bounded dimension for the public demo. -/
def d3 : Nat := 3

def c0 : Coord d3 := BitVec.ofNat d3 0
def c1 : Coord d3 := BitVec.ofNat d3 1
def c2 : Coord d3 := BitVec.ofNat d3 2

/--
Initial state with three exact opposite kink pairs:
`(c0, 3), (c0, -3), (c1, 5), (c1, -5), (c2, 7), (c2, -7)`.
-/
def demo_s0 : State d3 :=
  { active :=
      [ (c0, (3 : Scalar)),  (c0, (-3 : Scalar)),
        (c1, (5 : Scalar)),  (c1, (-5 : Scalar)),
        (c2, (7 : Scalar)),  (c2, (-7 : Scalar)) ]
    sparsity := by decide }

/-- After eliminating the `c0` kink pair. -/
def demo_s1 : State d3 :=
  { active :=
      [ (c1, (5 : Scalar)),  (c1, (-5 : Scalar)),
        (c2, (7 : Scalar)),  (c2, (-7 : Scalar)) ]
    sparsity := by decide }

/-- After eliminating the `c1` kink pair. -/
def demo_s2 : State d3 :=
  { active :=
      [ (c2, (7 : Scalar)),  (c2, (-7 : Scalar)) ]
    sparsity := by decide }

/-- After eliminating the `c2` kink pair. -/
def demo_s3 : State d3 :=
  { active := []
    sparsity := by decide }

/-- Three-step valid replay trace. -/
def demo_trace : List (ContactRule d3 × State d3) :=
  [ (ContactRule.kinkElimination c0 (3 : Scalar), demo_s1),
    (ContactRule.kinkElimination c1 (5 : Scalar), demo_s2),
    (ContactRule.kinkElimination c2 (7 : Scalar), demo_s3) ]

/-- Executable public smoke test. Expected output: `true`. -/
#eval CSL_Check stepCheck flatDecodeCheck demo_s0 demo_trace FlatWitness.empty

/-- Formal proof that the example trace is accepted by the Boolean checker. -/
example :
    CSL_Check stepCheck flatDecodeCheck demo_s0 demo_trace FlatWitness.empty = true := by
  decide

/-- Formal proof that accepted checker output implies mathematical trace validity. -/
example :
    TraceValid StepRel demo_s0 demo_trace (finalState demo_s0 demo_trace) ∧
    FlatDecodeRel (finalState demo_s0 demo_trace) FlatWitness.empty := by
  exact
    verified_kink_replay_pipeline
      flatDecodeCheck
      FlatDecodeRel
      flatDecode_sound
      demo_s0
      demo_trace
      FlatWitness.empty
      (by decide)

/-- Bad target state: this skips the `c1` pair after only one elimination. -/
def bad_s1 : State d3 :=
  { active :=
      [ (c2, (7 : Scalar)),  (c2, (-7 : Scalar)) ]
    sparsity := by decide }

def bad_trace : List (ContactRule d3 × State d3) :=
  [ (ContactRule.kinkElimination c0 (3 : Scalar), bad_s1) ]

/-- Executable rejection test. Expected output: `false`. -/
#eval CSL_Check stepCheck flatDecodeCheck demo_s0 bad_trace FlatWitness.empty

example :
    CSL_Check stepCheck flatDecodeCheck demo_s0 bad_trace FlatWitness.empty = false := by
  decide

end AXZ.CSL
