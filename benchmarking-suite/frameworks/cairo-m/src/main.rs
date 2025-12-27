use std::fs;
use std::path::Path;

use cairo_m_common::{InputValue, Program};
use cairo_m_compiler::{compile_cairo, CompilerOptions};
use cairo_m_prover::adapter::import_from_runner_output;
use cairo_m_prover::prover::prove_cairo_m;
use cairo_m_prover::verifier::verify_cairo_m;
use cairo_m_runner::{run_cairo_program, RunnerOptions};
use stwo_prover::core::vcs::blake2_merkle::Blake2sMerkleChannel;

fn main() -> anyhow::Result<()> {

    let source_code = fs::read_to_string("circuits/sha256.cm")
        .expect("Failed to read circuits/sha256.cm");
    
    let compiler_output = compile_cairo(
        source_code,
        "sha256.cm".to_string(),
        CompilerOptions::default(),
    ).map_err(|e| anyhow::anyhow!("Compilation failed: {:?}", e))?;

    let output_dir = Path::new("compiled");
    if !output_dir.exists() {
        fs::create_dir_all(output_dir)?;
    }
    let output_path = output_dir.join("cairo_sha256.json");
    let json_program = serde_json::to_string_pretty(&compiler_output.program)?;
    fs::write(&output_path, &json_program)?;
    println!("Saved compiled program to {:?}", output_path);

    let json = fs::read_to_string("compiled/sha256.json")?;
    let program: Program = serde_json::from_str(&json)?;

    // SHA-256 expects: padded_message (u32*), num_chunks (felt)
    // Create a simple 512-bit (16 words) padded message block
    // This represents "abc" padded according to SHA-256 spec
    let args = vec![
        // Padded message: 16 u32 words (one 512-bit chunk)
        InputValue::List(vec![
            InputValue::Number(0x61626380), // "abc" + padding bit
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000000),
            InputValue::Number(0x00000018), // length = 24 bits
        ]),
        InputValue::Number(1), // num_chunks = 1
    ];

    let runner_output = run_cairo_program(
        &program,
        "sha256_hash",
        &args,
        RunnerOptions::default(),
    )?;

    let mut prover_input = import_from_runner_output(
        runner_output.vm.segments.into_iter().next().unwrap(),
        runner_output.public_address_ranges,
    )?;
    let proof = prove_cairo_m::<Blake2sMerkleChannel>(&mut prover_input, None)?;

    verify_cairo_m::<Blake2sMerkleChannel>(proof, None)?;
    println!("Proof verified successfully");

    Ok(())
}