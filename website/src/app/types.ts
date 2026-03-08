// Type definitions for benchmark data

export interface MemoryInfo {
  totalPhysicalMemory: number;
  memoryUsedBeforeProof: number;
  peakMemoryUsage: number;
  memoryConsumedByProof: number;
  peakMemoryLoadInPercentage: number;
  memoryConsumedInPercentage: number;
}

export interface BatteryInfo {
  batteryBeforeProof: number;
  batteryAfterProof: number;
  batteryConsumed: number;
}

export interface DeviceInfo {
  platform: string;
  device: string;
  manufacturer?: string;
  androidVersion?: string;
  androidId?: string;
  systemName?: string;
  systemVersion?: string;
  name?: string;
  identifierForVendor?: string;
  isPhysicalDevice?: boolean;
  memory: MemoryInfo;
  battery: BatteryInfo;
}

export interface BenchmarkData {
  id?: string;
  circuit: string;
  framework: string;
  language: string;
  provingTimeMiliSeconds: number;
  verificationTimeMiliSeconds: number;
  deviceInfo: DeviceInfo;
  proofSize: number;
  proofBackend?: string;
  timestamp: string;
  createdAt?: string;
  customInputs?: { [key: string]: string };
}
