fn main() {
    // ==============================================================================
    // CIRCOM TEMPLATE (Uncomment to build for Circom)
    // ==============================================================================
    let dir = "./test-vectors/circom";
    rust_witness::transpile::transpile_wasm(dir.to_string());
}
