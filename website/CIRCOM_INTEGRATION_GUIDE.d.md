# Circom Circuit Integration Guide for MoPro

This guide explains how to integrate Circom circuits into the MoPro (Mobile Proving) framework for mobile zero-knowledge proof benchmarking. This is a sequel to the [Adding Hash Functions guide](../frameworks/circom/ADDING_HASH_FUNCTIONS.md) and focuses on the mobile integration aspects.

---

## 📋 **Prerequisites**

- Completed circuit development using the [Adding Hash Functions guide](../frameworks/circom/ADDING_HASH_FUNCTIONS.md)
- MoPro CLI installed (`cargo install --path mopro/cli`)
- Android Studio (for Android development) or a USB cable to test with actual mobile
- Working Circom circuit with `.zkey` and `.wasm` files

---

## 🎯 **Integration Overview**

MoPro enables mobile zero-knowledge proof generation through:

1. **Rust Core**: Circuit integration and FFI exports
2. **UniFFI Bindings**: Type-safe mobile bindings generation
3. **Mobile Apps**: Flutter/Android/iOS applications with benchmarking UI
4. **Asset Management**: Circuit files (.zkey, .wasm) bundled with apps

---

## 🚀 **Step-by-Step Integration**

The integration process for adding new Circom circuits to MoPro is much simpler than creating new projects. You work within the existing `mopro-example-app` structure:

### Step 1: Setup Rust Witness and Circuits (`mopro-example-app/src/lib.rs`)

#### Step 1 a): Setup Rust Witness

Add your circuit's witness generation to the existing `lib.rs`:

```rust
// Add your circuit witness (example: Blake2s256)
rust_witness::witness!(multiplier2);
rust_witness::witness!(keccak);
rust_witness::witness!(sha256);
rust_witness::witness!(blake2s256);  // <- Add your new circuit
```

#### Step 1 b): Setup Rust Circuits

Register your circuit in the `set_circom_circuits!` macro:

```rust
set_circom_circuits! {
    ("multiplier2_final.zkey", circom_prover::witness::WitnessFn::RustWitness(multiplier2_witness)),
    ("keccak.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak_witness)),
    ("sha256.zkey", circom_prover::witness::WitnessFn::RustWitness(sha256_witness)),
    ("blake2s256.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s256_witness)),  // <- Add your circuit
}
```

### Step 2: Build and Update MoPro Bindings

```bash
# Navigate to the mopro-example-app directory
cd mopro-example-app

# Build the Rust library and update bindings
mopro build
mopro update
```

This regenerates the Flutter/Android bindings with your new circuit support.

### Step 3: Add .zkey File to Flutter Assets

Copy your circuit's proving key to the Flutter assets directory:

```bash
# Copy your .zkey file from the Circom build
cp ../frameworks/circom/circuits/blake2s256/blake2s256_0000.zkey flutter/assets/blake2s256.zkey
```

### Step 4: Update pubspec.yaml

Add your new asset to the Flutter configuration:

```yaml
# flutter/pubspec.yaml
flutter:
  assets:
    # Existing assets
    - assets/multiplier2_final.zkey
    - assets/circom.zkey
    - assets/mimc256.zkey
    - assets/pedersen.zkey
    - assets/poseidon.zkey
    
    # Add your new circuit asset
    - assets/blake2s256.zkey
```

### Step 5: Use MoPro Plugin in Flutter

Use the existing MoPro plugin instance to generate and verify proofs with your circuit:

```dart
// In your Flutter app (flutter/lib/main.dart)
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
    setState(() => _blake2sProofResult = 'Error: $e');
  }
}

Future<void> _verifyBlake2s() async {
  if (_blake2sProofResult.isEmpty || _blake2sProofResult.startsWith('Error')) {
    setState(() => _blake2sValid = false);
    return;
  }
  
  try {
    final isValid = await verifyCircomProof(
      'blake2s256.zkey',  // <- Same asset path
      _blake2sProofResult,
      ProofLib.arkworks,
    );
    
    setState(() => _blake2sValid = isValid);
  } catch (e) {
    setState(() => _blake2sValid = false);
  }
}
```

---

## 📱 **Flutter UI Integration**

### Complete Flutter Integration Example

Based on our successful multi-circuit integration, here's how to add your new circuit to the existing Flutter UI:

```dart
// lib/main.dart - Add to existing _MyAppState class
class _MyAppState extends State<MyApp> {
  // Add state variables for your new circuit
  String _blake2sProofResult = '';
  String _keccakProofResult = '';
  String _sha256ProofResult = '';
  
  bool _blake2sValid = false;
  bool _keccakValid = false;
  bool _sha256Valid = false;

  Widget _buildCircomTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Blake2s256 Section
          _buildCircuitSection(
            title: "Blake2s256",
            color: Colors.purple,
            proofResult: _blake2sProofResult,
            isValid: _blake2sValid,
            onProve: _proveBlake2s,
            onVerify: _verifyBlake2s,
          ),
          
          const Divider(height: 40, thickness: 2),
          
          // Keccak256 Section  
          _buildCircuitSection(
            title: "Keccak256",
            color: Colors.blue,
            proofResult: _keccakProofResult,
            isValid: _keccakValid,
            onProve: _proveKeccak,
            onVerify: _verifyKeccak,
          ),
          
          const Divider(height: 40, thickness: 2),
          
          // SHA256 Section
          _buildCircuitSection(
            title: "SHA256", 
            color: Colors.green,
            proofResult: _sha256ProofResult,
            isValid: _sha256Valid,
            onProve: _proveSha256,
            onVerify: _verifySha256,
          ),
        ],
      ),
    );
  }

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
                  child: Text('Prove $title'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onVerify,
                  style: ElevatedButton.styleFrom(backgroundColor: color),
                  child: Text('Verify $title'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (proofResult.isNotEmpty) ...[
            Text(
              'Proof Result:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                proofResult,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Verification: ${isValid ? "✅ Valid" : "❌ Invalid"}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isValid ? Colors.green : Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Circuit-specific proof generation methods
  Future<void> _proveBlake2s() async {
    try {
      setState(() => _blake2sProofResult = 'Generating proof...');
      
      // Hardcoded test input: "Hello World! This is a test msg."
      final input = [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33, 32, 84, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 115, 116, 32, 109, 115, 103, 46];
      
      final result = await mopro_blake2s256.generateCircomProof(
        'blake2s256.zkey',
        {'in': input},
        mopro_blake2s256.ProofLib.arkworks,
      );
      
      setState(() => _blake2sProofResult = result.toString());
    } catch (e) {
      setState(() => _blake2sProofResult = 'Error: $e');
    }
  }

  Future<void> _verifyBlake2s() async {
    if (_blake2sProofResult.isEmpty || _blake2sProofResult.startsWith('Error')) {
      setState(() => _blake2sValid = false);
      return;
    }
    
    try {
      final isValid = await mopro_blake2s256.verifyCircomProof(
        'blake2s256.zkey',
        _blake2sProofResult,
        mopro_blake2s256.ProofLib.arkworks,
      );
      
      setState(() => _blake2sValid = isValid);
    } catch (e) {
      setState(() => _blake2sValid = false);
    }
  }
  
  // Similar methods for other circuits...
}
```

### Key Points for Flutter Integration

**No separate plugin dependencies needed!** The existing MoPro plugin in `mopro-example-app` handles all circuits through a single interface:

```dart
// Use the existing MoPro functions directly
import 'package:mopro_example_app/mopro_example_app.dart';

// These functions work with any circuit registered in lib.rs:
await generateCircomProof(zkeyPath, input, ProofLib.arkworks);
await verifyCircomProof(zkeyPath, proof, ProofLib.arkworks);
```

**Asset paths are relative to the Flutter assets directory:**
- `'blake2s256.zkey'` (not full paths)
- `'keccak.zkey'`
- `'multiplier2_final.zkey'`

---

## 🔧 **Advanced Integration Patterns**

### Multi-Circuit Architecture


```rust
// All circuit witnesses
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
}
```

**Key Points:**
- **Single MoPro instance** handles all circuits
- **Circuit selection** happens via the `.zkey` filename parameter
- **No separate projects** needed for each circuit

### Input Format Handling

Different circuits require different input formats:

```dart
// Byte-based circuits (Keccak, SHA256, Blake2s)
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
};
```

### Benchmarking Integration

Add performance benchmarking capabilities:

```dart
class BenchmarkResult {
  final Duration provingTime;
  final Duration verificationTime;
  final int proofSize;
  final bool success;
  
  BenchmarkResult({
    required this.provingTime,
    required this.verificationTime,
    required this.proofSize,
    required this.success,
  });
}

Future<BenchmarkResult> benchmarkCircuit(String circuitName, Map<String, dynamic> input) async {
  final stopwatch = Stopwatch();
  
  // Measure proving time
  stopwatch.start();
  final proofResult = await generateCircomProof(
    '$circuitName.zkey',
    input,
    ProofLib.arkworks,
  );
  stopwatch.stop();
  final provingTime = stopwatch.elapsed;
  
  // Measure verification time
  stopwatch.reset();
  stopwatch.start();
  final isValid = await verifyCircomProof(
    '$circuitName.zkey',
    proofResult,
    ProofLib.arkworks,
  );
  stopwatch.stop();
  final verificationTime = stopwatch.elapsed;
  
  return BenchmarkResult(
    provingTime: provingTime,
    verificationTime: verificationTime,
    proofSize: proofResult.toString().length,
    success: isValid,
  );
}
```

---

## 🐛 **Troubleshooting Common Issues**

### Issue 1: UniFFI Binding Generation Fails

**Cause:** Version mismatch or missing dependencies.

**Fix:**
```bash
# Ensure UniFFI version is pinned
cargo update uniffi --precise 0.29.0

# Clean and rebuild
cargo clean
mopro build
```

### Issue 2: Asset Loading Fails on Mobile

**Cause:** Incorrect asset paths or missing files.

**Fix:**
```bash
# Verify assets are in correct location
ls test-vectors/
# Should show: circuit.zkey, circuit.wasm

# Check Flutter asset configuration
grep -A 10 "assets:" pubspec.yaml
```

### Issue 3: Proof Generation Fails

**Cause:** Input format mismatch or circuit constraints.

**Fix:**
```rust
// Add detailed error logging
#[cfg(test)]
mod tests {
    #[test]
    fn debug_circuit_input() {
        let input = r#"{"in": [1, 2, 3]}"#;
        println!("Input: {}", input);
        
        match generate_circom_proof("circuit.zkey", input, ProofLib::Arkworks) {
            Ok(proof) => println!("Success: {}", proof),
            Err(e) => println!("Error: {:?}", e),
        }
    }
}
```

### Issue 4: Memory Issues on Mobile

**Cause:** Large circuit files or insufficient memory.

**Fix:**
- Use smaller pot files when possible
- Implement proof generation in background threads
- Add memory monitoring and cleanup

---

## 🚀 **Next Steps**

After successful integration:

1. **Performance Analysis**: Run comprehensive benchmarks across devices
2. **Optimization**: Profile and optimize bottlenecks
3. **Multi-Platform**: Extend to iOS if needed
4. **Documentation**: Update project README with specific instructions
5. **Testing**: Add comprehensive test coverage
6. **Deployment**: Prepare for production deployment

---

## 📚 **Related Resources**

- **Previous Guide**: [Adding Hash Functions to Circom](../frameworks/circom/ADDING_HASH_FUNCTIONS.md)
- **MoPro Documentation**: https://zkmopro.org
- **UniFFI Guide**: https://mozilla.github.io/uniffi-rs
- **Flutter Plugin Development**: https://docs.flutter.dev/packages-and-plugins

---

## 💡 **Key Learnings from Our Integrations**

Based on our successful integration of Keccak256, SHA256, Blake2s256, MiMC256, Pedersen, and Poseidon circuits:

### **Architecture Patterns**
- **Separate State Management**: Each circuit needs independent state variables
- **Color-Coded UI**: Visual distinction helps with multi-circuit interfaces  
- **Consistent Input Formats**: Standardize on byte arrays vs field elements
- **Asset Naming**: Use descriptive names for .zkey files (e.g., `mimc256.zkey`)

### **Technical Insights**
- **Batch Size**: Refers to benchmark iterations, not input processing
- **Memory Management**: Large .zkey files require careful mobile optimization
- **Error Handling**: Robust error handling prevents app crashes
- **Performance**: Proof generation times vary significantly between circuits

### **Integration Success Factors**
- **Incremental Development**: Start with one circuit, then add others
- **Comprehensive Testing**: Test both proof generation and verification
- **Visual Feedback**: Clear UI indicators for success/failure states
- **Documentation**: Maintain detailed integration notes for future reference

This guide represents the culmination of our successful multi-circuit MoPro integration experience and provides a roadmap for future circuit integrations.
