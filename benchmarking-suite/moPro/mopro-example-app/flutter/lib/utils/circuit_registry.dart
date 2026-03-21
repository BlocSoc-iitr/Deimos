import '../models/benchmark_item.dart';

class CircuitRegistry {
  static List<BenchmarkResult> getFullBenchmarkSuite() {
    final List<BenchmarkResult> suite = [];

    // Arkworks
    final groth16Algos = ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'MiMC256', 'Pedersen', 'Poseidon', 'RescuePrime'];
    for (var algo in groth16Algos) {
      final inputName = algo.contains('MiMC') || algo.contains('Poseidon') || algo.contains('Rescue') 
          ? 'Input 16f' 
          : 'Input 16';
      suite.add(BenchmarkResult(
        framework: 'arkworks',
        algorithm: algo,
        inputName: inputName,
        status: BenchmarkStatus.pending,
      ));
    }

    // Rapidsnark
    for (var algo in groth16Algos) {
      final inputName = algo.contains('MiMC') || algo.contains('Poseidon') || algo.contains('Rescue') 
          ? 'Input 16f' 
          : 'Input 16';
      suite.add(BenchmarkResult(
        framework: 'rapidsnark',
        algorithm: algo,
        inputName: inputName,
        status: BenchmarkStatus.pending,
      ));
    }

    // Barretenberg
    final noirAlgos = ['SHA256', 'Keccak256', 'Poseidon', 'MiMC', 'Blake2', 'Blake3', 'RescuePrime', 'Anemoi'];
    for (var algo in noirAlgos) {
      final inputName = algo.contains('MiMC') || algo.contains('Poseidon') || algo.contains('Rescue') || algo.contains('Anemoi')
          ? 'Input 1f' 
          : 'Input 16';
      suite.add(BenchmarkResult(
        framework: 'barretenberg',
        algorithm: algo,
        inputName: inputName,
        status: BenchmarkStatus.pending,
      ));
    }

    // RISC Zero
    suite.add(BenchmarkResult(
      framework: 'risc0',
      algorithm: 'Factor',
      inputName: 'Default',
      status: BenchmarkStatus.pending,
    ));

    // Cairo-M
    suite.add(BenchmarkResult(
      framework: 'cairo',
      algorithm: 'SHA256',
      inputName: 'Default',
      status: BenchmarkStatus.pending,
    ));

    // IMP1
    for (var algo in groth16Algos) {
      final inputName = algo.contains('MiMC') || algo.contains('Poseidon') || algo.contains('Rescue') 
          ? 'Input 16f' 
          : 'Input 16';
      suite.add(BenchmarkResult(
        framework: 'imp1',
        algorithm: algo,
        inputName: inputName,
        status: BenchmarkStatus.pending,
      ));
    }

    // ProveKit
    final proveKitAlgos = ['Anemoi', 'MiMC', 'Poseidon', 'RescuePrime'];
    for (var algo in proveKitAlgos) {
      suite.add(BenchmarkResult(
        framework: 'provekit',
        algorithm: algo,
        inputName: 'Input 1f',
        status: BenchmarkStatus.pending,
      ));
    }

    return suite;
  }

  static String getFrameworkDisplayName(String framework) {
    switch (framework) {
      case 'arkworks':
        return 'Arkworks';
      case 'rapidsnark':
        return 'Rapidsnark';
      case 'barretenberg':
        return 'Barretenberg';
      case 'risc0':
        return 'RISC Zero';
      case 'cairo':
        return 'Cairo-M';
      case 'imp1':
        return 'IMP1';
      case 'provekit':
        return 'ProveKit';
      default:
        return framework;
    }
  }

  static List<String> getAlgorithmsForFramework(String framework) {
    switch (framework) {
      case 'arkworks':
      case 'rapidsnark':
        return ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'MiMC256', 'Pedersen', 'Poseidon', 'RescuePrime'];
      case 'barretenberg':
        return ['SHA256', 'Keccak256', 'Poseidon', 'MiMC', 'Blake2', 'Blake3', 'RescuePrime', 'Anemoi'];
      case 'risc0':
        return ['Factor'];
      case 'cairo':
        return ['SHA256'];
      case 'imp1':
        return ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'MiMC256', 'Pedersen', 'Poseidon', 'RescuePrime'];
      case 'provekit':
        return ['Anemoi', 'MiMC', 'Poseidon', 'RescuePrime'];
      default:
        return [];
    }
  }
}
