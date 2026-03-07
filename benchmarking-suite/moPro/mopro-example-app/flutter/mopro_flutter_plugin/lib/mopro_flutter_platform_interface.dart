import 'dart:typed_data';

import 'package:mopro_flutter/mopro_types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mopro_flutter_method_channel.dart';

abstract class MoproFlutterPlatform extends PlatformInterface {
  /// Constructs a MoproFlutterPlatform.
  MoproFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoproFlutterPlatform _instance = MethodChannelMoproFlutter();

  /// The default instance of [MoproFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoproFlutter].
  static MoproFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MoproFlutterPlatform] when
  /// they register themselves.
  static set instance(MoproFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Groth16ProofResult?> generateGroth16Proof(
      String zkeyPath, String inputs, ProofLib proofLib) {
    throw UnimplementedError('generateGroth16Proof() has not been implemented.');
  }

  Future<bool> verifyGroth16Proof(
      String zkeyPath, Groth16ProofResult proof, ProofLib proofLib) {
    throw UnimplementedError('verifyGroth16Proof() has not been implemented.');
  }

  Future<Uint8List> generateBarretenbergProof(
      String circuitPath, String? srsPath, List<String> inputs, bool onChain, Uint8List vk, bool lowMemoryMode) {
    throw UnimplementedError('generateBarretenbergProof() has not been implemented.');
  }

  Future<bool> verifyBarretenbergProof(String circuitPath, Uint8List proof, bool onChain, Uint8List vk, bool lowMemoryMode) {
    throw UnimplementedError('verifyBarretenbergProof() has not been implemented.');
  }

  Future<Uint8List> getBarretenbergVerificationKey(String circuitPath, String? srsPath, bool onChain, bool lowMemoryMode) {
    throw UnimplementedError('getBarretenbergVerificationKey() has not been implemented.');
  }

  Future<Risc0ProofOutput> generateRisc0Proof(int input) {
    throw UnimplementedError('generateRisc0Proof() has not been implemented.');
  }

  Future<Risc0VerifyOutput> verifyRisc0Proof(Uint8List receiptBytes) {
    throw UnimplementedError('verifyRisc0Proof() has not been implemented.');
  }

  Future<CairoProofOutput> generateCairoProof(String programJson, String inputsJson) {
    throw UnimplementedError('generateCairoProof() has not been implemented.');
  }

  Future<CairoVerifyOutput> verifyCairoProof(Uint8List proof) {
    throw UnimplementedError('verifyCairoProof() has not been implemented.');
  }

  Future<ProveKitProofOutput> generateProveKitProof(String proverPath, String inputToml) {
    throw UnimplementedError('generateProveKitProof() has not been implemented.');
  }

  Future<ProveKitVerifyOutput> verifyProveKitProof(String verifierPath, Uint8List proof) {
    throw UnimplementedError('verifyProveKitProof() has not been implemented.');
  }

  Future<Map<String, int>> getIOSMemoryUsage() {
    throw UnimplementedError('getIOSMemoryUsage() has not been implemented.');
  }
}
