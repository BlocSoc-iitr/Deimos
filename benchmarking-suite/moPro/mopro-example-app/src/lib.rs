//! Deimos benchmarking-suite FFI entry point.
//!
//! Exposes proving/verifying functions for the following backends to Flutter
//! via [UniFFI](https://mozilla.github.io/uniffi-rs/):
//!
//! | Feature flag   | Proving system                        |
//! |----------------|---------------------------------------|
//! | `groth16`      | Groth16 via Arkworks (Circom circuits)|
//! | `barretenberg` | UltraHonk via Barretenberg (Noir)     |
//! | `cairo_m`      | STARKs via Stwo (Cairo-M)             |
//! | `provekit`     | ProveKit accelerated Noir             |
//! | _(always on)_  | RISC0 zkVM                            |

use methods::{RISC0_CIRCUIT_ELF, RISC0_CIRCUIT_ID};
#[cfg(feature = "cairo_m")]
use cairo_m_prover::{prove, verify};
use risc0_zkvm::{default_prover, ExecutorEnv, Receipt};


// Initializes the shared UniFFI scaffolding and defines the `MoproError` enum.
mopro_ffi::app!();

/// Returns a simple greeting string to verify FFI connectivity.
#[uniffi::export]
fn mopro_uniffi_hello_world() -> String {
    "Hello, World!".to_string()
}

#[macro_use]
mod stubs;

mod error;
pub use error::MoproError;

// ==============================================================================
// GROTH16 (CIRCOM) BACKEND
// ==============================================================================

#[cfg(feature = "groth16")]
#[macro_use]
mod groth16;

#[cfg(feature = "groth16")]
mod rapidsnark;

// Witness macro expects the file name without special characters.
// Each call generates a `<name>_witness` function used in the circuit registry.
#[cfg(feature = "groth16")]
rust_witness::witness!(blake2s25616);
#[cfg(feature = "groth16")]
rust_witness::witness!(blake2s25632);
#[cfg(feature = "groth16")]
rust_witness::witness!(blake2s25664);
#[cfg(feature = "groth16")]
rust_witness::witness!(blake2s256128);

#[cfg(feature = "groth16")]
rust_witness::witness!(blake316);
#[cfg(feature = "groth16")]
rust_witness::witness!(blake332);
#[cfg(feature = "groth16")]
rust_witness::witness!(blake364);
#[cfg(feature = "groth16")]
rust_witness::witness!(blake3128);

#[cfg(feature = "groth16")]
rust_witness::witness!(keccak25616);
#[cfg(feature = "groth16")]
rust_witness::witness!(keccak25632);
#[cfg(feature = "groth16")]
rust_witness::witness!(keccak25664);
#[cfg(feature = "groth16")]
rust_witness::witness!(keccak256128);

#[cfg(feature = "groth16")]
rust_witness::witness!(sha25616);
#[cfg(feature = "groth16")]
rust_witness::witness!(sha25632);
#[cfg(feature = "groth16")]
rust_witness::witness!(sha25664);
#[cfg(feature = "groth16")]
rust_witness::witness!(sha256128);

#[cfg(feature = "groth16")]
rust_witness::witness!(pedersen16);
#[cfg(feature = "groth16")]
rust_witness::witness!(pedersen32);
#[cfg(feature = "groth16")]
rust_witness::witness!(pedersen64);
#[cfg(feature = "groth16")]
rust_witness::witness!(pedersen128);

#[cfg(feature = "groth16")]
rust_witness::witness!(mimc25616f);
#[cfg(feature = "groth16")]
rust_witness::witness!(mimc25632f);
#[cfg(feature = "groth16")]
rust_witness::witness!(mimc25664f);
#[cfg(feature = "groth16")]
rust_witness::witness!(mimc256128f);

#[cfg(feature = "groth16")]
rust_witness::witness!(poseidon16f);
#[cfg(feature = "groth16")]
rust_witness::witness!(poseidon32f);
#[cfg(feature = "groth16")]
rust_witness::witness!(poseidon64f);
#[cfg(feature = "groth16")]
rust_witness::witness!(poseidon128f);

#[cfg(feature = "groth16")]
rust_witness::witness!(rescueprime16f);
#[cfg(feature = "groth16")]
rust_witness::witness!(rescueprime32f);
#[cfg(feature = "groth16")]
rust_witness::witness!(rescueprime64f);
#[cfg(feature = "groth16")]
rust_witness::witness!(rescueprime128f);

#[cfg(feature = "groth16")]
set_groth16_circuits! {
    ("blake2s256_16.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s25616_witness)),
    ("blake2s256_32.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s25632_witness)),
    ("blake2s256_64.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s25664_witness)),
    ("blake2s256_128.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s256128_witness)),

    ("blake3_16.zkey", circom_prover::witness::WitnessFn::RustWitness(blake316_witness)),
    ("blake3_32.zkey", circom_prover::witness::WitnessFn::RustWitness(blake332_witness)),
    ("blake3_64.zkey", circom_prover::witness::WitnessFn::RustWitness(blake364_witness)),
    ("blake3_128.zkey", circom_prover::witness::WitnessFn::RustWitness(blake3128_witness)),

    ("keccak256_16.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak25616_witness)),
    ("keccak256_32.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak25632_witness)),
    ("keccak256_64.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak25664_witness)),
    ("keccak256_128.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak256128_witness)),

    ("sha256_16.zkey", circom_prover::witness::WitnessFn::RustWitness(sha25616_witness)),
    ("sha256_32.zkey", circom_prover::witness::WitnessFn::RustWitness(sha25632_witness)),
    ("sha256_64.zkey", circom_prover::witness::WitnessFn::RustWitness(sha25664_witness)),
    ("sha256_128.zkey", circom_prover::witness::WitnessFn::RustWitness(sha256128_witness)),

    ("pedersen_16.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen16_witness)),
    ("pedersen_32.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen32_witness)),
    ("pedersen_64.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen64_witness)),
    ("pedersen_128.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen128_witness)),

    ("mimc256_16f.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc25616f_witness)),
    ("mimc256_32f.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc25632f_witness)),
    ("mimc256_64f.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc25664f_witness)),
    ("mimc256_128f.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc256128f_witness)),

    ("poseidon_16f.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon16f_witness)),
    ("poseidon_32f.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon32f_witness)),
    ("poseidon_64f.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon64f_witness)),
    ("poseidon_128f.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon128f_witness)),

    ("rescue-prime_16f.zkey", circom_prover::witness::WitnessFn::RustWitness(rescueprime16f_witness)),
    ("rescue-prime_32f.zkey", circom_prover::witness::WitnessFn::RustWitness(rescueprime32f_witness)),
    ("rescue-prime_64f.zkey", circom_prover::witness::WitnessFn::RustWitness(rescueprime64f_witness)),
    ("rescue-prime_128f.zkey", circom_prover::witness::WitnessFn::RustWitness(rescueprime128f_witness)),
}

// ==============================================================================
// BARRETENBERG (NOIR) BACKEND
// ==============================================================================

#[cfg(feature = "barretenberg")]
mod barretenberg;

#[cfg(all(test, feature = "barretenberg"))]
mod barretenberg_tests {
    use super::barretenberg::{
        generate_barretenberg_proof, get_barretenberg_verification_key, verify_barretenberg_proof,
    };
    use serial_test::serial;

    #[test]
    #[serial]
    fn test_barretenberg_multiplier2() {
        let srs_path = "./test-vectors/noir/noir_multiplier2.srs".to_string();
        let circuit_path = "./test-vectors/noir/noir_multiplier2.json".to_string();
        let circuit_inputs = vec!["3".to_string(), "5".to_string()];
        let vk = get_barretenberg_verification_key(
            circuit_path.clone(),
            Some(srs_path.clone()),
            true,  // on_chain: uses Keccak for Solidity compatibility
            false, // low_memory_mode
        )
        .unwrap();

        let proof = generate_barretenberg_proof(
            circuit_path.clone(),
            Some(srs_path.clone()),
            circuit_inputs.clone(),
            true,  // on_chain
            vk.clone(),
            false, // low_memory_mode
        )
        .unwrap();

        let valid = verify_barretenberg_proof(
            circuit_path,
            proof,
            true, // on_chain
            vk,
            false,
        )
        .unwrap();
        assert!(valid);
    }

    #[test]
    #[serial]
    fn test_barretenberg_multiplier2_with_existing_vk() {
        let srs_path = "./test-vectors/noir/noir_multiplier2.srs".to_string();
        let circuit_path = "./test-vectors/noir/noir_multiplier2.json".to_string();
        let vk_path = "./test-vectors/noir/noir_multiplier2.vk".to_string();

        let vk = std::fs::read(vk_path).unwrap();
        let circuit_inputs = vec!["3".to_string(), "5".to_string()];

        let proof = generate_barretenberg_proof(
            circuit_path.clone(),
            Some(srs_path),
            circuit_inputs,
            true,  // on_chain
            vk.clone(),
            false,
        )
        .unwrap();

        let valid = verify_barretenberg_proof(circuit_path, proof, true, vk, false).unwrap();
        assert!(valid);
    }
}


#[cfg(test)]
mod uniffi_tests {
    #[test]
    fn test_mopro_uniffi_hello_world() {
        assert_eq!(super::mopro_uniffi_hello_world(), "Hello, World!");
    }
}


// ==============================================================================
// RISC0 BACKEND
// ==============================================================================

/// Error type for the RISC0 zkVM backend.
#[derive(uniffi::Error, thiserror::Error, Debug)]
pub enum Risc0Error {
    /// Proof generation failed.
    #[error("Failed to prove: {0}")]
    ProveError(String),
    /// Receipt serialization or deserialization failed.
    #[error("Failed to serialize receipt: {0}")]
    SerializeError(String),
    /// Proof verification failed.
    #[error("Failed to verify: {0}")]
    VerifyError(String),
    /// Journal decoding failed.
    #[error("Failed to decode journal: {0}")]
    DecodeError(String),
}

/// Output of a RISC0 proof generation call.
#[derive(uniffi::Record, Clone)]
pub struct Risc0ProofOutput {
    /// Serialized RISC0 receipt bytes.
    pub receipt: Vec<u8>,
}

/// Output of a RISC0 proof verification call.
#[derive(uniffi::Record, Clone)]
pub struct Risc0VerifyOutput {
    /// Whether the proof is valid.
    pub is_valid: bool,
    /// The u32 output value committed in the journal.
    pub output_value: u32,
}

/// Generates a RISC0 zkVM proof for a u32 input.
///
/// # Arguments
/// - `input`: a u32 value written to the zkVM executor environment
///
/// # Returns
/// `Ok(Risc0ProofOutput)` with the serialized receipt, or a `Risc0Error`.
#[uniffi::export]
pub fn risc0_prove(input: u32) -> Result<Risc0ProofOutput, Risc0Error> {
    let env = ExecutorEnv::builder()
        .write(&input)
        .map_err(|e| Risc0Error::ProveError(format!("Failed to write input: {}", e)))?
        .build()
        .map_err(|e| {
            Risc0Error::ProveError(format!("Failed to build executor environment: {}", e))
        })?;

    let prover = default_prover();

    let prove_info = prover
        .prove(env, RISC0_CIRCUIT_ELF)
        .map_err(|e| Risc0Error::ProveError(format!("Failed to generate proof: {}", e)))?;

    let receipt = prove_info.receipt;

    let receipt_bytes = bincode::serialize(&receipt)
        .map_err(|e| Risc0Error::SerializeError(format!("Failed to serialize receipt: {}", e)))?;

    Ok(Risc0ProofOutput {
        receipt: receipt_bytes,
    })
}

/// Verifies a RISC0 zkVM proof and extracts the journal output.
///
/// # Arguments
/// - `receipt_bytes`: serialized RISC0 receipt produced by `risc0_prove`
///
/// # Returns
/// `Ok(Risc0VerifyOutput)` with validation result and output value, or a `Risc0Error`.
#[uniffi::export]
pub fn risc0_verify(receipt_bytes: Vec<u8>) -> Result<Risc0VerifyOutput, Risc0Error> {
    let receipt: Receipt = bincode::deserialize(&receipt_bytes)
        .map_err(|e| Risc0Error::SerializeError(format!("Failed to deserialize receipt: {}", e)))?;

    receipt
        .verify(RISC0_CIRCUIT_ID)
        .map_err(|e| Risc0Error::VerifyError(format!("Failed to verify receipt: {}", e)))?;

    let output_value: u32 = receipt
        .journal
        .decode()
        .map_err(|e| Risc0Error::DecodeError(format!("Failed to decode journal: {}", e)))?;

    Ok(Risc0VerifyOutput {
        is_valid: true,
        output_value,
    })
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_risc0_prove_success() {
        let input = 42u32;
        let result = risc0_prove(input);
        assert!(result.is_ok(), "Proving should succeed for valid input");
        let proof_output = result.unwrap();
        assert!(!proof_output.receipt.is_empty(), "Receipt should not be empty");
    }

    #[test]
    fn test_risc0_verify_success() {
        let input = 123u32;
        let prove_result = risc0_prove(input);
        assert!(prove_result.is_ok(), "Proving should succeed");
        let proof_output = prove_result.unwrap();

        let verify_result = risc0_verify(proof_output.receipt);
        assert!(verify_result.is_ok(), "Verification should succeed for valid proof");

        let verify_output = verify_result.unwrap();
        assert!(verify_output.is_valid, "Proof should be valid");
        assert_eq!(verify_output.output_value, input, "Output value should match input");
    }

    #[test]
    fn test_prove_verify_roundtrip() {
        let test_inputs = [0u32, 42u32, 100u32, 1000u32, u32::MAX];
        for &input in &test_inputs {
            let prove_result = risc0_prove(input);
            assert!(prove_result.is_ok(), "Proving should succeed for input: {}", input);

            let proof_output = prove_result.unwrap();
            let verify_result = risc0_verify(proof_output.receipt);
            assert!(verify_result.is_ok(), "Verification should succeed for input: {}", input);

            let verify_output = verify_result.unwrap();
            assert!(verify_output.is_valid, "Proof should be valid for input: {}", input);
            assert_eq!(verify_output.output_value, input, "Output should match input: {}", input);
        }
    }
}

// ==============================================================================
// CAIRO-M BACKEND
// ==============================================================================

/// Error type for the Cairo-M (Stwo STARKs) backend.
#[cfg(feature = "cairo_m")]
#[derive(uniffi::Error, thiserror::Error, Debug)]
pub enum CairoError {
    /// Proof generation failed.
    #[error("Failed to prove: {0}")]
    ProveError(String),
    /// Proof verification failed.
    #[error("Failed to verify: {0}")]
    VerifyError(String),
    /// Proof serialization or deserialization failed.
    #[error("Serialization error: {0}")]
    SerializeError(String),
}

/// Output of a Cairo-M proof generation call.
#[cfg(feature = "cairo_m")]
#[derive(uniffi::Record, Clone)]
pub struct CairoProofOutput {
    /// Serialized proof bytes.
    pub proof: Vec<u8>,
}

/// Output of a Cairo-M proof verification call.
#[cfg(feature = "cairo_m")]
#[derive(uniffi::Record, Clone)]
pub struct CairoVerifyOutput {
    /// Whether the proof is valid.
    pub is_valid: bool,
}

/// Generates a Cairo-M STARK proof for a compiled Cairo program.
///
/// # Arguments
/// - `program_json`: JSON-encoded Cairo-M program
/// - `inputs_json`: JSON-encoded program inputs
///
/// # Returns
/// `Ok(CairoProofOutput)` with serialized proof, or a `CairoError`.
#[cfg(feature = "cairo_m")]
#[uniffi::export]
pub fn cairo_prove(program_json: String, inputs_json: String, entrypoint: String) -> Result<CairoProofOutput, CairoError> {
    let proof = prove(&program_json, &inputs_json, &entrypoint)
        .map_err(|e| CairoError::ProveError(e.to_string()))?;
    Ok(CairoProofOutput { proof })
}

/// Verifies a Cairo-M STARK proof.
///
/// # Arguments
/// - `proof`: serialized proof bytes produced by `cairo_prove`
///
/// # Returns
/// `Ok(CairoVerifyOutput)` with validation result, or a `CairoError`.
#[cfg(feature = "cairo_m")]
#[uniffi::export]
pub fn cairo_verify(proof: Vec<u8>) -> Result<CairoVerifyOutput, CairoError> {
    let is_valid = verify(&proof)
        .map_err(|e| CairoError::VerifyError(e.to_string()))?;
    Ok(CairoVerifyOutput { is_valid })
}

#[cfg(all(test, feature = "cairo_m"))]
mod cairo_tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_cairo_prove_verify_sha256() {
        let inputs_json = r#"[
            [1633837952, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24],
            1
        ]"#.to_string();

        let program_json = fs::read_to_string("test-vectors/cairo-m/cairo_sha256.json")
            .expect("Failed to read cairo_sha256.json");

        println!("Generating proof...");
        let prove_result = cairo_prove(program_json, inputs_json, "sha256_hash".to_string());
        if let Err(e) = &prove_result {
            println!("Proving failed: {:?}", e);
        }
        assert!(prove_result.is_ok(), "Proving should succeed");

        let proof_output = prove_result.unwrap();
        println!("Proof generated. Size: {} bytes", proof_output.proof.len());

        let verify_result = cairo_verify(proof_output.proof);
        assert!(verify_result.is_ok(), "Verification should succeed: {:?}", verify_result.err());
        assert!(verify_result.unwrap().is_valid, "Proof should be valid");
    }
}

// ==============================================================================
// PROVEKIT BACKEND
// ==============================================================================

#[cfg(feature = "provekit")]
use provekit_wrapper::{prove as _provekit_prove, verify as _provekit_verify};

/// Error type for the ProveKit backend.
#[cfg(feature = "provekit")]
#[derive(uniffi::Error, thiserror::Error, Debug)]
pub enum ProveKitError {
    /// Proof generation failed.
    #[error("Failed to prove: {0}")]
    ProveError(String),
    /// Proof verification failed.
    #[error("Failed to verify: {0}")]
    VerifyError(String),
}

/// Output of a ProveKit proof generation call.
#[cfg(feature = "provekit")]
#[derive(uniffi::Record, Clone)]
pub struct ProveKitProofOutput {
    /// Serialized proof bytes.
    pub proof: Vec<u8>,
}

/// Output of a ProveKit proof verification call.
#[cfg(feature = "provekit")]
#[derive(uniffi::Record, Clone)]
pub struct ProveKitVerifyOutput {
    /// Whether the proof is valid.
    pub is_valid: bool,
}

/// Generates a ProveKit proof using a compiled prover key.
///
/// # Arguments
/// - `prover_path`: path to the `.pkp` prover key file
/// - `input_toml`: TOML-encoded circuit inputs
///
/// # Returns
/// `Ok(ProveKitProofOutput)` with serialized proof, or a `ProveKitError`.
#[cfg(feature = "provekit")]
#[uniffi::export]
pub fn provekit_prove(prover_path: String, input_toml: String) -> Result<ProveKitProofOutput, ProveKitError> {
    let proof = _provekit_prove(&prover_path, &input_toml)
        .map_err(|e| ProveKitError::ProveError(format!("{:?}", e)))?;
    Ok(ProveKitProofOutput { proof })
}

/// Verifies a ProveKit proof using a compiled verifier key.
///
/// # Arguments
/// - `verifier_path`: path to the `.pkv` verifier key file
/// - `proof`: serialized proof bytes produced by `provekit_prove`
///
/// # Returns
/// `Ok(ProveKitVerifyOutput)` with validation result, or a `ProveKitError`.
#[cfg(feature = "provekit")]
#[uniffi::export]
pub fn provekit_verify(verifier_path: String, proof: Vec<u8>) -> Result<ProveKitVerifyOutput, ProveKitError> {
    let is_valid = _provekit_verify(&verifier_path, &proof)
        .map_err(|e| ProveKitError::VerifyError(format!("{:?}", e)))?;
    Ok(ProveKitVerifyOutput { is_valid })
}

#[cfg(all(test, feature = "provekit"))]
mod provekit_tests {
    use super::*;
    use std::path::PathBuf;

    #[test]
    fn test_provekit_prove_verify_mimc() {
        let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
        let pkp_path = manifest_dir.join("test-vectors/provekit/mimc_field_1.pkp");
        let pkv_path = manifest_dir.join("test-vectors/provekit/mimc_field_1.pkv");

        assert!(pkp_path.exists(), "Prover key not found at {:?}", pkp_path);
        assert!(pkv_path.exists(), "Verifier key not found at {:?}", pkv_path);

        let input_toml = r#"
            input = ["123"]
        "#.to_string();

        println!("Generating ProveKit proof...");
        let prove_result = provekit_prove(pkp_path.to_string_lossy().to_string(), input_toml);
        assert!(prove_result.is_ok(), "Proving failed: {:?}", prove_result.err());

        let proof_output = prove_result.unwrap();
        println!("Proof generated. Size: {} bytes", proof_output.proof.len());

        let verify_result = provekit_verify(pkv_path.to_string_lossy().to_string(), proof_output.proof);
        assert!(verify_result.is_ok(), "Verification failed: {:?}", verify_result.err());
        assert!(verify_result.unwrap().is_valid, "Proof should be valid");
    }
}
