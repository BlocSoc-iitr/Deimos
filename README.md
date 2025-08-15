
# Deimos — zkVM Mobile Benchmarking Suite

**Deimos** is an open-source benchmarking suite for evaluating zero-knowledge virtual machines (zkVMs) on mobile devices.
It provides consistent, repeatable performance tests across various zkVM tools, starting with [Mopro](https://github.com/mopro).

## Overview

The goal of Deimos is to:

* Benchmark zkVM performance for mobile-specific environments.
* Compare multiple tools (initially **Mopro**, with more coming soon).
* Measure performance of common cryptographic and proof-related functions such as **Keccak** and **SHA-256**.
* Present results via a centralized **website dashboard**.

> **Note:** This project is under active development and undergoes frequent changes in the `dev` branch.

---

## Repository Structure

```
deimos/
│
├── website/                  # Dashboard for displaying benchmark results
│   ├── public/
│   ├── src/
│   └── package.json
│
├── mobile-apps/              # Mobile benchmarking apps for each zkVM
│   ├── mopro/
│   │   ├── keccak/            # Keccak performance benchmark
│   │   │   ├── android/
│   │   │   ├── ios/
│   │   │   └── README.md
│   │   ├── sha256/            # SHA-256 performance benchmark
│   │   │   ├── android/
│   │   │   ├── ios/
│   │   │   └── README.md
│   │   └── README.md
│   │
│   └── README.md
│
├── .github/                  # CI/CD and benchmark automation scripts
│   └── workflows/
│
├── .gitignore
├── README.md
├── CONTRIBUTING.md
├── proposal.md
└── LICENSE
```

---

## Development Status

* **Current focus:** Mopro integration and initial function benchmarks.
* **Branch policy:**

  * `main` → Stable releases only.
  * `dev` → Active development; frequent breaking changes.

---

## Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-org/deimos.git
   cd deimos
   ```

2. **Explore the website**

   ```bash
   cd website
   npm install
   npm run dev
   ```

3. **Run a mobile benchmark**

   * Navigate to the corresponding mobile app directory.
   * Follow the platform-specific README.


## License

This project is licensed under the [MIT License](LICENSE).

---
