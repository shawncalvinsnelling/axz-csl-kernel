# AXZ-CSL Commercial Options

AXZ-CSL is an open-source formal verification kernel with optional paid enterprise layers.

The public repository should stay clean, useful, and truth-safe. The paid business sits around the kernel: faster runtimes, custom rule packs, signed certificates, private deployment, and support.

## Open-source core

Included in the public MIT-licensed repository:

- Lean 4 proof kernel.
- AXZ-CSL-L02 bounded trace replay soundness theorem.
- AXZ-CSL-L03-KINK local mutation soundness.
- Flatness decoder example.
- Python reference runtime.
- Rust runtime scaffold.
- Example traces and CI workflow.
- Documentation for the finite-trace receipt model.

## Paid enterprise layers

### 1. Enterprise Runtime Integration

Production teams can sponsor or purchase high-throughput runtime integrations for large trace files, custom binary trace formats, streaming verification, and CI/CD deployment.

### 2. Signed Verification Certificates

A paid service can verify submitted traces and issue signed AXZ-CSL certificates containing:

- input trace hash;
- ruleset hash;
- checker version;
- pass/fail result;
- timestamp;
- certificate signature.

### 3. Custom Contact-Rule Packs

Organizations can commission private or public Lean modules for their domain-specific step relations, including:

- EDA / chip-design rule packs;
- photonic or optical simulation rule packs;
- logistics and route-optimization replay rules;
- matrix and sparse-state optimizer rules;
- finance/risk-model audit rules;
- aerospace or engineering simulation replay rules.

### 4. Private Deployment and Compliance Dashboard

Enterprise customers may need a private dashboard for uploaded traces, pass/fail reports, certificate history, access control, and audit trails.

### 5. Consulting, Training, and Proof Audits

Paid support can include architecture reviews, rule design, Lean module development, integration support, training sessions, and independent trace-checking workflows.

## Truth-safe scope

AXZ-CSL does **not** claim that external solvers are globally correct, that all software is bug-free, or that any global complexity theorem is solved.

The core claim is:

> If AXZ-CSL accepts a finite trace, the trace is proven to obey the declared local step relation and decoder relation.

## Contact

For enterprise integrations, paid rule packs, certificate infrastructure, or private support:

**Shawn Calvin Snelling**  
**axezentai@Gmail.com**
