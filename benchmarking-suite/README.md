# Deimos Benchmarking Suite

Mobile zkVM benchmarking platform built by BlocSoc IITR. Measures proof generation and verification times for multiple ZK proving systems on Android and iOS via Flutter.

## Workspace Structure

```
benchmarking-suite/
├── frameworks/               # Circuit source files (non-Rust)
│   ├── groth16/              # Circom circuits for Groth16 proving
│   ├── barretenberg/         # Noir circuits for Barretenberg (UltraHonk)
│   └── cairo-m/              # Cairo-M example program
│
└── moPro/                    # Rust workspace
    ├── Cargo.toml            # Workspace root
    ├── mopro-example-app/    # Main FFI library (UniFFI → Flutter)
    │   └── src/
    │       ├── lib.rs            # Crate entry, all backend exports
    │       ├── groth16.rs        # Groth16 (Arkworks/Circom) backend
    │       ├── barretenberg.rs   # Barretenberg (Noir/UltraHonk) backend
    │       ├── error.rs          # Shared MoproError type
    │       └── stubs.rs          # Feature-gated FFI stubs
    ├── cairo-m-prover/       # Cairo-M STARK prover library
    ├── provekit-wrapper/     # ProveKit prover wrapper
    └── risc0-circuit/        # RISC0 zkVM guest + host
```

## Backends

| Name | Proving System | Feature Flag |
|------|---------------|--------------|
| groth16 | Groth16 via Arkworks | `groth16` (default) |
| barretenberg | UltraHonk via Barretenberg | `barretenberg` (default) |
| cairo_m | STARKs via Stwo (M31 field) | `cairo_m` (default) |
| provekit | ProveKit accelerated Noir | `provekit` (default) |
| risc0 | RISC0 zkVM | always enabled |

## Building

Prerequisites: Rust 1.85+, the RISC0 toolchain, and the platform SDKs for your target.

```bash
# Build for the host (dev/test)
cd moPro
cargo build

# Build with only specific backends
cargo build --no-default-features --features groth16,cairo_m

# Run unit tests (host)
cargo test
```

For cross-compilation to Android/iOS, use `mopro build` with the `Config.toml` in `moPro/`.

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for a full technical reference covering:
- Stack overview (Flutter → UniFFI → Rust → proving backends)
- FFI binding layer (RustBuffer, FfiConverter, JNA, C headers)
- Complete call stack trace for a proof generation request
- Per-backend proof system flows
- Feature flags and backend naming convention
- Memory ownership rules

## Backend Naming Convention

Backends are named after their **proving system**, not the circuit language. See [ARCHITECTURE.md §9](ARCHITECTURE.md#9-backend-naming-convention) for the full rationale and naming table.
