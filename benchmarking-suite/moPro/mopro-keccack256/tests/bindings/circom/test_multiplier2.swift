import Foundation
import mopro_keccack256

do {
    let zkeyPath = "../../../test-vectors/circom/circom.zkey"

    // Keccak input: "Hello World! This is a test msg." as byte array
    let input_str = """
    {
        "in": [
            "72",
            "101",
            "108",
            "108",
            "111",
            "32",
            "87",
            "111",
            "114",
            "108",
            "100",
            "33",
            "32",
            "84",
            "104",
            "105",
            "115",
            "32",
            "105",
            "115",
            "32",
            "97",
            "32",
            "116",
            "101",
            "115",
            "116",
            "32",
            "109",
            "115",
            "103",
            "46"
        ]
    }
    """

    // Generate Proof
    let generateProofResult = try generateCircomProof(
        zkeyPath: zkeyPath, circuitInputs: input_str, proofLib: ProofLib.arkworks)
    assert(!generateProofResult.proof.a.x.isEmpty, "Proof should not be empty")

    // Verify Proof
    let isValid = try verifyCircomProof(zkeyPath: zkeyPath, proofResult: generateProofResult, proofLib: ProofLib.arkworks)
    assert(isValid, "Proof verification should succeed")

    assert(generateProofResult.proof.a.x.count > 0, "Proof should not be empty")
    assert(generateProofResult.inputs.count > 0, "Inputs should not be empty")

    print("Keccak proof generation and verification successful!")

} catch let error as MoproError {
    print("MoproError: \(error)")
    throw error
} catch {
    print("Unexpected error: \(error)")
    throw error
}
