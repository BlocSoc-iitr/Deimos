use provekit_wrapper::{prove, verify};
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

#[test]
fn test_prove_and_verify_anemoi_field_1() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/anemoi_field_1.pkp");
    let pkv_path = manifest_dir.join("test_vectors/anemoi_field_1.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 1));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input1f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_anemoi_field_2() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/anemoi_field_2.pkp");
    let pkv_path = manifest_dir.join("test_vectors/anemoi_field_2.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 2));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input2f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_anemoi_field_3() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/anemoi_field_3.pkp");
    let pkv_path = manifest_dir.join("test_vectors/anemoi_field_3.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 3));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input3f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_anemoi_field_5() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/anemoi_field_5.pkp");
    let pkv_path = manifest_dir.join("test_vectors/anemoi_field_5.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 5));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input5f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_anemoi_field_9() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/anemoi_field_9.pkp");
    let pkv_path = manifest_dir.join("test_vectors/anemoi_field_9.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 9));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input9f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_anemoi_field_17() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/anemoi_field_17.pkp");
    let pkv_path = manifest_dir.join("test_vectors/anemoi_field_17.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 17));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input17f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_anemoi_field_34() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/anemoi_field_34.pkp");
    let pkv_path = manifest_dir.join("test_vectors/anemoi_field_34.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 34));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input34f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_mimc_field_1() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/mimc_field_1.pkp");
    let pkv_path = manifest_dir.join("test_vectors/mimc_field_1.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 1));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input1f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_mimc_field_2() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/mimc_field_2.pkp");
    let pkv_path = manifest_dir.join("test_vectors/mimc_field_2.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 2));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input2f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_mimc_field_3() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/mimc_field_3.pkp");
    let pkv_path = manifest_dir.join("test_vectors/mimc_field_3.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 3));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input3f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_mimc_field_5() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/mimc_field_5.pkp");
    let pkv_path = manifest_dir.join("test_vectors/mimc_field_5.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 5));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input5f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_mimc_field_9() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/mimc_field_9.pkp");
    let pkv_path = manifest_dir.join("test_vectors/mimc_field_9.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 9));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input9f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_mimc_field_17() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/mimc_field_17.pkp");
    let pkv_path = manifest_dir.join("test_vectors/mimc_field_17.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 17));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input17f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_mimc_field_34() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/mimc_field_34.pkp");
    let pkv_path = manifest_dir.join("test_vectors/mimc_field_34.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 34));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input34f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_poseidon_field_1() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/poseidon_field_1.pkp");
    let pkv_path = manifest_dir.join("test_vectors/poseidon_field_1.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 1));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input1f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_poseidon_field_2() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/poseidon_field_2.pkp");
    let pkv_path = manifest_dir.join("test_vectors/poseidon_field_2.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 2));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input2f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_poseidon_field_3() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/poseidon_field_3.pkp");
    let pkv_path = manifest_dir.join("test_vectors/poseidon_field_3.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 3));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input3f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_poseidon_field_5() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/poseidon_field_5.pkp");
    let pkv_path = manifest_dir.join("test_vectors/poseidon_field_5.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 5));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input5f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_poseidon_field_9() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/poseidon_field_9.pkp");
    let pkv_path = manifest_dir.join("test_vectors/poseidon_field_9.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 9));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input9f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_poseidon_field_17() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/poseidon_field_17.pkp");
    let pkv_path = manifest_dir.join("test_vectors/poseidon_field_17.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 17));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input17f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_poseidon_field_34() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/poseidon_field_34.pkp");
    let pkv_path = manifest_dir.join("test_vectors/poseidon_field_34.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 34));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input34f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_rescue_prime_field_1() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/rescue_prime_field_1.pkp");
    let pkv_path = manifest_dir.join("test_vectors/rescue_prime_field_1.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 1));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input1f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_rescue_prime_field_2() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/rescue_prime_field_2.pkp");
    let pkv_path = manifest_dir.join("test_vectors/rescue_prime_field_2.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 2));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input2f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_rescue_prime_field_3() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/rescue_prime_field_3.pkp");
    let pkv_path = manifest_dir.join("test_vectors/rescue_prime_field_3.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 3));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input3f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_rescue_prime_field_5() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/rescue_prime_field_5.pkp");
    let pkv_path = manifest_dir.join("test_vectors/rescue_prime_field_5.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 5));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input5f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_rescue_prime_field_9() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/rescue_prime_field_9.pkp");
    let pkv_path = manifest_dir.join("test_vectors/rescue_prime_field_9.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 9));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input9f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_rescue_prime_field_17() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/rescue_prime_field_17.pkp");
    let pkv_path = manifest_dir.join("test_vectors/rescue_prime_field_17.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 17));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input17f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_rescue_prime_field_34() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/rescue_prime_field_34.pkp");
    let pkv_path = manifest_dir.join("test_vectors/rescue_prime_field_34.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/field_elements");
    let input_json_path = inputs_dir.join(format!("input{}f.json", 34));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input34f.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_sha256_bytes_16() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/sha256_bytes_16.pkp");
    let pkv_path = manifest_dir.join("test_vectors/sha256_bytes_16.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/bytes");
    let input_json_path = inputs_dir.join(format!("input{}.json", 16));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input16.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_sha256_bytes_32() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/sha256_bytes_32.pkp");
    let pkv_path = manifest_dir.join("test_vectors/sha256_bytes_32.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/bytes");
    let input_json_path = inputs_dir.join(format!("input{}.json", 32));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input32.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_sha256_bytes_64() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/sha256_bytes_64.pkp");
    let pkv_path = manifest_dir.join("test_vectors/sha256_bytes_64.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/bytes");
    let input_json_path = inputs_dir.join(format!("input{}.json", 64));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input64.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_sha256_bytes_128() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/sha256_bytes_128.pkp");
    let pkv_path = manifest_dir.join("test_vectors/sha256_bytes_128.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/bytes");
    let input_json_path = inputs_dir.join(format!("input{}.json", 128));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input128.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_sha256_bytes_256() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/sha256_bytes_256.pkp");
    let pkv_path = manifest_dir.join("test_vectors/sha256_bytes_256.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/bytes");
    let input_json_path = inputs_dir.join(format!("input{}.json", 256));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input256.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_sha256_bytes_512() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/sha256_bytes_512.pkp");
    let pkv_path = manifest_dir.join("test_vectors/sha256_bytes_512.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/bytes");
    let input_json_path = inputs_dir.join(format!("input{}.json", 512));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input512.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}

#[test]
fn test_prove_and_verify_sha256_bytes_1028() {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let pkp_path = manifest_dir.join("test_vectors/sha256_bytes_1028.pkp");
    let pkv_path = manifest_dir.join("test_vectors/sha256_bytes_1028.pkv");
    
    let inputs_dir = manifest_dir.join("../mopro-example-app/flutter/inputs/bytes");
    let input_json_path = inputs_dir.join(format!("input{}.json", 1028));
    let json_str = fs::read_to_string(&input_json_path).expect("Failed to read input json: input1028.json");
    
    let json_val: Value = serde_json::from_str(&json_str).expect("Failed to parse json");
    let in_array = json_val.get("in").expect("No 'in' field").as_array().expect("'in' is not an array");
    
    let toml_array = in_array.iter().map(|v| {
        if let Some(s) = v.as_str() {
            format!("\"{}\"", s)
        } else if let Some(n) = v.as_u64() {
            format!("\"{}\"", n)
        } else {
            panic!("Unexpected type in array")
        }
    }).collect::<Vec<_>>().join(", ");
    
    let input_toml = format!("input = [{}]\n", toml_array);
    run_prove_verify_for_circuit(pkp_path.to_str().unwrap(), pkv_path.to_str().unwrap(), &input_toml);
}
