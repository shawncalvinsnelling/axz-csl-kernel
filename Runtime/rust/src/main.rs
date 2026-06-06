fn main() {
    let ok = axz_csl_runtime::demo();
    println!("AXZ-CSL Rust runtime demo ACCEPT={ok}");
    if !ok {
        std::process::exit(1);
    }
}
