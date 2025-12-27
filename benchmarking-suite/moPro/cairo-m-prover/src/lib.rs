use cairo_m_common::{InputValue, Program};
use cairo_m_prover_core::adapter::import_from_runner_output;
use cairo_m_prover_core::prover::prove_cairo_m;
use cairo_m_prover_core::verifier::verify_cairo_m;
use cairo_m_prover_core::Proof;
use cairo_m_runner::{run_cairo_program, RunnerOptions};
use stwo_prover::core::vcs::blake2_merkle::{Blake2sMerkleChannel, Blake2sMerkleHasher};
use anyhow::{Context, Result};

pub fn prove(program_json: &str, inputs_json: &str) -> Result<Vec<u8>> {
    // Deserialize Program
    let program: Program = serde_json::from_str(program_json)
        .context("Failed to parse program JSON")?;

    // Deserialize Inputs
    let args: Vec<InputValue> = serde_json::from_str(inputs_json)
        .context("Failed to parse inputs JSON")?;

    // Run Cairo Program
    // Entrypoint hardcoded to "sha256_hash" as per cairo-test reference for this demo.
    let runner_output = run_cairo_program(
        &program,
        "sha256_hash", 
        &args,
        RunnerOptions::default(),
    ).context("Failed to run cairo program")?;

    let mut prover_input = import_from_runner_output(
        runner_output.vm.segments.into_iter().next().unwrap(),
        runner_output.public_address_ranges,
    ).context("Failed to import runner output")?;

    let proof = prove_cairo_m::<Blake2sMerkleChannel>(&mut prover_input, None)
        .context("Failed to generate proof")?;

    // Serialize proof
    bincode::serialize(&proof).context("Failed to serialize proof")
}

pub fn verify(proof_bytes: &[u8]) -> Result<bool> {
    let proof: Proof<Blake2sMerkleHasher> = bincode::deserialize(proof_bytes)
        .context("Failed to deserialize proof")?;

    verify_cairo_m::<Blake2sMerkleChannel>(proof, None)
        .context("Failed to verify proof")?;

    Ok(true)
}

