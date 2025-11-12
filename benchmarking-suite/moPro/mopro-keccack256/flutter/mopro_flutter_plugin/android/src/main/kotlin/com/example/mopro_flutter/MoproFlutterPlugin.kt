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

class FlutterCircomProof(a: FlutterG1, b: FlutterG2, c: FlutterG1, protocol: String, curve: String) {
    val a = a
    val b = b
    val c = c
    val protocol = protocol
    val curve = curve
}

class FlutterCircomProofResult(proof: FlutterCircomProof, inputs: List<String>) {
    val proof = proof
    val inputs = inputs
}

fun convertCircomProof(res: CircomProofResult): Map<String, Any> {
    val g1a = FlutterG1(res.proof.a.x, res.proof.a.y, res.proof.a.z)
            val g2b = FlutterG2(res.proof.b.x, res.proof.b.y, res.proof.b.z)
            val g1c = FlutterG1(res.proof.c.x, res.proof.c.y, res.proof.c.z)
            val circomProof = FlutterCircomProof(g1a, g2b, g1c, res.proof.protocol, res.proof.curve)
            val circomProofResult = FlutterCircomProofResult(circomProof, res.inputs)
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
fun convertCircomProofResult(proofResult: Map<String, Any>): CircomProofResult {
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
    val circomProof = CircomProof(
        g1a,
        g2b,
        g1c,
        proofMap["protocol"] as String,
        proofMap["curve"] as String
    )
    val circomProofResult = CircomProofResult(circomProof, proofResult["inputs"] as List<String>)
    return circomProofResult
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
        if (call.method == "generateCircomProof") {
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

            val res = generateCircomProof(zkeyPath, inputs, proofLib)
            val resultMap = convertCircomProof(res)

            
            result.success(resultMap)
        } else if (call.method == "verifyCircomProof") {
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

            val circomProofResult = convertCircomProofResult(proof)
            val res = verifyCircomProof(zkeyPath, circomProofResult, proofLib)
            result.success(res)

        } else if (call.method== "generateHalo2Proof") {
            val srsPath = call.argument<String>("srsPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing srsPath",
                null
            )

            val pkPath = call.argument<String>("pkPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing pkPath",
                null
            )

            val inputs = call.argument<Map<String, List<String>>>("inputs") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing inputs",
                null
            )

            val res = generateHalo2Proof(srsPath, pkPath, inputs)
            val resultMap = mapOf(
                "proof" to res.proof,
                "inputs" to res.inputs
            )

            result.success(resultMap)
        } else if (call.method== "verifyHalo2Proof") {
            val srsPath = call.argument<String>("srsPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing srsPath",
                null
            )

            val vkPath = call.argument<String>("vkPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing vkPath",
                null
            )

            val proof = call.argument<ByteArray>("proof") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing proof",
                null
            )

            val inputs = call.argument<ByteArray>("inputs") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing inputs",
                null
            )

            val res = verifyHalo2Proof(srsPath, vkPath, proof, inputs)
            result.success(res)
        } else if (call.method== "generateNoirProof") {
            val circuitPath = call.argument<String>("circuitPath") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing circuitPath",
                null
            )

            val srsPath = call.argument<String>("srsPath") 

            val inputs: List<String> = call.argument<List<Any>>("inputs")
            ?.map { it.toString() } ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing or invalid inputs",
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

            val res = generateNoirProof(circuitPath, srsPath, inputs, onChain, vk, lowMemoryMode)
            result.success(res)
        } else if (call.method== "verifyNoirProof") {
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

            val res = verifyNoirProof(circuitPath, proof, onChain, vk, lowMemoryMode)
            result.success(res)

        } else if (call.method== "getNoirVerificationKey") {
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

            val res = getNoirVerificationKey(circuitPath, srsPath, onChain, lowMemoryMode)
            result.success(res)

        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
