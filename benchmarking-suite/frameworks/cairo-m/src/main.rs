

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
    let output_dir = Path::new("compiled");
    if !output_dir.exists() {
        fs::create_dir_all(output_dir)?;
    }

    // --- SHA256 ---
    println!("--- SHA-256 ---");
    let sha256_src = fs::read_to_string("circuits/sha256.cm")?;
    let sha256_compiled = compile_cairo(sha256_src, "sha256.cm".to_string(), CompilerOptions::default())?;
    let sha256_json = serde_json::to_string_pretty(&sha256_compiled.program)?;
    fs::write(output_dir.join("cairo_sha256.json"), &sha256_json)?;
    let sha256_args = vec![
        InputValue::List(vec![
            InputValue::Number(0x61626380), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0x18),
        ]),
        InputValue::Number(1),
    ];
    let sha256_out = run_cairo_program(&sha256_compiled.program, "sha256_hash", &sha256_args, RunnerOptions::default())?;
    prove_and_verify(sha256_out, "SHA-256")?;

    // --- BLAKE2S ---
    println!("--- BLAKE2S ---");
    let blake2s_src = fs::read_to_string("circuits/blake2s.cm")?;
    let blake2s_compiled = compile_cairo(blake2s_src, "blake2s.cm".to_string(), CompilerOptions::default())?;
    let blake2s_json = serde_json::to_string_pretty(&blake2s_compiled.program)?;
    fs::write(output_dir.join("cairo_blake2s.json"), &blake2s_json)?;
    // Blake2s handles "abc" (3 bytes)
    // 0x61626300 in big-endian u32 is 1633837824
    let blake2s_args = vec![
        InputValue::List(vec![
            InputValue::Number(0x61626300), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
        ]),
        InputValue::Number(3), // 3 bytes
    ];
    let blake2s_out = run_cairo_program(&blake2s_compiled.program, "blake2s_hash", &blake2s_args, RunnerOptions::default())?;
    prove_and_verify(blake2s_out, "BLAKE2S")?;

    // --- BLAKE3 ---
    println!("--- BLAKE3 ---");
    let blake3_src = fs::read_to_string("circuits/blake3.cm")?;
    let blake3_res = compile_cairo(blake3_src, "blake3.cm".to_string(), CompilerOptions::default());
    let blake3_compiled = match blake3_res {
        Ok(c) => c,
        Err(e) => {
            println!("BLAKE3 COMPILE ERROR DUMP: {:#?}", e);
            std::process::exit(1);
        }
    };
    let blake3_json = serde_json::to_string_pretty(&blake3_compiled.program)?;
    fs::write(output_dir.join("cairo_blake3.json"), &blake3_json)?;
    // Blake3 test "abc"
    // "abc" in little-endian 32-bit word = 0x00636261 = 6513249
    let blake3_args = vec![
        InputValue::List(vec![
            InputValue::Number(6513249), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
        ]),
        InputValue::Number(3), // 3 bytes
    ];
    let blake3_out = run_cairo_program(&blake3_compiled.program, "blake3_hash", &blake3_args, RunnerOptions::default())?;
    prove_and_verify(blake3_out, "BLAKE3")?;

    // --- MiMC ---
    println!("--- MiMC ---");
    let mimc_src = fs::read_to_string("circuits/mimc.cm")?;
    let mimc_compiled = compile_cairo(mimc_src, "mimc.cm".to_string(), CompilerOptions::default())?;
    let mimc_json = serde_json::to_string_pretty(&mimc_compiled.program)?;
    fs::write(output_dir.join("cairo_mimc.json"), &mimc_json)?;
    // MiMC testing "123", "456"
    let mimc_args = vec![
        InputValue::List(vec![
            InputValue::Number(123), InputValue::Number(456)
        ]),
        InputValue::Number(2), // 2 inputs
        InputValue::Number(0), // k = 0
    ];
    let mimc_out = run_cairo_program(&mimc_compiled.program, "multi_mimc7", &mimc_args, RunnerOptions::default())?;
    prove_and_verify(mimc_out, "MiMC")?;

    Ok(())
}

fn prove_and_verify(runner_output: cairo_m_runner::RunnerOutput, name: &str) -> anyhow::Result<()> {
    let mut prover_input = import_from_runner_output(
        runner_output.vm.segments.into_iter().next().unwrap(),
        runner_output.public_address_ranges,
    )?;
    let proof = prove_cairo_m::<Blake2sMerkleChannel>(&mut prover_input, None)?;
    verify_cairo_m::<Blake2sMerkleChannel>(proof, None)?;
    println!("{} Proof verified successfully", name);
    Ok(())
}