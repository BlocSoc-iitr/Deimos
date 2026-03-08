pub use crate::groth16::{Groth16Proof, Groth16ProofResult, G1, G2};

use crate::{
    MoproError,
    groth16::{generate_groth16_proof, verify_groth16_proof, ProofLib},
};

#[uniffi::export]
pub fn generate_rapidsnark_proof(
    zkey_path: String,
    circuit_inputs: String,
) -> Result<Groth16ProofResult, MoproError> {
    generate_groth16_proof(zkey_path, circuit_inputs, ProofLib::Rapidsnark)
}

#[uniffi::export]
pub fn verify_rapidsnark_proof(
    zkey_path: String,
    proof_result: Groth16ProofResult,
) -> Result<bool, MoproError> {
    verify_groth16_proof(zkey_path, proof_result, ProofLib::Rapidsnark)
}
