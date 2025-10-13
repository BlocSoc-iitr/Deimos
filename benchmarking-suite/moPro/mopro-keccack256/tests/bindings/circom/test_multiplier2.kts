import uniffi.mopro_keccack256.*

try {
    var zkeyPath = "./test-vectors/circom/circom.zkey"

    val input_str: String = """{
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
    }"""

    // Generate proof
    var generateProofResult = generateCircomProof(zkeyPath, input_str, ProofLib.ARKWORKS)

    // Verify proof
    var isValid = verifyCircomProof(zkeyPath, generateProofResult, ProofLib.ARKWORKS)
    assert(isValid) { "Proof is invalid" }

    assert(generateProofResult.proof.a.x.isNotEmpty()) { "Proof is empty" }
    assert(generateProofResult.inputs.size > 0) { "Inputs are empty" }


} catch (e: Exception) {
    println(e)
    throw e
}
