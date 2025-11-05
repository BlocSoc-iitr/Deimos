'use client';

export default function CircomIntegration() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Circom Circuit Integration Guide for MoPro</h1>
      
      <p className="mb-8 text-lg text-gray-700">
        This guide explains how to integrate Circom circuits into the MoPro (Mobile Proving) framework for mobile zero-knowledge proof benchmarking.
      </p>

      <section id="prerequisites" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Prerequisites</h2>
        <ul className="list-disc ml-6 mb-4">
          <li>Completed circuit development using the Adding Hash Functions guide</li>
          <li>MoPro CLI installed (<code>cargo install --path mopro/cli</code>)</li>
          <li>Android Studio (for Android development) or a USB cable to test with actual mobile</li>
          <li>Working Circom circuit with <code>.zkey</code> and <code>.wasm</code> files</li>
        </ul>
      </section>

      <section id="integration-overview" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Integration Overview</h2>
        <p className="mb-4">
          MoPro enables mobile zero-knowledge proof generation through:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Rust Core:</strong> Circuit integration and FFI exports</li>
          <li><strong>UniFFI Bindings:</strong> Type-safe mobile bindings generation</li>
          <li><strong>Mobile Apps:</strong> Flutter/Android/iOS applications with benchmarking UI</li>
          <li><strong>Asset Management:</strong> Circuit files (.zkey, .wasm) bundled with apps</li>
        </ul>
      </section>

      <section id="step-by-step-integration" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Step-by-Step Integration</h2>
        <p className="mb-4">
          The integration process for adding new Circom circuits to MoPro is much simpler than creating new projects. 
          You work within the existing <code>mopro-example-app</code> structure.
        </p>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 1: Setup Rust Witness and Circuits</h3>
        
        <p className="mb-2"><strong>1a. Setup Rust Witness</strong></p>
        <p className="mb-4">
          Add your circuit&apos;s witness generation to the existing <code>lib.rs</code>:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// Add your circuit witness (example: Blake2s256)
rust_witness::witness!(multiplier2);
rust_witness::witness!(keccak);
rust_witness::witness!(sha256);
rust_witness::witness!(blake2s256);  // <- Add your new circuit`}
          </pre>
        </div>

        <p className="mb-2"><strong>1b. Setup Rust Circuits</strong></p>
        <p className="mb-4">
          Register your circuit in the <code>set_circom_circuits!</code> macro:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`set_circom_circuits! {
    ("multiplier2_final.zkey", circom_prover::witness::WitnessFn::RustWitness(multiplier2_witness)),
    ("keccak.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak_witness)),
    ("sha256.zkey", circom_prover::witness::WitnessFn::RustWitness(sha256_witness)),
    ("blake2s256.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s256_witness)),  // <- Add your circuit
}`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 2: Build and Update MoPro Bindings</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Navigate to the mopro-example-app directory
cd mopro-example-app

# Build the Rust library and update bindings
mopro build
mopro update`}
          </pre>
        </div>
        <p className="mb-4">
          This regenerates the Flutter/Android bindings with your new circuit support.
        </p>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 3: Add .zkey File to Flutter Assets</h3>
        <p className="mb-4">
          Copy your circuit&apos;s proving key to the Flutter assets directory:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Copy your .zkey file from the Circom build
cp ../frameworks/circom/circuits/blake2s256/blake2s256_0000.zkey flutter/assets/blake2s256.zkey`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 4: Update pubspec.yaml</h3>
        <p className="mb-4">
          Add your new asset to the Flutter configuration:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# flutter/pubspec.yaml
flutter:
  assets:
    # Existing assets
    - assets/multiplier2_final.zkey
    - assets/circom.zkey
    - assets/mimc256.zkey
    - assets/pedersen.zkey
    - assets/poseidon.zkey
    
    # Add your new circuit asset
    - assets/blake2s256.zkey`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 5: Use MoPro Plugin in Flutter</h3>
        <p className="mb-4">
          Use the existing MoPro plugin instance to generate and verify proofs with your circuit:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// In your Flutter app (flutter/lib/main.dart)
Future<void> _proveBlake2s() async {
  try {
    setState(() => _blake2sProofResult = 'Generating proof...');
    
    final input = {
      'in': [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33, 32, 84, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 115, 116, 32, 109, 115, 103, 46]
    };
    
    // Use the correct .zkey path and input format
    final result = await generateCircomProof(
      'blake2s256.zkey',  // <- Your asset path
      input,
      ProofLib.arkworks,
    );
    
    setState(() => _blake2sProofResult = result.toString());
  } catch (e) {
    setState(() => _blake2sProofResult = 'Error: \$e');
  }
}`}
          </pre>
        </div>
      </section>

      <section id="flutter-ui-integration" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Flutter UI Integration</h2>
        
        <h3 className="text-xl font-bold mb-2">Complete Flutter Integration Example</h3>
        <p className="mb-4">
          Based on our successful multi-circuit integration, here&apos;s how to add your new circuit to the existing Flutter UI:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// lib/main.dart - Add to existing _MyAppState class
class _MyAppState extends State<MyApp> {
  // Add state variables for your new circuit
  String _blake2sProofResult = '';
  bool _blake2sValid = false;

  Widget _buildCircuitSection({
    required String title,
    required Color color,
    required String proofResult,
    required bool isValid,
    required VoidCallback onProve,
    required VoidCallback onVerify,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onProve,
                  style: ElevatedButton.styleFrom(backgroundColor: color),
                  child: Text('Prove \$title'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onVerify,
                  style: ElevatedButton.styleFrom(backgroundColor: color),
                  child: Text('Verify \$title'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-6">Key Points for Flutter Integration</h3>
        <p className="mb-4">
          <strong>No separate plugin dependencies needed!</strong> The existing MoPro plugin in <code>mopro-example-app</code> handles all circuits through a single interface:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// Use the existing MoPro functions directly
import 'package:mopro_example_app/mopro_example_app.dart';

// These functions work with any circuit registered in lib.rs:
await generateCircomProof(zkeyPath, input, ProofLib.arkworks);
await verifyCircomProof(zkeyPath, proof, ProofLib.arkworks);`}
          </pre>
        </div>
        <p className="mb-4">
          <strong>Asset paths are relative to the Flutter assets directory:</strong>
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><code>&apos;blake2s256.zkey&apos;</code> (not full paths)</li>
          <li><code>&apos;keccak.zkey&apos;</code></li>
          <li><code>&apos;multiplier2_final.zkey&apos;</code></li>
        </ul>
      </section>

      <section id="advanced-patterns" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Advanced Integration Patterns</h2>
        
        <h3 className="text-xl font-bold mb-2">Multi-Circuit Architecture</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// All circuit witnesses
rust_witness::witness!(multiplier2);
rust_witness::witness!(keccak);
rust_witness::witness!(sha256);
rust_witness::witness!(blake2s256);
rust_witness::witness!(mimc256);
rust_witness::witness!(pedersen);
rust_witness::witness!(poseidon);

// Register all circuits with their .zkey files
set_circom_circuits! {
    ("multiplier2_final.zkey", circom_prover::witness::WitnessFn::RustWitness(multiplier2_witness)),
    ("keccak.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak_witness)),
    ("sha256.zkey", circom_prover::witness::WitnessFn::RustWitness(sha256_witness)),
    ("blake2s256.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s256_witness)),
    ("mimc256.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc256_witness)),
    ("pedersen.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen_witness)),
    ("poseidon.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon_witness)),
}`}
          </pre>
        </div>
        <p className="mb-4"><strong>Key Points:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Single MoPro instance</strong> handles all circuits</li>
          <li><strong>Circuit selection</strong> happens via the <code>.zkey</code> filename parameter</li>
          <li><strong>No separate projects</strong> needed for each circuit</li>
        </ul>

        <h3 className="text-xl font-bold mb-2 mt-6">Input Format Handling</h3>
        <p className="mb-4">
          Different circuits require different input formats:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// Byte-based circuits (Keccak, SHA256, Blake2s)
final byteInput = {
  'in': [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33, 32, 84, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 115, 116, 32, 109, 115, 103, 46]
};

// Field-based circuits (MiMC)
final fieldInput = {
  'in': '123456789'
};

// Array field-based circuits (Pedersen, Poseidon)
final arrayFieldInput = {
  'inputs': ['123456789', '987654321']
};`}
          </pre>
        </div>
      </section>

      <section id="troubleshooting" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Troubleshooting Common Issues</h2>
        
        <h3 className="text-xl font-bold mb-2">Issue 1: UniFFI Binding Generation Fails</h3>
        <p className="mb-4">
          <strong>Cause:</strong> Version mismatch or missing dependencies.
        </p>
        <p className="mb-2"><strong>Fix:</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Ensure UniFFI version is pinned
cargo update uniffi --precise 0.29.0

# Clean and rebuild
cargo clean
mopro build`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-6">Issue 2: Asset Loading Fails on Mobile</h3>
        <p className="mb-4">
          <strong>Cause:</strong> Incorrect asset paths or missing files.
        </p>
        <p className="mb-2"><strong>Fix:</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Verify assets are in correct location
ls test-vectors/
# Should show: circuit.zkey, circuit.wasm

# Check Flutter asset configuration
grep -A 10 "assets:" pubspec.yaml`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2 mt-6">Issue 3: Proof Generation Fails</h3>
        <p className="mb-4">
          <strong>Cause:</strong> Input format mismatch or circuit constraints.
        </p>
        <p className="mb-2"><strong>Fix:</strong></p>
        <p className="mb-4">
          Add detailed error logging to debug the issue. Verify input format matches circuit expectations.
        </p>

        <h3 className="text-xl font-bold mb-2 mt-6">Issue 4: Memory Issues on Mobile</h3>
        <p className="mb-4">
          <strong>Cause:</strong> Large circuit files or insufficient memory.
        </p>
        <p className="mb-2"><strong>Fix:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li>Use smaller pot files when possible</li>
          <li>Implement proof generation in background threads</li>
          <li>Add memory monitoring and cleanup</li>
        </ul>
      </section>

      <section id="next-steps" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Next Steps</h2>
        <p className="mb-4">After successful integration:</p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Performance Analysis:</strong> Run comprehensive benchmarks across devices</li>
          <li><strong>Optimization:</strong> Profile and optimize bottlenecks</li>
          <li><strong>Multi-Platform:</strong> Extend to iOS if needed</li>
          <li><strong>Documentation:</strong> Update project README with specific instructions</li>
          <li><strong>Testing:</strong> Add comprehensive test coverage</li>
          <li><strong>Deployment:</strong> Prepare for production deployment</li>
        </ul>
      </section>

      <section id="key-learnings" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Key Learnings from Our Integrations</h2>
        <p className="mb-4">
          Based on our successful integration of Keccak256, SHA256, Blake2s256, MiMC256, Pedersen, and Poseidon circuits:
        </p>
        
        <h3 className="text-xl font-bold mb-2">Architecture Patterns</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Separate State Management:</strong> Each circuit needs independent state variables</li>
          <li><strong>Color-Coded UI:</strong> Visual distinction helps with multi-circuit interfaces</li>
          <li><strong>Consistent Input Formats:</strong> Standardize on byte arrays vs field elements</li>
          <li><strong>Asset Naming:</strong> Use descriptive names for .zkey files (e.g., <code>mimc256.zkey</code>)</li>
        </ul>

        <h3 className="text-xl font-bold mb-2 mt-6">Technical Insights</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Batch Size:</strong> Refers to benchmark iterations, not input processing</li>
          <li><strong>Memory Management:</strong> Large .zkey files require careful mobile optimization</li>
          <li><strong>Error Handling:</strong> Robust error handling prevents app crashes</li>
          <li><strong>Performance:</strong> Proof generation times vary significantly between circuits</li>
        </ul>

        <h3 className="text-xl font-bold mb-2 mt-6">Integration Success Factors</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Incremental Development:</strong> Start with one circuit, then add others</li>
          <li><strong>Comprehensive Testing:</strong> Test both proof generation and verification</li>
          <li><strong>Visual Feedback:</strong> Clear UI indicators for success/failure states</li>
          <li><strong>Documentation:</strong> Maintain detailed integration notes for future reference</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Related Resources</h2>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>MoPro Documentation:</strong> <a href="https://zkmopro.org" className="text-blue-600 hover:underline" target="_blank" rel="noopener noreferrer">https://zkmopro.org</a></li>
          <li><strong>UniFFI Guide:</strong> <a href="https://mozilla.github.io/uniffi-rs" className="text-blue-600 hover:underline" target="_blank" rel="noopener noreferrer">https://mozilla.github.io/uniffi-rs</a></li>
          <li><strong>Flutter Plugin Development:</strong> <a href="https://docs.flutter.dev/packages-and-plugins" className="text-blue-600 hover:underline" target="_blank" rel="noopener noreferrer">https://docs.flutter.dev/packages-and-plugins</a></li>
        </ul>
      </section>
    </div>
  );
}
