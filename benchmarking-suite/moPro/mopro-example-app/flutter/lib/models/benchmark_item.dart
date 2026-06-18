class InputData {
  final String name;
  final String description;
  final List<String> values;
  
  InputData({required this.name, required this.description, required this.values});
}

enum BenchmarkStatus {
  pending,
  proving,
  verifying,
  completed,
  failed,
}

class BenchmarkResult {
  final String framework;
  final String algorithm;
  final String inputName;
  final BenchmarkStatus status;
  final Duration? provingTime;
  final Duration? verificationTime;
  final String? error;
  
  final int? proofSize;
  final int? preprocessingSize;
  final double? temperatureC;
  final Map<String, dynamic>? memoryInfo;
  final Map<String, dynamic>? cpuInfo;

  BenchmarkResult({
    required this.framework,
    required this.algorithm,
    required this.inputName,
    required this.status,
    this.provingTime,
    this.verificationTime,
    this.error,
    this.proofSize,
    this.preprocessingSize,
    this.temperatureC,
    this.memoryInfo,
    this.cpuInfo,
  });

  BenchmarkResult copyWith({
    BenchmarkStatus? status,
    Duration? provingTime,
    Duration? verificationTime,
    String? error,
    int? proofSize,
    int? preprocessingSize,
    double? temperatureC,
    Map<String, dynamic>? memoryInfo,
    Map<String, dynamic>? cpuInfo,
  }) {
    return BenchmarkResult(
      framework: framework,
      algorithm: algorithm,
      inputName: inputName,
      status: status ?? this.status,
      provingTime: provingTime ?? this.provingTime,
      verificationTime: verificationTime ?? this.verificationTime,
      error: error ?? this.error,
      proofSize: proofSize ?? this.proofSize,
      preprocessingSize: preprocessingSize ?? this.preprocessingSize,
      temperatureC: temperatureC ?? this.temperatureC,
      memoryInfo: memoryInfo ?? this.memoryInfo,
      cpuInfo: cpuInfo ?? this.cpuInfo,
    );
  }
}

