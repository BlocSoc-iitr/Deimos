import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mopro_flutter/mopro_types.dart';

import 'mopro_flutter_platform_interface.dart';

/// An implementation of [MoproFlutterPlatform] that uses method channels.
class MethodChannelMoproFlutter extends MoproFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mopro_flutter');

  @override
  Future<Groth16ProofResult?> generateGroth16Proof(
      String zkeyPath, String inputs, ProofLib proofLib) async {
    final proofResult = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('generateGroth16Proof', {
      'zkeyPath': zkeyPath,
      'inputs': inputs,
      'proofLib': proofLib.index,
    });

    if (proofResult == null) {
      return null;
    }

    var circomProofResult = Groth16ProofResult.fromMap(proofResult);

    return circomProofResult;
  }

  @override
  Future<bool> verifyGroth16Proof(
      String zkeyPath, Groth16ProofResult proof, ProofLib proofLib) async {
    final result = await methodChannel.invokeMethod<bool>('verifyGroth16Proof', {
      'zkeyPath': zkeyPath,
      'proof': proof.toMap(),
      'proofLib': proofLib.index,
    });
    return result ?? false;
  }

  @override
  Future<Uint8List> generateBarretenbergProof(
      String circuitPath, String? srsPath, List<String> inputs, bool onChain, Uint8List vk, bool lowMemoryMode) async {
    final result =
        await methodChannel.invokeMethod<Uint8List>('generateBarretenbergProof', {
      'circuitPath': circuitPath,
      'srsPath': srsPath,
      'inputs': inputs,
      'onChain': onChain,
      'vk': vk,
      'lowMemoryMode': lowMemoryMode,
    });
    return result ?? Uint8List(0);
  }

  @override
  Future<bool> verifyBarretenbergProof(String circuitPath, Uint8List proof, bool onChain, Uint8List vk, bool lowMemoryMode) async {
    final result = await methodChannel.invokeMethod<bool>('verifyBarretenbergProof', {
      'circuitPath': circuitPath,
      'proof': proof,
      'onChain': onChain,
      'vk': vk,
      'lowMemoryMode': lowMemoryMode,
    });
    return result ?? false;
  }

  @override
  Future<Uint8List> getBarretenbergVerificationKey(String circuitPath, String? srsPath, bool onChain, bool lowMemoryMode) async {
    final result = await methodChannel.invokeMethod<Uint8List>('getBarretenbergVerificationKey', {
      'circuitPath': circuitPath,
      'srsPath': srsPath,
      'onChain': onChain,
      'lowMemoryMode': lowMemoryMode,
    });
    return result ?? Uint8List(0);
  }

  @override
  Future<Risc0ProofOutput> generateRisc0Proof(int input) async {
    final proofResult = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('generateRisc0Proof', {
      'input': input,
    });

    if (proofResult == null) {
      throw Exception('Failed to generate RISC0 proof');
    }

    return Risc0ProofOutput.fromMap(proofResult);
  }

  @override
  Future<Risc0VerifyOutput> verifyRisc0Proof(Uint8List receiptBytes) async {
    final verifyResult = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('verifyRisc0Proof', {
      'receiptBytes': receiptBytes,
    });

    if (verifyResult == null) {
      throw Exception('Failed to verify RISC0 proof');
    }

    return Risc0VerifyOutput.fromMap(verifyResult);
  }

  @override
  Future<CairoProofOutput> generateCairoProof(String programJson, String inputsJson) async {
    final proofResult = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('generateCairoProof', {
      'programJson': programJson,
      'inputsJson': inputsJson,
    });

    if (proofResult == null) {
      throw Exception('Failed to generate Cairo proof');
    }

    return CairoProofOutput.fromMap(proofResult);
  }

  @override
  Future<CairoVerifyOutput> verifyCairoProof(Uint8List proof) async {
    final verifyResult = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('verifyCairoProof', {
      'proof': proof,
    });

    if (verifyResult == null) {
      throw Exception('Failed to verify Cairo proof');
    }

    return CairoVerifyOutput.fromMap(verifyResult);
  }

  @override
  Future<ProveKitProofOutput> generateProveKitProof(String proverPath, String inputToml) async {
    final proofResult = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('generateProveKitProof', {
      'proverPath': proverPath,
      'inputToml': inputToml,
    });

    if (proofResult == null) {
      throw Exception('Failed to generate ProveKit proof');
    }

    return ProveKitProofOutput.fromMap(proofResult);
  }

  @override
  Future<ProveKitVerifyOutput> verifyProveKitProof(String verifierPath, Uint8List proof) async {
    final verifyResult = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('verifyProveKitProof', {
      'verifierPath': verifierPath,
      'proof': proof,
    });

    if (verifyResult == null) {
      throw Exception('Failed to verify ProveKit proof');
    }

    return ProveKitVerifyOutput.fromMap(verifyResult);
  }

  @override
  Future<Map<String, int>> getIOSMemoryUsage() async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>('getIOSMemoryUsage');
    if (result == null) {
      return {'used': 0, 'total': 0};
    }
    return {
      'used': result['used'] as int? ?? 0,
      'total': result['total'] as int? ?? 0,
    };
  }
}
