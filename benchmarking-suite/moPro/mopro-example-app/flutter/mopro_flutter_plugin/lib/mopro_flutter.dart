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
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file.path; // Return the file path
  }

  Future<Groth16ProofResult?> generateGroth16Proof(
      String zkeyFile, String inputs, ProofLib proofLib) async {
    return await copyAssetToFileSystem(zkeyFile).then((path) async {
      return await MoproFlutterPlatform.instance
          .generateGroth16Proof(path, inputs, proofLib);
    });
  }

  Future<bool> verifyGroth16Proof(
      String zkeyFile, Groth16ProofResult proof, ProofLib proofLib) async {
    return await copyAssetToFileSystem(zkeyFile).then((path) async {
      return await MoproFlutterPlatform.instance.verifyGroth16Proof(path, proof, proofLib);
    });
  }

  Future<Uint8List> generateBarretenbergProof(String circuitPath, String? srsPath, List<String> inputs, bool onChain, Uint8List vk, bool lowMemoryMode) async {
    return await copyAssetToFileSystem(circuitPath).then((circuitPath) async {
      if (srsPath != null) {
        return await copyAssetToFileSystem(srsPath).then((srsPath) async {
          return await MoproFlutterPlatform.instance.generateBarretenbergProof(circuitPath, srsPath, inputs, onChain, vk, lowMemoryMode);
        });
      } else {
        return await MoproFlutterPlatform.instance.generateBarretenbergProof(circuitPath, null, inputs, onChain, vk, lowMemoryMode);
      }
    });
  }

  Future<bool> verifyBarretenbergProof(String circuitPath, Uint8List proof, bool onChain, Uint8List vk, bool lowMemoryMode) async {
    return await copyAssetToFileSystem(circuitPath).then((circuitPath) async {  
      return await MoproFlutterPlatform.instance.verifyBarretenbergProof(circuitPath, proof, onChain, vk, lowMemoryMode);
    });
  }

  Future<Uint8List> getBarretenbergVerificationKey(String circuitPath, String? srsPath, bool onChain, bool lowMemoryMode) async {
    return await copyAssetToFileSystem(circuitPath).then((circuitPath) async {
      if (srsPath != null) {
        return await copyAssetToFileSystem(srsPath).then((srsPath) async {
          return await MoproFlutterPlatform.instance.getBarretenbergVerificationKey(circuitPath, srsPath, onChain, lowMemoryMode);
        });
      } else {
        return await MoproFlutterPlatform.instance.getBarretenbergVerificationKey(circuitPath, null, onChain, lowMemoryMode);
      }
    });
  }

  Future<Risc0ProofOutput> generateRisc0Proof(int input) async {
    return await MoproFlutterPlatform.instance.generateRisc0Proof(input);
  }

  Future<Risc0VerifyOutput> verifyRisc0Proof(Uint8List receiptBytes) async {
    return await MoproFlutterPlatform.instance.verifyRisc0Proof(receiptBytes);
  }

  Future<CairoProofOutput> generateCairoProof(String programJson, String inputsJson, String entrypoint) async {
    return await copyAssetToFileSystem(programJson).then((path) async {
      final programJsonStr = await File(path).readAsString();
      
      // For inputs, we might receive a file path (asset) or a raw JSON string
      String inputsJsonStr = inputsJson;
      // Simple heuristic: if it doesn't start with [ or {, it might be a path
      if (!inputsJson.trim().startsWith('[') && !inputsJson.trim().startsWith('{')) {
         try {
          final inputPath = await copyAssetToFileSystem(inputsJson);
          inputsJsonStr = await File(inputPath).readAsString();
        } catch (e) {
             print("Assuming input is raw string: $e");
        }
      }
      
      return await MoproFlutterPlatform.instance.generateCairoProof(programJsonStr, inputsJsonStr, entrypoint);
    });
  }

  Future<CairoVerifyOutput> verifyCairoProof(Uint8List proof) async {
    return await MoproFlutterPlatform.instance.verifyCairoProof(proof);
  }

  Future<ProveKitProofOutput> generateProveKitProof(String proverPath, String inputToml) async {
    return await copyAssetToFileSystem(proverPath).then((path) async {
      return await MoproFlutterPlatform.instance.generateProveKitProof(path, inputToml);
    });
  }

  Future<ProveKitVerifyOutput> verifyProveKitProof(String verifierPath, Uint8List proof) async {
    return await copyAssetToFileSystem(verifierPath).then((path) async {
      return await MoproFlutterPlatform.instance.verifyProveKitProof(path, proof);
    });
  }

  Future<Map<String, int>> getIOSMemoryUsage() async {
    return await MoproFlutterPlatform.instance.getIOSMemoryUsage();
  }
}
