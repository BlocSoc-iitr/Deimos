mopro_ffi::app!();

/// Barretenberg-only MoproError for single-backend configurations.
#[derive(Debug, thiserror::Error, uniffi::Error)]
pub enum MoproError {
    #[error("Barretenberg error: {0}")]
    BarretenbergError(String),
}

/// Returns a greeting string to verify FFI connectivity.
#[uniffi::export]
fn mopro_uniffi_hello_world() -> String {
    "Hello, World!".to_string()
}

#[macro_use]
mod stubs;

// Barretenberg (Noir/UltraHonk) backend
mod barretenberg;

#[cfg(test)]
mod uniffi_tests {
    #[test]
    fn test_mopro_uniffi_hello_world() {
        assert_eq!(super::mopro_uniffi_hello_world(), "Hello, World!");
    }
}
