# Trace Format

The reference JSON trace format is `axz-csl-trace-v1`.

```json
{
  "format": "axz-csl-trace-v1",
  "initial": {"dimension": 3, "active": []},
  "steps": [
    {
      "rule": "kinkElimination",
      "coord": 0,
      "scalar": {"num": 3, "den": 1},
      "target": {"dimension": 3, "active": []}
    }
  ],
  "decoder": "flat-empty"
}
```

Scalars are rational numbers represented as numerator/denominator pairs.
