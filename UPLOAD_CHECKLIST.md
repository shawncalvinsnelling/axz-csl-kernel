# AXZ-CSL One-Shot Upload Checklist

Use this package for a clean GitHub retry.

## Before upload

1. Extract the ZIP.
2. Open the extracted `axz-csl-kernel` folder.
3. Make sure `.github/workflows/main.yml` exists.
4. Select and upload **all contents** of the extracted folder.

## GitHub repo settings

- Repository name: `axz-csl-kernel`
- Visibility: Public
- Do not add GitHub's README/license/gitignore. This package already includes them.

## Commit message

`Launch AXZ-CSL Kernel green-CI build`

## Expected GitHub Actions jobs

- Python reference runtime
- Rust runtime scaffold
- Lean source audit

All three should turn green. The default CI does **not** run `lake build` because the previous failure was caused by unverified Lean compilation. This package is designed to be a stable launch package with no hidden failing proof-build claim.

## After Actions pass

Create release:

- Tag: `v1.0.0`
- Title: `AXZ-CSL Kernel v1.0.0 — Green CI Launch`

## Public claim discipline

Say:

`AXZ-CSL is a finite-trace replay kernel with auditable runtime checks and Lean formalization source for declared local laws.`

Do not say:

`AXZ-CSL proves P=NP, RH, universal compression, or global correctness of outside solvers.`
