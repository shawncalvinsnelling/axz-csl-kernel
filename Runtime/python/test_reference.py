from fractions import Fraction
from axz_csl_reference import State, csl_check, demo_trace


def test_demo_accepts():
    s0, trace = demo_trace()
    assert csl_check(s0, trace) is True


def test_bad_trace_rejects():
    s0, _ = demo_trace()
    bad_s1 = State(3, ((2, Fraction(7)), (2, Fraction(-7))))
    bad_trace = [("kinkElimination", 0, Fraction(3), bad_s1)]
    assert csl_check(s0, bad_trace) is False
