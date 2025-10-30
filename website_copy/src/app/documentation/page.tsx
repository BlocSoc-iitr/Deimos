'use client';

export default function Documentation() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Documentation</h1>
      
      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">What is Deimos?</h2>
        <p className="mb-4">
          Deimos is an open-source project similar to L2Beat, designed to display comprehensive benchmark data that allows users to compare the performance of different zkVMs across various devices. This enables developers to choose the most suitable zkVM based on their target device requirements.
        </p>
        <p className="mb-4">
          Deimos serves two primary functions:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Benchmarking Suite:</strong> A comprehensive toolkit for evaluating zero-knowledge virtual machines (zkVMs) on mobile devices</li>
          <li><strong>Public Dashboard:</strong> A web-based service where users can view and compare all benchmark results</li>
        </ul>
        <p className="mb-4">
          The project aims to benchmark zkVM performance for mobile-specific environments, compare multiple tools 
          (initially MoPro, imp1, and ProveKit), and measure performance of common cryptographic and proof-related 
          functions across different frameworks (Circom, Noir, Halo2).
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Technology Stack</h2>
        <h3 className="text-xl font-bold mb-2">Circuit Development</h3>
        <p className="mb-4"><strong>Circom Ecosystem:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Circom Compiler:</strong> Version 2.1.6 for circuit compilation</li>
          <li><strong>snarkjs:</strong> Groth16 proof generation and verification</li>
          <li><strong>circomlib:</strong> Standard library of circuits</li>
          <li><strong>hash-circuits:</strong> Library for Blake2s circuit</li>
          <li><strong>keccak256-circom:</strong> Library for Keccak256 circuit</li>
        </ul>
        <p className="mb-4"><strong>Noir Ecosystem:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Noir:</strong> Version 1.0.0-beta.8</li>
          <li><strong>Nargo:</strong> Build and compilation toolchain</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Mobile Development</h3>
        <p className="mb-4"><strong>Rust Core:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>mopro-wasm:</strong> WebAssembly support</li>
          <li><strong>mopro-ffi:</strong> FFI bindings with Circom, Halo2, and Noir adapters</li>
          <li><strong>uniffi:</strong> Version 0.29.0 for cross-language bindings</li>
          <li><strong>rust-witness:</strong> Version 0.1 for witness generation</li>
        </ul>
        <p className="mb-4"><strong>Android Platform:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li>Kotlin for application logic</li>
          <li>Jetpack Compose for UI</li>
          <li>Material Design components</li>
        </ul>
        <p className="mb-4"><strong>iOS Platform:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li>Swift for application logic</li>
          <li>SwiftUI/UIKit for UI</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Website Dashboard</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Framework:</strong> Next.js 15.5.3 with Turbopack</li>
          <li><strong>Language:</strong> TypeScript</li>
          <li><strong>Styling:</strong> Tailwind CSS</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Repository Structure</h2>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`deimos/
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
│   │   └── noir/             # Noir implementations (planned)
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
└── LICENSE`}
          </pre>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Current Support</h2>
        <p className="mb-4">
          Deimos currently supports <strong>MoPro</strong> with the following frameworks and circuits:
        </p>
        <h3 className="text-xl font-bold mb-2">Circom Framework</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>SHA-256</li>
          <li>Keccak-256</li>
          <li>BLAKE2s-256</li>
          <li>MiMC-256</li>
          <li>Pedersen</li>
          <li>Poseidon</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Noir Framework</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>SHA-256</li>
          <li>Keccak-256</li>
          <li>MiMC</li>
          <li>Poseidon</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Planned Integration</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>imp1 - Ingonyama&apos;s mobile proving solution</li>
          <li>ProveKit - Worldcoin&apos;s Noir-based toolkit</li>
          <li>RISC Zero - General-purpose zkVM</li>
          <li>SP1 - Succinct&apos;s zkVM</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Benchmarked Primitives</h2>
        <h3 className="text-xl font-bold mb-2">Hash Functions</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>SHA-256</strong> - Standard cryptographic hash (29k constraints)</li>
          <li><strong>Keccak-256</strong> - Ethereum-compatible hash (151k constraints)</li>
          <li><strong>BLAKE2s-256</strong> - Fast cryptographic hash (32k constraints)</li>
          <li><strong>Poseidon</strong> - ZK-friendly hash (240 constraints)</li>
          <li><strong>MiMC-256</strong> - Minimal multiplicative complexity (330 constraints)</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Digital Signatures</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>EdDSA (planned)</li>
          <li>ECDSA (planned)</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Other Primitives</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Pedersen Hash</li>
          <li>Fibonacci sequence (basic arithmetic)</li>
          <li>JWT parsing (planned)</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Measured Metrics</h2>
        <p className="mb-4">The benchmarking suite collects comprehensive performance data:</p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Proof Generation Time</strong> - Time required to generate ZK proofs</li>
          <li><strong>Proof Verification Time</strong> - Duration of proof validation</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">System Architecture</h2>
        <h3 className="text-xl font-bold mb-2">High-Level Architecture</h3>
        <p className="mb-4">
          Deimos is divided into two main components:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Website Dashboard</strong> - A frontend interface where users can access project documentation and view all benchmark data</li>
          <li><strong>Mobile Applications</strong> - Android and iOS apps used for benchmarking different zkVMs with various circuits and frameworks</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Mobile App: MoPro Architecture and Implementation</h3>
        <p className="mb-4">
          The mobile app currently uses the <strong>MoPro framework</strong>, which enables cross-platform mobile ZK proof generation through a layered approach with native bindings via Rust FFI and UniFFI.
        </p>
        <p className="mb-4"><strong>Key Components:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Rust Core:</strong> Circuit integration, FFI functions, and multi-backend support</li>
          <li><strong>Android Integration:</strong> Performance benchmarking, UI components, and memory monitoring</li>
          <li><strong>Generated Bindings:</strong> Type-safe FFI, memory management, and error handling</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Circuit Implementation Architecture</h3>
        <p className="mb-4">
          The circuit layer supports multiple frameworks with a consistent structure:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Circom Circuits:</strong> Located in <code>benchmarking-suite/frameworks/circom/circuits/</code> with implementations for SHA-256, Keccak-256, BLAKE2s, Poseidon, MiMC, and Pedersen</li>
          <li><strong>Noir Circuits:</strong> Located in <code>benchmarking-suite/frameworks/noir/circuits/</code></li>
        </ul>
        <p className="mb-4">
          Each circuit follows a byte-to-bits conversion pattern with proper bit ordering considerations (MSB-first for SHA-256, LSB-first for Keccak-256).
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Circuit Implementation Details</h2>
        <h3 className="text-xl font-bold mb-2">Circom Circuits</h3>
        <p className="mb-4">
          All circuits are implemented in Circom 2.0+ and use the Groth16 proving system. 
          The circuits are designed for benchmarking with public inputs to measure verifiable computation performance.
        </p>
        <h4 className="text-lg font-bold mb-2">Circuit Sizes (R1CS Constraints)</h4>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <p className="mb-2"><strong>Per byte hashing:</strong></p>
          <ul className="list-disc ml-6 mb-4">
            <li>Poseidon2: ~8 constraints/byte</li>
            <li>MiMC: ~10.5 constraints/byte</li>
            <li>SHA-256: ~410 constraints/byte</li>
            <li>BLAKE2s: ~509 constraints/byte</li>
            <li>Keccak-256: ~1100 constraints/byte</li>
          </ul>
          <p className="mb-2"><strong>Per native chunk:</strong></p>
          <ul className="list-disc ml-6 mb-4">
            <li>Poseidon2: ~250 constraints</li>
            <li>MiMC: ~330 constraints</li>
            <li>SHA-256: ~26,200 constraints</li>
            <li>BLAKE2s: ~32,600 constraints</li>
            <li>Keccak-256: ~147,000 constraints</li>
          </ul>
        </div>
        <h4 className="text-lg font-bold mb-2">Circuit Pattern</h4>
        <p className="mb-4">All hash circuits follow this pattern:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`template HashBench(N) {
    signal input in[N];      // Input bytes
    signal output out[32];   // Hash output (32 bytes for 256-bit)
    
    component hash = HashFunction(N);
    hash.in <== in;
    out <== hash.out;
}

// Public input for verifiable computation
component main {public[in]} = HashBench(32);`}
          </pre>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">MoPro Integration</h2>
        <p className="mb-4">
          MoPro (Mobile Proving) is a framework that brings zero-knowledge proof capabilities to mobile platforms.
        </p>
        <h3 className="text-xl font-bold mb-2">Architecture</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm">
{`┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Kotlin/Swift  │───▶│   Rust FFI       │───▶│  ZK Circuits    │
│   (Mobile App)  │    │   (UniFFI)       │    │  (Circom/Halo2) │
└─────────────────┘    └──────────────────┘    └─────────────────┘`}
          </pre>
        </div>
        <h3 className="text-xl font-bold mb-2">Key Features</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Cross-platform support for iOS, Android, and Web</li>
          <li>Multiple ZK backends: Circom, Halo2, and Noir</li>
          <li>Native bindings through Rust FFI and UniFFI</li>
          <li>Performance benchmarking tools for mobile ZK operations</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Rust FFI Implementation</h3>
        <p className="mb-4">
          The Rust core uses the <code>mopro_ffi</code> macro to generate FFI bindings for proof generation and verification functions across multiple backends.
        </p>
        <h3 className="text-xl font-bold mb-2">Circuit Configuration</h3>
        <p className="mb-4">
          Circuits are registered using the <code>set_circom_circuits!</code> macro with witness generation functions.
        </p>
        <h3 className="text-xl font-bold mb-2">Benchmarking Features</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Single run testing for individual proof generation</li>
          <li>Batch processing with automated multiple runs and statistics</li>
          <li>Framework comparison for side-by-side performance analysis</li>
          <li>Real-time monitoring with live performance metrics display</li>
          <li>Memory usage tracking during proof generation</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">CI/CD Pipeline</h2>
        <h3 className="text-xl font-bold mb-2">Circuit Validation Workflow</h3>
        <p className="mb-4">
          The project includes an automated circuit validation workflow that triggers on pull requests affecting circuit files.
        </p>
        <h3 className="text-xl font-bold mb-2">Validation Steps</h3>
        <p className="mb-4">
          The workflow performs the following validations:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Dependency Installation:</strong> Caches and installs system dependencies, Rust toolchain, Node.js, Circom, and Noir</li>
          <li><strong>Change Detection:</strong> Identifies modified circuit files in pull requests</li>
          <li><strong>Circom Compilation:</strong> Compiles changed Circom circuits with R1CS generation</li>
          <li><strong>Noir Compilation:</strong> Checks and compiles changed Noir projects</li>
          <li><strong>Summary Generation:</strong> Provides detailed validation results</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Circuit Compilation Rules</h3>
        <p className="mb-4">
          The workflow skips library circuits without a main component and validates only circuits with a main component declaration.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Development Status</h2>
        <p className="mb-4"><strong>Current Focus:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li>MoPro integration and core hash function benchmarks</li>
          <li>Circom circuit implementations for various hash functions</li>
          <li>Mobile app development for Android and iOS</li>
        </ul>
        <p className="mb-4"><strong>Next Milestones:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li>Database integration for storing benchmark results</li>
          <li>Basic web dashboard for visualizing performance data</li>
          <li>Additional zkVM framework integrations</li>
        </ul>
        <p className="mb-4"><strong>Branch Policy:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><code>main</code> - Stable releases only</li>
          <li><code>dev</code> - Active development with frequent breaking changes</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Use Cases</h2>
        <h3 className="text-xl font-bold mb-2">Privacy-Preserving Authentication</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Prove knowledge of password without revealing it</li>
          <li>Zero-knowledge identity verification</li>
          <li>Private credential systems</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Blockchain Integration</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Mobile wallet proof generation</li>
          <li>Layer 2 scaling solutions</li>
          <li>Private transaction validation</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Performance Research</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Mobile ZK proof benchmarking</li>
          <li>Cross-platform performance analysis</li>
          <li>Resource optimization studies</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Website Documentation</h2>
        <h3 className="text-xl font-bold mb-2">Documentation Structure</h3>
        <p className="mb-4">
          The website provides comprehensive documentation organized into logical sections:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Home</strong> - Landing page with project overview</li>
          <li><strong>Documentation</strong> - Complete technical documentation</li>
          <li><strong>Get Started</strong> - Step-by-step setup guide</li>
          <li><strong>Circuits</strong> - Circuit implementation guide</li>
          <li><strong>MoPro</strong> - MoPro integration documentation</li>
          <li><strong>Contributing</strong> - Contribution guidelines</li>
          <li><strong>About</strong> - Project information and roadmap</li>
          <li><strong>Benchmarks</strong> - Future benchmark dashboard</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Design Philosophy</h3>
        <p className="mb-4">
          The documentation website follows a simple, content-focused approach with emphasis on:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Information rather than aesthetics</li>
          <li>Clear explanations</li>
          <li>Complete information in one place</li>
          <li>Easy navigation</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Resources and References</h2>
        <h3 className="text-xl font-bold mb-2">Official Documentation</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>MoPro Documentation:</strong> https://zkmopro.org</li>
          <li><strong>Circom Language:</strong> https://docs.circom.io</li>
          <li><strong>UniFFI Guide:</strong> https://mozilla.github.io/uniffi-rs</li>
          <li><strong>snarkjs:</strong> https://github.com/iden3/snarkjs</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Community</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Twitter:</strong> @zkmopro</li>
          <li><strong>Telegram:</strong> @zkmopro</li>
        </ul>
      </section>
    </div>
  );
}
