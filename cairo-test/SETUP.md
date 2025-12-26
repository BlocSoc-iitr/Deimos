# Cairo-M Project Setup Guide

This guide covers setting up a Rust project that uses Cairo-M for provable computation.

## Prerequisites

### 1. Install Rust Nightly Toolchain

Cairo-M requires a specific nightly version due to its dependency on `stwo-prover`:

```bash
rustup install nightly-2025-04-06
```

### 2. Clone & Build Cairo-M Compiler

```bash
# Clone with submodules (stwo is a git submodule)
git clone --recurse-submodules https://github.com/kkrt-labs/cairo-m.git ~/cairo-m
cd ~/cairo-m

# Initialize submodules if not already done
git submodule update --init --recursive

# Install the compiler (uses rust-toolchain.toml automatically)
cargo install --path crates/compiler
```

This installs `cairo-m-compiler` to your Cargo bin directory.

---

## Project Configuration

### rust-toolchain.toml

Create this file in your project root to ensure the correct Rust version:

```toml
[toolchain]
channel = "nightly-2025-04-06"
```

### Cargo.toml

```toml
[package]
name = "your-project"
version = "0.1.0"
edition = "2021"

[dependencies]
cairo-m-runner = { git = "https://github.com/kkrt-labs/cairo-m", package = "cairo-m-runner" }
cairo-m-prover = { git = "https://github.com/kkrt-labs/cairo-m", package = "cairo-m-prover" }
cairo-m-common = { git = "https://github.com/kkrt-labs/cairo-m", package = "cairo-m-common" }
stwo-prover = { git = "https://github.com/starkware-libs/stwo", rev = "ab57a1c", features = ["parallel"] }
serde_json = "1.0"
anyhow = "1.0"

# Required: Patch zkhash to use fork with M31 field support
[patch."https://github.com/HorizenLabs/poseidon2.git"]
zkhash = { git = "https://github.com/AntoineFONDEUR/poseidon2.git", branch = "poseidon2-M31" }
```

> **Important**: The `zkhash` patch is required because cairo-m-prover depends on a fork with M31 field operations that aren't in the upstream repository.

---

## Workflow

### 1. Compile Cairo-M Programs

```bash
cairo-m-compiler -i circuits/your_program.cm -o compiled/your_program.json
```

### 2. Run & Prove

```rust
use cairo_m_common::{InputValue, Program};
use cairo_m_prover::adapter::import_from_runner_output;
use cairo_m_prover::prover::prove_cairo_m;
use cairo_m_prover::verifier::verify_cairo_m;
use cairo_m_runner::{run_cairo_program, RunnerOptions};
use stwo_prover::core::vcs::blake2_merkle::Blake2sMerkleChannel;

// Load compiled program
let json = std::fs::read_to_string("compiled/your_program.json")?;
let program: Program = serde_json::from_str(&json)?;

// Run
let runner_output = run_cairo_program(
    &program,
    "entrypoint_name",
    &args,
    RunnerOptions::default(),
)?;

// Prove
let mut prover_input = import_from_runner_output(
    runner_output.vm.segments.into_iter().next().unwrap(),
    runner_output.public_address_ranges,
)?;
let proof = prove_cairo_m::<Blake2sMerkleChannel>(&mut prover_input, None)?;

// Verify
verify_cairo_m::<Blake2sMerkleChannel>(proof, None)?;
```

---

## Troubleshooting

### "feature may not be used on stable"
You're using stable Rust. Ensure `rust-toolchain.toml` exists in your project root with `channel = "nightly-2025-04-06"`.

### "no matching package named stwo-prover"
Pin the revision in your dependency: `rev = "ab57a1c"`.

### "unresolved import poseidon2_instance_m31"
Add the `[patch."https://github.com/HorizenLabs/poseidon2.git"]` section to your Cargo.toml.

### "Entry point not found"
Check available entry points in the error message. Use the exact function name from your `.cm` file.
