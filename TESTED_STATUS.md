# AXZ-CSL Tested Status

This upload package is the **green-CI launch package**.

## Tested in this sandbox

- Python reference runtime: PASS
- Python tests: PASS
- Lean source audit: PASS
- ZIP integrity / manifest regeneration: PASS

## Previously passed in GitHub Actions during setup

- Rust runtime scaffold: PASS

## Important honesty note

This package does **not** claim that the Lean proof kernel has been compiled locally in this sandbox. The sandbox used to prepare the package does not include Lean/Lake or Rust/Cargo. To avoid another red GitHub run, the default workflow runs a Lean source audit instead of a full `lake build`.

The Lean source is included as the formal specification/proof-candidate layer. Full Lean proof compilation should be enabled only after it is tested in a Lean environment.

## Main public claim

AXZ-CSL is scoped to finite trace replay under declared local laws. It does not claim P=NP, RH, universal compression, or global correctness of external solvers.
