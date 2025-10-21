fn main() {
    // CIRCOM_TEMPLATE

    rust_witness::transpile::transpile_wasm("./test-vectors/circom".to_string());
    
}
