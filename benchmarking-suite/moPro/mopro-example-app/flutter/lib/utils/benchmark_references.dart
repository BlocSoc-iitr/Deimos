class FrameworkMeta {
  final String id;
  final String name;
  final String type;
  final String lang;

  const FrameworkMeta({
    required this.id,
    required this.name,
    required this.type,
    required this.lang,
  });
}

/// Static reference data for frameworks, circuits, and baseline timings.
///
/// Baseline timings are median values from Poseidon · Input 1f on SM-M315F,
/// used for cross-framework comparison in the results screen.
class BenchmarkReferences {
  static const List<FrameworkMeta> frameworks = [
    FrameworkMeta(id: 'arkworks',     name: 'Arkworks',     type: 'Groth16',    lang: 'Rust'),
    FrameworkMeta(id: 'rapidsnark',   name: 'Rapidsnark',   type: 'Groth16',    lang: 'C++'),
    FrameworkMeta(id: 'barretenberg', name: 'Barretenberg', type: 'UltraPlonk', lang: 'C++'),
    FrameworkMeta(id: 'risc0',        name: 'RISC Zero',    type: 'STARK',      lang: 'Rust'),
    FrameworkMeta(id: 'cairo',        name: 'Cairo-M',      type: 'STARK',      lang: 'Cairo'),
    FrameworkMeta(id: 'imp1',         name: 'IMP1',         type: 'Groth16',    lang: 'Rust'),
    FrameworkMeta(id: 'provekit',     name: 'ProveKit',     type: 'Halo2',      lang: 'Rust'),
  ];

  /// Median total (proof + verify) ms for Poseidon · Input 1f on SM-M315F.
  /// Source: data.jsx COMPARE table from the Deimos design spec.
  static const Map<String, int> baselineTotalMs = {
    'arkworks':     179,
    'rapidsnark':   232,
    'barretenberg': 1790,
    'risc0':        6520,
    'cairo':        3995,
    'imp1':         1780,
    'provekit':     2100,
  };

  static const Map<String, String> _circuitFamilies = {
    'SHA256':      'Hash',
    'Keccak256':   'Hash',
    'Blake2s256':  'Hash',
    'Blake2':      'Hash',
    'Blake3':      'Hash',
    'MiMC256':     'Arithmetic',
    'MiMC':        'Arithmetic',
    'Pedersen':    'Commitment',
    'Poseidon':    'Arithmetic',
    'Poseidon2':   'Arithmetic',
    'RescuePrime': 'Arithmetic',
    'Anemoi':      'Arithmetic',
    'Factor':      'STARK',
  };

  static FrameworkMeta? getMeta(String id) {
    try {
      return frameworks.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  static String getCircuitFamily(String algorithm) =>
      _circuitFamilies[algorithm] ?? 'Circuit';

  static String formatMs(int ms) =>
      ms < 1000 ? '${ms}ms' : '${(ms / 1000).toStringAsFixed(2)}s';
}
