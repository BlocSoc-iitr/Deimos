fn main() {
    // ==============================================================================
    // CIRCOM
    // ==============================================================================
    let dir = "./test-vectors/circom";
    rust_witness::transpile::transpile_wasm(dir.to_string());

    // Manual compilation of the generated C++ files if they exist (witnesscalc)
    // This fixes "Undefined symbol" errors when rust-witness fails to link correctly
    let witnesscalc_dir = std::path::Path::new(dir).join("witnesscalc");
    if witnesscalc_dir.exists() {
        let mut build = cc::Build::new();
        build.cpp(true);
        build.define("W2C2_LOOP_START", Some(""));
        
        // Collect C++ files
        let paths = std::fs::read_dir(&witnesscalc_dir).unwrap();
        let mut has_cpp = false;
        for path in paths {
            let path = path.unwrap().path();
            if path.extension().map_or(false, |e| e == "cpp") {
                build.file(&path);
                has_cpp = true;
                println!("cargo:warning=Compiling witness file: {:?}", path);
            }
        }
        
        if has_cpp {
             build.compile("witnesses"); 
             println!("cargo:rustc-link-lib=static=witnesses");
        }
    }

    // ==============================================================================
    // RISC0
    // ==============================================================================
    // Embed methods from the risc0-circuit crate
    // This requires "methods" dependency in Cargo.toml
    // methods = { path = "../risc0-circuit/methods" }
    // Check if methods crate exists before trying to build
    if std::path::Path::new("../risc0-circuit/methods").exists() {
       println!("cargo:warning=Building Risc0 methods...");
       // Note: In some Mopro setups, this might be handled by the dependency itself.
       // But if we are embedding them, we usually don't need explicit build.rs code 
       // unless we are compiling guests here. 
       // The `methods` crate build.rs usually handles guest compilation.
    }
}
