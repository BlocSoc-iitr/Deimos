use std::fs;
use std::time::Instant;

use cairo_m_common::{InputValue, Program};
use cairo_m_prover::adapter::import_from_runner_output;
use cairo_m_prover::prover::prove_cairo_m;
use cairo_m_prover::verifier::verify_cairo_m;
use cairo_m_runner::{run_cairo_program, RunnerOptions};
use stwo_prover::core::vcs::blake2_merkle::Blake2sMerkleChannel;

fn main() -> anyhow::Result<()> {
    // Load pre-compiled program from JSON
    // (Compiled externally with: cairo-m-compiler -i circuits/my_program.cm -o compiled/my_program.json)
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

    println!("=== Cairo-M Benchmark ===\n");

    // --- RUN ---
    let run_start = Instant::now();
    let runner_output = run_cairo_program(
        &program,
        "sha256_hash",
        &args,
        RunnerOptions::default(),
    )?;
    let run_time = run_start.elapsed();
    println!("Run time:    {:?}", run_time);
    println!("Return:      {:?}", runner_output.return_values);

    // --- PROVE ---
    let prove_start = Instant::now();
    let mut prover_input = import_from_runner_output(
        runner_output.vm.segments.into_iter().next().unwrap(),
        runner_output.public_address_ranges,
    )?;
    let proof = prove_cairo_m::<Blake2sMerkleChannel>(&mut prover_input, None)?;
    let prove_time = prove_start.elapsed();
    println!("Prove time:  {:?}", prove_time);

    // --- VERIFY ---
    let verify_start = Instant::now();
    verify_cairo_m::<Blake2sMerkleChannel>(proof, None)?;
    let verify_time = verify_start.elapsed();
    println!("Verify time: {:?}", verify_time);

    println!("\n────────────────────────────");
    println!("Total time:  {:?}", run_time + prove_time + verify_time);
    println!("✓ Proof verified successfully!");

    Ok(())
}