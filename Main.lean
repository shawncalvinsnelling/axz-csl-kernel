import AXZ.CSL.Example

/-- Minimal executable target. The proof-carrying demo lives in `AXZ.CSL.Example`. -/
def main : IO Unit := do
  IO.println "AXZ-CSL kernel package loaded. Run `lake build` to check Lean proofs."
