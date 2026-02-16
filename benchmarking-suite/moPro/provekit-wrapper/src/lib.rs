use anyhow::{Context, Result};
use provekit_common::{file::read, Prover, Verifier};
use provekit_core_prover::Prove;
use provekit_verifier::Verify;
use std::io::Write;
use tempfile::NamedTempFile;

pub fn prove(prover_path: &str, input_toml: &str) -> Result<Vec<u8>> {
    // Write input TOML to a temporary file because Prover::prove expects a path
    // Create temp file for input
    let mut file = tempfile::Builder::new().suffix(".toml").tempfile()?;
    file.write_all(input_toml.as_bytes()).context("Failed to write input data")?;
    let input_path = file.path();

    // Read the prover from the provided path
    // Note: The prover_path usually points to a .pkp file derived from setup
    let prover: Prover = read(std::path::Path::new(prover_path)).context("Failed to read Prover pkp")?;

    // Generate proof
    let proof = prover.prove(input_path).context("Failed to generate proof")?;

    // Serialize proof to bytes (using bincode or internal serialization)
    // provekit_common::file::write uses generic serialization.
    // We can use postcard directly as provekit does internally.
    let proof_bytes = postcard::to_stdvec(&proof).context("Failed to serialize proof")?;

    Ok(proof_bytes)
}

pub fn verify(verifier_path: &str, proof_bytes: &[u8]) -> Result<bool> {
    // Read the verified from the provided path
    let mut verifier: Verifier = read(std::path::Path::new(verifier_path)).context("Failed to read Verifier pkv")?;

    // Deserialize proof
    let proof: provekit_common::NoirProof = postcard::from_bytes(proof_bytes).context("Failed to deserialize proof")?;

    // Verify
    verifier.verify(&proof).context("Verification failed")?;

    Ok(true)
}
