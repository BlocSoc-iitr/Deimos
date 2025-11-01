'use client';

export default function GetStarted() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Getting Started</h1>
      
      <section id="prerequisites" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Prerequisites</h2>
        <p className="mb-4"><strong>System Requirements:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Node.js</strong> for website development</li>
          <li><strong>Rust</strong> for mobile app compilation</li>
          <li><strong>Git</strong> for version control</li>
        </ul>
        <p className="mb-4"><strong>Circuit Development Tools:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Circom</strong></li>
          <li><strong>snarkjs</strong> </li>
          <li><strong>Noir/Nargo</strong> </li>
        </ul>
        <p className="mb-4"><strong>App Development Tools:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Mopro CLI</strong> </li>
          <li><strong>Flutter</strong> </li>
          <li><strong>Android Studio</strong> </li>
        </ul>        
      </section>

      <section id="quick-start" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Quick Start</h2>
        <h3 className="text-xl font-bold mb-2">1. Clone the Repository</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`git clone https://github.com/BlocSoc-iitr/Deimos.git
cd Deimos`}
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
      </section>


      <section id="working-with-circom-circuits" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Working with Circom Circuits</h2>
        
        <h3 className="text-xl font-bold mb-2">Step 1: Compiling a Circuit</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd benchmarking-suite/frameworks/circom/circuits/sha256

circom circom.circom --r1cs --wasm --sym --c
`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 2: Computing the Witness</h3>
        <p className="mb-4">
          First, copy the <code>input.json</code> file from <code>inputs/sha256/</code> to the appropriate directory:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>For WebAssembly: <code>circuits/sha256/circom_js/</code></li>
          <li>For C++: <code>circuits/sha256/circom_cpp/</code></li>
        </ul>

        <p className="mb-2"><strong>Option 1: Computing Witness with WebAssembly</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd benchmarking-suite/frameworks/circom/circuits/sha256/circom_js/

node generate_witness.js circom.wasm input.json witness.wtns`}
          </pre>
        </div>

        <p className="mb-2"><strong>Option 2: Computing Witness with C++</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd benchmarking-suite/frameworks/circom/circuits/sha256/circom_cpp/

make
./circom input.json witness.wtns`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 3: Generating Proving Keys</h3>
        
        <p className="mb-2"><strong>3a. Powers of Tau Ceremony (Circuit-Independent)</strong></p>
        <p className="mb-4">
          The Powers of Tau ceremony is a one-time setup that doesn&apos;t depend on a specific circuit. 
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Start new ceremony
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v

# Contribute randomness
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v`}
          </pre>
        </div>

        <p className="mb-2"><strong>3b. Generating zkey and verification key (Circuit-Dependent)</strong></p>
        <p className="mb-4">
          These steps are specific to your circuit and must be done for each circuit you compile.
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Prepare for phase 2
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

# Generate proving key
snarkjs groth16 setup circom.r1cs pot12_final.ptau circuit_0000.zkey

# Contribute to the proving key
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v

# Export verification key
snarkjs zkey export verificationkey circuit_0001.zkey verification_key.json`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 4: Generating and Verifying Proofs</h3>
        <p className="mb-4">
          Once you have the proving key and witness, you can generate and verify proofs.
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Generate proof
snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json

# Verify proof
snarkjs groth16 verify verification_key.json public.json proof.json

# Expected output: [INFO] snarkJS: OK!`}
          </pre>
        </div>

      </section>

      <section id="setting-up-mopro-mobile-apps" className="mb-12">
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

      <section id="project-structure-navigation" className="mb-12">
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

      <section id="common-issues-and-solutions" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Common Issues and Solutions</h2>
        
        <h3 className="text-xl font-bold mb-2">Circuit Compilation Errors</h3>
        <p className="mb-4"><strong>Issue:</strong> &quot;Too many values for input signal&quot;</p>
        <p className="mb-4">
          <strong>Solution:</strong> Make sure your input JSON only contains fields that match circuit inputs. 
          Remove any extra fields like &apos;hash&apos;, &apos;N&apos;, etc.
        </p>

        <p className="mb-4"><strong>Issue:</strong> &quot;Not enough coefficients&quot;</p>
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
          <strong>Solution:</strong> Make sure you&apos;re using UniFFI version 0.29.0 as specified in Cargo.toml.
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
    </div>
  );
}
