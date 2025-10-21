import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mopro_flutter/mopro_types.dart';
import 'package:path_provider/path_provider.dart';

import 'mopro_flutter_platform_interface.dart';

class MoproFlutter {
  Future<String> copyAssetToFileSystem(String assetPath) async {
    // Load the asset as bytes
    final byteData = await rootBundle.load(assetPath);
    // Get the app's document directory (or other accessible directory)
    final directory = await getApplicationDocumentsDirectory();
    //Strip off the initial dirs from the filename
    assetPath = assetPath.split('/').last;

    final file = File('${directory.path}/$assetPath');

    // Write the bytes to a file in the file system
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file.path; // Return the file path
  }

  Future<CircomProofResult?> generateCircomProof(
      String zkeyFile, String inputs, ProofLib proofLib) async {
    return await copyAssetToFileSystem(zkeyFile).then((path) async {
      return await MoproFlutterPlatform.instance
          .generateCircomProof(path, inputs, proofLib);
    });
  }

  Future<bool> verifyCircomProof(
      String zkeyFile, CircomProofResult proof, ProofLib proofLib) async {
    return await copyAssetToFileSystem(zkeyFile).then((path) async {
      return await MoproFlutterPlatform.instance.verifyCircomProof(path, proof, proofLib);
    });
  }

  Future<Halo2ProofResult?> generateHalo2Proof(
      String srsPath, String pkPath, Map<String, List<String>> inputs) async {
    return await copyAssetToFileSystem(srsPath).then((srsPath) async {
      return await copyAssetToFileSystem(pkPath).then((pkPath) async {
        return await MoproFlutterPlatform.instance
            .generateHalo2Proof(srsPath, pkPath, inputs);
      });
    });
  }

  Future<bool> verifyHalo2Proof(
      String srsPath, String vkPath, Uint8List proof, Uint8List inputs) async {
    return await copyAssetToFileSystem(srsPath).then((srsPath) async {
      return await copyAssetToFileSystem(vkPath).then((vkPath) async {
        return await MoproFlutterPlatform.instance
            .verifyHalo2Proof(srsPath, vkPath, proof, inputs);
      });
    });
  }

  Future<Uint8List> generateNoirProof(String circuitPath, String? srsPath, List<String> inputs, bool onChain, Uint8List vk, bool lowMemoryMode) async {
    return await copyAssetToFileSystem(circuitPath).then((circuitPath) async {
      if (srsPath != null) {
        return await copyAssetToFileSystem(srsPath).then((srsPath) async {
          return await MoproFlutterPlatform.instance.generateNoirProof(circuitPath, srsPath, inputs, onChain, vk, lowMemoryMode);
        });
      } else {
        return await MoproFlutterPlatform.instance.generateNoirProof(circuitPath, null, inputs, onChain, vk, lowMemoryMode);
      }
    });
  }

  Future<bool> verifyNoirProof(String circuitPath, Uint8List proof, bool onChain, Uint8List vk, bool lowMemoryMode) async {
    return await copyAssetToFileSystem(circuitPath).then((circuitPath) async {  
      return await MoproFlutterPlatform.instance.verifyNoirProof(circuitPath, proof, onChain, vk, lowMemoryMode);
    });
  }

  Future<Uint8List> getNoirVerificationKey(String circuitPath, String? srsPath, bool onChain, bool lowMemoryMode) async {
    return await copyAssetToFileSystem(circuitPath).then((circuitPath) async {
      if (srsPath != null) {
        return await copyAssetToFileSystem(srsPath).then((srsPath) async {
          return await MoproFlutterPlatform.instance.getNoirVerificationKey(circuitPath, srsPath, onChain, lowMemoryMode);
        });
      } else {
        return await MoproFlutterPlatform.instance.getNoirVerificationKey(circuitPath, null, onChain, lowMemoryMode);
      }
    });
  }
}
