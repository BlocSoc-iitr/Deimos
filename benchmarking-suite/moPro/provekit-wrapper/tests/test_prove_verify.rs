use provekit_wrapper::{prove, verify};
use serde_json::Value;
use std::fs;
use std::path::PathBuf;

// Helper to run proof and verification
fn run_prove_verify_for_circuit(pkp_path: &str, pkv_path: &str, input_toml: &str) {
    let pkp_path_buf = PathBuf::from(pkp_path);
    let pkv_path_buf = PathBuf::from(pkv_path);
    assert!(
        pkp_path_buf.exists(),
        "Prover key not found at {:?}",
        pkp_path
    );
    assert!(
        pkv_path_buf.exists(),
        "Verifier key not found at {:?}",
        pkv_path
    );

    println!("Proving with input: {}", input_toml);

    let proof_result = prove(pkp_path, input_toml);
    assert!(
        proof_result.is_ok(),
        "Proving failed: {:?}",
        proof_result.err()
    );

    let proof_bytes = proof_result.unwrap();
    println!("Proof generated. Size: {} bytes", proof_bytes.len());

    let verify_result = verify(pkv_path, &proof_bytes);
    assert!(
        verify_result.is_ok(),
        "Verification failed: {:?}",
        verify_result.err()
    );

    let is_valid = verify_result.unwrap();
    assert!(is_valid, "Proof verification returned false");
}

fn run_test_case(algo: &str, size: usize) {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join(format!(
        "../mopro-example-app/flutter/assets/provekit/{}_field_{}.pkp",
        algo, size
    ));
    let pkv_path = manifest_dir.join(format!(
        "../mopro-example-app/flutter/assets/provekit/{}_field_{}.pkv",
        algo, size
    ));

    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", size));
    let json_str = fs::read_to_string(&input_json_path)
        .unwrap_or_else(|_| panic!("Failed to read input json: input{}f.json", size));

    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val
        .get("in")
        .expect("No 'in' field")
        .as_array()
        .expect("'in' is not an array");

    let toml_array = in_array
        .iter()
        .map(|v| {
            if let Some(s) = v.as_str() {
                format!("\"{}\"", s)
            } else if let Some(n) = v.as_u64() {
                format!("\"{}\"", n)
            } else {
                panic!("Unexpected type in array")
            }
        })
        .collect::<Vec<_>>()
        .join(", ");

    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(
        pkp_path.to_str().unwrap(),
        pkv_path.to_str().unwrap(),
        &input_toml,
    );
}

macro_rules! test_circuit {
    ($name:ident, $algo:expr, $size:expr) => {
        #[test]
        fn $name() {
            run_test_case($algo, $size);
        }
    };
}

// anemoi
test_circuit!(test_prove_and_verify_anemoi_field_1, "anemoi", 1);
test_circuit!(test_prove_and_verify_anemoi_field_2, "anemoi", 2);
test_circuit!(test_prove_and_verify_anemoi_field_3, "anemoi", 3);
test_circuit!(test_prove_and_verify_anemoi_field_5, "anemoi", 5);
test_circuit!(test_prove_and_verify_anemoi_field_9, "anemoi", 9);
test_circuit!(test_prove_and_verify_anemoi_field_17, "anemoi", 17);
test_circuit!(test_prove_and_verify_anemoi_field_34, "anemoi", 34);

// mimc
test_circuit!(test_prove_and_verify_mimc_field_1, "mimc", 1);
test_circuit!(test_prove_and_verify_mimc_field_2, "mimc", 2);
test_circuit!(test_prove_and_verify_mimc_field_3, "mimc", 3);
test_circuit!(test_prove_and_verify_mimc_field_5, "mimc", 5);
test_circuit!(test_prove_and_verify_mimc_field_9, "mimc", 9);
test_circuit!(test_prove_and_verify_mimc_field_17, "mimc", 17);
test_circuit!(test_prove_and_verify_mimc_field_34, "mimc", 34);

// poseidon
test_circuit!(test_prove_and_verify_poseidon_field_1, "poseidon", 1);
test_circuit!(test_prove_and_verify_poseidon_field_2, "poseidon", 2);
test_circuit!(test_prove_and_verify_poseidon_field_3, "poseidon", 3);
test_circuit!(test_prove_and_verify_poseidon_field_5, "poseidon", 5);
test_circuit!(test_prove_and_verify_poseidon_field_9, "poseidon", 9);
test_circuit!(test_prove_and_verify_poseidon_field_17, "poseidon", 17);
test_circuit!(test_prove_and_verify_poseidon_field_34, "poseidon", 34);

// rescue_prime
test_circuit!(test_prove_and_verify_rescue_prime_field_1, "rescue_prime", 1);
test_circuit!(test_prove_and_verify_rescue_prime_field_2, "rescue_prime", 2);
test_circuit!(test_prove_and_verify_rescue_prime_field_3, "rescue_prime", 3);
test_circuit!(test_prove_and_verify_rescue_prime_field_5, "rescue_prime", 5);
test_circuit!(test_prove_and_verify_rescue_prime_field_9, "rescue_prime", 9);
test_circuit!(test_prove_and_verify_rescue_prime_field_17, "rescue_prime", 17);
test_circuit!(test_prove_and_verify_rescue_prime_field_34, "rescue_prime", 34);
