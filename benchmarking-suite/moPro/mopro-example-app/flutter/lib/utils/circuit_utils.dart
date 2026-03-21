import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mopro_flutter/mopro_flutter.dart';

class CircuitUtils {
  static final Map<String, Uint8List> _noirVerificationKeys = {};

  static String getZkeyPath(String algorithm, String inputName) {
    String algoPrefix = algorithm.toLowerCase();
    if (algorithm == 'RescuePrime') algoPrefix = 'rescue-prime';
    else if (algorithm == 'Blake2s256') algoPrefix = 'blake2s256';
    final suffix = inputName.split(' ').last;
    return "assets/groth16/zkey/${algoPrefix}_$suffix.zkey";
  }

  static String getImp1CircuitName(String algorithm, String inputName) {
    String algoPrefix = algorithm.toLowerCase();
    if (algorithm == 'RescuePrime') algoPrefix = 'rescue-prime';
    else if (algorithm == 'Blake2s256') algoPrefix = 'blake2s256';
    final suffix = inputName.split(' ').last;
    return "${algoPrefix}_$suffix";
  }

  static String getProveKitCircuitName(String algorithm, String inputName) {
    String algoPrefix = algorithm.toLowerCase();
    if (algorithm == 'RescuePrime') algoPrefix = 'rescue_prime';
    final suffix = inputName.split(' ').last;
    if (['SHA256', 'Keccak256', 'Blake2', 'Blake3', 'Pedersen'].contains(algorithm)) {
      return "${algoPrefix}_bytes_$suffix";
    } else {
      return "${algoPrefix}_field_${suffix.replaceAll('f', '')}";
    }
  }

  static List<String> inputDataToNoirInput(List<String> inputData, int targetSize) {
    final paddedData = List<String>.from(inputData);
    while (paddedData.length < targetSize) paddedData.add('0');
    return paddedData.take(targetSize).toList();
  }

  static Future<({String circuitPath, String srsPath, bool onChain, Uint8List vk, int targetInputSize})> getNoirSettings(
    MoproFlutter plugin,
    String algorithm, 
    String inputName,
  ) async {
    final algorithmKey = algorithm.toLowerCase().replaceAll('rescueprime', 'rescue_prime');
    final suffix = inputName.split(' ').last.replaceAll('f', '');
    final rawInputSize = int.tryParse(suffix) ?? 0;
    
    int targetInputSize;
    String assetPath;
    String srsPath;
    bool onChain = true;
    String? vkAssetPath;

    if (['SHA256', 'Keccak256', 'Blake2', 'Blake3', 'Pedersen'].contains(algorithm)) {
      targetInputSize = rawInputSize <= 16 ? 16 : (rawInputSize <= 32 ? 32 : (rawInputSize <= 64 ? 64 : (rawInputSize <= 128 ? 128 : (rawInputSize <= 256 ? 256 : (rawInputSize <= 512 ? 512 : 1028)))));
      if (algorithm == 'Pedersen') {
        assetPath = 'assets/pedersen.json'; srsPath = 'assets/pedersen.srs'; vkAssetPath = 'assets/pedersen.vk';
      } else {
        assetPath = 'assets/barretenberg/${algorithmKey}_bytes_$targetInputSize.json';
        srsPath = 'assets/barretenberg/${algorithmKey}_bytes_$targetInputSize.srs';
      }
    } else {
      targetInputSize = rawInputSize <= 1 ? 1 : (rawInputSize <= 2 ? 2 : (rawInputSize <= 3 ? 3 : (rawInputSize <= 5 ? 5 : (rawInputSize <= 9 ? 9 : (rawInputSize <= 17 ? 17 : 34)))));
      assetPath = 'assets/barretenberg/${algorithmKey}_field_$targetInputSize.json';
      srsPath = 'assets/barretenberg/${algorithmKey}_field_$targetInputSize.srs';
      onChain = algorithm != 'Poseidon';
    }

    final cacheKey = '$assetPath|$srsPath|$onChain';
    if (_noirVerificationKeys.containsKey(cacheKey)) {
      return (circuitPath: assetPath, srsPath: srsPath, onChain: onChain, vk: _noirVerificationKeys[cacheKey]!, targetInputSize: targetInputSize);
    }

    Uint8List? vk;
    if (vkAssetPath != null) {
      try { vk = (await rootBundle.load(vkAssetPath)).buffer.asUint8List(); } catch (_) {}
    }
    vk ??= await plugin.getBarretenbergVerificationKey(assetPath, srsPath, onChain, false);
    _noirVerificationKeys[cacheKey] = vk;

    return (circuitPath: assetPath, srsPath: srsPath, onChain: onChain, vk: vk, targetInputSize: targetInputSize);
  }
}
