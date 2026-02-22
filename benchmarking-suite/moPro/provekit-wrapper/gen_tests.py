import os

output = """use provekit_wrapper::{prove, verify};
use std::fs;
use std::path::PathBuf;
use serde_json::Value;

// Helper to run proof and verification
fn run_prove_verify_for_circuit(pkp_path: &str, pkv_path: &str, input_toml: &str) {
    let pkp_path_buf = PathBuf::from(pkp_path);
    let pkv_path_buf = PathBuf::from(pkv_path);
    assert!(pkp_path_buf.exists(), "Prover key not found at {:?}", pkp_path);
    assert!(pkv_path_buf.exists(), "Verifier key not found at {:?}", pkv_path);

    println!("Proving with input: {}", input_toml);

    let proof_result = prove(pkp_path, input_toml);
    assert!(proof_result.is_ok(), "Proving failed: {:?}", proof_result.err());
    
    let proof_bytes = proof_result.unwrap();
    println!("Proof generated. Size: {} bytes", proof_bytes.len());

    let verify_result = verify(pkv_path, &proof_bytes);
    assert!(verify_result.is_ok(), "Verification failed: {:?}", verify_result.err());
    
    let is_valid = verify_result.unwrap();
    assert!(is_valid, "Proof verification returned false");
}
"""

field_sizes = [1, 2, 3, 5, 9, 17, 34]
for algo in ["anemoi", "mimc", "poseidon", "rescue_prime"]:
    for size in field_sizes:
        output += f"""
#[test]
fn test_prove_and_verify_{algo}_field_{size}() {{
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/{algo}_field_{size}.pkp");
    let pkv_path = manifest_dir.join("test_vectors/{algo}_field_{size}.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{{}}f.json", {size}));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input{size}f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {{
        if let Some(s) = v.as_str() {{
            format!("\\\"{{}}\\\"", s)
        }} else if let Some(n) = v.as_u64() {{
            format!("\\\"{{}}\\\"", n)
        }} else {{
            panic!("Unexpected type in array")
        }}
    }}).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{{}}]\\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}}
"""

byte_sizes = [16, 32, 64, 128, 256, 512, 1028]
for size in byte_sizes:
    output += f"""
#[test]
fn test_prove_and_verify_sha256_bytes_{size}() {{
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/sha256_bytes_{size}.pkp");
    let pkv_path = manifest_dir.join("test_vectors/sha256_bytes_{size}.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/bytes");
    let input_json_path = inputs_dir.join(format!("input{{}}.json", {size}));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input{size}.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {{
        if let Some(s) = v.as_str() {{
            format!("\\\"{{}}\\\"", s)
        }} else if let Some(n) = v.as_u64() {{
            format!("\\\"{{}}\\\"", n)
        }} else {{
            panic!("Unexpected type in array")
        }}
    }}).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{{}}]\\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}}
"""

with open("/home/anand/Deimos/benchmarking-suite/moPro/provekit-wrapper/tests/test_prove_verify.rs", "w") as f:
    f.write(output)
print("Updated test_prove_verify.rs")
