#!/usr/bin/env python3
"""AXZ-CSL Lean source audit.

This audit is intentionally conservative. It does not claim to replace `lake build`.
It prevents known broken proof placeholders and known Lean symbols that previously
broke the public CI from entering the launch package.
"""
from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
LEAN_ROOTS = [ROOT / "AXZ", ROOT / "Main.lean", ROOT / "AXZ.lean"]
BLOCKED = [
    "sorry",
    "admit",
    "axiom ",
    "unsafe",
    "Bool.and_eq_true.mp",
    "rules.head!",
    "rules.tail!",
]


def lean_files() -> list[Path]:
    files: list[Path] = []
    for root in LEAN_ROOTS:
        if root.is_file() and root.suffix == ".lean":
            files.append(root)
        elif root.is_dir():
            files.extend(sorted(root.rglob("*.lean")))
    return sorted(set(files))


def main() -> int:
    failures: list[str] = []
    files = lean_files()
    if not files:
        failures.append("No Lean source files found.")

    for path in files:
        text = path.read_text(encoding="utf-8")
        rel = path.relative_to(ROOT)
        for token in BLOCKED:
            if token in text:
                failures.append(f"{rel}: blocked token found: {token!r}")

    if failures:
        print("AXZ-CSL Lean source audit FAILED")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print(f"AXZ-CSL Lean source audit PASSED ({len(files)} Lean files checked)")
    print("Note: this is a source audit, not a full Lean/Lake proof build.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
