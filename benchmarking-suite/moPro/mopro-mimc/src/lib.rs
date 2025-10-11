// Initializes the shared UniFFI scaffolding and defines the `MoproError` enum.
mopro_ffi::app!();

/// You can also customize the bindings by #[uniffi::export]
/// Reference: https://mozilla.github.io/uniffi-rs/latest/proc_macro/index.html
#[uniffi::export]
fn mopro_uniffi_hello_world() -> String {
    "Hello, World!".to_string()
}

#[macro_use]
mod stubs;

mod error;
pub use error::MoproError;

// CIRCOM_TEMPLATE
circom_stub!();

// HALO2_TEMPLATE
halo2_stub!();

// NOIR_TEMPLATE
// --- Noir Example of using Ultra Honk proving and verifying circuits ---

// Module containing the Noir circuit logic (Multiplier2)
mod noir;

#[cfg(test)]
mod noir_tests {
    use super::noir::{generate_noir_proof, get_noir_verification_key, verify_noir_proof};
    use serde_json::Value;
    use serial_test::serial;

    #[test]
    #[serial]
    fn test_noir_multiplier2() {
        let srs_path = "./test-vectors/noir/mimc.srs".to_string();
        let circuit_path = "./test-vectors/noir/mimc.json".to_string();
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

        // parse the JSON and convert to Vec<String> matching Noir's expected input shape
        // For the MiMC circuit the expected input is the `in` array (32 field elements).
        let json_val: Value = serde_json::from_str(&circuit_inputs).unwrap();
        let mut inputs_vec: Vec<String> = Vec::new();
        if let Some(arr) = json_val.get("in").and_then(|v| v.as_array()) {
            for e in arr {
                inputs_vec.push(e.as_str().unwrap().to_string());
            }
        }
        let vk = get_noir_verification_key(
            circuit_path.clone(),
            Some(srs_path.clone()),
            true,  // on_chain (uses Keccak for Solidity compatibility)
            false, // low_memory_mode
        )
        .unwrap();

        let proof = generate_noir_proof(
            circuit_path.clone(),
            Some(srs_path.clone()),
            inputs_vec,
            true, // on_chain (uses Keccak for Solidity compatibility)
            vk.clone(),
            false, // low_memory_mode
        )
        .unwrap();

        let valid = verify_noir_proof(
            circuit_path,
            proof,
            true, // on_chain (uses Keccak for Solidity compatibility)
            vk,
            false, // low_memory_mode
        )
        .unwrap();
        assert!(valid);
    }

    #[test]
    #[serial]
    fn test_noir_multiplier2_with_existing_vk() {
        // Use the MiMC test vectors (existing in this crate) and generate the VK via helper.
        let srs_path = "./test-vectors/noir/mimc.srs".to_string();
        let circuit_path = "./test-vectors/noir/mimc.json".to_string();

        // reuse the same JSON input from the other test
        let circuit_inputs = r#"{
    "in": [
        "40","202","21","44","148","225","219","127",
        "125","137","45","39","181","182","116","221",
        "65","64","40","99","92","60","3","33",
        "40","159","154","251","14","238","144","106"
    ]
}"#.to_string();

        let json_val: Value = serde_json::from_str(&circuit_inputs).unwrap();
        let mut inputs_vec: Vec<String> = Vec::new();
        if let Some(arr) = json_val.get("in").and_then(|v| v.as_array()) {
            for e in arr {
                inputs_vec.push(e.as_str().unwrap().to_string());
            }
        }

        // generate the verification key (keccak/on_chain = true)
        let vk = get_noir_verification_key(
            circuit_path.clone(),
            Some(srs_path.clone()),
            true,  // on_chain
            false, // low_memory_mode
        )
        .unwrap();

        let proof = generate_noir_proof(
            circuit_path.clone(),
            Some(srs_path),
            inputs_vec,
            true, // on_chain
            vk.clone(),
            false, // low_memory_mode
        )
        .unwrap();

        let valid = verify_noir_proof(
            circuit_path,
            proof,
            true, // on_chain
            vk,
            false, // low_memory_mode
        )
        .unwrap();
        assert!(valid);
    }
}


#[cfg(test)]
mod uniffi_tests {
    #[test]
    fn test_mopro_uniffi_hello_world() {
        assert_eq!(super::mopro_uniffi_hello_world(), "Hello, World!");
    }
}
