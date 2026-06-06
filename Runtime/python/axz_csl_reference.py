#!/usr/bin/env python3
"""Reference runtime for AXZ-CSL finite kink-trace replay.

This Python runtime is intentionally simple and auditable. It mirrors the Lean
launch kernel at engineering level: exact rational scalars, finite active lists,
one executable local mutation law, and flatness decoding.
"""
from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from typing import Iterable, List, Tuple
import json

Contact = Tuple[int, Fraction]


@dataclass(frozen=True)
class State:
    d: int
    active: Tuple[Contact, ...]

    def check_sparsity(self) -> bool:
        return len(self.active) <= self.d ** 3


def scalar_mass(xs: Iterable[Contact]) -> Fraction:
    total = Fraction(0, 1)
    for _, value in xs:
        total += value
    return total


def erase_once(xs: Tuple[Contact, ...], target: Contact) -> Tuple[Contact, ...]:
    out: List[Contact] = []
    removed = False
    for item in xs:
        if not removed and item == target:
            removed = True
            continue
        out.append(item)
    return tuple(out)


def kink_target(c: int, a: Fraction, s: State) -> Tuple[Contact, ...]:
    return erase_once(erase_once(s.active, (c, a)), (c, -a))


def kink_step_check(c: int, a: Fraction, s: State, t: State) -> bool:
    after_first = erase_once(s.active, (c, a))
    return (
        s.d == t.d
        and s.check_sparsity()
        and t.check_sparsity()
        and (c, a) in s.active
        and (c, -a) in after_first
        and t.active == erase_once(after_first, (c, -a))
        and scalar_mass(s.active) == scalar_mass(t.active)
    )


def check_trace(s0: State, trace: Iterable[Tuple[str, int, Fraction, State]]) -> bool:
    s = s0
    for rule, c, a, t in trace:
        if rule != "kinkElimination":
            return False
        if not kink_step_check(c, a, s, t):
            return False
        s = t
    return True


def flat_decode(sf: State) -> bool:
    return sf.active == tuple()


def csl_check(s0: State, trace: List[Tuple[str, int, Fraction, State]]) -> bool:
    return check_trace(s0, trace) and flat_decode(trace[-1][3] if trace else s0)


def demo_trace() -> Tuple[State, List[Tuple[str, int, Fraction, State]]]:
    s0 = State(3, ((0, Fraction(3)), (0, Fraction(-3)), (1, Fraction(5)), (1, Fraction(-5)), (2, Fraction(7)), (2, Fraction(-7))))
    s1 = State(3, ((1, Fraction(5)), (1, Fraction(-5)), (2, Fraction(7)), (2, Fraction(-7))))
    s2 = State(3, ((2, Fraction(7)), (2, Fraction(-7))))
    s3 = State(3, tuple())
    return s0, [
        ("kinkElimination", 0, Fraction(3), s1),
        ("kinkElimination", 1, Fraction(5), s2),
        ("kinkElimination", 2, Fraction(7), s3),
    ]


def state_to_json(s: State) -> dict:
    return {
        "dimension": s.d,
        "active": [
            {"coord": c, "num": v.numerator, "den": v.denominator}
            for c, v in s.active
        ],
    }


def export_demo_json(path: str) -> None:
    s0, trace = demo_trace()
    payload = {
        "format": "axz-csl-trace-v1",
        "initial": state_to_json(s0),
        "steps": [
            {
                "rule": rule,
                "coord": c,
                "scalar": {"num": a.numerator, "den": a.denominator},
                "target": state_to_json(t),
            }
            for rule, c, a, t in trace
        ],
        "decoder": "flat-empty",
    }
    with open(path, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2)
        f.write("\n")


def main() -> int:
    s0, trace = demo_trace()
    ok = csl_check(s0, trace)
    print(f"AXZ-CSL Python reference demo ACCEPT={ok}")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
