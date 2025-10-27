'use client';

export default function Documentation() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Documentation</h1>
      
      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">What is Deimos?</h2>
        <p className="mb-4">
          Deimos is an open-source benchmarking suite for evaluating zero-knowledge virtual machines (zkVMs) on mobile devices. 
          It provides consistent, repeatable performance tests across various zkVM tools, starting with MoPro.
        </p>
        <p className="mb-4">
          The project aims to benchmark zkVM performance for mobile-specific environments, compare multiple tools 
          (initially MoPro, imp1, and ProveKit), and measure performance of common cryptographic and proof-related 
          functions such as Poseidon2, SHA-256, Keccak-256, and EdDSA.
        </p>
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
        <h2 className="text-2xl font-bold mb-4">Benchmarked Frameworks</h2>
        <h3 className="text-xl font-bold mb-2">Currently Supported</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>MoPro - Mobile-first ZK proving toolkit</li>
        </ul>
        <h3 className="text-xl font-bold mb-2">Planned Integration</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>imp1 - Ingonyama's mobile proving solution</li>
          <li>ProveKit - Worldcoin's Noir-based toolkit</li>
          <li>RISC Zero - General-purpose zkVM</li>
          <li>SP1 - Succinct's zkVM</li>
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
        <p className="mb-4">The benchmarking suite collects the following performance metrics:</p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Proving Time</strong> - Time to generate ZK proof (milliseconds)</li>
          <li><strong>Verification Time</strong> - Time to verify proof (milliseconds)</li>
          <li><strong>Peak Memory Usage</strong> - Maximum RAM consumption during proving (MB)</li>
          <li><strong>Proof Size</strong> - Generated proof artifact size (bytes)</li>
          <li><strong>Battery Impact</strong> - Energy consumption per proof (planned)</li>
          <li><strong>Success Rate</strong> - Percentage of successful operations</li>
        </ul>
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
        <p className="mb-4">
          The project includes automated circuit validation through GitHub Actions. The workflow:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Detects changed circuit files in pull requests</li>
          <li>Compiles Circom circuits with proper library paths</li>
          <li>Compiles Noir projects with nargo</li>
          <li>Validates that circuits have proper main components</li>
          <li>Generates R1CS, WASM, and symbol files</li>
          <li>Reports validation results in PR summaries</li>
        </ul>
        <p className="mb-4">
          The workflow uses caching for Circom, Noir, and system dependencies to speed up validation.
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
        <h2 className="text-2xl font-bold mb-4">Resources</h2>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>MoPro Documentation:</strong> https://zkmopro.org</li>
          <li><strong>Circom Language:</strong> https://docs.circom.io</li>
          <li><strong>snarkjs Guide:</strong> https://github.com/iden3/snarkjs</li>
          <li><strong>UniFFI Guide:</strong> https://mozilla.github.io/uniffi-rs</li>
          <li><strong>circomlib Repository:</strong> https://github.com/iden3/circomlib</li>
          <li><strong>Powers of Tau:</strong> https://github.com/iden3/snarkjs#powers-of-tau</li>
        </ul>
      </section>
    </div>
  );
}
