import AXZ.CSL.Core
import AXZ.CSL.ContactMap
import AXZ.CSL.Kink
import AXZ.CSL.Trace
import AXZ.CSL.FlatnessDecoder

namespace AXZ.CSL

/--
Assembled verified pipeline for the launch kernel.

The local law is `StepRel` from `Kink.lean`; the generic trace theorem is
`AXZ_CSL_L02_sound` from `Trace.lean`.
-/
def verified_kink_replay_pipeline {d : Nat} {Witness : Type}
    (decodeCheck : State d → Witness → Bool)
    (DecodeRel : State d → Witness → Prop)
    (hDecode : ∀ sf y, decodeCheck sf y = true → DecodeRel sf y)
    (s0 : State d)
    (tr : List (ContactRule d × State d))
    (y : Witness)
    (h : CSL_Check stepCheck decodeCheck s0 tr y = true) :
    TraceValid StepRel s0 tr (finalState s0 tr) ∧ DecodeRel (finalState s0 tr) y :=
  AXZ_CSL_L02_sound
    stepCheck
    StepRel
    decodeCheck
    DecodeRel
    stepCheck_sound
    hDecode
    s0
    tr
    y
    h

end AXZ.CSL
