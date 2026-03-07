package com.example.mopro_flutter_example.channels

import android.content.Context
import android.util.Log
import com.ingonyama.imp1.DeviceType
import com.ingonyama.imp1.NativeBridge
import com.ingonyama.imp1.ProverException
import com.ingonyama.imp1.VerifierResult
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Platform channel for IMP1 proof generation and verification
 * Uses pre-bundled witness files
 */
class IMP1ProverChannel(private val context: Context) : MethodChannel.MethodCallHandler {
    
    companion object {
        const val CHANNEL_NAME = "com.deimos.imp1/prover"
        private const val TAG = "IMP1ProverChannel"
    }
    
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "generateProof" -> generateProof(call, result)
            "verifyProof" -> verifyProof(call, result)
            else -> result.notImplemented()
        }
    }
    
    /**
     * Generate a proof using IMP1
     * Expects: circuitName (String)
     * Uses pre-bundled witness file
     */
    private fun generateProof(call: MethodCall, result: MethodChannel.Result) {
        try {
            val circuitName = call.argument<String>("circuitName") 
                ?: return result.error("INVALID_ARGS", "circuitName required", null)
            
            Log.d(TAG, "Generating proof for circuit: $circuitName")
            
            // Prepare file paths
            val cacheDir = context.cacheDir
            val witnessFile = copyAssetToCache("groth16/wtns/${circuitName}.wtns")
            val zkeyFile = copyAssetToCache("groth16/zkey/${circuitName}.zkey")
            val proofFile = File(cacheDir, "proof_${circuitName}_${System.currentTimeMillis()}.proof")
            val publicFile = File(cacheDir, "public_${circuitName}_${System.currentTimeMillis()}.public")
            
            Log.d(TAG, "Files prepared:")
            Log.d(TAG, "  Witness: ${witnessFile.absolutePath} (${witnessFile.length()} bytes)")
            Log.d(TAG, "  Zkey: ${zkeyFile.absolutePath} (${zkeyFile.length()} bytes)")
            
            // Generate proof with IMP1
            val startTime = System.currentTimeMillis()
            NativeBridge.prove(
                witnessPath = witnessFile.absolutePath,
                zkeyPath = zkeyFile.absolutePath,
                proofPath = proofFile.absolutePath,
                publicPath = publicFile.absolutePath,
                deviceType = DeviceType.CPU
            )
            val provingTime = System.currentTimeMillis() - startTime
            
            Log.d(TAG, "Proof generated in ${provingTime}ms")
            
            // Read generated files
            val proofData = proofFile.readText()
            val publicInputs = publicFile.readText()
            val proofSize = proofFile.length().toInt()
            
            Log.d(TAG, "Proof size: $proofSize bytes")
            
            // Return result
            result.success(mapOf(
                "proof" to proofData,
                "publicInputs" to publicInputs,
                "provingTimeMs" to provingTime,
                "proofSizeBytes" to proofSize
            ))
            
        } catch (e: ProverException) {
            Log.e(TAG, "Prover error: ${e.message}", e)
            result.error("PROVER_ERROR", e.message, null)
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected error: ${e.message}", e)
            result.error("UNKNOWN_ERROR", e.message, e.stackTraceToString())
        }
    }
    
    /**
     * Verify a proof using IMP1
     */
    private fun verifyProof(call: MethodCall, result: MethodChannel.Result) {
        try {
            val circuitName = call.argument<String>("circuitName")
                ?: return result.error("INVALID_ARGS", "circuitName required", null)
            val proofData = call.argument<String>("proofData")
                ?: return result.error("INVALID_ARGS", "proofData required", null)
            val publicInputs = call.argument<String>("publicInputs")
                ?: return result.error("INVALID_ARGS", "publicInputs required", null)
            
            Log.d(TAG, "Verifying proof for circuit: $circuitName")
            
            // Write proof and public to temp files
            val cacheDir = context.cacheDir
            val proofFile = File(cacheDir, "verify_proof_${System.currentTimeMillis()}.proof").apply { 
                writeText(proofData) 
            }
            val publicFile = File(cacheDir, "verify_public_${System.currentTimeMillis()}.public").apply { 
                writeText(publicInputs) 
            }
            
            // Copy verification key from assets
            val vkFile = copyAssetToCache("groth16/vk/${circuitName}_vk.json")
            
            // Verify with IMP1
            val startTime = System.currentTimeMillis()
            val verifyResult = NativeBridge.verify(
                proofPath = proofFile.absolutePath,
                publicPath = publicFile.absolutePath,
                vkPath = vkFile.absolutePath
            )
            val verificationTime = System.currentTimeMillis() - startTime
            
            val isValid = verifyResult == VerifierResult.SUCCESS
            
            Log.d(TAG, "Verification completed in ${verificationTime}ms: $isValid")
            
            // Clean up
            proofFile.delete()
            publicFile.delete()
            
            result.success(mapOf(
                "isValid" to isValid,
                "verificationTimeMs" to verificationTime
            ))
            
        } catch (e: Exception) {
            Log.e(TAG, "Verification error: ${e.message}", e)
            result.error("VERIFICATION_ERROR", e.message, e.stackTraceToString())
        }
    }
    
    /**
     * Copy an asset file to cache directory
     */
    private fun copyAssetToCache(assetPath: String): File {
        // Extract filename from path
        val fileName = File(assetPath).name
        val cacheFile = File(context.cacheDir, fileName)
        
        if (cacheFile.exists() && cacheFile.length() > 0) {
            Log.d(TAG, "Reusing cached file: $fileName")
            return cacheFile
        }
        
        // Flutter assets are under flutter_assets/assets/ path
        // We append the provided relative path (which includes subdirs)
        val flutterAssetPath = "flutter_assets/assets/$assetPath"
        Log.d(TAG, "Copying asset from: $flutterAssetPath")
        context.assets.open(flutterAssetPath).use { input ->
            cacheFile.outputStream().use { output ->
                input.copyTo(output)
            }
        }
        
        Log.d(TAG, "Asset copied: ${cacheFile.length()} bytes")
        return cacheFile
    }
}
