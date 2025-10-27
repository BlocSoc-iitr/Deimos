'use client';

export default function GetStarted() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Getting Started</h1>
      
      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Prerequisites</h2>
        <p className="mb-4">Before you begin, make sure you have the following installed:</p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Node.js</strong> (v18 or higher) - For running the website and snarkjs</li>
          <li><strong>Rust</strong> - For building MoPro bindings and Circom compiler</li>
          <li><strong>Git</strong> - For cloning the repository</li>
          <li><strong>Circom</strong> (v2.1.6+) - For compiling circuits</li>
          <li><strong>snarkjs</strong> - For generating and verifying proofs</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Quick Start</h2>
        <h3 className="text-xl font-bold mb-2">1. Clone the Repository</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`git clone https://github.com/BlocSoc-iitr/deimos.git
cd deimos`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">2. Explore the Website Dashboard</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd website
npm install
npm run dev`}
          </pre>
        </div>
        <p className="mb-4">
          The website will be available at http://localhost:3000
        </p>

        <h3 className="text-xl font-bold mb-2">3. Run Mobile Benchmarks</h3>
        <p className="mb-4">
          Navigate to the corresponding mobile app directory (e.g., benchmarking-suite/moPro/mopro-sha256/android/).
          Follow the platform-specific README for setup instructions. Build and run on physical devices for accurate 
          performance measurements.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Installing Dependencies</h2>
        
        <h3 className="text-xl font-bold mb-2">Install Rust</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Install Circom</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`git clone https://github.com/iden3/circom.git
cd circom
git checkout v2.1.6
cargo build --release
cargo install --path circom
cd ..`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Install snarkjs</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`npm install -g snarkjs`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Install MoPro CLI</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`git clone https://github.com/zkmopro/mopro
cd mopro/cli
cargo install --path .
cd ../..`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Install Noir (Optional)</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
noirup --version v1.0.0-beta.8`}
          </pre>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Working with Circom Circuits</h2>
        
        <h3 className="text-xl font-bold mb-2">Compiling a Circuit</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd benchmarking-suite/frameworks/circom/circuits/sha256

# Compile circuit
circom circom.circom --r1cs --wasm --sym --c

# This generates:
# - circom.r1cs (constraint system)
# - circom_js/circom.wasm (witness generator)
# - circom.sym (symbol table)
# - circom_cpp/ (C++ witness generator)`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Generating Proving Key</h3>
        <p className="mb-4">
          You need a Powers of Tau file. The required size depends on your circuit's constraint count.
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Download Powers of Tau (example for pot18)
# pot14 = 16,384 constraints
# pot16 = 65,536 constraints
# pot18 = 262,144 constraints
# pot20 = 1,048,576 constraints

# Generate proving key
snarkjs groth16 setup \\
  circom.r1cs \\
  ../../phase1/pot18_final.ptau \\
  sha256_0000.zkey

# Export verification key
snarkjs zkey export verificationkey \\
  sha256_0000.zkey \\
  verification_key.json`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Generating and Verifying Proofs</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Generate proof
snarkjs groth16 fullprove \\
  ../../inputs/sha256/input_9.json \\
  circom_js/circom.wasm \\
  sha256_0000.zkey \\
  proof.json \\
  public.json

# Verify proof
snarkjs groth16 verify \\
  verification_key.json \\
  public.json \\
  proof.json

# Should output: [INFO] snarkJS: OK!`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Testing Circuits</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Run circuit tests
cd benchmarking-suite/frameworks/circom
cargo test

# Test specific circuit
cargo test test_sha256`}
          </pre>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Setting Up MoPro Mobile Apps</h2>
        
        <h3 className="text-xl font-bold mb-2">Initialize MoPro Project</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd benchmarking-suite/moPro/mopro-sha256

# Initialize MoPro configuration
mopro init

# Build native bindings
mopro build

# Generate platform templates
mopro create

# Update bindings after changes
mopro update`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Android Development</h3>
        <p className="mb-4">Prerequisites: Android Studio, Android SDK, Java 11+</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Open in Android Studio
open android -a Android\\ Studio

# Or build from command line
cd android
./gradlew build

# Run on device
./gradlew installDebug`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">iOS Development</h3>
        <p className="mb-4">Prerequisites: Xcode, macOS, CocoaPods</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Open in Xcode
open ios/MoproApp.xcodeproj

# Or build from command line
cd ios
xcodebuild -project MoproApp.xcodeproj -scheme MoproApp build`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Running Tests</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Run Rust tests
cargo test

# Test specific circuit
cargo test test_circom

# Run with verbose output
cargo test -- --nocapture`}
          </pre>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Project Structure Navigation</h2>
        
        <h3 className="text-xl font-bold mb-2">Circuit Implementations</h3>
        <p className="mb-4">
          All Circom circuits are in <code>benchmarking-suite/frameworks/circom/circuits/</code>
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><code>sha256/</code> - SHA-256 hash circuit</li>
          <li><code>keccak256/</code> - Keccak-256 hash circuit</li>
          <li><code>blake2s256/</code> - BLAKE2s-256 hash circuit</li>
          <li><code>poseidon/</code> - Poseidon hash circuit</li>
          <li><code>mimc256/</code> - MiMC hash circuit</li>
          <li><code>pedersen/</code> - Pedersen hash circuit</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Test Inputs</h3>
        <p className="mb-4">
          Test vectors are in <code>benchmarking-suite/frameworks/circom/inputs/</code>
        </p>

        <h3 className="text-xl font-bold mb-2">Mobile Apps</h3>
        <p className="mb-4">
          MoPro mobile implementations are in <code>benchmarking-suite/moPro/</code>
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><code>mopro-sha256/</code> - SHA-256 benchmarking app</li>
          <li><code>mopro-keccack256/</code> - Keccak-256 benchmarking app</li>
          <li><code>mopro-example-app/</code> - Example implementation</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Documentation</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><code>README.md</code> - Project overview</li>
          <li><code>CONTRIBUTING.md</code> - Contribution guidelines</li>
          <li><code>APP_INTEGRATION_GUIDE.md</code> - Integration guide</li>
          <li><code>benchmarking-suite/frameworks/circom/ADDING_HASH_FUNCTIONS.md</code> - Circuit development guide</li>
          <li><code>benchmarking-suite/moPro/README.md</code> - MoPro documentation</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Common Issues and Solutions</h2>
        
        <h3 className="text-xl font-bold mb-2">Circuit Compilation Errors</h3>
        <p className="mb-4"><strong>Issue:</strong> "Too many values for input signal"</p>
        <p className="mb-4">
          <strong>Solution:</strong> Make sure your input JSON only contains fields that match circuit inputs. 
          Remove any extra fields like 'hash', 'N', etc.
        </p>

        <p className="mb-4"><strong>Issue:</strong> "Not enough coefficients"</p>
        <p className="mb-4">
          <strong>Solution:</strong> Your Powers of Tau file is too small. Use a larger pot file 
          (pot14 → pot16 → pot18 → pot20).
        </p>

        <p className="mb-4"><strong>Issue:</strong> Library import errors</p>
        <p className="mb-4">
          <strong>Solution:</strong> Check import paths in your circuit files. Use relative paths to circomlib 
          and other libraries.
        </p>

        <h3 className="text-xl font-bold mb-2">MoPro Build Issues</h3>
        <p className="mb-4"><strong>Issue:</strong> UniFFI version mismatch</p>
        <p className="mb-4">
          <strong>Solution:</strong> Make sure you're using UniFFI version 0.29.0 as specified in Cargo.toml.
        </p>

        <p className="mb-4"><strong>Issue:</strong> Android build fails</p>
        <p className="mb-4">
          <strong>Solution:</strong> Ensure you have the correct Android SDK version and Java 11+ installed. 
          Run <code>mopro update</code> to refresh bindings.
        </p>

        <h3 className="text-xl font-bold mb-2">Performance Issues</h3>
        <p className="mb-4"><strong>Issue:</strong> Slow proof generation on mobile</p>
        <p className="mb-4">
          <strong>Solution:</strong> This is expected for large circuits. Use physical devices instead of emulators 
          for accurate benchmarks. Consider using ZK-friendly hash functions like Poseidon for better performance.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Next Steps</h2>
        <ul className="list-disc ml-6 mb-4">
          <li>Read the full documentation to understand the architecture</li>
          <li>Explore existing circuit implementations</li>
          <li>Try running benchmarks on your mobile device</li>
          <li>Contribute new circuits or improvements</li>
          <li>Join the community and share your results</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Getting Help</h2>
        <p className="mb-4">If you encounter issues:</p>
        <ul className="list-disc ml-6 mb-4">
          <li>Check the documentation and README files</li>
          <li>Look at existing circuit implementations for reference</li>
          <li>Create an issue on GitHub with detailed information</li>
          <li>Join the MoPro community on Telegram: @zkmopro</li>
          <li>Follow updates on Twitter: @zkmopro</li>
        </ul>
      </section>
    </div>
  );
}
