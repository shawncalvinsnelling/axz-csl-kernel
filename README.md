# AXZ-CSL Kernel

**Verified Sparse-State Trace Replay for Exact Finite Receipts**

AXZ-CSL is an open-source formal verification kernel for checking finite execution traces over sparse coordinate states. It separates **search** from **verification**:

1. an external solver or simulator searches for a path;
2. the solver emits a compact replay receipt;
3. AXZ-CSL checks the receipt step by step using exact arithmetic;
4. The Lean source states the proof kernel for Boolean acceptance implying declared-law trace validity; the green launch CI audits the Lean source and tests the executable runtimes.

This repository is intentionally scoped to a defendable claim:

> If `CSL_Check` accepts a submitted finite trace, then the trace is valid with respect to the declared local step relation and decoder relation.

It does **not** claim P=NP, RH, universal compression, asymptotic optimality, or correctness of an external solver.

## Core theorem

`AXZ_CSL_L02_sound` proves bounded trace replay soundness:

```text
Boolean checker accepts
        ↓
finite trace obeys declared StepRel
        ↓
final state satisfies declared DecodeRel
```

## Launch local law

`AXZ-CSL-L03-KINK` proves local soundness for exact opposite-pair cancellation:

```text
(c, a), (c, -a)  →  removed exactly once each
```

All scalar operations in the proof layer use exact rational arithmetic, not floating-point tolerance.

## Repository layout

```text
AXZ/CSL/Core.lean             Core exact sparse-state types
AXZ/CSL/ContactMap.lean       Contact-kind ontology registry
AXZ/CSL/Kink.lean             Local kink-elimination law and soundness
AXZ/CSL/Trace.lean            AXZ-CSL-L02 replay theorem
AXZ/CSL/FlatnessDecoder.lean  Empty-support flatness decoder
AXZ/CSL/Main.lean             Assembled verified pipeline
AXZ/CSL/Example.lean          Passing and failing public smoke tests
Runtime/python/               Auditable reference runtime
Runtime/rust/                 High-performance runtime scaffold
Examples/demo_trace.json      Compact demo receipt
```

## Quick start

This project is pinned to Lean `v4.30.0` in `lean-toolchain`.

```bash
lake build
```

To run the Python reference runtime:

```bash
python Runtime/python/axz_csl_reference.py
python -m pytest Runtime/python/test_reference.py
```

To run the Rust runtime scaffold:

```bash
cd Runtime/rust
cargo test
cargo run --bin axz-csl-runtime-demo
```

## Public claim discipline

Use this language publicly:

> AXZ-CSL is a finite-trace replay kernel with Lean formalization source for declared local laws and decoder relations. The executable runtime checks finite receipts step by step.

Avoid this language:

> Solves all SAT, proves P=NP, proves RH, proves any external simulator is globally correct, or guarantees all software is bug-free.

## Commercial value

AXZ-CSL is built for teams that need auditable replay receipts for expensive optimization or simulation runs. The open kernel defines the proof layer. Production users can build or purchase high-throughput runtime emitters, custom StepRel modules, signed certificate storage, and compliance dashboards around the same core replay theorem.

## Enterprise / paid support

The proof kernel and reference runtimes are open source under the MIT License.

Paid commercial options can be built around the same kernel for organizations that need production-scale trace replay, signed certificates, private deployments, custom rule packs, or integration support. See [`COMMERCIAL.md`](COMMERCIAL.md) for the enterprise menu and truth-safe scope.

Contact: **axezentai@Gmail.com**

## License

MIT. See `LICENSE`.


## Clean upload note

This repository package includes the GitHub Actions workflow at `.github/workflows/ci.yml`.
You do not need to create any workflow file or folder manually. Extract the ZIP and upload the included contents.
