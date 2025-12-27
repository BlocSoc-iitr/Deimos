# Cairo-M Automated Pipeline

This project demonstrates how to programmatically compile, execute, prove, and verify **Cairo-M** programs (`.cm`) using Rust. It leverages the `cairo-m` compiler and prover crates directly, avoiding the need for external CLI steps.

## Prerequisites

- **Rust**: Nightly toolchain (e.g., `nightly-2025-04-06`)
- **Dependencies**: The project depends on the [cairo-m](https://github.com/AnInsaneJimJam/cairo-m) fork (or your specific fork).

## Project Structure

- **`circuits/`**: Contains the source Cairo-M assembly files (e.g., `sha256.cm`).
- **`compiled/`**: Directory where the compiled program JSON artifacts are saved.
- **`src/main.rs`**: The main automation script that runs the full pipeline.

## Usage

To run the full pipeline (Compile → Run → Prove → Verify):

```bash
cargo run
```

### What happens under the hood?

1.  **Compilation**:
    - Reads `circuits/sha256.cm`.
    - Invokes `cairo_m_compiler::compile_cairo` to compile the source code in-memory.
    - Saves the compiled `Program` to `compiled/cairo_sha256.json`.

2.  **Execution (Runner)**:
    - Loads the compiled program.
    - Sets up inputs (e.g., a 512-bit padded message for SHA256).
    - Runs the VM to generate an execution trace.

3.  **Proving**:
    - Converts the execution trace into prover input.
    - Generates a STARK proof using the `stwo-prover` backend.

4.  **Verification**:
    - Verifies the generated proof against the program and public inputs.
    - Prints "Proof verified successfully" on success.

## Customization

To benchmark your own circuits:
1.  Place your `.cm` file in `circuits/`.
2.  Update `source_path` in `src/main.rs`.
3.  Adjust the `args` (inputs) in `main.rs` to match your program's expected memory layout.
