# Mathematical Design

## State

A state is a sparse list of active contacts:

```lean
structure SparseTensorState (d : Nat) where
  active : List (Coord d × Scalar)
  sparsity : active.length ≤ d ^ 3
```

`Coord d` is a fixed-width bit-vector coordinate and `Scalar` is exact rational arithmetic.

## Trace format

A trace is encoded as:

```text
s0 + [(rule₁, s1), (rule₂, s2), ...]
```

This avoids unsafe `head!` and `tail!` access because every transition carries its next state.

## Soundness theorem

`AXZ_CSL_L02_sound` states that if:

- every local Boolean step check is sound with respect to `StepRel`, and
- the Boolean decoder is sound with respect to `DecodeRel`, and
- `CSL_Check` returns `true`,

then:

- the whole finite trace is `TraceValid`, and
- the final state satisfies `DecodeRel`.
