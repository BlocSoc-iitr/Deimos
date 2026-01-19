mopro_ffi::app!();

#[derive(Debug, thiserror::Error, uniffi::Error)]
pub enum MoproError {
    #[error("Circom error: {0}")]
    CircomError(String),
}

mod circom;

use std::collections::HashMap;
use num_bigint::BigInt;

rust_witness::witness!(keccak);
rust_witness::witness!(blake2s256);
rust_witness::witness!(mimc256);
rust_witness::witness!(pedersen);
rust_witness::witness!(poseidon);
rust_witness::witness!(sha256);

set_circom_circuits! {
    ("keccak.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak_witness)),
    ("blake2s256.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s256_witness)),
    ("mimc256.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc256_witness)),
    ("pedersen.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen_witness)),
    ("poseidon.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon_witness)),
    ("sha256.zkey", circom_prover::witness::WitnessFn::RustWitness(sha256_witness)),
}

#[uniffi::export]
fn mopro_uniffi_hello_world() -> String {
    "Hello, World!".to_string()
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
