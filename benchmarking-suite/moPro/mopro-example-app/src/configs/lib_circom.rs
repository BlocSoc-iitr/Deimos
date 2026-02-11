mopro_ffi::app!();

#[derive(Debug, thiserror::Error, uniffi::Error)]
pub enum MoproError {
    #[error("Circom error: {0}")]
    CircomError(String),
}

mod circom;

use std::collections::HashMap;
use num_bigint::BigInt;


// Bytes circuits
rust_witness::witness!(blake2s25616);
rust_witness::witness!(blake2s25632);
rust_witness::witness!(blake2s25664);
rust_witness::witness!(blake2s256128);

rust_witness::witness!(blake316);
rust_witness::witness!(blake332);
rust_witness::witness!(blake364);
rust_witness::witness!(blake3128);

rust_witness::witness!(keccak25616);
rust_witness::witness!(keccak25632);
rust_witness::witness!(keccak25664);
rust_witness::witness!(keccak256128);

rust_witness::witness!(sha25616);
rust_witness::witness!(sha25632);
rust_witness::witness!(sha25664);
rust_witness::witness!(sha256128);

rust_witness::witness!(pedersen16);
rust_witness::witness!(pedersen32);
rust_witness::witness!(pedersen64);
rust_witness::witness!(pedersen128);

// Field circuits
rust_witness::witness!(mimc25616f);
rust_witness::witness!(mimc25632f);
rust_witness::witness!(mimc25664f);
rust_witness::witness!(mimc256128f);

rust_witness::witness!(poseidon16f);
rust_witness::witness!(poseidon32f);
rust_witness::witness!(poseidon64f);
rust_witness::witness!(poseidon128f);

rust_witness::witness!(rescueprime16f);
rust_witness::witness!(rescueprime32f);
rust_witness::witness!(rescueprime64f);
rust_witness::witness!(rescueprime128f);

set_circom_circuits! {
    ("blake2s256_16.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s25616_witness)),
    ("blake2s256_32.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s25632_witness)),
    ("blake2s256_64.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s25664_witness)),
    ("blake2s256_128.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s256128_witness)),

    ("blake3_16.zkey", circom_prover::witness::WitnessFn::RustWitness(blake316_witness)),
    ("blake3_32.zkey", circom_prover::witness::WitnessFn::RustWitness(blake332_witness)),
    ("blake3_64.zkey", circom_prover::witness::WitnessFn::RustWitness(blake364_witness)),
    ("blake3_128.zkey", circom_prover::witness::WitnessFn::RustWitness(blake3128_witness)),

    ("keccak256_16.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak25616_witness)),
    ("keccak256_32.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak25632_witness)),
    ("keccak256_64.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak25664_witness)),
    ("keccak256_128.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak256128_witness)),

    ("sha256_16.zkey", circom_prover::witness::WitnessFn::RustWitness(sha25616_witness)),
    ("sha256_32.zkey", circom_prover::witness::WitnessFn::RustWitness(sha25632_witness)),
    ("sha256_64.zkey", circom_prover::witness::WitnessFn::RustWitness(sha25664_witness)),
    ("sha256_128.zkey", circom_prover::witness::WitnessFn::RustWitness(sha256128_witness)),

    ("pedersen_16.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen16_witness)),
    ("pedersen_32.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen32_witness)),
    ("pedersen_64.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen64_witness)),
    ("pedersen_128.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen128_witness)),

    ("mimc256_16f.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc25616f_witness)),
    ("mimc256_32f.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc25632f_witness)),
    ("mimc256_64f.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc25664f_witness)),
    ("mimc256_128f.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc256128f_witness)),

    ("poseidon_16f.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon16f_witness)),
    ("poseidon_32f.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon32f_witness)),
    ("poseidon_64f.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon64f_witness)),
    ("poseidon_128f.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon128f_witness)),

    ("rescue-prime_16f.zkey", circom_prover::witness::WitnessFn::RustWitness(rescueprime16f_witness)),
    ("rescue-prime_32f.zkey", circom_prover::witness::WitnessFn::RustWitness(rescueprime32f_witness)),
    ("rescue-prime_64f.zkey", circom_prover::witness::WitnessFn::RustWitness(rescueprime64f_witness)),
    ("rescue-prime_128f.zkey", circom_prover::witness::WitnessFn::RustWitness(rescueprime128f_witness)),
}

#[uniffi::export]
fn mopro_uniffi_hello_world() -> String {
    "Hello, World!".to_string()
}
