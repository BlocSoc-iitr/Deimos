//! Feature-gated stubs for optional backends.
//!
//! When a backend feature is disabled at compile time, UniFFI still requires
//! that the exported function symbols exist. These macros generate stub
//! implementations that panic with a descriptive message at runtime if called.
//!
//! Usage: invoke the appropriate stub macro in `lib.rs` inside a
//! `#[cfg(not(feature = "..."))]` block.

/// Generates stub implementations for the Groth16 (circom-prover) backend.
///
/// Invoke with `groth16_stub!()` when the `groth16` feature is not enabled.
#[macro_export]
macro_rules! groth16_stub {
    () => {
        mod groth16_stub {
            use crate::error::MoproError;

            #[derive(uniffi::Record)]
            pub struct Groth16ProofResult {
                pub proof: Groth16Proof,
                pub inputs: Vec<String>,
            }

            #[derive(uniffi::Record)]
            pub struct G1 {
                pub x: String,
                pub y: String,
                pub z: String,
            }

            #[derive(uniffi::Record)]
            pub struct G2 {
                pub x: Vec<String>,
                pub y: Vec<String>,
                pub z: Vec<String>,
            }

            #[derive(uniffi::Record)]
            pub struct Groth16Proof {
                pub a: G1,
                pub b: G2,
                pub c: G1,
                pub protocol: String,
                pub curve: String,
            }

            #[derive(uniffi::Enum)]
            pub enum ProofLib {
                Arkworks,
                Rapidsnark,
            }

            #[uniffi::export]
            pub(crate) fn generate_groth16_proof(
                _zkey_path: String,
                _circuit_inputs: String,
                _proof_lib: ProofLib,
            ) -> Result<Groth16ProofResult, MoproError> {
                panic!("Groth16 backend is not enabled. Enable the `groth16` feature to use this.");
            }

            #[uniffi::export]
            pub(crate) fn verify_groth16_proof(
                _zkey_path: String,
                _proof_result: Groth16ProofResult,
                _proof_lib: ProofLib,
            ) -> Result<bool, MoproError> {
                panic!("Groth16 backend is not enabled. Enable the `groth16` feature to use this.");
            }
        }
    };
}

/// Generates stub implementations for the Barretenberg (noir_rs) backend.
///
/// Invoke with `barretenberg_stub!()` when the `barretenberg` feature is not enabled.
#[macro_export]
macro_rules! barretenberg_stub {
    () => {
        mod barretenberg_stub {
            use crate::error::MoproError;

            #[uniffi::export]
            pub(crate) fn generate_barretenberg_proof(
                _circuit_path: String,
                _srs_path: Option<String>,
                _inputs: Vec<String>,
                _on_chain: bool,
                _vk: Vec<u8>,
                _low_memory_mode: bool,
            ) -> Result<Vec<u8>, MoproError> {
                panic!("Barretenberg backend is not enabled. Enable the `barretenberg` feature to use this.");
            }

            #[uniffi::export]
            pub(crate) fn verify_barretenberg_proof(
                _circuit_path: String,
                _proof: Vec<u8>,
                _on_chain: bool,
                _vk: Vec<u8>,
                _low_memory_mode: bool,
            ) -> Result<bool, MoproError> {
                panic!("Barretenberg backend is not enabled. Enable the `barretenberg` feature to use this.");
            }

            #[uniffi::export]
            pub(crate) fn get_barretenberg_verification_key(
                _circuit_path: String,
                _srs_path: Option<String>,
                _on_chain: bool,
                _low_memory_mode: bool,
            ) -> Result<Vec<u8>, MoproError> {
                panic!("Barretenberg backend is not enabled. Enable the `barretenberg` feature to use this.");
            }
        }
    };
}
