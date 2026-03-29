import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mopro_flutter/mopro_flutter.dart';
import 'package:mopro_flutter/mopro_types.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:Deimos/channels/imp1_channel.dart';
import '../models/benchmark_item.dart';
import '../utils/circuit_utils.dart';
import 'device_stats_service.dart';

class BenchmarkService {
  final MoproFlutter _moproFlutter = MoproFlutter();


  Future<BenchmarkResult> runBenchmark(BenchmarkResult item, InputData inputData) async {
    final battery = Battery();
    final batteryBefore = await battery.batteryLevel;
    final memSnapshotBefore = await DeviceStatsService.getMemorySnapshot();
    
    final stopwatch = Stopwatch()..start();
    
    try {
      final updatedItem = item.copyWith(status: BenchmarkStatus.proving);
      
      final proofData = await _generateProof(item.framework, item.algorithm, item.inputName, inputData);
      final provingTime = stopwatch.elapsed;
      stopwatch.reset();
      stopwatch.start();
      
      final batteryAfter = await battery.batteryLevel;
      final memSnapshotAfter = await DeviceStatsService.getMemorySnapshot();

      final isValid = await _verifyProof(item.framework, item.algorithm, item.inputName, proofData);
      final verificationTime = stopwatch.elapsed;
      
      final proofSize = _getProofSize(item.framework, proofData);

      final memoryInfo = {
        'totalPhysicalMemory': memSnapshotBefore.total,
        'memoryUsedBeforeProof': memSnapshotBefore.total - memSnapshotBefore.free,
        'memoryUsedAfterProof': memSnapshotAfter.total - memSnapshotAfter.free,
      };

      final batteryInfo = {
        'batteryBeforeProof': batteryBefore,
        'batteryAfterProof': batteryAfter,
        'batteryConsumed': batteryBefore - batteryAfter,
      };

      return item.copyWith(
        status: isValid ? BenchmarkStatus.completed : BenchmarkStatus.failed,
        provingTime: provingTime,
        verificationTime: verificationTime,
        proofSize: proofSize,
        memoryInfo: memoryInfo,
        batteryInfo: batteryInfo,
      );
    } catch (e) {
      return item.copyWith(
        status: BenchmarkStatus.failed,
        error: e.toString(),
      );
    }
  }

  int _getProofSize(String framework, dynamic proofData) {
    if (proofData == null) return 0;
    try {
      switch (framework.toLowerCase()) {
        case 'arkworks':
        case 'rapidsnark':
        case 'imp1': 
          return 256; 
        case 'barretenberg':
          return (proofData as Uint8List).length;
        case 'risc0':
          return (proofData as Risc0ProofOutput).receipt.length;
        case 'cairo':
          return (proofData as CairoProofOutput).proof.length;
        case 'provekit':
          return (proofData as ProveKitProofOutput).proof.length;
        default:
          return 0;
      }
    } catch (_) {
      return 0;
    }
  }


  Future<dynamic> _generateProof(String framework, String algorithm, String inputName, InputData inputData) async {
    switch (framework.toLowerCase()) {
      case 'arkworks':
      case 'rapidsnark':
        return await _generateGroth16Proof(framework, algorithm, inputName, inputData);
      case 'barretenberg':
        return await _generateBarretenbergProof(algorithm, inputName, inputData);
      case 'risc0':
        return await _generateRisc0Proof(inputData);
      case 'cairo':
        return await _generateCairoProof(algorithm, inputData);
      case 'imp1':
        return await _generateIMP1Proof(algorithm, inputName);
      case 'provekit':
        return await _generateProveKitProof(algorithm, inputName, inputData);
      default:
        throw Exception('Unknown framework: $framework');
    }
  }

  Future<bool> _verifyProof(String framework, String algorithm, String inputName, dynamic proofData) async {
    switch (framework.toLowerCase()) {
      case 'arkworks':
      case 'rapidsnark':
        final proofLib = framework == 'rapidsnark' ? ProofLib.rapidsnark : ProofLib.arkworks;
        return await _moproFlutter.verifyGroth16Proof(CircuitUtils.getZkeyPath(algorithm, inputName), proofData, proofLib);
      case 'barretenberg':
        final settings = await CircuitUtils.getNoirSettings(_moproFlutter, algorithm, inputName);
        return await _moproFlutter.verifyBarretenbergProof(settings.circuitPath, proofData, settings.onChain, settings.vk, false);
      case 'risc0':
        final verifyResult = await _moproFlutter.verifyRisc0Proof(proofData.receipt);
        return verifyResult.isValid;
      case 'cairo':
        final verifyResult = await _moproFlutter.verifyCairoProof(proofData.proof);
        return verifyResult.isValid;
      case 'imp1':
        final verifyResult = await IMP1Channel.verifyProof(
          circuitName: CircuitUtils.getImp1CircuitName(algorithm, inputName),
          proofData: proofData.proof,
          publicInputs: proofData.publicInputs,
        );
        return verifyResult.isValid;
      case 'provekit':
        final pkvPath = 'assets/provekit/${CircuitUtils.getProveKitCircuitName(algorithm, inputName)}.pkv';
        final verifyResult = await _moproFlutter.verifyProveKitProof(pkvPath, proofData.proof);
        return verifyResult.isValid;
      default:
        return false;
    }
  }

  Future<Groth16ProofResult> _generateGroth16Proof(String framework, String algorithm, String inputName, InputData inputData) async {
    final inputs = '{"in": [${inputData.values.map((v) => '"$v"').join(', ')}]}';
    final zkeyPath = CircuitUtils.getZkeyPath(algorithm, inputName);
    final proofLib = framework == 'rapidsnark' ? ProofLib.rapidsnark : ProofLib.arkworks;
    final result = await _moproFlutter.generateGroth16Proof(zkeyPath, inputs, proofLib);
    if (result == null) throw Exception('Failed to generate Groth16 proof');
    return result;
  }

  Future<Uint8List> _generateBarretenbergProof(String algorithm, String inputName, InputData inputData) async {
    final settings = await CircuitUtils.getNoirSettings(_moproFlutter, algorithm, inputName);
    final noirInputs = CircuitUtils.inputDataToNoirInput(inputData.values, settings.targetInputSize);
    return await _moproFlutter.generateBarretenbergProof(
      settings.circuitPath, settings.srsPath, noirInputs, settings.onChain, settings.vk, false
    );
  }

  Future<Risc0ProofOutput> _generateRisc0Proof(InputData inputData) async {
    int numericInput = int.tryParse(inputData.values.first) ?? 17;
    final result = await _moproFlutter.generateRisc0Proof(numericInput);
    if (result == null) throw Exception('Failed to generate RISC0 proof');
    return result;
  }

  Future<CairoProofOutput> _generateCairoProof(String algorithm, InputData inputData) async {
    String inputsJson;
    String entrypoint = "main";
    String programPath = "assets/cairo-m/cairo_sha256.json";

    final values = inputData.values;

    if (algorithm.toLowerCase() == "sha256") {
      entrypoint = "sha256_hash";
      programPath = "assets/cairo-m/cairo_sha256.json";
      List<String> words = List.from(values);
      while (words.length % 16 != 0 || words.isEmpty) {
        words.add("0");
      }
      int numChunks = words.length ~/ 16;
      inputsJson = '[[${words.join(', ')}], $numChunks]';
    } else if (algorithm.toLowerCase() == "blake2s256" || algorithm.toLowerCase() == "blake2s") {
      entrypoint = "blake2s_hash";
      programPath = "assets/cairo-m/cairo_blake2s.json";
      int numBytes = values.length * 4;
      inputsJson = '[[${values.join(', ')}], $numBytes]';
    } else if (algorithm.toLowerCase() == "blake3") {
      entrypoint = "blake3_hash";
      programPath = "assets/cairo-m/cairo_blake3.json";
      int numBytes = values.length * 4;
      inputsJson = '[[${values.join(', ')}], $numBytes]';
    } else if (algorithm.toLowerCase() == "keccak256") {
      entrypoint = "keccak256_hash";
      programPath = "assets/cairo-m/cairo_keccak256.json";
      int numBytes = values.length * 4;
      inputsJson = '[[${values.join(', ')}], $numBytes]';
    } else if (algorithm.toLowerCase() == "mimc") {
      entrypoint = "multi_mimc7";
      programPath = "assets/cairo-m/cairo_mimc.json";
      inputsJson = '[[${values.join(', ')}], ${values.length}, 0]';
    } else if (algorithm.toLowerCase() == "poseidon2" || algorithm.toLowerCase() == "poseidon") {
      entrypoint = "poseidon2_hash";
      programPath = "assets/cairo-m/cairo_poseidon2.json";
      inputsJson = '[[${values.join(', ')}], ${values.length}]';
    } else if (algorithm.toLowerCase() == "rescueprime") {
      entrypoint = "rescue_prime_hash";
      programPath = "assets/cairo-m/cairo_rescue_prime.json";
      inputsJson = '[[${values.join(', ')}], ${values.length}]';
    } else {
      inputsJson = await rootBundle.loadString('assets/cairo_input.json');
    }
    
    final result = await _moproFlutter.generateCairoProof(programPath, inputsJson, entrypoint);
    if (result == null) throw Exception('Failed to generate Cairo proof');
    return result;
  }

  Future<IMP1ProofResult> _generateIMP1Proof(String algorithm, String inputName) async {
    final circuitName = CircuitUtils.getImp1CircuitName(algorithm, inputName);
    return await IMP1Channel.generateProof(circuitName: circuitName);
  }

  Future<ProveKitProofOutput> _generateProveKitProof(String algorithm, String inputName, InputData inputData) async {
    final circuitName = CircuitUtils.getProveKitCircuitName(algorithm, inputName);
    final pkpPath = 'assets/provekit/$circuitName.pkp';
    final inputToml = 'input = [${inputData.values.map((v) => '"$v"').join(', ')}]\n';
    return await _moproFlutter.generateProveKitProof(pkpPath, inputToml);
  }
}
