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
        <h2 className="text-2xl font-bold mb-4">Setting Up MoPro Mobile App</h2>
        
        <p className="mb-6 text-lg">
          This tutorial walks you through building a static library from scratch using the Circom, Halo2, or Noir adapter, 
          and demonstrates how to integrate it with Android, iOS, and Web platforms.
        </p>

        <div className="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6">
          <p className="mb-2"><strong>📝 Note:</strong></p>
          <ul className="list-disc ml-6 text-sm">
            <li>If you already have an existing Rust project, check out the Rust Setup guide for detailed instructions.</li>
            <li>If you already have an existing mobile frontend, follow Steps 0-3 to generate bindings, then proceed to the relevant integration guide.</li>
          </ul>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-8">Step 0: Prerequisites</h3>
        <p className="mb-4">Make sure you&apos;ve installed the prerequisites before proceeding.</p>

        <h3 className="text-xl font-bold mb-2 mt-8">Step 1: Install MoPro CLI</h3>
        <p className="mb-4">Install the published CLI:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cargo install mopro-cli`}
          </pre>
        </div>
        
        <div className="bg-yellow-50 border-l-4 border-yellow-500 p-4 mb-4">
          <p className="mb-2"><strong>💡 Alternative:</strong> Get the latest CLI from GitHub</p>
          <div className="bg-gray-50 p-3 rounded mt-2">
            <pre className="text-sm overflow-x-auto">
{`git clone https://github.com/zkmopro/mopro
cd mopro/cli
cargo install --path .`}
            </pre>
          </div>
        </div>

        <p className="mb-4">Verify installation and see available commands:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`mopro --help
mopro init --help  # See details for specific commands`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-8">Step 2: Initialize Adapters</h3>
        <p className="mb-4">Navigate to the folder where you want to build the app and select the adapters:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`mopro init`}
          </pre>
        </div>

        <p className="mb-4">The following prompt will appear:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`$ mopro init
✔ Project name · mopro-example-app
? Pick the adapters you want (multiple selection with space)
⬚ circom
⬚ halo2
⬚ noir
⬚ none of above
🚀 Project 'mopro-example-app' initialized successfully! 🎉`}
          </pre>
        </div>

        <p className="mb-4">Navigate to your project directory:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd mopro-example-app`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-8">Step 3: Build Bindings</h3>
        <p className="mb-4">
          Build bindings for specific targets (iOS, Android, Web). This step builds example circuits 
          (Circom: multiplier2, Halo2: fibonacci, Noir: multiplier2).
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`mopro build`}
          </pre>
        </div>

        <p className="mb-4">The following prompt will appear:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`$ mopro build
? Build mode ›
  debug
> release
? Select platform(s) to build for (multiple selection with space) ›
⬚ ios
⬚ android
⬚ web
? Select ios architecture(s) to compile ›
⬚ aarch64-apple-ios
⬚ aarch64-apple-ios-sim
⬚ x86_64-apple-ios
? Select android architecture(s) to compile >
⬚ x86_64-linux-android
⬚ i686-linux-android
⬚ armv7-linux-androideabi
⬚ aarch64-linux-android`}
          </pre>
        </div>

        <div className="bg-yellow-50 border-l-4 border-yellow-500 p-4 mb-4">
          <p className="mb-2"><strong>⚠️ Warning:</strong> The process of building bindings may take a few minutes.</p>
        </div>

        <div className="bg-blue-50 border-l-4 border-blue-500 p-4 mb-4">
          <p className="mb-2"><strong>💡 Performance Tip:</strong></p>
          <p className="text-sm">
            Running your project in release mode significantly enhances performance compared to debug mode. 
            The Rust compiler applies optimizations that improve runtime speed and reduce binary size.
          </p>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-8">Step 4: Create Templates</h3>
        <p className="mb-4">Create templates for developing your mobile app:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`mopro create`}
          </pre>
        </div>

        <p className="mb-4">The following prompt will appear:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`$ mopro create
? Create template ›
  ios
  android
  web
  flutter
  react-native`}
          </pre>
        </div>

        <p className="mb-4 text-sm text-gray-600">
          <em>Note: Only one template can be selected at a time. To build for additional frameworks, run mopro create again.</em>
        </p>

        <h4 className="text-lg font-bold mb-2 mt-6">Opening Development Tools</h4>
        
        <p className="mb-2"><strong>For iOS:</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`open ios/MoproApp.xcodeproj`}
          </pre>
        </div>

        <p className="mb-2"><strong>For Android:</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`open android -a Android\\ Studio`}
          </pre>
        </div>

        <p className="mb-2"><strong>For Web:</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd web && yarn && yarn start`}
          </pre>
        </div>

        <p className="mb-2"><strong>For React Native:</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd react-native && npm install

# Setup ANDROID_HOME environment for Android
export ANDROID_HOME=~/Library/Android/sdk

npm run ios           # for iOS simulator
npm run ios:device    # for iOS device
npm run android       # for Android emulator/devices`}
          </pre>
        </div>

        <p className="mb-2"><strong>For Flutter:</strong></p>
        <p className="mb-4 text-sm">Make sure Flutter is installed on your system.</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`flutter doctor
flutter pub get

# Connect devices or turn on simulators before running
flutter run`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-8">Step 5: Update Circuits</h3>

        <h4 className="text-lg font-bold mb-2 mt-6">For Circom Circuits</h4>
        <ul className="list-disc ml-6 mb-4">
          <li>Ensure <code>circom</code> feature is activated in <code>mopro-ffi</code></li>
          <li>Follow the Circom documentation to generate the <code>.wasm</code> and <code>.zkey</code> files</li>
          <li>Place the <code>.wasm</code> and <code>.zkey</code> files in the <code>test-vectors/circom</code> directory</li>
        </ul>

        <p className="mb-4">Generate the execution function using the rust_witness macro:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`rust_witness::witness!(circuitname);

// ⚠️ The name should be the name of the wasm file all lowercase
// ⚠️ with all special characters removed
// ⚠️ Avoid using 'main' as your circuit name
//
// Examples:
// multiplier2 -> multiplier2
// keccak_256_256_main -> keccak256256main
// aadhaar-verifier -> aadhaarverifier`}
          </pre>
        </div>

        <p className="mb-4">Bind the <code>.zkey</code> file to the witness generation function:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`mopro_ffi::set_circom_circuits! {
    ("circuitname.zkey", mopro_ffi::witness::WitnessFn::RustWitness(circuitname_witness))
}`}
          </pre>
        </div>

        <p className="mb-4">Circuit input format (flat one-dimensional JSON string mapping):</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`{
  "in": [
    "72", "101", "108", "108", "111", "32", "87", "111",
    "114", "108", "100", "33", "32", "84", "104", "105",
    "115", "32", "105", "115", "32", "97", "32", "116",
    "101", "115", "116", "32", "109", "115", "103", "46"
  ]
}`}
          </pre>
        </div>

        <h4 className="text-lg font-bold mb-2 mt-6">For Noir Circuits</h4>
        <ul className="list-disc ml-6 mb-4">
          <li>Ensure <code>noir</code> feature is activated in <code>mopro-ffi</code></li>
          <li>Follow the Noir documentation to generate the <code>.json</code> file</li>
          <li>Download SRS to generate the <code>.srs</code> file</li>
          <li>Place the <code>.json</code> and <code>.srs</code> files in the <code>test-vectors/noir</code> directory</li>
        </ul>

        <p className="mb-4">Circuit input format (flat one-dimensional Vec&lt;String&gt;):</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`{
  "in": [
    "72", "101", "108", "108", "111", "32", "87", "111",
    "114", "108", "100", "33", "32", "84", "104", "105",
    "115", "32", "105", "115", "32", "97", "32", "116",
    "101", "115", "116", "32", "109", "115", "103", "46"
  ]
}`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-8">Step 6: Update Bindings</h3>
        <p className="mb-4">
          If you make changes to <code>src/lib.rs</code>—such as updating circuits or adding functions 
          with <code>#[uniffi::export]</code>—run:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`mopro build
mopro update`}
          </pre>
        </div>

        <p className="mb-4">This automatically updates bindings in all platform templates. For custom paths:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`mopro update --src ./my_bindings --dest ../MyMobileApp`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-8">Step 7: What&apos;s Next</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>
            <strong>Update your ZK circuits:</strong> After making changes, run <code>mopro build</code> and <code>mopro update</code>
          </li>
          <li>
            <strong>Build your mobile app frontend:</strong> Implement your business logic and user flow
          </li>
          <li>
            <strong>Expose additional Rust functionality:</strong> Add required Rust crates in <code>Cargo.toml</code> 
            and annotate functions with <code>#[uniffi::export]</code>
          </li>
        </ul>

        <div className="bg-yellow-50 border-l-4 border-yellow-500 p-4 mb-4">
          <p className="mb-2"><strong>⚠️ Important for React Native and Flutter:</strong></p>
          <p className="text-sm">
            Don&apos;t forget to update the module&apos;s API definitions to ensure the framework can access 
            the new Swift/Kotlin bindings.
          </p>
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
          <li><code>mopro-keccak256/</code> - Keccak-256 benchmarking app</li>
          <li><code>mopro-example-app/</code> - Example implementation</li>
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
