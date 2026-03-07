/// The unified error type exposed to UniFFI consumers.
///
/// Each variant corresponds to one proving backend. The inner `String`
/// carries a human-readable description of what went wrong.
///
/// Note: declared inside this file rather than via the `mopro_ffi::app!()`
/// macro due to a UniFFI limitation (see <https://github.com/mozilla/uniffi-rs/issues/2257>).
#[derive(Debug, thiserror::Error, uniffi::Error)]
pub enum MoproError {
    /// An error that occurred in the Groth16 (Arkworks/Circom) backend.
    #[error("Groth16Error: {0}")]
    Groth16Error(String),
    /// An error that occurred in the Barretenberg (Noir/UltraHonk) backend.
    #[error("BarretenbergError: {0}")]
    BarretenbergError(String),
}
