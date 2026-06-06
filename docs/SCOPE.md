# AXZ-CSL Scope

## Proven by the launch kernel

- Finite trace replay soundness.
- Local kink-elimination soundness.
- Flat-empty decoder soundness.
- Passing and failing smoke tests in `AXZ/CSL/Example.lean`.

## Not proven by the launch kernel

- P=NP.
- Riemann Hypothesis.
- Global non-cancellation.
- Completeness of any solver.
- Asymptotic performance of any external search procedure.
- Physical correctness of a proprietary simulator.

## Correct statement

If the Boolean checker accepts a finite receipt, then Lean proves the submitted finite receipt obeys the declared transition laws and decoder relation.
