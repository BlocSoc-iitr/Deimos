// Here we're calling a macro exported with Uniffi. This macro will
// write some functions and bind them to FFI type.
// These functions include:
// - `generate_circom_proof`
// - `verify_circom_proof`
// - `generate_halo2_proof`
// - `verify_halo2_proof`
// - `generate_noir_proof`
// - `verify_noir_proof`
mopro_ffi::app!();

/// You can also customize the bindings by #[uniffi::export]
/// Reference: https://mozilla.github.io/uniffi-rs/latest/proc_macro/index.html
// #[uniffi::export]
// fn mopro_uniffi_hello_world() -> String {
//     "Hello, World!".to_string()
// }

// --- Circom Example of using groth16 proving and verifying circuits ---

// Module containing the Circom circuit logic (Multiplier2)

rust_witness::witness!(circom);

mopro_ffi::set_circom_circuits! {
    ("circom.zkey", mopro_ffi::witness::WitnessFn::RustWitness(circom_witness))
}

#[cfg(test)]
mod circom_tests {
    use super::*;

    #[test]
    fn test_circom() {
        let zkey_path = "./test-vectors/circom/circom.zkey".to_string();
        let circuit_inputs = r#"{
    "in": [
        "40","202","21","44","148","225","219","127",
        "125","137","45","39","181","182","116","221",
        "65","64","40","99","92","60","3","33",
        "40","159","154","251","14","238","144","106"
    ],
    "hash": [
        "200","2","99","144","139","188","123","236",
        "232","211","64","87","85","71","207","146",
        "2","6","23","143","54","243","126","167",
        "135","171","232","30","242","226","64","67"
    ]
}"#.to_string();

        let result = generate_circom_proof(zkey_path.clone(), circuit_inputs, ProofLib::Arkworks);
        assert!(result.is_ok());
        let proof = result.unwrap();
        assert!(verify_circom_proof(zkey_path, proof, ProofLib::Arkworks).is_ok());
    }
}


// --- Halo2 Example of using Plonk proving and verifying circuits ---

// Module containing the Halo2 circuit logic (FibonacciMoproCircuit)

// mopro_ffi::set_halo2_circuits! {
//     ("plonk_fibonacci_pk.bin", plonk_fibonacci::prove, "plonk_fibonacci_vk.bin", plonk_fibonacci::verify),
//     ("hyperplonk_fibonacci_pk.bin", hyperplonk_fibonacci::prove, "hyperplonk_fibonacci_vk.bin", hyperplonk_fibonacci::verify),
//     ("gemini_fibonacci_pk.bin", gemini_fibonacci::prove, "gemini_fibonacci_vk.bin", gemini_fibonacci::verify),
// }

// #[cfg(test)]
// mod halo2_tests {
//     use std::collections::HashMap;

//     use super::*;

//     #[test]
//     fn test_plonk_fibonacci() {
//         let srs_path = "./test-vectors/halo2/plonk_fibonacci_srs.bin".to_string();
//         let pk_path = "./test-vectors/halo2/plonk_fibonacci_pk.bin".to_string();
//         let vk_path = "./test-vectors/halo2/plonk_fibonacci_vk.bin".to_string();
//         let mut circuit_inputs = HashMap::new();
//         circuit_inputs.insert("out".to_string(), vec!["55".to_string()]);
//         let result = generate_halo2_proof(srs_path.clone(), pk_path.clone(), circuit_inputs);
//         assert!(result.is_ok());
//         let halo2_proof_result = result.unwrap();
//         let valid = verify_halo2_proof(
//             srs_path,
//             vk_path,
//             halo2_proof_result.proof,
//             halo2_proof_result.inputs,
//         );
//         assert!(valid.is_ok());
//         assert!(valid.unwrap());
//     }

//     #[test]
//     fn test_hyperplonk_fibonacci() {
//         let srs_path = "./test-vectors/halo2/hyperplonk_fibonacci_srs.bin".to_string();
//         let pk_path = "./test-vectors/halo2/hyperplonk_fibonacci_pk.bin".to_string();
//         let vk_path = "./test-vectors/halo2/hyperplonk_fibonacci_vk.bin".to_string();
//         let mut circuit_inputs = HashMap::new();
//         circuit_inputs.insert("out".to_string(), vec!["55".to_string()]);
//         let result = generate_halo2_proof(srs_path.clone(), pk_path.clone(), circuit_inputs);
//         assert!(result.is_ok());
//         let halo2_proof_result = result.unwrap();
//         let valid = verify_halo2_proof(
//             srs_path,
//             vk_path,
//             halo2_proof_result.proof,
//             halo2_proof_result.inputs,
//         );
//         assert!(valid.is_ok());
//         assert!(valid.unwrap());
//     }

//     #[test]
//     fn test_gemini_fibonacci() {
//         let srs_path = "./test-vectors/halo2/gemini_fibonacci_srs.bin".to_string();
//         let pk_path = "./test-vectors/halo2/gemini_fibonacci_pk.bin".to_string();
//         let vk_path = "./test-vectors/halo2/gemini_fibonacci_vk.bin".to_string();
//         let mut circuit_inputs = HashMap::new();
//         circuit_inputs.insert("out".to_string(), vec!["55".to_string()]);
//         let result = generate_halo2_proof(srs_path.clone(), pk_path.clone(), circuit_inputs);
//         assert!(result.is_ok());
//         let halo2_proof_result = result.unwrap();
//         let valid = verify_halo2_proof(
//             srs_path,
//             vk_path,
//             halo2_proof_result.proof,
//             halo2_proof_result.inputs,
//         );
//         assert!(valid.is_ok());
//         assert!(valid.unwrap());
//     }
// }


// #[cfg(test)]
// mod noir_tests {
//     use super::*;

//     #[test]
//     fn test_noir_multiplier2() {
//         let srs_path = "./test-vectors/noir/noir_multiplier2.srs".to_string();
//         let circuit_path = "./test-vectors/noir/noir_multiplier2.json".to_string();
//         let circuit_inputs = vec!["3".to_string(), "5".to_string()];
//         let result = generate_noir_proof(
//             circuit_path.clone(),
//             Some(srs_path.clone()),
//             circuit_inputs.clone(),
//         );
//         assert!(result.is_ok());
//         let proof = result.unwrap();
//         let result = verify_noir_proof(circuit_path.clone(), proof);
//         assert!(result.is_ok());
//         let valid = result.unwrap();
//         assert!(valid);
//     }
// }


// #[cfg(test)]
// mod uniffi_tests {
//     use super::*;

//     #[test]
//     fn test_mopro_uniffi_hello_world() {
//         assert_eq!(mopro_uniffi_hello_world(), "Hello, World!");
//     }
// }
