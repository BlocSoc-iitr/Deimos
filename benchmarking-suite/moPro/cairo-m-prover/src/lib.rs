//! Cairo-M (Stwo STARKs) proving backend.
//!
//! Wraps the `cairo-m-prover-core` and `cairo-m-runner` crates to provide
//! STARK proof generation and verification for programs compiled with Cairo-M.
//! Enabled in the main crate via the `cairo_m` feature flag.

use cairo_m_common::{InputValue, Program};
use cairo_m_prover_core::adapter::import_from_runner_output;
use cairo_m_prover_core::prover::prove_cairo_m;
use cairo_m_prover_core::verifier::verify_cairo_m;
use cairo_m_prover_core::Proof;
use cairo_m_runner::{run_cairo_program, RunnerOptions};
use stwo_prover::core::vcs::blake2_merkle::{Blake2sMerkleChannel, Blake2sMerkleHasher};
use anyhow::{Context, Result};

/// Generates a Cairo-M STARK proof.
///
/// # Arguments
/// - `program_json`: JSON-encoded Cairo-M compiled program
/// - `inputs_json`: JSON-encoded program input values
///
/// # Returns
/// `Ok(Vec<u8>)` containing the serialized proof, or an `anyhow::Error`.
pub fn prove(program_json: &str, inputs_json: &str, entrypoint: &str) -> Result<Vec<u8>> {
    // Deserialize Program
    let program: Program = serde_json::from_str(program_json)
        .context("Failed to parse program JSON")?;

    // Deserialize Inputs
    let args: Vec<InputValue> = serde_json::from_str(inputs_json)
        .context("Failed to parse inputs JSON")?;

    // Run Cairo Program
    let runner_output = run_cairo_program(
        &program,
        entrypoint, 
        &args,
        RunnerOptions::default(),
    ).context("Failed to run cairo program")?;

    let first_segment = runner_output
        .vm
        .segments
        .into_iter()
        .next()
        .ok_or_else(|| anyhow::anyhow!("Cairo runner produced no memory segments"))?;
    let mut prover_input = import_from_runner_output(first_segment, runner_output.public_address_ranges)
        .context("Failed to import runner output")?;

    let proof = prove_cairo_m::<Blake2sMerkleChannel>(&mut prover_input, None)
        .context("Failed to generate proof")?;

    // Serialize proof
    bincode::serialize(&proof).context("Failed to serialize proof")
}

/// Verifies a Cairo-M STARK proof.
///
/// # Arguments
/// - `proof_bytes`: serialized proof bytes produced by [`prove`]
///
/// # Returns
/// `Ok(true)` if the proof is valid, or an `anyhow::Error` on failure.
pub fn verify(proof_bytes: &[u8]) -> Result<bool> {
    let proof: Proof<Blake2sMerkleHasher> = bincode::deserialize(proof_bytes)
        .context("Failed to deserialize proof")?;

    verify_cairo_m::<Blake2sMerkleChannel>(proof, None)
        .context("Failed to verify proof")?;

    Ok(true)
}

