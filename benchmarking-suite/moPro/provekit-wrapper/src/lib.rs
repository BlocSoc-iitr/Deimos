//! ProveKit proving backend.
//!
//! Wraps the `provekit-core-prover` and `provekit-verifier` crates to provide
//! proof generation and verification for circuits compiled with the ProveKit
//! toolchain (an accelerated Noir backend). Enabled via the `provekit` feature flag.

use anyhow::{Context, Result};
use provekit_common::{file::read, Prover, Verifier};
use provekit_core_prover::Prove;
use provekit_verifier::Verify;
use std::io::Write;
use tempfile::NamedTempFile;

/// Generates a ProveKit proof using a compiled prover key file.
///
/// # Arguments
/// - `prover_path`: path to the `.pkp` prover key file produced during setup
/// - `input_toml`: TOML-encoded circuit inputs
///
/// # Returns
/// `Ok(Vec<u8>)` containing the serialized proof, or an `anyhow::Error`.
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

/// Verifies a ProveKit proof using a compiled verifier key file.
///
/// # Arguments
/// - `verifier_path`: path to the `.pkv` verifier key file produced during setup
/// - `proof_bytes`: serialized proof bytes produced by [`prove`]
///
/// # Returns
/// `Ok(true)` if the proof is valid, or an `anyhow::Error` on failure.
pub fn verify(verifier_path: &str, proof_bytes: &[u8]) -> Result<bool> {
    // Read the verified from the provided path
    let mut verifier: Verifier = read(std::path::Path::new(verifier_path)).context("Failed to read Verifier pkv")?;

    // Deserialize proof
    let proof: provekit_common::NoirProof = postcard::from_bytes(proof_bytes).context("Failed to deserialize proof")?;

    // Verify
    verifier.verify(&proof).context("Verification failed")?;

    Ok(true)
}
