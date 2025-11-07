# Deimos — Client-Side Mobile Benchmarking Suite

**Deimos** is an open-source benchmarking suite for computing zero-knowledge proofs on mobile devices. It provides consistent, repeatable performance tests across various frameworks, starting with [MoPro](https://github.com/zkmopro/mopro).

## Overview

The goal of Deimos is to:
* Benchmark performance of common cryptographic and proof-related functions such as **Poseidon2**, **SHA-256**, **Keccak-256**, and **EdDSA** for mobile-specific environments.
* Compare multiple benchmarking tools such as DSLs like Circom, Noir and ZkVMs like RiscZero, Cairo
* Present results via a public **website dashboard**.

> **Note:** This project is under active development and undergoes frequent changes in the `dev` branch.

---

## Repository Structure

```
deimos/
├── website/                    # Dashboard for displaying benchmark results
│   ├── src/app/               # Next.js application
│   └── package.json
│
├── benchmarking-suite/        # Core benchmarking implementation
│   ├── frameworks/
│   │   ├── circom/           # Circom circuit implementations
│   │   │   ├── circuits/     # Hash function circuits
│   │   │   │   ├── sha256/
│   │   │   │   ├── keccak256/
│   │   │   │   ├── blake2s256/
│   │   │   │   ├── poseidon/
│   │   │   │   ├── mimc256/
│   │   │   │   └── pedersen/
│   │   │   └── inputs/       # Test vectors
│   │   └── noir/             # Noir implementations 
│   │
│   └── moPro/                # MoPro mobile integration
│       ├── mopro-sha256/     # SHA256 mobile app
│       ├── mopro-keccack256/ # Keccak256 mobile app
│       └── mopro-example-app/
│
├── .github/workflows/         # CI/CD automation
│   └── validate-circuits.yml # Circuit validation
│
├── README.md
├── CONTRIBUTING.md
├── APP_INTEGRATION_GUIDE.md
└── LICENSE
```
---

## Benchmarked Frameworks

### Currently Supported
<!-- * **[MoPro](https://zkmopro.org/)** — Mobile-first ZK proving toolkit -->

### Planned Integration
<!-- * **[imp1](https://github.com/ingonyama-zk/zkml)** — Ingonyama's mobile proving toolkit
* **[ProveKit](https://github.com/worldfnd/ProveKit)** — Worldcoin's Noir-based toolkit

## Benchmarked Primitives

<!-- * **Hash Functions:** Poseidon2, SHA-256, Keccak-256
* **Digital Signatures:** EdDSA, ECDSA (planned)
* **Basic Arithmetic:** Fibonacci sequence
* **Application-Level:** JWT parsing (planned) -->

## Measured Metrics

<!-- * **Proving Time** — Time to generate ZK proof
* **Peak Memory Usage** — Maximum RAM consumption during proving
* **Battery Impact** — Energy consumption per proof (planned)
* **Proof Size** — Generated proof artifact size -->

---

## Development Status

* **Current focus:** MoPro integration and core hash function benchmarks.
* **Next milestone:** Database integration and basic web dashboard.
* **Branch policy:**
  * `main` → Stable releases only.
  * `dev` → Active development; frequent breaking changes.

---

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/BlocSoc-iitr/deimos.git
   git checkout dev
   cd deimos
   ```

2. **Explore the website dashboard**
   ```bash
   cd website
   npm install
   npm run dev
   ```

3. **Run mobile benchmarks**
   * Navigate to the corresponding mobile app directory (e.g., `mobile-apps/mopro/sha256/android/`).
   * Follow the platform-specific README for setup instructions.
   * Build and run on physical devices for accurate performance measurements.

## Contributing

We welcome contributions! See [CONTRIBUTING.md](/contributing.md) for:
* Setting up the development environment
* Adding new zkVM frameworks
* Contributing benchmark circuits
* Reporting issues

## License

This project is licensed under the [MIT License](LICENSE).

---

*Building neutral, comprehensive benchmarks for mobile ZK proving.*
