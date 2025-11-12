use methods::{RISC0_CIRCUIT_ELF, RISC0_CIRCUIT_ID};
use risc0_zkvm::{default_prover, ExecutorEnv, Receipt};

// Initializes the shared UniFFI scaffolding and defines the `MoproError` enum.
mopro_ffi::app!();

/// You can also customize the bindings by #[uniffi::export]
/// Reference: https://mozilla.github.io/uniffi-rs/latest/proc_macro/index.html
#[uniffi::export]
fn mopro_uniffi_hello_world() -> String {
    "Hello, World!".to_string()
}

#[macro_use]
mod stubs;

mod error;
pub use error::MoproError;

// CIRCOM_TEMPLATE
// --- Circom Example of using groth16 proving and verifying circuits ---

// Module containing the Circom circuit logic (Multiplier2)
#[macro_use]
mod circom;

rust_witness::witness!(blake2s256);
rust_witness::witness!(keccak);
rust_witness::witness!(mimc256);
rust_witness::witness!(pedersen);
rust_witness::witness!(poseidon);
rust_witness::witness!(sha256);


set_circom_circuits! {
    ("blake2s256.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s256_witness)),
    ("keccak.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak_witness)),
    ("mimc256.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc256_witness)),
    ("pedersen.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen_witness)),
    ("poseidon.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon_witness)),
    ("sha256.zkey", circom_prover::witness::WitnessFn::RustWitness(sha256_witness)),
}

#[cfg(test)]
mod circom_tests {
    use crate::circom::{generate_circom_proof, verify_circom_proof, ProofLib};

    const ZKEY_PATH: &str = "./test-vectors/circom/mimc256.zkey";

    #[test]
    fn test_circom() {
        let circuit_inputs = r#"{
    "in": [
        "72",
        "101",
        "108",
        "108",
        "111",
        "32",
        "87",
        "111",
        "114",
        "108",
        "100",
        "33",
        "32",
        "84",
        "104",
        "105",
        "115",
        "32",
        "105",
        "115",
        "32",
        "97",
        "32",
        "116",
        "101",
        "115",
        "116",
        "32",
        "109",
        "115",
        "103",
        "46"
    ]
    }"#.to_string();
        let result =
            generate_circom_proof(ZKEY_PATH.to_string(), circuit_inputs, ProofLib::Arkworks);
        assert!(result.is_ok());
        let proof = result.unwrap();
        assert!(verify_circom_proof(ZKEY_PATH.to_string(), proof, ProofLib::Arkworks).is_ok());
    }
}



// HALO2_TEMPLATE
// --- Halo2 Example of using Plonk proving and verifying circuits ---

// Module containing the Halo2 circuit logic (FibonacciMoproCircuit)
#[macro_use]
mod halo2;

set_halo2_circuits! {
    ("plonk_fibonacci_pk.bin", plonk_fibonacci::prove, "plonk_fibonacci_vk.bin", plonk_fibonacci::verify),
    ("hyperplonk_fibonacci_pk.bin", hyperplonk_fibonacci::prove, "hyperplonk_fibonacci_vk.bin", hyperplonk_fibonacci::verify),
    ("gemini_fibonacci_pk.bin", gemini_fibonacci::prove, "gemini_fibonacci_vk.bin", gemini_fibonacci::verify),
}

#[cfg(test)]
mod halo2_tests {
    use crate::halo2::{generate_halo2_proof, verify_halo2_proof};
    use std::collections::HashMap;

    #[test]
    fn test_plonk_fibonacci() {
        let srs_path = "./test-vectors/halo2/plonk_fibonacci_srs.bin".to_string();
        let pk_path = "./test-vectors/halo2/plonk_fibonacci_pk.bin".to_string();
        let vk_path = "./test-vectors/halo2/plonk_fibonacci_vk.bin".to_string();
        let mut circuit_inputs = HashMap::new();
        circuit_inputs.insert("out".to_string(), vec!["55".to_string()]);
        let result = generate_halo2_proof(srs_path.clone(), pk_path.clone(), circuit_inputs);
        assert!(result.is_ok());
        let halo2_proof_result = result.unwrap();
        let valid = verify_halo2_proof(
            srs_path,
            vk_path,
            halo2_proof_result.proof,
            halo2_proof_result.inputs,
        );
        assert!(valid.is_ok());
        assert!(valid.unwrap());
    }

    #[test]
    fn test_hyperplonk_fibonacci() {
        let srs_path = "./test-vectors/halo2/hyperplonk_fibonacci_srs.bin".to_string();
        let pk_path = "./test-vectors/halo2/hyperplonk_fibonacci_pk.bin".to_string();
        let vk_path = "./test-vectors/halo2/hyperplonk_fibonacci_vk.bin".to_string();
        let mut circuit_inputs = HashMap::new();
        circuit_inputs.insert("out".to_string(), vec!["55".to_string()]);
        let result = generate_halo2_proof(srs_path.clone(), pk_path.clone(), circuit_inputs);
        assert!(result.is_ok());
        let halo2_proof_result = result.unwrap();
        let valid = verify_halo2_proof(
            srs_path,
            vk_path,
            halo2_proof_result.proof,
            halo2_proof_result.inputs,
        );
        assert!(valid.is_ok());
        assert!(valid.unwrap());
    }

    #[test]
    fn test_gemini_fibonacci() {
        let srs_path = "./test-vectors/halo2/gemini_fibonacci_srs.bin".to_string();
        let pk_path = "./test-vectors/halo2/gemini_fibonacci_pk.bin".to_string();
        let vk_path = "./test-vectors/halo2/gemini_fibonacci_vk.bin".to_string();
        let mut circuit_inputs = HashMap::new();
        circuit_inputs.insert("out".to_string(), vec!["55".to_string()]);
        let result = generate_halo2_proof(srs_path.clone(), pk_path.clone(), circuit_inputs);
        assert!(result.is_ok());
        let halo2_proof_result = result.unwrap();
        let valid = verify_halo2_proof(
            srs_path,
            vk_path,
            halo2_proof_result.proof,
            halo2_proof_result.inputs,
        );
        assert!(valid.is_ok());
        assert!(valid.unwrap());
    }
}


// NOIR_TEMPLATE
// --- Noir Example of using Ultra Honk proving and verifying circuits ---

// Module containing the Noir circuit logic (Multiplier2)
mod noir;

#[cfg(test)]
mod noir_tests {
    use super::noir::{generate_noir_proof, get_noir_verification_key, verify_noir_proof};
    use serial_test::serial;

    #[test]
    #[serial]
    fn test_noir_multiplier2() {
        let srs_path = "./test-vectors/noir/noir_multiplier2.srs".to_string();
        let circuit_path = "./test-vectors/noir/noir_multiplier2.json".to_string();
        let circuit_inputs = vec!["3".to_string(), "5".to_string()];
        let vk = get_noir_verification_key(
            circuit_path.clone(),
            Some(srs_path.clone()),
            true,  // on_chain (uses Keccak for Solidity compatibility)
            false, // low_memory_mode
        )
        .unwrap();

        let proof = generate_noir_proof(
            circuit_path.clone(),
            Some(srs_path.clone()),
            circuit_inputs.clone(),
            true, // on_chain (uses Keccak for Solidity compatibility)
            vk.clone(),
            false, // low_memory_mode
        )
        .unwrap();

        let valid = verify_noir_proof(
            circuit_path,
            proof,
            true, // on_chain (uses Keccak for Solidity compatibility)
            vk,
            false, // low_memory_mode
        )
        .unwrap();
        assert!(valid);
    }

    #[test]
    #[serial]
    fn test_noir_multiplier2_with_existing_vk() {
        let srs_path = "./test-vectors/noir/noir_multiplier2.srs".to_string();
        let circuit_path = "./test-vectors/noir/noir_multiplier2.json".to_string();
        let vk_path = "./test-vectors/noir/noir_multiplier2.vk".to_string();

        // read vk from file as Vec<u8>
        let vk = std::fs::read(vk_path).unwrap();

        let circuit_inputs = vec!["3".to_string(), "5".to_string()];

        let proof = generate_noir_proof(
            circuit_path.clone(),
            Some(srs_path),
            circuit_inputs,
            true, // on_chain (uses Keccak for Solidity compatibility)
            vk.clone(),
            false, // low_memory_mode
        )
        .unwrap();

        let valid = verify_noir_proof(
            circuit_path,
            proof,
            true, // on_chain (uses Keccak for Solidity compatibility)
            vk,
            false, // low_memory_mode
        )
        .unwrap();
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


#[derive(uniffi::Error, thiserror::Error, Debug)]
pub enum Risc0Error {
    #[error("Failed to prove: {0}")]
    ProveError(String),
    #[error("Failed to serialize receipt: {0}")]
    SerializeError(String),
    #[error("Failed to verify: {0}")]
    VerifyError(String),
    #[error("Failed to decode journal: {0}")]
    DecodeError(String),
}

#[derive(uniffi::Record, Clone)]
pub struct Risc0ProofOutput {
    pub receipt: Vec<u8>,
}

#[derive(uniffi::Record, Clone)]
pub struct Risc0VerifyOutput {
    pub is_valid: bool,
    pub output_value: u32,
}

#[uniffi::export]
pub fn risc0_prove(input: u32) -> Result<Risc0ProofOutput, Risc0Error> {
    // Create executor environment with input
    let env = ExecutorEnv::builder()
        .write(&input)
        .map_err(|e| Risc0Error::ProveError(format!("Failed to write input: {}", e)))?
        .build()
        .map_err(|e| {
            Risc0Error::ProveError(format!("Failed to build executor environment: {}", e))
        })?;

    // Get the default prover
    let prover = default_prover();

    // Generate proof
    let prove_info = prover
        .prove(env, RISC0_CIRCUIT_ELF)
        .map_err(|e| Risc0Error::ProveError(format!("Failed to generate proof: {}", e)))?;

    // Extract receipt
    let receipt = prove_info.receipt;

    // Serialize receipt to bytes
    let receipt_bytes = bincode::serialize(&receipt)
        .map_err(|e| Risc0Error::SerializeError(format!("Failed to serialize receipt: {}", e)))?;

    Ok(Risc0ProofOutput {
        receipt: receipt_bytes,
    })
}

#[uniffi::export]
pub fn risc0_verify(receipt_bytes: Vec<u8>) -> Result<Risc0VerifyOutput, Risc0Error> {
    // Deserialize receipt from bytes
    let receipt: Receipt = bincode::deserialize(&receipt_bytes)
        .map_err(|e| Risc0Error::SerializeError(format!("Failed to deserialize receipt: {}", e)))?;

    // Verify the receipt
    receipt
        .verify(RISC0_CIRCUIT_ID)
        .map_err(|e| Risc0Error::VerifyError(format!("Failed to verify receipt: {}", e)))?;

    // Extract output from journal
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
        // Test proving with a simple u32 input
        let input = 42u32;
        let result = risc0_prove(input);

        assert!(result.is_ok(), "Proving should succeed for valid input");

        let proof_output = result.unwrap();
        assert!(
            !proof_output.receipt.is_empty(),
            "Receipt should not be empty"
        );
    }

    #[test]
    fn test_risc0_verify_success() {
        // First generate a proof
        let input = 123u32;
        let prove_result = risc0_prove(input);
        assert!(prove_result.is_ok(), "Proving should succeed");

        let proof_output = prove_result.unwrap();

        // Now verify the proof
        let verify_result = risc0_verify(proof_output.receipt);
        assert!(
            verify_result.is_ok(),
            "Verification should succeed for valid proof"
        );

        let verify_output = verify_result.unwrap();
        assert!(verify_output.is_valid, "Proof should be valid");
        assert_eq!(
            verify_output.output_value, input,
            "Output value should match input"
        );
    }

    #[test]
    fn test_prove_verify_roundtrip() {
        // Test the complete prove -> verify workflow with multiple inputs
        let test_inputs = [0u32, 42u32, 100u32, 1000u32, u32::MAX];

        for &input in &test_inputs {
            // Generate proof
            let prove_result = risc0_prove(input);
            assert!(
                prove_result.is_ok(),
                "Proving should succeed for input: {}",
                input
            );

            let proof_output = prove_result.unwrap();

            // Verify proof
            let verify_result = risc0_verify(proof_output.receipt);
            assert!(
                verify_result.is_ok(),
                "Verification should succeed for input: {}",
                input
            );

            let verify_output = verify_result.unwrap();
            assert!(
                verify_output.is_valid,
                "Proof should be valid for input: {}",
                input
            );
            assert_eq!(
                verify_output.output_value, input,
                "Output should match input: {}",
                input
            );
        }
    }
}
