# API Design Notes

The proof kernel is intentionally small. External systems should treat it as a receipt auditor.

## Minimal service contract

```text
POST /verify
  input: axz-csl-trace-v1 JSON receipt
  output: ACCEPT/REJECT + certificate hash
```

## Certificate payload

A production certificate should include:

- trace hash;
- rule registry hash;
- decoder hash;
- verifier version;
- timestamp;
- signer public key;
- result.
```

## Safety rule

A certificate proves only the submitted finite receipt against the declared local laws. It does not certify the external solver's global correctness.
