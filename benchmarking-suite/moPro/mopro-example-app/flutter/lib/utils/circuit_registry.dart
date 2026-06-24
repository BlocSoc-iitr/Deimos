import '../models/benchmark_item.dart';

class CircuitRegistry {
  // Algorithms whose inputs are byte arrays (vs. field elements).
  static const _bytesAlgorithms = ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'Pedersen', 'Blake2'];

  // Input-name sets, mirroring the asset sizes loaded in MainSelectionPage.
  static const _bytesGroth = ['Input 16', 'Input 32', 'Input 64', 'Input 128']; // arkworks/rapidsnark/imp1
  static const _bytesAll = ['Input 16', 'Input 32', 'Input 64', 'Input 128', 'Input 256', 'Input 512', 'Input 1024'];
  static const _u32Cairo = ['Input 4u', 'Input 8u', 'Input 16u', 'Input 32u', 'Input 64u', 'Input 128u', 'Input 256u'];
  static const _fieldAll = ['Input 1f', 'Input 2f', 'Input 3f', 'Input 5f', 'Input 9f', 'Input 17f', 'Input 34f'];
  static const _m31Cairo = ['Input 5m', 'Input 9m', 'Input 17m', 'Input 34m', 'Input 67m', 'Input 133m', 'Input 265m'];

  /// All valid input names for a framework+algorithm pair. Mirrors
  /// MainSelectionPage._updateAvailableInputs so the batch sweeps exactly the
  /// input sizes the app considers valid for that circuit.
  static List<String> _inputsFor(String framework, String algorithm) {
    if (_bytesAlgorithms.contains(algorithm)) {
      if (framework == 'arkworks' || framework == 'rapidsnark' || framework == 'imp1') return _bytesGroth;
      if (framework == 'cairo') return _u32Cairo;
      return _bytesAll; // barretenberg, provekit
    }
    if (framework == 'cairo') return _m31Cairo; // Cairo-M uses M31 field inputs
    return _fieldAll; // barretenberg / arkworks / rapidsnark / provekit / imp1
  }

  static List<BenchmarkResult> getFullBenchmarkSuite() {
    final List<BenchmarkResult> suite = [];

    // Adds one entry per (framework, algorithm, input size) — sweeping every
    // valid input size for the pair.
    void addAll(String framework, List<String> algos) {
      for (final algo in algos) {
        for (final inputName in _inputsFor(framework, algo)) {
          suite.add(BenchmarkResult(
            framework: framework,
            algorithm: algo,
            inputName: inputName,
            status: BenchmarkStatus.pending,
          ));
        }
      }
    }

    final groth16Algos = ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'MiMC256', 'Pedersen', 'Poseidon', 'Poseidon2', 'RescuePrime'];
    final noirAlgos = ['SHA256', 'Keccak256', 'Poseidon', 'Poseidon2', 'MiMC', 'Blake2', 'Blake3', 'RescuePrime', 'Anemoi'];
    final proveKitAlgos = ['Anemoi', 'MiMC', 'Poseidon', 'RescuePrime'];

    addAll('arkworks', groth16Algos);
    addAll('rapidsnark', groth16Algos);
    addAll('barretenberg', noirAlgos);
    // RISC Zero — disabled in the batch suite: proving is very heavy and crashes
    // on lower-memory devices. Re-enable below (single-run still supports it).
    // addAll only handles input-swept circuits; risc0 had a single fixed input.
    addAll('cairo', ['SHA256']);
    addAll('imp1', groth16Algos);
    addAll('provekit', proveKitAlgos);

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
        return ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'MiMC256', 'Pedersen', 'Poseidon', 'Poseidon2', 'RescuePrime'];
      case 'barretenberg':
        return ['SHA256', 'Keccak256', 'Poseidon', 'Poseidon2', 'MiMC', 'Blake2', 'Blake3', 'RescuePrime', 'Anemoi'];
      case 'risc0':
        return ['Factor'];
      case 'cairo':
        return ['SHA256', 'Blake2s256', 'Blake3', 'Keccak256', 'MiMC', 'Poseidon2', 'RescuePrime'];
      case 'imp1':
        return ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'MiMC256', 'Pedersen', 'Poseidon', 'Poseidon2', 'RescuePrime'];
      case 'provekit':
        return ['Anemoi', 'MiMC', 'Poseidon', 'RescuePrime'];
      default:
        return [];
    }
  }
}
