

use std::fs;
use std::path::Path;

use cairo_m_common::InputValue;
use cairo_m_compiler::{compile_cairo, CompilerOptions};
use cairo_m_prover::adapter::import_from_runner_output;
use cairo_m_prover::prover::prove_cairo_m;
use cairo_m_prover::verifier::verify_cairo_m;
use cairo_m_runner::{run_cairo_program, RunnerOptions};
use stwo_prover::core::vcs::blake2_merkle::Blake2sMerkleChannel;

fn main() -> anyhow::Result<()> {
    let output_dir = Path::new("../../moPro/mopro-example-app/flutter/assets/cairo-m");
    if !output_dir.exists() {
        fs::create_dir_all(output_dir)?;
    }

    let compiled_dir = Path::new("compiled");
    if !compiled_dir.exists() {
        fs::create_dir_all(compiled_dir)?;
    }

    // --- SHA256 ---
    println!("--- SHA-256 ---");
    let sha256_src = fs::read_to_string("circuits/sha256.cm")?;
    let sha256_compiled = compile_cairo(sha256_src, "sha256.cm".to_string(), CompilerOptions::default())?;
    let sha256_json = serde_json::to_string_pretty(&sha256_compiled.program)?;
    fs::write(output_dir.join("cairo_sha256.json"), &sha256_json)?;
    fs::write(compiled_dir.join("cairo_sha256.json"), &sha256_json)?;
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
    fs::write(compiled_dir.join("cairo_blake2s.json"), &blake2s_json)?;
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
    fs::write(compiled_dir.join("cairo_blake3.json"), &blake3_json)?;
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
    fs::write(compiled_dir.join("cairo_mimc.json"), &mimc_json)?;
    // MiMC testing with 4 M31 field elements for multi-input absorption
    let mimc_args = vec![
        InputValue::List(vec![
            InputValue::Number(123456789), InputValue::Number(987654321),
            InputValue::Number(1500000000), InputValue::Number(2000000000),
        ]),
        InputValue::Number(4), // 4 inputs
        InputValue::Number(0), // k = 0
    ];
    let mimc_out = run_cairo_program(&mimc_compiled.program, "multi_mimc7", &mimc_args, RunnerOptions::default())?;
    prove_and_verify(mimc_out, "MiMC")?;


    // --- POSEIDON2 ---
    println!("--- POSEIDON2 ---");
    let p2_src = fs::read_to_string("circuits/poseidon2.cm")?;
    let p2_res = compile_cairo(p2_src, "poseidon2.cm".to_string(), CompilerOptions::default());
    let p2_compiled = match p2_res {
        Ok(c) => c,
        Err(e) => {
            println!("POSEIDON2 COMPILE ERROR DUMP: {:#?}", e);
            std::process::exit(1);
        }
    };
    let p2_json = serde_json::to_string_pretty(&p2_compiled.program)?;
    fs::write(output_dir.join("cairo_poseidon2.json"), &p2_json)?;
    fs::write(compiled_dir.join("cairo_poseidon2.json"), &p2_json)?;
    // 16 M31 field elements — exercises 2 absorption rounds (rate=8)
    let p2_args = vec![
        InputValue::List(vec![
            InputValue::Number(123456789), InputValue::Number(987654321),
            InputValue::Number(1500000000), InputValue::Number(2000000000),
            InputValue::Number(750000000), InputValue::Number(1234567890),
            InputValue::Number(2100000000), InputValue::Number(42),
            InputValue::Number(314159265), InputValue::Number(271828182),
            InputValue::Number(1618033988), InputValue::Number(1414213562),
            InputValue::Number(1732050808), InputValue::Number(2000000),
            InputValue::Number(999999999), InputValue::Number(1073741824),
        ]),
        InputValue::Number(16), // 16 inputs — 2 sponge absorption rounds
    ];
    let p2_out = run_cairo_program(&p2_compiled.program, "poseidon2_hash", &p2_args, RunnerOptions::default())?;
    prove_and_verify(p2_out, "POSEIDON2")?;


    // --- KECCAK-256 ---
    println!("--- KECCAK-256 ---");
    let keccak_src = fs::read_to_string("circuits/keccak256.cm")?;
    let keccak_res = compile_cairo(keccak_src, "keccak256.cm".to_string(), CompilerOptions::default());
    let keccak_compiled = match keccak_res {
        Ok(c) => c,
        Err(e) => {
            println!("KECCAK COMPILE ERROR DUMP: {:#?}", e);
            std::process::exit(1);
        }
    };
    let keccak_json = serde_json::to_string_pretty(&keccak_compiled.program)?;
    fs::write(output_dir.join("cairo_keccak256.json"), &keccak_json)?;
    fs::write(compiled_dir.join("cairo_keccak256.json"), &keccak_json)?;
    // Test with 3-byte message packed into a single u32 word (little-endian)
    let keccak_args = vec![
        InputValue::List(vec![
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
            InputValue::Number(0), InputValue::Number(0), InputValue::Number(0), InputValue::Number(0),
        ]),
        InputValue::Number(3), // 3 bytes
    ];
    let keccak_out = run_cairo_program(&keccak_compiled.program, "keccak256_hash", &keccak_args, RunnerOptions::default())?;
    prove_and_verify(keccak_out, "KECCAK-256")?;


    // --- RESCUE PRIME ---
    println!("--- RESCUE PRIME ---");
    let rp_src = fs::read_to_string("circuits/rescue_prime.cm")?;
    let rp_res = compile_cairo(rp_src, "rescue_prime.cm".to_string(), CompilerOptions::default());
    let rp_compiled = match rp_res {
        Ok(c) => c,
        Err(e) => {
            println!("RESCUE PRIME COMPILE ERROR DUMP: {:#?}", e);
            std::process::exit(1);
        }
    };
    let rp_json = serde_json::to_string_pretty(&rp_compiled.program)?;
    fs::write(output_dir.join("cairo_rescue_prime.json"), &rp_json)?;
    fs::write(compiled_dir.join("cairo_rescue_prime.json"), &rp_json)?;
    // 8 M31 field elements — exercises 1 full sponge absorption round (rate=8)
    let rp_args = vec![
        InputValue::List(vec![
            InputValue::Number(123456789), InputValue::Number(987654321),
            InputValue::Number(1500000000), InputValue::Number(2000000000),
            InputValue::Number(750000000), InputValue::Number(1234567890),
            InputValue::Number(2100000000), InputValue::Number(42),
        ]),
        InputValue::Number(8), // 8 inputs — 1 full sponge absorption round
    ];
    let rp_out = run_cairo_program(&rp_compiled.program, "rescue_prime_hash", &rp_args, RunnerOptions::default())?;
    prove_and_verify(rp_out, "RESCUE PRIME")?;

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