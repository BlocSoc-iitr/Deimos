import 'package:flutter/services.dart';

/// Flutter channel for IMP1 Mobile Prover
class IMP1Channel {
  static const MethodChannel _channel =
      MethodChannel('com.deimos.imp1/prover');

  /// Generate a proof using IMP1
  /// 
  /// [circuitName] should be the name without extension (e.g., "sha256")
  /// [circuitInputsJson] is the JSON string of circuit inputs
  /// Assets required:
  /// - ${circuitName}.zkey (proving key)
  /// - ${circuitName}_vk.json (verification key)
  static Future<IMP1ProofResult> generateProof({
    required String circuitName,
  }) async {
    try {
      print('[IMP1] Generating proof for: $circuitName');
      
      final result = await _channel.invokeMethod('generateProof', {
        'circuitName': circuitName,
      });

      return IMP1ProofResult(
        proof: result['proof'] as String,
        publicInputs: result['publicInputs'] as String,
        provingTimeMs: result['provingTimeMs'] as int,
        proofSizeBytes: result['proofSizeBytes'] as int,
      );
    } on PlatformException catch (e) {
      print('[IMP1] Proof generation failed: ${e.message}');
      throw IMP1ProverException(
        'Failed to generate proof: ${e.message}',
        e.code,
      );
    } catch (e) {
      print('[IMP1] Unexpected error: $e');
      rethrow;
    }
  }

  /// Verify a proof using IMP1
  static Future<IMP1VerifyResult> verifyProof({
    required String circuitName,
    required String proofData,
    required String publicInputs,
  }) async {
    try {
      print('[IMP1] Verifying proof for: $circuitName');
      
      final result = await _channel.invokeMethod('verifyProof', {
        'circuitName': circuitName,
        'proofData': proofData,
        'publicInputs': publicInputs,
      });

      return IMP1VerifyResult(
        isValid: result['isValid'] as bool,
        verificationTimeMs: result['verificationTimeMs'] as int,
      );
    } on PlatformException catch (e) {
      print('[IMP1] Verification failed: ${e.message}');
      throw IMP1ProverException(
        'Failed to verify proof: ${e.message}',
        e.code,
      );
    } catch (e) {
      print('[IMP1] Unexpected verification error: $e');
      rethrow;
    }
  }
}

/// Result of proof generation
class IMP1ProofResult {
  final String proof;
  final String publicInputs;
  final int provingTimeMs;
  final int proofSizeBytes;

  IMP1ProofResult({
    required this.proof,
    required this.publicInputs,
    required this.provingTimeMs,
    required this.proofSizeBytes,
  });

  @override
  String toString() {
    return 'IMP1ProofResult(provingTime: ${provingTimeMs}ms, proofSize: $proofSizeBytes bytes)';
  }
}

/// Result of proof verification
class IMP1VerifyResult {
  final bool isValid;
  final int verificationTimeMs;

  IMP1VerifyResult({
    required this.isValid,
    required this.verificationTimeMs,
  });

  @override
  String toString() {
    return 'IMP1VerifyResult(isValid: $isValid, verificationTime: ${verificationTimeMs}ms)';
  }
}

/// Exception thrown by IMP1 prover
class IMP1ProverException implements Exception {
  final String message;
  final String? code;

  IMP1ProverException(this.message, [this.code]);

  @override
  String toString() => 'IMP1ProverException: $message (code: $code)';
}
