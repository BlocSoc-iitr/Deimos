//! Barretenberg (Noir/UltraHonk) proving backend.
//!
//! This module wraps the `noir_rs` crate to provide UltraHonk proof generation
//! and verification for circuits compiled with the Noir language via the
//! Barretenberg proving library. Enabled via the `barretenberg` feature flag.

use noir_rs::{
    barretenberg::{
        prove::{prove_ultra_honk, prove_ultra_honk_keccak},
        srs::setup_srs_from_bytecode,
        verify::{
            get_ultra_honk_keccak_verification_key, get_ultra_honk_verification_key,
            verify_ultra_honk, verify_ultra_honk_keccak,
        },
    },
    witness::from_vec_str_to_witness_map,
};

use crate::MoproError;

/// Generates a Barretenberg (UltraHonk) proof with automatic hash function selection.
///
/// Automatically chooses the appropriate hash function based on the intended use case:
/// - `on_chain = true`: Uses Keccak hash for Solidity verifier compatibility
/// - `on_chain = false`: Uses Poseidon hash for better performance
#[uniffi::export]
pub(crate) fn generate_barretenberg_proof(
    circuit_path: String,
    srs_path: Option<String>,
    inputs: Vec<String>,
    on_chain: bool,
    vk: Vec<u8>,
    low_memory_mode: bool,
) -> Result<Vec<u8>, MoproError> {
    let res = if on_chain {
        generate_barretenberg_proof_with_keccak(circuit_path, srs_path, inputs, false, vk, low_memory_mode)
    } else {
        generate_barretenberg_proof_with_poseidon(circuit_path, srs_path, inputs, vk, low_memory_mode)
    };

    res.map_err(|e| MoproError::BarretenbergError(format!("Generate Proof error: {}", e)))
}

/// Verifies a Barretenberg (UltraHonk) proof with automatic hash function selection.
///
/// Automatically uses the correct verification method based on how the proof was generated:
/// - `on_chain = true`: Verifies Keccak-based proof (Solidity compatible)
/// - `on_chain = false`: Verifies Poseidon-based proof (performance optimized)
#[uniffi::export]
pub(crate) fn verify_barretenberg_proof(
    circuit_path: String,
    proof: Vec<u8>,
    on_chain: bool,
    vk: Vec<u8>,
    low_memory_mode: bool,
) -> Result<bool, MoproError> {
    if on_chain {
        verify_barretenberg_proof_with_keccak(circuit_path, proof, false, vk, low_memory_mode)
            .map_err(|e| MoproError::BarretenbergError(format!("Verify error: {}", e)))
    } else {
        verify_barretenberg_proof_with_poseidon(circuit_path, proof, vk, low_memory_mode)
            .map_err(|e| MoproError::BarretenbergError(format!("Verify error: {}", e)))
    }
}

/// Generates a verification key with automatic hash function selection.
///
/// - `on_chain = true`: Uses Keccak hash for Solidity verifier compatibility
/// - `on_chain = false`: Uses Poseidon hash for better performance
#[uniffi::export]
pub(crate) fn get_barretenberg_verification_key(
    circuit_path: String,
    srs_path: Option<String>,
    on_chain: bool,
    low_memory_mode: bool,
) -> Result<Vec<u8>, MoproError> {
    let res = if on_chain {
        get_barretenberg_verification_keccak_key(circuit_path, srs_path, false, low_memory_mode)
    } else {
        get_barretenberg_verification_poseidon_key(circuit_path, srs_path, low_memory_mode)
    };

    res.map_err(|e| MoproError::BarretenbergError(format!("Get Verification Key error: {}", e)))
}

/// Generates a Barretenberg proof using Poseidon as oracle hash.
///
/// Uses the Poseidon hash function for better performance.
/// Proofs generated with Poseidon cannot be verified on-chain with Solidity verifiers.
///
/// Use this for off-chain verification or when maximum performance is needed.
fn generate_barretenberg_proof_with_poseidon(
    circuit_path: String,
    srs_path: Option<String>,
    inputs: Vec<String>,
    vk: Vec<u8>,
    low_memory_mode: bool,
) -> Result<Vec<u8>, String> {
    let circuit_bytecode = get_bytecode(circuit_path)?;

    setup_srs_from_bytecode(circuit_bytecode.as_str(), srs_path.as_deref(), false)
        .map_err(|e| format!("SRS setup failed: {}", e))?;

    let witness = from_vec_str_to_witness_map(inputs.iter().map(|s| s.as_str()).collect())
        .map_err(|e| format!("Witness map failed: {}", e))?;

    prove_ultra_honk(circuit_bytecode.as_str(), witness, vk, low_memory_mode)
}

/// Verifies a Barretenberg proof generated with Poseidon as oracle hash.
///
/// Cannot verify proofs intended for on-chain verification with Solidity verifiers.
pub fn verify_barretenberg_proof_with_poseidon(
    circuit_path: String,
    proof: Vec<u8>,
    vk: Vec<u8>,
    _low_memory_mode: bool,
) -> Result<bool, String> {
    let _circuit_bytecode = get_bytecode(circuit_path)?;
    verify_ultra_honk(proof, vk).map_err(|e| format!("Verification failed: {}", e))
}

/// Generates a verification key for Poseidon-based Barretenberg proofs.
///
/// This verification key can only be used to verify proofs generated
/// with the Poseidon hash function (off-chain proofs).
fn get_barretenberg_verification_poseidon_key(
    circuit_path: String,
    srs_path: Option<String>,
    low_memory_mode: bool,
) -> Result<Vec<u8>, String> {
    let circuit_bytecode = get_bytecode(circuit_path)?;

    setup_srs_from_bytecode(circuit_bytecode.as_str(), srs_path.as_deref(), false)
        .map_err(|e| format!("SRS setup failed: {}", e))?;

    get_ultra_honk_verification_key(circuit_bytecode.as_str(), low_memory_mode)
        .map_err(|e| format!("VK generation failed: {}", e))
}

/// Generates a Barretenberg proof using Keccak as oracle hash.
///
/// Uses the Keccak hash function which is required for generating proofs
/// that can be verified on-chain with Solidity verifiers.
///
/// Use this when you need to verify proofs on Ethereum or other EVM chains.
fn generate_barretenberg_proof_with_keccak(
    circuit_path: String,
    srs_path: Option<String>,
    inputs: Vec<String>,
    disable_zk: bool,
    vk: Vec<u8>,
    low_memory_mode: bool,
) -> Result<Vec<u8>, String> {
    let circuit_bytecode = get_bytecode(circuit_path)?;

    setup_srs_from_bytecode(circuit_bytecode.as_str(), srs_path.as_deref(), false)
        .map_err(|e| format!("SRS setup failed: {}", e))?;

    let witness = from_vec_str_to_witness_map(inputs.iter().map(|s| s.as_str()).collect())
        .map_err(|e| format!("Witness map failed: {}", e))?;

    prove_ultra_honk_keccak(
        circuit_bytecode.as_str(),
        witness,
        vk,
        disable_zk,
        low_memory_mode,
    )
}

/// Verifies a Barretenberg proof generated with Keccak as oracle hash.
///
/// Verifies proofs that were generated using the Keccak hash,
/// which are compatible with Solidity verifiers for on-chain verification.
fn verify_barretenberg_proof_with_keccak(
    circuit_path: String,
    proof: Vec<u8>,
    disable_zk: bool,
    vk: Vec<u8>,
    _low_memory_mode: bool,
) -> Result<bool, String> {
    let _circuit_bytecode = get_bytecode(circuit_path)?;
    verify_ultra_honk_keccak(proof, vk, disable_zk)
        .map_err(|e| format!("Verification failed: {}", e))
}

/// Generates a verification key for Keccak-based Barretenberg proofs.
///
/// This verification key can be used to verify proofs generated with
/// the Keccak hash function, and is compatible with Solidity verifiers
/// for on-chain verification.
fn get_barretenberg_verification_keccak_key(
    circuit_path: String,
    srs_path: Option<String>,
    disable_zk: bool,
    low_memory_mode: bool,
) -> Result<Vec<u8>, String> {
    let circuit_bytecode = get_bytecode(circuit_path)?;

    setup_srs_from_bytecode(circuit_bytecode.as_str(), srs_path.as_deref(), false)
        .map_err(|e| format!("SRS setup failed: {}", e))?;

    get_ultra_honk_keccak_verification_key(
        circuit_bytecode.as_str(),
        disable_zk,
        low_memory_mode,
    )
    .map_err(|e| format!("VK generation failed: {}", e))
}

/// Reads and extracts the bytecode from a Noir circuit JSON manifest.
fn get_bytecode(circuit_path: String) -> Result<String, String> {
    let circuit_txt = std::fs::read_to_string(&circuit_path)
        .map_err(|e| format!("Failed to read circuit file '{}': {}", circuit_path, e))?;
    let circuit: serde_json::Value = serde_json::from_str(&circuit_txt)
        .map_err(|e| format!("Failed to parse circuit JSON: {}", e))?;
    circuit["bytecode"]
        .as_str()
        .map(|s| s.to_string())
        .ok_or_else(|| "Circuit JSON missing 'bytecode' field".to_string())
}

#[cfg(test)]
mod tests {
    const MULTIPLIER2_CIRCUIT_FILE: &str = "./test-vectors/noir/noir_multiplier2.json";
    const SRS_FILE: &str = "./test-vectors/noir/noir_multiplier2.srs";
    const VK_FILE: &str = "./test-vectors/noir/noir_multiplier2.vk";

    use super::*;

    #[test]
    #[serial_test::serial]
    fn test_proof_multiplier2() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = get_barretenberg_verification_poseidon_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            false,
        )
        .unwrap();
        let proof = generate_barretenberg_proof_with_poseidon(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            vk.clone(),
            false,
        )
        .unwrap();
        assert!(verify_barretenberg_proof_with_poseidon(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof,
            vk,
            false,
        )
        .unwrap());
    }

    #[test]
    #[serial_test::serial]
    fn test_proof_multiplier2_low_memory() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = get_barretenberg_verification_poseidon_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            true,
        )
        .unwrap();
        let proof = generate_barretenberg_proof_with_poseidon(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            vk.clone(),
            true,
        )
        .unwrap();
        assert!(verify_barretenberg_proof_with_poseidon(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof,
            vk,
            true,
        )
        .unwrap());
    }

    #[test]
    #[serial_test::serial]
    fn test_proof_multiplier2_without_srs_path() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk =
            get_barretenberg_verification_poseidon_key(MULTIPLIER2_CIRCUIT_FILE.to_string(), None, false)
                .unwrap();
        let proof = generate_barretenberg_proof_with_poseidon(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            None,
            witness,
            vk.clone(),
            false,
        )
        .unwrap();
        assert!(verify_barretenberg_proof_with_poseidon(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof,
            vk,
            false,
        )
        .unwrap());
    }

    #[test]
    #[serial_test::serial]
    fn test_keccak_proof_multiplier2() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = get_barretenberg_verification_keccak_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            false,
            false,
        )
        .unwrap();
        let proof = generate_barretenberg_proof_with_keccak(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            false,
            vk.clone(),
            false,
        )
        .unwrap();
        assert!(verify_barretenberg_proof_with_keccak(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof,
            false,
            vk,
            false,
        )
        .unwrap());
    }

    #[test]
    #[serial_test::serial]
    fn test_keccak_proof_multiplier2_disable_zk() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = get_barretenberg_verification_keccak_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            true,
            false,
        )
        .unwrap();
        let proof = generate_barretenberg_proof_with_keccak(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            true,
            vk.clone(),
            false,
        )
        .unwrap();
        assert!(verify_barretenberg_proof_with_keccak(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof,
            true,
            vk,
            false,
        )
        .unwrap());
    }

    #[test]
    #[serial_test::serial]
    fn test_keccak_proof_multiplier2_low_memory() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = get_barretenberg_verification_keccak_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            false,
            true,
        )
        .unwrap();
        let proof = generate_barretenberg_proof_with_keccak(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            false,
            vk.clone(),
            true,
        )
        .unwrap();
        assert!(verify_barretenberg_proof_with_keccak(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof,
            false,
            vk,
            true,
        )
        .unwrap());
    }

    #[test]
    #[serial_test::serial]
    fn test_keccak_proof_multiplier2_with_vk() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = std::fs::read(VK_FILE).unwrap();
        let proof = generate_barretenberg_proof_with_keccak(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            false,
            vk.clone(),
            false,
        )
        .unwrap();
        let is_valid = verify_barretenberg_proof_with_keccak(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof.clone(),
            false,
            vk.clone(),
            false,
        );
        assert!(is_valid.unwrap());
    }

    #[test]
    #[serial_test::serial]
    fn test_get_barretenberg_verification_poseidon_key() {
        let vk = get_barretenberg_verification_poseidon_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            false,
        );
        assert!(vk.is_ok());
        assert!(!vk.unwrap().is_empty());
    }

    #[test]
    #[serial_test::serial]
    fn test_barretenberg_proof_with_poseidon_and_vk() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = std::fs::read(VK_FILE).unwrap();
        let proof = generate_barretenberg_proof_with_poseidon(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            vk.clone(),
            false,
        )
        .unwrap();
        let is_valid = verify_barretenberg_proof_with_poseidon(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof.clone(),
            vk.clone(),
            false,
        );
        assert!(is_valid.unwrap());
    }

    #[test]
    #[serial_test::serial]
    fn test_high_level_barretenberg_proof_poseidon() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = get_barretenberg_verification_poseidon_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            false,
        )
        .unwrap();
        let proof = generate_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            false,
            vk.clone(),
            false,
        )
        .unwrap();
        let is_valid = verify_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof,
            false,
            vk,
            false,
        )
        .unwrap();
        assert!(is_valid);
    }

    #[test]
    #[serial_test::serial]
    fn test_high_level_barretenberg_proof_keccak() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = get_barretenberg_verification_keccak_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            false,
            false,
        )
        .unwrap();
        let proof = generate_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            true,
            vk.clone(),
            false,
        )
        .unwrap();
        let is_valid =
            verify_barretenberg_proof(MULTIPLIER2_CIRCUIT_FILE.to_string(), proof, true, vk, false)
                .unwrap();
        assert!(is_valid);
    }

    #[test]
    #[serial_test::serial]
    fn test_high_level_barretenberg_proof_poseidon_with_vk() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = std::fs::read(VK_FILE).unwrap();
        let proof = generate_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            false,
            vk.clone(),
            false,
        )
        .unwrap();
        let is_valid = verify_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof,
            false,
            vk,
            false,
        )
        .unwrap();
        assert!(is_valid);
    }

    #[test]
    #[serial_test::serial]
    fn test_high_level_barretenberg_proof_keccak_with_vk() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk = std::fs::read(VK_FILE).unwrap();
        let proof = generate_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness,
            true,
            vk.clone(),
            false,
        )
        .unwrap();
        let is_valid =
            verify_barretenberg_proof(MULTIPLIER2_CIRCUIT_FILE.to_string(), proof, true, vk, false)
                .unwrap();
        assert!(is_valid);
    }

    #[test]
    #[serial_test::serial]
    fn test_get_barretenberg_verification_key_poseidon() {
        let vk = get_barretenberg_verification_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            false, // off-chain, uses Poseidon
            false,
        );
        assert!(vk.is_ok());
        assert!(!vk.unwrap().is_empty());
    }

    #[test]
    #[serial_test::serial]
    fn test_get_barretenberg_verification_key_keccak() {
        let vk = get_barretenberg_verification_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            true, // on-chain, uses Keccak
            false,
        );
        assert!(vk.is_ok());
        assert!(!vk.unwrap().is_empty());
    }

    #[test]
    #[serial_test::serial]
    fn test_barretenberg_app_macro() {
        let witness = vec!["3".to_string(), "5".to_string()];
        let vk_offchain = get_barretenberg_verification_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            false,
            false,
        )
        .unwrap();
        let vk_onchain = get_barretenberg_verification_key(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            true,
            false,
        )
        .unwrap();
        let proof_offchain = generate_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness.clone(),
            false,
            vk_offchain.clone(),
            false,
        );
        let proof_onchain = generate_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            Some(SRS_FILE.to_string()),
            witness.clone(),
            true,
            vk_onchain.clone(),
            false,
        );

        assert!(proof_offchain.is_ok());
        assert!(proof_onchain.is_ok());
        let proof_offchain = proof_offchain.unwrap();
        let proof_onchain = proof_onchain.unwrap();

        let verify_result_offchain = verify_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof_offchain.clone(),
            false,
            vk_offchain,
            false,
        );
        let verify_result_onchain = verify_barretenberg_proof(
            MULTIPLIER2_CIRCUIT_FILE.to_string(),
            proof_onchain.clone(),
            true,
            vk_onchain,
            false,
        );

        assert!(verify_result_offchain.is_ok());
        assert!(verify_result_offchain.unwrap());
        assert!(verify_result_onchain.is_ok());
        assert!(verify_result_onchain.unwrap());
    }
}
