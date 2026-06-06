#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct Rat {
    pub num: i128,
    pub den: i128,
}

fn gcd(mut a: i128, mut b: i128) -> i128 {
    a = a.abs();
    b = b.abs();
    while b != 0 {
        let r = a % b;
        a = b;
        b = r;
    }
    if a == 0 { 1 } else { a }
}

impl Rat {
    pub fn new(num: i128, den: i128) -> Self {
        assert!(den != 0, "denominator must be nonzero");
        let sign = if den < 0 { -1 } else { 1 };
        let g = gcd(num, den);
        Self { num: sign * num / g, den: den.abs() / g }
    }

    pub fn neg(self) -> Self {
        Self { num: -self.num, den: self.den }
    }

    pub fn add(self, rhs: Self) -> Self {
        Self::new(self.num * rhs.den + rhs.num * self.den, self.den * rhs.den)
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct Contact {
    pub coord: u64,
    pub value: Rat,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct State {
    pub d: u64,
    pub active: Vec<Contact>,
}

impl State {
    pub fn check_sparsity(&self) -> bool {
        self.active.len() as u128 <= (self.d as u128).pow(3)
    }
}

pub fn scalar_mass(xs: &[Contact]) -> Rat {
    xs.iter().fold(Rat::new(0, 1), |acc, x| acc.add(x.value))
}

pub fn erase_once(xs: &[Contact], target: Contact) -> Vec<Contact> {
    let mut removed = false;
    let mut out = Vec::with_capacity(xs.len());
    for item in xs {
        if !removed && *item == target {
            removed = true;
        } else {
            out.push(*item);
        }
    }
    out
}

pub fn kink_target(c: u64, a: Rat, s: &State) -> Vec<Contact> {
    let first = erase_once(&s.active, Contact { coord: c, value: a });
    erase_once(&first, Contact { coord: c, value: a.neg() })
}

pub fn kink_step_check(c: u64, a: Rat, s: &State, t: &State) -> bool {
    let positive = Contact { coord: c, value: a };
    let negative = Contact { coord: c, value: a.neg() };
    let after_first = erase_once(&s.active, positive);
    s.d == t.d
        && s.check_sparsity()
        && t.check_sparsity()
        && s.active.contains(&positive)
        && after_first.contains(&negative)
        && t.active == erase_once(&after_first, negative)
        && scalar_mass(&s.active) == scalar_mass(&t.active)
}

pub fn flat_decode(s: &State) -> bool {
    s.active.is_empty()
}

pub fn demo() -> bool {
    let r = |n| Rat::new(n, 1);
    let contact = |coord, value| Contact { coord, value: r(value) };
    let s0 = State { d: 3, active: vec![contact(0, 3), contact(0, -3), contact(1, 5), contact(1, -5), contact(2, 7), contact(2, -7)] };
    let s1 = State { d: 3, active: vec![contact(1, 5), contact(1, -5), contact(2, 7), contact(2, -7)] };
    let s2 = State { d: 3, active: vec![contact(2, 7), contact(2, -7)] };
    let s3 = State { d: 3, active: vec![] };
    kink_step_check(0, r(3), &s0, &s1)
        && kink_step_check(1, r(5), &s1, &s2)
        && kink_step_check(2, r(7), &s2, &s3)
        && flat_decode(&s3)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn demo_accepts() {
        assert!(demo());
    }

    #[test]
    fn bad_trace_rejects() {
        let r = |n| Rat::new(n, 1);
        let contact = |coord, value| Contact { coord, value: r(value) };
        let s0 = State { d: 3, active: vec![contact(0, 3), contact(0, -3), contact(1, 5), contact(1, -5)] };
        let bad = State { d: 3, active: vec![] };
        assert!(!kink_step_check(0, r(3), &s0, &bad));
    }
}
