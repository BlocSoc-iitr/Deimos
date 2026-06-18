// Type definitions for benchmark data

export interface MemoryInfo {
  totalPhysicalMemory: number;
  memoryUsedBeforeProof: number;
  peakMemoryUsage: number;
  memoryConsumedByProof: number;
  peakMemoryLoadInPercentage: number;
  memoryConsumedInPercentage: number;
}

export interface CpuInfo {
  cpuTimeMs: number;
  cpuPercent: number;
}

export interface DeviceInfo {
  platform: string;
  device: string;
  manufacturer?: string;
  deviceId?: string;
  systemVersion?: string;
  memory: MemoryInfo;
  cpu?: CpuInfo;
}

export interface BenchmarkData {
  id?: string;
  circuit: string;
  framework: string;
  language: string;
  inputSize?: number;
  provingTimeMiliSeconds: number;
  verificationTimeMiliSeconds: number;
  deviceInfo: DeviceInfo;
  proofSize: number;
  timestamp: string;
  createdAt?: string;
  customInputs?: { [key: string]: string };
}
