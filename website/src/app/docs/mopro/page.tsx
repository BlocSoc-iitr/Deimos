'use client';

export default function MoPro() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">MoPro Integration Guide</h1>
      
      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">What is MoPro?</h2>
        <p className="mb-4">
          MoPro (Mobile Proving) is a framework that brings zero-knowledge proof capabilities to mobile platforms. 
          It provides cross-platform support for iOS, Android, and Web with multiple ZK backends including Circom, 
          Halo2, and Noir.
        </p>
        <p className="mb-4">
          In Deimos, MoPro is used to run benchmarks on actual mobile devices, measuring real-world performance 
          of ZK proof generation and verification.
        </p>
      </section>

      <section id="architecture" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Architecture</h2>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm">
{`┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Kotlin/Swift  │───▶│   Rust FFI       │───▶│  ZK Circuits    │
│   (Mobile App)  │    │   (UniFFI)       │    │  (Circom/Halo2) │
└─────────────────┘    └──────────────────┘    └─────────────────┘`}
          </pre>
        </div>
        <p className="mb-4">
          The architecture consists of three layers:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Mobile App Layer:</strong> Kotlin (Android) or Swift (iOS) UI and benchmarking logic</li>
          <li><strong>FFI Layer:</strong> Rust code with UniFFI bindings for type-safe cross-language communication</li>
          <li><strong>Circuit Layer:</strong> Compiled ZK circuits (Circom, Halo2, or Noir)</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Directory Structure</h2>
        <p className="mb-4">
          Each MoPro implementation follows a consistent pattern:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`moPro/
├── mopro-sha256/                 # SHA-256 implementation
│   ├── src/
│   │   └── lib.rs               # Rust library with ZK proof functions
│   ├── android/                 # Android application
│   │   └── app/src/main/java/   # Kotlin integration code
│   ├── ios/                     # iOS application (if created)
│   ├── MoproAndroidBindings/    # Generated FFI bindings
│   ├── test-vectors/            # Test data for circuits
│   ├── Cargo.toml              # Rust dependencies
│   └── README.md               # Setup instructions
│
├── mopro-keccack256/            # Keccak-256 implementation
│   └── (same structure)
│
└── mopro-example-app/           # Example implementation
    └── (same structure)`}
          </pre>
        </div>
        <p className="mb-4">
          Key directories in each MoPro implementation:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>src/:</strong> Rust library with ZK proof functions</li>
          <li><strong>android/:</strong> Android application with Kotlin integration</li>
          <li><strong>MoproAndroidBindings/:</strong> Generated FFI bindings</li>
          <li><strong>test-vectors/:</strong> Test data for circuits</li>
          <li><strong>Cargo.toml:</strong> Rust dependencies</li>
        </ul>
      </section>

      <section id="setting-up-mopro" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Setting Up MoPro</h2>
        
        <h3 className="text-xl font-bold mb-2">Prerequisites</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Rust toolchain installed</li>
          <li>MoPro CLI tool installed</li>
          <li>Android Studio (for Android) or Xcode (for iOS)</li>
          <li>Compiled circuit files (r1cs, wasm, zkey)</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Install MoPro CLI</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`git clone https://github.com/zkmopro/mopro
cd mopro/cli
cargo install --path .`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Initialize Project</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd benchmarking-suite/moPro/mopro-sha256

# Initialize MoPro configuration
mopro init

# This creates mopro-config.toml with project settings`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Build Native Bindings</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Build bindings for all configured platforms
mopro build

# This compiles Rust code and generates FFI bindings`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Create Platform Templates</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Generate platform-specific templates
mopro create

# This creates android/, ios/, or web/ directories with starter code`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Update Bindings</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# After making changes to Rust code
mopro update

# This refreshes bindings in all platform directories`}
          </pre>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Rust Implementation</h2>
        
        <h3 className="text-xl font-bold mb-2">Basic Structure (src/lib.rs)</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`use mopro_ffi::app;

// Define your app with MoPro macro
app!();

// The macro automatically generates these functions:
// - generate_circom_proof()
// - verify_circom_proof()
// - generate_halo2_proof()
// - verify_halo2_proof()
// - generate_noir_proof()
// - verify_noir_proof()`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Custom Functions</h3>
        <p className="mb-4">
          You can add custom functions using the <code>#[uniffi::export]</code> attribute:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`#[uniffi::export]
fn mopro_hello_world() -> String {
    "Hello, World!".to_string()
}

#[uniffi::export]
fn custom_benchmark_function(input: String) -> Result<String, String> {
    // Your custom logic here
    Ok("Result".to_string())
}`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Cargo Configuration</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`[package]
name = "mopro-sha256"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["lib", "cdylib", "staticlib"]

[dependencies]
mopro-ffi = { version = "0.1", features = ["circom"] }
uniffi = "0.29.0"

[features]
default = ["mopro-ffi/circom"]
# Optional: "mopro-ffi/halo2", "mopro-ffi/noir"`}
          </pre>
        </div>
      </section>

      <section id="android-integration" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Android Integration</h2>
        
        <h3 className="text-xl font-bold mb-2">Opening the Project</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Open in Android Studio
open android -a Android\\ Studio

# Or build from command line
cd android
./gradlew build`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Kotlin Usage Example</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`import uniffi.mopro.generateCircomProof
import uniffi.mopro.verifyCircomProof
import uniffi.mopro.ProofLib

// Prepare input JSON
val input = """
{
    "in": [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100]
}
""".trimIndent()

// Generate proof
val proofResult = generateCircomProof(
    zkeyPath = "/path/to/circuit.zkey",
    circuitInputs = input,
    proofLib = ProofLib.ARKWORKS
)

// Verify proof
val isValid = verifyCircomProof(
    zkeyPath = "/path/to/circuit.zkey",
    proof = proofResult,
    proofLib = ProofLib.ARKWORKS
)

println("Proof valid: $isValid")`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Benchmarking Implementation</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// Measure proving time
val startTime = System.currentTimeMillis()
val proof = generateCircomProof(zkeyPath, input, ProofLib.ARKWORKS)
val provingTime = System.currentTimeMillis() - startTime

// Measure memory usage
val runtime = Runtime.getRuntime()
val memoryBefore = runtime.totalMemory() - runtime.freeMemory()
// ... generate proof ...
val memoryAfter = runtime.totalMemory() - runtime.freeMemory()
val memoryUsed = memoryAfter - memoryBefore

// Store results
val benchmarkResult = BenchmarkResult(
    provingTime = provingTime,
    verificationTime = verificationTime,
    memoryUsed = memoryUsed,
    proofSize = proof.length
)`}
          </pre>
        </div>
      </section>

      <section id="ios-integration" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">iOS Integration</h2>
        
        <h3 className="text-xl font-bold mb-2">Opening the Project</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Open in Xcode
open ios/MoproApp.xcodeproj

# Or build from command line
cd ios
xcodebuild -project MoproApp.xcodeproj -scheme MoproApp build`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Swift Usage Example</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`import mopro

// Prepare input
let input = """
{
    "in": [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100]
}
"""

// Generate proof
let proof = try generateCircomProof(
    zkeyPath: "/path/to/circuit.zkey",
    circuitInputs: input,
    proofLib: .arkworks
)

// Verify proof
let isValid = try verifyCircomProof(
    zkeyPath: "/path/to/circuit.zkey",
    proof: proof,
    proofLib: .arkworks
)

print("Proof valid: \\(isValid)")`}
          </pre>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Benchmarking Features</h2>
        
        <h3 className="text-xl font-bold mb-2">Metrics Collected</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Proving Time:</strong> Duration of proof generation in milliseconds</li>
          <li><strong>Verification Time:</strong> Duration of proof verification in milliseconds</li>
          <li><strong>Memory Usage:</strong> Peak RAM consumption during operations in MB</li>
          <li><strong>Proof Size:</strong> Size of generated proof in bytes</li>
          <li><strong>Success Rate:</strong> Percentage of successful proof generations</li>
          <li><strong>Device Information:</strong> Model, OS version, CPU, RAM</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Single Run Testing</h3>
        <p className="mb-4">
          Test individual proof generation with detailed metrics display. Useful for debugging and 
          understanding performance characteristics.
        </p>

        <h3 className="text-xl font-bold mb-2">Batch Processing</h3>
        <p className="mb-4">
          Run multiple proof generations automatically and collect statistics:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Average proving time</li>
          <li>Minimum and maximum times</li>
          <li>Standard deviation</li>
          <li>Success rate</li>
          <li>Memory usage patterns</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Framework Comparison</h3>
        <p className="mb-4">
          Compare performance across different proving backends (Arkworks, Rapidsnark) side-by-side.
        </p>

        <h3 className="text-xl font-bold mb-2">Real-time Monitoring</h3>
        <p className="mb-4">
          Live display of performance metrics during proof generation with progress indicators.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Circuit Integration</h2>
        
        <h3 className="text-xl font-bold mb-2">Adding Circuit Files</h3>
        <p className="mb-4">
          Place your compiled circuit files in the appropriate directory:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`mopro-sha256/
├── circuits/
│   ├── sha256.wasm          # Witness generator
│   ├── sha256.zkey          # Proving key
│   └── verification_key.json # Verification key
└── test-vectors/
    └── input.json           # Test inputs`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Configuring Circuit Paths</h3>
        <p className="mb-4">
          Update your app to reference the circuit files. On Android, place files in assets/ directory. 
          On iOS, add files to the Xcode project bundle.
        </p>

        <h3 className="text-xl font-bold mb-2">Loading Circuit Files</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// Android - Load from assets
val zkeyPath = context.assets.open("sha256.zkey").use { input ->
    val file = File(context.filesDir, "sha256.zkey")
    file.outputStream().use { output ->
        input.copyTo(output)
    }
    file.absolutePath
}

// iOS - Load from bundle
guard let zkeyPath = Bundle.main.path(
    forResource: "sha256", 
    ofType: "zkey"
) else {
    fatalError("Circuit file not found")
}`}
          </pre>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Testing</h2>
        
        <h3 className="text-xl font-bold mb-2">Rust Tests</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Run all tests
cargo test

# Run specific test
cargo test test_circom

# Run with verbose output
cargo test -- --nocapture

# Run tests with release optimizations
cargo test --release`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Android Tests</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd android

# Run unit tests
./gradlew test

# Run instrumented tests on device
./gradlew connectedAndroidTest`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">iOS Tests</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd ios

# Run tests
xcodebuild test -project MoproApp.xcodeproj -scheme MoproApp`}
          </pre>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Performance Optimization</h2>
        
        <h3 className="text-xl font-bold mb-2">Rust Optimization</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Always build with <code>--release</code> flag for production</li>
          <li>Enable LTO (Link Time Optimization) in Cargo.toml</li>
          <li>Use appropriate optimization level (opt-level = 3)</li>
          <li>Profile with cargo flamegraph to identify bottlenecks</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Mobile Optimization</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Test on physical devices, not emulators</li>
          <li>Disable debug logging in production builds</li>
          <li>Use background threads for proof generation</li>
          <li>Implement proper memory management</li>
          <li>Cache circuit files to avoid repeated loading</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Circuit Optimization</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Use ZK-friendly hash functions when possible (Poseidon, MiMC)</li>
          <li>Minimize constraint count in circuits</li>
          <li>Use appropriate Powers of Tau size (not too large)</li>
          <li>Consider using Rapidsnark for faster proving</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Common Issues</h2>
        
        <h3 className="text-xl font-bold mb-2">UniFFI Version Mismatch</h3>
        <p className="mb-4">
          <strong>Issue:</strong> Build fails with UniFFI errors
        </p>
        <p className="mb-4">
          <strong>Solution:</strong> Ensure you&apos;re using UniFFI version 0.29.0 as specified in Cargo.toml. 
          This version is pinned for compatibility.
        </p>

        <h3 className="text-xl font-bold mb-2">Circuit File Not Found</h3>
        <p className="mb-4">
          <strong>Issue:</strong> App crashes when trying to load circuit files
        </p>
        <p className="mb-4">
          <strong>Solution:</strong> Verify circuit files are properly included in assets (Android) or bundle (iOS). 
          Check file paths are correct.
        </p>

        <h3 className="text-xl font-bold mb-2">Out of Memory</h3>
        <p className="mb-4">
          <strong>Issue:</strong> App crashes during proof generation
        </p>
        <p className="mb-4">
          <strong>Solution:</strong> Large circuits may exceed mobile device memory. Use smaller circuits or 
          implement memory-efficient proving strategies. Test on devices with adequate RAM.
        </p>

        <h3 className="text-xl font-bold mb-2">Slow Performance</h3>
        <p className="mb-4">
          <strong>Issue:</strong> Proof generation takes too long
        </p>
        <p className="mb-4">
          <strong>Solution:</strong> This is expected for large circuits on mobile. Use release builds, 
          test on physical devices, and consider using ZK-friendly hash functions.
        </p>
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
          <li><strong>MoPro GitHub:</strong> https://github.com/zkmopro/mopro</li>
          <li><strong>UniFFI Guide:</strong> https://mozilla.github.io/uniffi-rs</li>
          <li><strong>Circom Documentation:</strong> https://docs.circom.io</li>
          <li><strong>Community Telegram:</strong> @zkmopro</li>
          <li><strong>Community Twitter:</strong> @zkmopro</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Example Projects</h2>
        <p className="mb-4">
          Check out the example implementations in the repository:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>mopro-sha256:</strong> SHA-256 hash benchmarking app</li>
          <li><strong>mopro-keccack256:</strong> Keccak-256 hash benchmarking app</li>
          <li><strong>mopro-example-app:</strong> Basic example with all features</li>
        </ul>
      </section>
    </div>
  );
}
