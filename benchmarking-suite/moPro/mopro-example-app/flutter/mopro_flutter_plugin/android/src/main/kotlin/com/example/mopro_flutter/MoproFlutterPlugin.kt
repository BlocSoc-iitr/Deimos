package com.example.mopro_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import uniffi.mopro.*

import io.flutter.plugin.common.StandardMethodCodec

class FlutterG1(x: String, y: String, z: String) {
    val x = x
    val y = y
    val z = z
}

class FlutterG2(x: List<String>, y: List<String>, z: List<String>) {
    val x = x
    val y = y
    val z = z
}

class FlutterGroth16Proof(a: FlutterG1, b: FlutterG2, c: FlutterG1, protocol: String, curve: String) {
    val a = a
    val b = b
    val c = c
    val protocol = protocol
    val curve = curve
}

class FlutterGroth16ProofResult(proof: FlutterGroth16Proof, inputs: List<String>) {
    val proof = proof
    val inputs = inputs
}

fun convertGroth16Proof(res: Groth16ProofResult): Map<String, Any> {
    val g1a = FlutterG1(res.proof.a.x, res.proof.a.y, res.proof.a.z)
            val g2b = FlutterG2(res.proof.b.x, res.proof.b.y, res.proof.b.z)
            val g1c = FlutterG1(res.proof.c.x, res.proof.c.y, res.proof.c.z)
            val circomProof = FlutterGroth16Proof(g1a, g2b, g1c, res.proof.protocol, res.proof.curve)
            val circomProofResult = FlutterGroth16ProofResult(circomProof, res.inputs)
            // Convert to Map before sending
    val resultMap = mapOf(
        "proof" to mapOf(
            "a" to mapOf(
                "x" to circomProofResult.proof.a.x,
                "y" to circomProofResult.proof.a.y,
                "z" to circomProofResult.proof.a.z
            ),
            "b" to mapOf(
                "x" to circomProofResult.proof.b.x,
                "y" to circomProofResult.proof.b.y,
                "z" to circomProofResult.proof.b.z
            ),
            "c" to mapOf(
                "x" to circomProofResult.proof.c.x,
                "y" to circomProofResult.proof.c.y,
                "z" to circomProofResult.proof.c.z
            ),
            "protocol" to circomProofResult.proof.protocol,
            "curve" to circomProofResult.proof.curve
        ),
        "inputs" to circomProofResult.inputs
    )
    return resultMap
}
fun convertGroth16ProofResult(proofResult: Map<String, Any>): Groth16ProofResult {
    val proofMap = proofResult["proof"] as Map<String, Any>
    val aMap = proofMap["a"] as Map<String, Any>
    val g1a = G1(
        aMap["x"] as String,
        aMap["y"] as String,
        aMap["z"] as String
    )
    val bMap = proofMap["b"] as Map<String, Any>
    val g2b = G2(
        bMap["x"] as List<String>,
        bMap["y"] as List<String>,
        bMap["z"] as List<String>
    )
    val cMap = proofMap["c"] as Map<String, Any>
    val g1c = G1(
        cMap["x"] as String,
        cMap["y"] as String,
        cMap["z"] as String
    )
    val groth16Proof = Groth16Proof(
        g1a,
        g2b,
        g1c,
        proofMap["protocol"] as String,
        proofMap["curve"] as String
    )
    val groth16ProofResult = Groth16ProofResult(groth16Proof, proofResult["inputs"] as List<String>)
    return groth16ProofResult
  }

/** MoproFlutterPlugin */
class MoproFlutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "mopro_flutter",
            StandardMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "generateGroth16Proof") {
            val zkeyPath = call.argument<String>("zkeyPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing zkeyPath",
                null
            )

            val inputs =
                call.argument<String>("inputs") ?: return result.error(
                    "ARGUMENT_ERROR",
                    "Missing inputs",
                    null
                )
            
            val proofLibIndex = call.argument<Int>("proofLib") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing proofLib",
                null
            )

            val proofLib = if (proofLibIndex == 0) ProofLib.ARKWORKS else ProofLib.RAPIDSNARK

            try {
                val res = generateGroth16Proof(zkeyPath, inputs, proofLib)
                val resultMap = convertGroth16Proof(res)
                result.success(resultMap)
            } catch (e: Exception) {
                result.error("PROOF_GENERATION_ERROR", "Failed to generate Groth16 proof", e.message)
            }
        } else if (call.method == "verifyGroth16Proof") {
            val zkeyPath = call.argument<String>("zkeyPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing zkeyPath",
                null
            )

            val proof = call.argument<Map<String, Any>>("proof") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing proof",
                null
            )

            val proofLibIndex = call.argument<Int>("proofLib") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing proofLib",
                null
            )

            val proofLib = if (proofLibIndex == 0) ProofLib.ARKWORKS else ProofLib.RAPIDSNARK

            try {
                val circomProofResult = convertGroth16ProofResult(proof)
                val res = verifyGroth16Proof(zkeyPath, circomProofResult, proofLib)
                result.success(res)
            } catch (e: Exception) {
                result.error("PROOF_VERIFICATION_ERROR", "Failed to verify Groth16 proof", e.message)
            }

        } else if (call.method== "generateBarretenbergProof") {
            val circuitPath = call.argument<String>("circuitPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing circuitPath",
                null
            )

            val srsPath = call.argument<String>("srsPath") 

            val inputs = call.argument<List<String>>("inputs") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing inputs",
                null
            )

            val onChain = call.argument<Boolean>("onChain") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing onChain",
                null
            )

            val vk = call.argument<ByteArray>("vk") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing vk",
                null
            )

            val lowMemoryMode = call.argument<Boolean>("lowMemoryMode") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing lowMemoryMode",
                null
            )

            val res = generateBarretenbergProof(circuitPath, srsPath, inputs, onChain, vk, lowMemoryMode)
            result.success(res)
        } else if (call.method== "verifyBarretenbergProof") {
            val circuitPath = call.argument<String>("circuitPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing circuitPath",
                null
            )

            val proof = call.argument<ByteArray>("proof") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing proof",
                null
            )

            val onChain = call.argument<Boolean>("onChain") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing onChain",
                null
            )

            val vk = call.argument<ByteArray>("vk") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing vk",
                null
            )

            val lowMemoryMode = call.argument<Boolean>("lowMemoryMode") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing lowMemoryMode",
                null
            )

            val res = verifyBarretenbergProof(circuitPath, proof, onChain, vk, lowMemoryMode)
            result.success(res)

        } else if (call.method== "getBarretenbergVerificationKey") {
            val circuitPath = call.argument<String>("circuitPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing circuitPath",
                null
            )

            val srsPath = call.argument<String>("srsPath")

            val onChain = call.argument<Boolean>("onChain") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing onChain",
                null
            )

            val lowMemoryMode = call.argument<Boolean>("lowMemoryMode") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing lowMemoryMode",
                null
            )

            val res = getBarretenbergVerificationKey(circuitPath, srsPath, onChain, lowMemoryMode)
            result.success(res)

        } else if (call.method== "generateRisc0Proof") {
            val input = call.argument<Int>("input") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing input",
                null
            )

            try {
                val res = risc0Prove(input.toUInt())
                val resultMap = mapOf(
                    "receipt" to res.receipt
                )
                result.success(resultMap)
            } catch (e: Exception) {
                result.error("PROOF_GENERATION_ERROR", "Failed to generate RISC0 proof", e.message)
            }

        } else if (call.method== "verifyRisc0Proof") {
            val receiptBytes = call.argument<ByteArray>("receiptBytes") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing receiptBytes",
                null
            )

            try {
                val res = risc0Verify(receiptBytes)
                val resultMap = mapOf(
                    "isValid" to res.isValid,
                    "outputValue" to res.outputValue.toInt()
                )
                result.success(resultMap)
            } catch (e: Exception) {
                result.error("PROOF_VERIFICATION_ERROR", "Failed to verify RISC0 proof", e.message)
            }
            
            
        } else if (call.method == "generateCairoProof") {
            val programJson = call.argument<String>("programJson") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing programJson",
                null
            )
            val inputsJson = call.argument<String>("inputsJson") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing inputsJson",
                null
            )

            try {
                val res = cairoProve(programJson, inputsJson)
                val resultMap = mapOf(
                    "proof" to res.proof
                )
                result.success(resultMap)
            } catch (e: Exception) {
                result.error("CAIRO_PROOF_ERROR", "Failed to generate Cairo proof: ${e.message}", null)
            }

        } else if (call.method == "verifyCairoProof") {
            val proof = call.argument<ByteArray>("proof") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing proof",
                null
            )

            try {
                val res = cairoVerify(proof)
                val resultMap = mapOf(
                    "is_valid" to res.isValid
                )
                result.success(resultMap)
            } catch (e: Exception) {
                result.error("CAIRO_VERIFY_ERROR", "Failed to verify Cairo proof: ${e.message}", null)
            }

        } else if (call.method == "generateProveKitProof") {
            val proverPath = call.argument<String>("proverPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing proverPath",
                null
            )
            val inputToml = call.argument<String>("inputToml") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing inputToml",
                null
            )

            try {
                val res = provekitProve(proverPath, inputToml)
                val resultMap = mapOf(
                    "proof" to res.proof
                )
                result.success(resultMap)
            } catch (e: Exception) {
                result.error("PROVEKIT_PROOF_ERROR", "Failed to generate ProveKit proof: ${e.message}", null)
            }

        } else if (call.method == "verifyProveKitProof") {
            val verifierPath = call.argument<String>("verifierPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing verifierPath",
                null
            )
            val proof = call.argument<ByteArray>("proof") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing proof",
                null
            )

            try {
                val res = provekitVerify(verifierPath, proof)
                val resultMap = mapOf(
                    "is_valid" to res.isValid
                )
                result.success(resultMap)
            } catch (e: Exception) {
                result.error("PROVEKIT_VERIFY_ERROR", "Failed to verify ProveKit proof: ${e.message}", null)
            }

        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
