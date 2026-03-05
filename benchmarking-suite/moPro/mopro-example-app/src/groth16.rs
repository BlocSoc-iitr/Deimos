//! Groth16 (Arkworks-based) proving backend.
//!
//! This module wraps the `circom-prover` crate to provide Groth16 proof generation
//! and verification for circuits compiled with Circom. Enabled via the `groth16` feature flag.

use crate::MoproError;
use circom_prover::{
    prover::{
        circom::{
            Proof as CircomProverProof, CURVE_BLS12_381, CURVE_BN254, G1 as CircomProverG1,
            G2 as CircomProverG2,
        },
        ProofLib as CircomProverProofLib,
    },
    CircomProver,
};
use num_bigint::BigUint;
use std::str::FromStr;

/// The result of a Groth16 proof generation, containing the proof and public inputs.
#[derive(Debug, Clone, uniffi::Record)]
pub struct Groth16ProofResult {
    /// The Groth16 proof.
    pub proof: Groth16Proof,
    /// The public inputs as string-encoded field elements.
    pub inputs: Vec<String>,
}

/// A Groth16 proof in G1/G2 representation.
#[derive(Debug, Clone, Default, uniffi::Record)]
pub struct Groth16Proof {
    /// First G1 element (A).
    pub a: G1,
    /// G2 element (B).
    pub b: G2,
    /// Second G1 element (C).
    pub c: G1,
    /// Proof protocol identifier (e.g. "groth16").
    pub protocol: String,
    /// Elliptic curve identifier (e.g. "bn254").
    pub curve: String,
}

/// A point on a G1 elliptic curve group, represented as string-encoded coordinates.
#[derive(Debug, Clone, Default, uniffi::Record)]
pub struct G1 {
    /// X coordinate.
    pub x: String,
    /// Y coordinate.
    pub y: String,
    /// Z coordinate (projective).
    pub z: String,
}

/// A point on a G2 elliptic curve group, represented as string-encoded coordinate pairs.
#[derive(Debug, Clone, Default, uniffi::Record)]
pub struct G2 {
    /// X coordinates (degree-2 extension field).
    pub x: Vec<String>,
    /// Y coordinates (degree-2 extension field).
    pub y: Vec<String>,
    /// Z coordinates (projective, degree-2 extension field).
    pub z: Vec<String>,
}

/// Selects the proof backend library for Groth16 proof generation.
#[derive(Debug, Clone, Default, uniffi::Enum)]
pub enum ProofLib {
    /// Use the Arkworks Rust library (default).
    #[default]
    Arkworks,
    /// Use the Rapidsnark C++ library.
    Rapidsnark,
}

//
// `From` implementation for proof conversion
//
impl From<CircomProverProof> for Groth16Proof {
    fn from(proof: CircomProverProof) -> Self {
        Groth16Proof {
            a: proof.a.into(),
            b: proof.b.into(),
            c: proof.c.into(),
            protocol: proof.protocol,
            curve: proof.curve,
        }
    }
}

impl TryFrom<Groth16Proof> for CircomProverProof {
    type Error = MoproError;

    fn try_from(proof: Groth16Proof) -> Result<Self, Self::Error> {
        Ok(CircomProverProof {
            a: proof.a.try_into()?,
            b: proof.b.try_into()?,
            c: proof.c.try_into()?,
            protocol: proof.protocol,
            curve: proof.curve,
        })
    }
}

impl From<CircomProverG1> for G1 {
    fn from(g1: CircomProverG1) -> Self {
        G1 {
            x: g1.x.to_string(),
            y: g1.y.to_string(),
            z: g1.z.to_string(),
        }
    }
}

impl TryFrom<G1> for CircomProverG1 {
    type Error = MoproError;

    fn try_from(g1: G1) -> Result<Self, Self::Error> {
        Ok(CircomProverG1 {
            x: BigUint::from_str(g1.x.as_str())
                .map_err(|e| MoproError::Groth16Error(format!("Invalid G1.x: {}", e)))?,
            y: BigUint::from_str(g1.y.as_str())
                .map_err(|e| MoproError::Groth16Error(format!("Invalid G1.y: {}", e)))?,
            z: BigUint::from_str(g1.z.as_str())
                .map_err(|e| MoproError::Groth16Error(format!("Invalid G1.z: {}", e)))?,
        })
    }
}

impl From<CircomProverG2> for G2 {
    fn from(g2: CircomProverG2) -> Self {
        let x = vec![g2.x[0].to_string(), g2.x[1].to_string()];
        let y = vec![g2.y[0].to_string(), g2.y[1].to_string()];
        let z = vec![g2.z[0].to_string(), g2.z[1].to_string()];
        G2 { x, y, z }
    }
}

impl TryFrom<G2> for CircomProverG2 {
    type Error = MoproError;

    fn try_from(g2: G2) -> Result<Self, Self::Error> {
        let parse = |v: &[String], coord: &str| -> Result<Vec<BigUint>, MoproError> {
            v.iter()
                .map(|p| {
                    BigUint::from_str(p.as_str()).map_err(|e| {
                        MoproError::Groth16Error(format!("Invalid G2.{}: {}", coord, e))
                    })
                })
                .collect()
        };
        let x = parse(&g2.x, "x")?;
        let y = parse(&g2.y, "y")?;
        let z = parse(&g2.z, "z")?;
        Ok(CircomProverG2 {
            x: [x[0].clone(), x[1].clone()],
            y: [y[0].clone(), y[1].clone()],
            z: [z[0].clone(), z[1].clone()],
        })
    }
}

impl Into<CircomProverProofLib> for ProofLib {
    fn into(self) -> CircomProverProofLib {
        match self {
            ProofLib::Arkworks => CircomProverProofLib::Arkworks,
            ProofLib::Rapidsnark => CircomProverProofLib::Rapidsnark,
        }
    }
}

/// Generates a Groth16 proof for a Circom circuit.
///
/// # Arguments
/// - `zkey_path`: path to the `.zkey` proving key file
/// - `circuit_inputs`: JSON-encoded circuit inputs
/// - `proof_lib`: which backend library to use (Arkworks or Rapidsnark)
///
/// # Returns
/// `Ok(Groth16ProofResult)` containing the proof and public inputs, or a `MoproError`.
#[uniffi::export]
pub(crate) fn generate_groth16_proof(
    zkey_path: String,
    circuit_inputs: String,
    proof_lib: ProofLib,
) -> Result<Groth16ProofResult, MoproError> {
    let name = std::path::Path::new(zkey_path.as_str())
        .file_name()
        .ok_or_else(|| {
            MoproError::Groth16Error("failed to parse file name from zkey_path".to_string())
        })?;

    let witness_fn = crate::groth16_get(name.to_str().ok_or_else(|| {
        MoproError::Groth16Error("zkey file name contains invalid UTF-8".to_string())
    })?)
    .ok_or_else(|| {
        MoproError::Groth16Error(format!("Unknown ZKEY: {}", name.to_string_lossy()))
    })?;

    let ret = CircomProver::prove(proof_lib.into(), witness_fn, circuit_inputs, zkey_path)
        .map_err(|e| MoproError::Groth16Error(format!("Generate Proof error: {}", e)))?;

    let (proof, pub_inputs) = match ret.proof.curve.as_ref() {
        CURVE_BN254 | CURVE_BLS12_381 => (ret.proof.into(), ret.pub_inputs.into()),
        _ => {
            return Err(MoproError::Groth16Error(format!(
                "Unsupported curve: {}",
                ret.proof.curve
            )))
        }
    };

    Ok(Groth16ProofResult {
        proof,
        inputs: pub_inputs,
    })
}

/// Verifies a Groth16 proof for a Circom circuit.
///
/// # Arguments
/// - `zkey_path`: path to the `.zkey` proving key file
/// - `proof_result`: the proof and public inputs to verify
/// - `proof_lib`: which backend library was used to generate the proof
///
/// # Returns
/// `Ok(true)` if the proof is valid, `Err(MoproError)` on failure.
#[uniffi::export]
pub(crate) fn verify_groth16_proof(
    zkey_path: String,
    proof_result: Groth16ProofResult,
    proof_lib: ProofLib,
) -> Result<bool, MoproError> {
    let chosen_proof_lib = proof_lib.into();
    let proof: CircomProverProof = proof_result
        .proof
        .try_into()
        .map_err(|e: MoproError| e)?;
    CircomProver::verify(
        chosen_proof_lib,
        circom_prover::prover::CircomProof {
            proof,
            pub_inputs: proof_result.inputs.into(),
        },
        zkey_path,
    )
    .map_err(|e| MoproError::Groth16Error(format!("Verification error: {}", e)))
}

/// Registers the set of Groth16 circuits available to the prover.
///
/// Accepts a list of `(zkey_filename, WitnessFn)` pairs and generates
/// a static lookup table plus a `groth16_get(name)` accessor function.
///
/// ## Example
/// ```ignore
/// set_groth16_circuits! {
///     ("multiplier2.zkey", WitnessFn::RustWitness(multiplier2_witness)),
/// }
/// ```
#[macro_export]
macro_rules! set_groth16_circuits {
    // Accept any number of (key, func) pairs
    ($(($key:expr, $func:expr)),+ $(,)?) => {

        // Adjust the path if these types live elsewhere
        use circom_prover::witness::WitnessFn;

        const GROTH16_CIRCUITS: &[(&'static str, WitnessFn)] = &[
            $(
                ($key, $func),
            )+
        ];

        #[inline]
        pub fn groth16_get(name: &str) -> Option<WitnessFn> {
            GROTH16_CIRCUITS.iter()
                .find(|(k, _)| *k == name)
                .map(|(_, v)| *v)
        }
    };
}
