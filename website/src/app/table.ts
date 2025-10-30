export interface BenchmarkData {
  circuit: string;
  framework: string;
  language: string;
  platform: string;
  device: string;
  provingTime: number; // in seconds
  verificationTime: number; // in seconds
}

export const benchmarkData: BenchmarkData[] = [
  // MoPro - Circom - SHA-256
  {
    circuit: "SHA-256",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 2.45,
    verificationTime: 0.12,
  },
  {
    circuit: "SHA-256",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Google Pixel 6",
    provingTime: 2.38,
    verificationTime: 0.11,
  },
  {
    circuit: "SHA-256",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 1.89,
    verificationTime: 0.09,
  },
  {
    circuit: "SHA-256",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 12",
    provingTime: 2.12,
    verificationTime: 0.10,
  },
  
  // MoPro - Circom - Keccak-256
  {
    circuit: "Keccak-256",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 8.76,
    verificationTime: 0.15,
  },
  {
    circuit: "Keccak-256",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Google Pixel 6",
    provingTime: 8.52,
    verificationTime: 0.14,
  },
  {
    circuit: "Keccak-256",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 6.84,
    verificationTime: 0.12,
  },
  {
    circuit: "Keccak-256",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 12",
    provingTime: 7.45,
    verificationTime: 0.13,
  },
  
  // MoPro - Circom - BLAKE2s-256
  {
    circuit: "BLAKE2s-256",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 3.12,
    verificationTime: 0.13,
  },
  {
    circuit: "BLAKE2s-256",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Google Pixel 6",
    provingTime: 3.05,
    verificationTime: 0.12,
  },
  {
    circuit: "BLAKE2s-256",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 2.34,
    verificationTime: 0.10,
  },
  {
    circuit: "BLAKE2s-256",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 12",
    provingTime: 2.67,
    verificationTime: 0.11,
  },
  
  // MoPro - Circom - Poseidon
  {
    circuit: "Poseidon",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 0.18,
    verificationTime: 0.08,
  },
  {
    circuit: "Poseidon",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Google Pixel 6",
    provingTime: 0.17,
    verificationTime: 0.08,
  },
  {
    circuit: "Poseidon",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 0.14,
    verificationTime: 0.07,
  },
  {
    circuit: "Poseidon",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 12",
    provingTime: 0.16,
    verificationTime: 0.07,
  },
  
  // MoPro - Circom - MiMC-256
  {
    circuit: "MiMC-256",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 0.24,
    verificationTime: 0.09,
  },
  {
    circuit: "MiMC-256",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Google Pixel 6",
    provingTime: 0.23,
    verificationTime: 0.08,
  },
  {
    circuit: "MiMC-256",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 0.19,
    verificationTime: 0.07,
  },
  {
    circuit: "MiMC-256",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 12",
    provingTime: 0.21,
    verificationTime: 0.08,
  },
  
  // MoPro - Circom - Pedersen
  {
    circuit: "Pedersen",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 0.32,
    verificationTime: 0.09,
  },
  {
    circuit: "Pedersen",
    framework: "MoPro",
    language: "Circom",
    platform: "Android",
    device: "Google Pixel 6",
    provingTime: 0.31,
    verificationTime: 0.09,
  },
  {
    circuit: "Pedersen",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 0.25,
    verificationTime: 0.08,
  },
  {
    circuit: "Pedersen",
    framework: "MoPro",
    language: "Circom",
    platform: "iOS",
    device: "iPhone 12",
    provingTime: 0.28,
    verificationTime: 0.08,
  },
  
  // MoPro - Noir - SHA-256
  {
    circuit: "SHA-256",
    framework: "MoPro",
    language: "Noir",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 2.67,
    verificationTime: 0.13,
  },
  {
    circuit: "SHA-256",
    framework: "MoPro",
    language: "Noir",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 2.05,
    verificationTime: 0.10,
  },
  
  // MoPro - Noir - Keccak-256
  {
    circuit: "Keccak-256",
    framework: "MoPro",
    language: "Noir",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 9.12,
    verificationTime: 0.16,
  },
  {
    circuit: "Keccak-256",
    framework: "MoPro",
    language: "Noir",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 7.23,
    verificationTime: 0.13,
  },
  
  // MoPro - Noir - Poseidon
  {
    circuit: "Poseidon",
    framework: "MoPro",
    language: "Noir",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 0.21,
    verificationTime: 0.09,
  },
  {
    circuit: "Poseidon",
    framework: "MoPro",
    language: "Noir",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 0.16,
    verificationTime: 0.07,
  },
  
  // MoPro - Noir - MiMC
  {
    circuit: "MiMC",
    framework: "MoPro",
    language: "Noir",
    platform: "Android",
    device: "Samsung Galaxy S21",
    provingTime: 0.26,
    verificationTime: 0.09,
  },
  {
    circuit: "MiMC",
    framework: "MoPro",
    language: "Noir",
    platform: "iOS",
    device: "iPhone 13 Pro",
    provingTime: 0.20,
    verificationTime: 0.08,
  },
];
