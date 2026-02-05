# Deimos — zkVM Mobile Benchmarking Suite

**Deimos** is an open-source project similar to L2Beat, designed to display comprehensive benchmark data that allows users to compare the performance of different zkVMs across various devices. This enables developers to choose the most suitable zkVM based on their target device requirements.

Deimos serves two primary functions:
1. **Benchmarking Suite**: A comprehensive toolkit for evaluating zero-knowledge virtual machines (zkVMs) on mobile devices
2. **Public Dashboard**: A web-based service where users can view and compare all benchmark results

---

## Overview

The goal of Deimos is to:

* **Benchmark zkVM performance** for mobile-specific environments
* **Compare multiple tools** including MoPro, imp1, and ProveKit
* **Measure performance** of common cryptographic and proof-related functions across different frameworks (Circom, Noir, Halo2)
* **Present results** via a centralized website dashboard

---

## Current Support

Deimos currently supports **MoPro** with the following frameworks and circuits:

### Circom Framework
- SHA-256
- Keccak-256
- BLAKE2s-256
- MiMC-256
- Pedersen
- Poseidon

### Noir Framework
- SHA-256
- Keccak-256
- MiMC
- Poseidon

---

## Measured Metrics

The benchmarking suite collects comprehensive performance data:

- **Proof Generation Time** — Time required to generate ZK proofs
- **Proof Verification Time** — Duration of proof validation
- **Memory Usage** — Total RAM, peak usage, consumed memory, and percentages
- **Battery Impact** — Battery consumption during proving operations
- **Proof Size** — Generated proof artifact size in bytes
- **Device Information** — Platform, device model, manufacturer, OS version

---

## System Architecture

### High-Level Architecture

Deimos is divided into three main components:

1. **Backend API** — Node.js/Express server with Firebase Firestore for data persistence and RESTful endpoints
2. **Website Dashboard** — Next.js frontend interface where users can access project documentation and view all benchmark data
3. **Mobile Applications** — Android and iOS apps used for benchmarking different zkVMs with various circuits and frameworks

### Mobile App: MoPro Architecture and Implementation

The mobile app currently uses the **MoPro framework**, which enables cross-platform mobile ZK proof generation through a layered approach with native bindings via Rust FFI and UniFFI. 

**Key Components:**

1. **Rust Core**: Circuit integration, FFI functions, and multi-backend support
2. **Android Integration**: Performance benchmarking, UI components, and memory monitoring
3. **Generated Bindings**: Type-safe FFI, memory management, and error handling 

#### Circuit Implementation Architecture

The circuit layer supports multiple frameworks with a consistent structure:

- **Circom Circuits**: Located in `benchmarking-suite/frameworks/circom/circuits/` with implementations for SHA-256, Keccak-256, BLAKE2s, Poseidon, MiMC, and Pedersen
- **Noir Circuits**: Located in `benchmarking-suite/frameworks/noir/circuits/`

Each circuit follows a byte-to-bits conversion pattern with proper bit ordering considerations (MSB-first for SHA-256, LSB-first for Keccak-256).

---

## Repository Structure

### Main Directories

- **`benchmarking-suite/`**: Core benchmarking implementations
  - **`frameworks/`**: Circuit implementations for Circom, Noir, and Cairo-M
  - **`moPro/`**: MoPro mobile app implementations with Rust FFI
- **`backend/`**: Node.js/Express API server with Firebase integration
- **`website/`**: Next.js-based documentation and dashboard
- **`.github/`**: CI/CD workflows and automation scripts

### MoPro Directory Structure

Each MoPro implementation follows a consistent pattern: 

- **`src/`**: Rust library with ZK proof functions
- **`android/`**: Android application with Kotlin integration
- **`MoproAndroidBindings/`**: Generated FFI bindings
- **`test-vectors/`**: Test data for circuits
- **`Cargo.toml`**: Rust dependencies

---

## Technology Stack

### Circuit Development

**Circom Ecosystem:**
- **Circom Compiler**: Version 2.1.6 for circuit compilation
- **snarkjs**: Groth16 proof generation and verification
- **circomlib**: Standard library of circuits 
- **hash-circuits**: Library for Blake2s circuit
- **keccak256-circom**: Library for Keccak256 circuit 

**Noir Ecosystem:**
- **Noir**: Version 1.0.0-beta.8
- **Nargo**: Build and compilation toolchain 

### Mobile Development

**Rust Core:**
- **mopro-wasm**: WebAssembly support
- **mopro-ffi**: FFI bindings with Circom, Halo2, and Noir adapters
- **uniffi**: Version 0.29.0 for cross-language bindings
- **rust-witness**: Version 0.1 for witness generation 

**Android Platform:**
- Kotlin for application logic
- Jetpack Compose for UI
- Material Design components

**iOS Platform:**
- Swift for application logic
- SwiftUI/UIKit for UI

### Website Dashboard

- **Framework**: Next.js 15.5.3 with Turbopack
- **Language**: TypeScript
- **Styling**: Tailwind CSS with Radix UI components
- **Features**: Card-based expandable design, real-time filtering, responsive layout

### Backend API

- **Framework**: Node.js with Express.js
- **Database**: Firebase Firestore for data persistence
- **Features**: Duplicate detection, comprehensive filtering, pagination, CORS support

---

## Installation and Setup

### Prerequisites

**System Requirements:**
- Node.js 18+ for website and backend development
- Rust toolchain (stable) for mobile app compilation
- Git for version control
- Firebase project for backend data persistence

**Circuit Development Tools:**
- Circom compiler (v2.1.6)
- snarkjs (npm global installation)
- Noir/Nargo (v1.0.0-beta.8) 

### Quick Start

**1. Clone the Repository:**

```bash
git clone https://github.com/aryanbaranwal001/temp_deimos.git
cd temp_deimos
```

**2. Run the Backend API:**

```bash
cd backend
npm install
# Configure .env with Firebase credentials
npm start
```

**3. Run the Website Dashboard:**

```bash
cd website
npm install
npm run dev
```

**4. Run Mobile Benchmarks:**

Install the APK on your Android device to run benchmarks. The mobile app allows you to execute performance tests directly on physical hardware for accurate measurements.

### Environment Configuration

**Backend `.env` file:**
```env
FIREBASE_ADMINSDK_CREDENTIALS={"type":"service_account",...}
PORT=5000
NODE_ENV=development
CORS_ORIGIN=*
```

## Data Flow Architecture

### Mobile App → Backend

1. Flutter app generates proof using MoPro framework
2. App verifies the generated proof
3. App collects device metrics (memory, battery, device info)
4. App sends POST request to `/api/benchmark-result`
5. Backend checks for duplicates based on device ID
6. If not duplicate: saves to Firestore database
7. Returns appropriate response (201 for created, 200 for duplicate)

### Website ← Backend

1. Website fetches available filters from `/api/filters`
2. User applies filters (circuit, framework, platform, etc.)
3. Website fetches paginated data from `/api/benchmarks`
4. Backend queries Firestore with applied filters
5. Backend returns data with pagination metadata
6. Website displays results in card format with expandable details

## Circuit Implementation Guide

### Implemented Circuits

The project includes implementations for multiple cryptographic primitives:

- **SHA-256**: Standard cryptographic hash (MSB-first bit ordering)
- **Keccak-256**: Ethereum-compatible hash (LSB-first bit ordering)
- **BLAKE2s-256**: Fast cryptographic hash
- **Poseidon**: ZK-friendly hash function
- **MiMC-256**: Minimal multiplicative complexity
- **Pedersen**: Hash function for commitment schemes

### Circuit Pattern

All circuits follow a consistent wrapper pattern for byte-to-bits conversion.

### Adding New Hash Functions

The project provides a comprehensive guide for adding new hash functions with step-by-step instructions covering:

1. Directory structure creation
2. Core circuit implementation
3. Main circuit file creation
4. Test input generation
5. Circuit compilation
6. Proving key generation
7. Verification testing

### Bit Ordering Considerations

- **MSB-First (Big-Endian)**: Used by SHA-256 and most standard cryptographic hashes
- **LSB-First (Little-Endian)**: Used by Keccak-256 and Ethereum-compatible implementations 

---

## Mobile Integration

### Rust FFI Implementation

The Rust core uses the `mopro_ffi` macro to generate FFI bindings for proof generation and verification functions across multiple backends.

### Circuit Configuration

Circuits are registered using the `set_circom_circuits!` macro with witness generation functions.

---

## CI/CD Pipeline

### Circuit Validation Workflow

The project includes an automated circuit validation workflow that triggers on pull requests affecting circuit files. 

### Validation Steps

The workflow performs the following validations:

1. **Dependency Installation**: Caches and installs system dependencies, Rust toolchain, Node.js, Circom, and Noir
2. **Change Detection**: Identifies modified circuit files in pull requests
3. **Circom Compilation**: Compiles changed Circom circuits with R1CS generation
4. **Noir Compilation**: Checks and compiles changed Noir projects
5. **Summary Generation**: Provides detailed validation results

### Circuit Compilation Rules

The workflow skips library circuits without a main component and validates only circuits with a main component declaration. 

---

## Contributing Guidelines

### Contribution Workflow

Before starting development, contributors should create an issue to open discussion, validate that the PR is wanted, and coordinate implementation details. 

### Standard Workflow

The typical contribution workflow includes:

1. Fork the repository and keep it synchronized
2. Branch from `dev` with descriptive branch names
3. Make changes and commit with proper messages
4. Run tests and linters before submission
5. Create pull requests with issue references
6. Address maintainer feedback

### Code Quality Requirements

All code must pass the following checks:

- Rust formatting with `cargo fmt`
- Clippy linting with all warnings as errors
- Typo checking

### Branch Policy

- **`main`** — Stable releases only
- **`dev`** — Active development with frequent breaking changes 

---

## Data Structure

### Benchmark Data Format

The benchmark data follows this comprehensive structure:

```typescript
{
  circuit: string                    // e.g., "Poseidon"
  framework: string                  // e.g., "MoPro"
  language: string                   // e.g., "circom"
  provingTimeMiliSeconds: number     // Proving time in ms
  verificationTimeMiliSeconds: number // Verification time in ms
  deviceInfo: {
    platform: string                 // "Android" or "iOS"
    device: string                   // Device model
    manufacturer?: string            // Device manufacturer
    androidVersion?: string          // Android version
    androidId?: string               // Unique Android ID (for duplicate detection)
    memory: {
      totalPhysicalMemory: number
      memoryUsedBeforeProof: number
      peakMemoryUsage: number
      memoryConsumedByProof: number
      peakMemoryLoadInPercentage: number
      memoryConsumedInPercentage: number
    }
    battery: {
      batteryBeforeProof: number
      batteryAfterProof: number
      batteryConsumed: number
    }
  }
  proofSize: number                  // Proof size in bytes
  timestamp: string                  // ISO 8601 timestamp
  createdAt?: string                 // Added by backend
}
```

## Website Documentation

### Documentation Structure

The website provides comprehensive documentation organized into logical sections:

1. **Home** — Landing page with project overview
2. **Documentation** — Complete technical documentation
3. **Get Started** — Step-by-step setup guide
4. **Circuits** — Circuit implementation guide
5. **MoPro** — MoPro integration documentation
6. **Contributing** — Contribution guidelines
7. **About** — Project information and roadmap
8. **Benchmarks** — Live benchmark dashboard with card-based interface

### Design Philosophy

The documentation website follows a simple, content-focused approach with emphasis on:
- Information rather than aesthetics
- Clear explanations
- Complete information in one place
- Easy navigation

### Dashboard Features

The benchmark dashboard provides:
- **Card-based Layout**: User-friendly expandable cards for each benchmark
- **Summary Statistics**: Total benchmarks, average times, memory usage
- **Real-time Filtering**: By circuit, framework, language, and platform
- **Detailed Metrics**: Expandable sections showing device info, memory usage, and performance data
- **Responsive Design**: Optimized for mobile, tablet, and desktop viewing
- **Pagination**: Efficient handling of large datasets

## Testing

### Backend Testing

```bash
cd backend
npm start  # Start the server in one terminal

# In another terminal:
node test-api.js  # Run the test script
```

The test script will:
1. Check health endpoint
2. Fetch available filters
3. Submit a benchmark
4. Test duplicate detection
5. Fetch benchmarks with pagination
6. Test filtered queries

### Frontend Testing

```bash
cd website
npm run dev  # Start Next.js dev server
```

Visit `http://localhost:3000` to see the dashboard.

## Implementation Notes

### Key Features Implemented

✅ **Backend Data Persistence**: Benchmark data saved to Firestore
✅ **Duplicate Detection**: Prevents duplicate entries based on device IDs
✅ **Card-based UI**: User-friendly expandable design
✅ **Comprehensive Metrics**: All benchmark metrics including memory and battery
✅ **Real-time Filtering**: Dynamic filtering by multiple criteria
✅ **Responsive Design**: Works on all device sizes
✅ **Extensible Structure**: Easy to add new metrics and frameworks

### Future Enhancements

The current architecture allows for easy addition of:
- More device metrics (CPU usage, temperature, etc.)
- Comparison views between different devices
- Charts and graphs for performance visualization
- Export functionality for benchmark data
- Advanced filtering (date ranges, performance thresholds)
- Additional zkVM frameworks and circuits

---

## Use Cases

### Privacy-Preserving Authentication

- Prove knowledge of passwords without revealing them
- Zero-knowledge identity verification
- Private credential systems

### Blockchain Integration

- Mobile wallet proof generation
- Layer 2 scaling solutions
- Private transaction validation

### Performance Research

- Mobile ZK proof benchmarking
- Cross-platform performance analysis
- Resource optimization studies

---

## Resources and References

### Official Documentation

- **MoPro Documentation**: https://zkmopro.org
- **Circom Language**: https://docs.circom.io
- **UniFFI Guide**: https://mozilla.github.io/uniffi-rs
- **snarkjs**: https://github.com/iden3/snarkjs

### Community

- **Twitter**: @zkmopro
- **Telegram**: @zkmopro

---

## License

This project is licensed under the [MIT License](LICENSE).

---

*Building neutral, comprehensive benchmarks for mobile ZK proving.*


















