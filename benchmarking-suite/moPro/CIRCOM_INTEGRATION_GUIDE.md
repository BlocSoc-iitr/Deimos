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

The integration process for adding new Circom circuits to MoPro is straightforward. The Flutter app uses a dynamic selection-based UI, so you only need to register your circuit in a few places:

### Step 1: Setup Rust Witness and Circuits (`mopro-example-app/src/lib.rs`)

#### Step 1a: Add Rust Witness Macro

Add your circuit's witness generation to the existing `lib.rs` file:

```rust
// In mopro-example-app/src/lib.rs
rust_witness::witness!(blake2s256);
rust_witness::witness!(keccak);
rust_witness::witness!(mimc256);
rust_witness::witness!(pedersen);
rust_witness::witness!(poseidon);
rust_witness::witness!(sha256);
rust_witness::witness!(your_circuit_name);  // <- Add your new circuit here
```

#### Step 1b: Register Circuit in `set_circom_circuits!` Macro

Register your circuit in the `set_circom_circuits!` macro:

```rust
set_circom_circuits! {
    ("blake2s256.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s256_witness)),
    ("keccak.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak_witness)),
    ("mimc256.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc256_witness)),
    ("pedersen.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen_witness)),
    ("poseidon.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon_witness)),
    ("sha256.zkey", circom_prover::witness::WitnessFn::RustWitness(sha256_witness)),
    ("your_circuit.zkey", circom_prover::witness::WitnessFn::RustWitness(your_circuit_name_witness)),  // <- Add your circuit
}
```

**Important:** The `.zkey` filename in the macro must match the filename you'll use in the Flutter assets directory.

### Step 2: Build and Update MoPro Bindings

```bash
# Navigate to the mopro-example-app directory
cd benchmarking-suite/moPro/mopro-example-app

# Build the Rust library and update bindings
mopro build
mopro update
```

This regenerates the Flutter/Android/iOS bindings with your new circuit support.

### Step 3: Copy .zkey File to Flutter Assets

Copy your circuit's proving key to the Flutter assets directory:

```bash
# From the mopro-example-app directory
# Copy your .zkey file from the Circom build output
cp ../../frameworks/circom/circuits/your-circuit/your-circuit_0000.zkey flutter/assets/your-circuit.zkey
```

**Note:** The filename should match what you used in Step 1b (e.g., `your-circuit.zkey`).

### Step 4: Update `pubspec.yaml`

Add your new asset to the Flutter configuration:

```yaml
# flutter/pubspec.yaml
flutter:
  assets:
    # Existing assets
    - assets/blake2s256.zkey
    - assets/keccak.zkey
    - assets/mimc256.zkey
    - assets/pedersen.zkey
    - assets/poseidon.zkey
    - assets/sha256.zkey
    
    # Add your new circuit asset
    - assets/your-circuit.zkey
```

### Step 5: Add Algorithm to Flutter UI (`flutter/lib/main.dart`)

The Flutter app uses a dynamic selection system. You need to add your circuit in two places:

#### Step 5a: Add to Algorithm List

In the `_getAlgorithmsForFramework()` method, add your circuit name to the Circom list:

```dart
List<String> _getAlgorithmsForFramework(String framework) {
  switch (framework) {
    case 'circom':
      return [
        'SHA256', 
        'Keccak256', 
        'Blake2s256', 
        'MiMC256', 
        'Pedersen', 
        'Poseidon',
        'YourCircuitName'  // <- Add your circuit name here
      ];
    // ... other frameworks
  }
}
```

#### Step 5b: Add Zkey Path Mapping

In the `_getZkeyPath()` method, add a case for your circuit:

```dart
String _getZkeyPath() {
  switch (widget.algorithm.toLowerCase()) {
    case 'sha256':
      return "assets/sha256.zkey";
    case 'keccak256':
      return "assets/keccak.zkey";
    case 'blake2s256':
      return "assets/blake2s256.zkey";
    case 'mimc256':
      return "assets/mimc256.zkey";
    case 'pedersen':
      return "assets/pedersen.zkey";
    case 'poseidon':
      return "assets/poseidon.zkey";
    case 'yourcircuitname':  // <- Add your circuit (lowercase)
      return "assets/your-circuit.zkey";
    default:
      return "assets/sha256.zkey";
  }
}
```

**That's it!** The Flutter app will automatically:
- Show your circuit in the algorithm dropdown when "Circom" is selected
- Generate proofs using the MoPro plugin
- Verify proofs automatically
- Display benchmarking results

---

## 📱 **Flutter UI Integration**

### How the Flutter App Works

The Flutter app uses a **dynamic selection-based UI** that automatically handles all circuits. Users:

1. **Select Framework**: Choose "Circom" from the framework dropdown
2. **Select Circuit**: Choose your circuit from the algorithm dropdown (automatically populated from `_getAlgorithmsForFramework()`)
3. **Select Input**: Choose a predefined input from the input dropdown
4. **Run Benchmark**: Click "Run Benchmark" to generate and verify proofs

The app automatically:
- Generates proofs using `MoproFlutter().generateCircomProof()`
- Verifies proofs using `MoproFlutter().verifyCircomProof()`
- Displays proof details, timing, and benchmarking results
- Sends results to the backend API

### No Additional UI Code Required!

Unlike older integration patterns, **you don't need to write any UI code**. The app's `ProofResultPage` automatically handles:
- Proof generation with progress indicators
- Proof verification
- Benchmarking metrics (timing, memory, battery)
- Result display and backend submission

### Input Format

The app automatically converts selected inputs to the correct format for Circom circuits. Most hash circuits expect byte arrays:

```dart
// The app automatically formats inputs as:
{
  'in': ['72', '101', '108', ...]  // String array of byte values
}
```

For special cases (like Poseidon requiring exactly 8 bytes), the app handles padding/truncation automatically in `_getInputDataForAlgorithm()`.

### Key Points

- **Single MoPro Instance**: All circuits use the same `MoproFlutter()` instance
- **Dynamic Circuit Selection**: Circuit selection happens via the `.zkey` filename
- **Automatic Proof Handling**: The app handles proof generation, verification, and display automatically
- **Asset Paths**: Use relative paths like `"assets/your-circuit.zkey"` (not full file paths)

---

## 🔧 **Advanced Integration Patterns**

### Multi-Circuit Architecture

The current architecture supports multiple circuits through a unified interface:

```rust
// All circuit witnesses registered in lib.rs
rust_witness::witness!(blake2s256);
rust_witness::witness!(keccak);
rust_witness::witness!(mimc256);
rust_witness::witness!(pedersen);
rust_witness::witness!(poseidon);
rust_witness::witness!(sha256);
// Add more circuits as needed...

// All circuits registered with their .zkey files
set_circom_circuits! {
    ("blake2s256.zkey", circom_prover::witness::WitnessFn::RustWitness(blake2s256_witness)),
    ("keccak.zkey", circom_prover::witness::WitnessFn::RustWitness(keccak_witness)),
    ("mimc256.zkey", circom_prover::witness::WitnessFn::RustWitness(mimc256_witness)),
    ("pedersen.zkey", circom_prover::witness::WitnessFn::RustWitness(pedersen_witness)),
    ("poseidon.zkey", circom_prover::witness::WitnessFn::RustWitness(poseidon_witness)),
    ("sha256.zkey", circom_prover::witness::WitnessFn::RustWitness(sha256_witness)),
}
```

**Key Points:**
- **Single MoPro instance** handles all circuits through UniFFI bindings
- **Circuit selection** happens via the `.zkey` filename parameter
- **No separate projects** needed for each circuit
- **Flutter UI** automatically discovers circuits from the algorithm list

### Input Format Handling

The Flutter app automatically handles input formatting based on the circuit type. Most hash circuits expect byte arrays:

```dart
// Byte-based circuits (Keccak, SHA256, Blake2s, etc.)
// Input is automatically formatted as:
{
  'in': ['72', '101', '108', ...]  // String array of byte values
}
```

For special cases, the app handles formatting in `_getInputDataForAlgorithm()`:
- **Poseidon**: Automatically pads/truncates to exactly 8 bytes
- **Blake2/Blake3**: Automatically pads/truncates to exactly 32 bytes
- **Other circuits**: Uses full input array

### Automatic Benchmarking

The Flutter app automatically performs comprehensive benchmarking:

- **Proof Generation Time**: Measured during `generateCircomProof()`
- **Verification Time**: Measured during `verifyCircomProof()`
- **Memory Usage**: Tracks peak memory consumption during proof generation
- **Battery Consumption**: Monitors battery level before/after operations
- **Proof Size**: Calculates proof data size
- **Backend Submission**: Automatically sends results to the backend API

All metrics are displayed in the `ProofResultPage` and sent to the backend for analysis.

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
