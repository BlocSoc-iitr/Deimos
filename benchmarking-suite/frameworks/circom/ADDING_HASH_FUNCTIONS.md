# Adding New Hash Functions to Circom Benchmarking Suite

This guide shows you how to add new cryptographic hash functions to the Circom benchmarking framework, following the pattern established with SHA256 and Keccak256.

---

## 📋 **Prerequisites**

- Circom compiler installed
- snarkjs installed
- Node.js installed
- Basic understanding of Circom circuits

---

## 🎯 **Quick Reference: Existing Implementations**

### SHA256
- **Location**: `circuits/sha256/`
- **Library**: Built-in circomlib (MSB-first bit ordering)
- **Pattern**: Public input → Public output

### Keccak256
- **Location**: `circuits/keccak256/`
- **Library**: vocdoni/keccak256-circom (LSB-first bit ordering)
- **Pattern**: Public input → Public output

---

## 🚀 **Step-by-Step Guide**

### Step 1: Choose Your Hash Function

Examples:
- **BLAKE2b** - Fast cryptographic hash
- **Poseidon** - ZK-friendly hash (already in circomlib)
- **MiMC** - Minimal multiplicative complexity
- **SHA3-512** - NIST standard (different from Keccak)

---

### Step 2: Create Directory Structure

```bash
# Set your hash function name
HASH_NAME="blake2b"  # Change this to your hash function

# Create directories
cd /Volumes/Senpai\'s\ SSD/Deimos/benchmarking-suite/frameworks/circom

mkdir -p circuits/${HASH_NAME}
mkdir -p inputs/${HASH_NAME}

echo "✅ Created directories for ${HASH_NAME}"
```

---

### Step 3: Find or Create the Core Circuit

#### Option A: Using Existing Library (Recommended)

**If the library exists in circomlib:**
```bash
# Check if it exists
ls circuits/circomlib/circuits/ | grep -i ${HASH_NAME}
```

**If you need to add an external library:**
```bash
cd circuits/circomlib/circuits/

# Example: Clone external library
git clone https://github.com/organization/hash-circom.git ${HASH_NAME}-lib

# Fix import paths if needed (see Keccak256 example)
# Edit the library files to use relative paths to circomlib
```

#### Option B: Implement from Scratch

Create `circuits/${HASH_NAME}/${HASH_NAME}.circom`:

```circom
pragma circom 2.1.2;

include "../circomlib/circuits/bitify.circom";

/**
 * Wrapper to support bytes as input instead of bits
 * @param  n   The number of input bytes
 * @input  in  The input bytes
 * @output out The hash output in bytes
 */
template HashNameBytes(n) {
  signal input in[n];
  signal output out[OUTPUT_SIZE]; // Change OUTPUT_SIZE (e.g., 32 for 256-bit)

  // Convert bytes to bits
  component byte_to_bits[n];
  for (var i = 0; i < n; i++) {
    byte_to_bits[i] = Num2Bits(8);
    byte_to_bits[i].in <== in[i];
  }

  // Call the core hash circuit
  component hash = YourHashCircuit(n*8, OUTPUT_SIZE*8);

  // IMPORTANT: Check bit ordering!
  // MSB-first (like SHA256): use [7-j]
  // LSB-first (like Keccak): use [j]
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < 8; j++) {
      hash.in[i*8+j] <== byte_to_bits[i].out[j]; // or [7-j]
    }
  }

  // Convert output bits back to bytes
  component bits_to_bytes[OUTPUT_SIZE];
  for (var i = 0; i < OUTPUT_SIZE; i++) {
    bits_to_bytes[i] = Bits2Num(8);
    for (var j = 0; j < 8; j++) {
      bits_to_bytes[i].in[j] <== hash.out[i*8+j]; // or [7-j]
    }
    out[i] <== bits_to_bytes[i].out;
  }
}
```

---

### Step 4: Create Main Circuit File

Create `circuits/${HASH_NAME}/circom.circom`:

```circom
pragma circom 2.0.0;

include "./${HASH_NAME}.circom";

template HashBench(N) {
    signal input in[N];
    signal output out[OUTPUT_SIZE]; // e.g., 32 for 256-bit, 64 for 512-bit

    component hash = HashNameBytes(N);
    hash.in <== in;
    out <== hash.out;
}

// Public input for verifiable computation benchmarking
component main {public[in]} = HashBench(32);
```

**Key Points:**
- `{public[in]}` makes the input public (for benchmarking)
- Change `32` to your desired input size
- Change `OUTPUT_SIZE` to match your hash output (32 bytes = 256 bits)

---

### Step 5: Create Test Input

Create `inputs/${HASH_NAME}/input_9.json`:

```json
{
    "in": [
        "72", "101", "108", "108", "111", "32", "87", "111",
        "114", "108", "100", "33", "32", "84", "104", "105",
        "115", "32", "105", "115", "32", "97", "32", "116",
        "101", "115", "116", "32", "109", "115", "103", "46"
    ]
}
```

This is "Hello World! This is a test msg." in decimal bytes.

---

### Step 6: Compile the Circuit

```bash
cd circuits/${HASH_NAME}

# Compile circuit
circom circom.circom --r1cs --wasm --sym --c

# Check output
echo "✅ Compilation complete!"
echo "Constraints: $(grep 'non-linear constraints' <(circom circom.circom --r1cs 2>&1))"
```

**Expected output:**
```
template instances: XXX
non-linear constraints: XXXXX
public inputs: 32  ← Should show your input size
private inputs: 0  ← Should be 0 for public benchmarking
public outputs: OUTPUT_SIZE
```

---

### Step 7: Determine Required Powers of Tau

```bash
# Calculate required pot size
CONSTRAINTS=$(grep -oP 'non-linear constraints: \K\d+' <(circom circom.circom --r1cs 2>&1))

# Find the next power of 2
python3 << EOF
import math
constraints = ${CONSTRAINTS}
pot = math.ceil(math.log2(constraints))
print(f"Constraints: {constraints}")
print(f"Required pot: {pot}")
print(f"Use: pot{pot}_final.ptau (or higher)")
EOF
```

**Common pot files:**
- pot14 = 16,384 constraints
- pot16 = 65,536 constraints
- pot18 = 262,144 constraints
- pot20 = 1,048,576 constraints

---

### Step 8: Generate Proving Key

```bash
# Choose appropriate pot file based on constraints
# For SHA256 (~29k): pot16
# For Keccak256 (~151k): pot18

POT_FILE="pot18_final.ptau"  # Adjust based on your circuit size

snarkjs groth16 setup \
  circom.r1cs \
  "../../phase1/${POT_FILE}" \
  ${HASH_NAME}_0000.zkey

echo "✅ Proving key generated!"
ls -lh ${HASH_NAME}_0000.zkey
```

---

### Step 9: Test with Known Test Vector

**Create test vector** `inputs/${HASH_NAME}/test_zeros.json`:
```json
{
    "in": [
        "0", "0", "0", "0", "0", "0", "0", "0",
        "0", "0", "0", "0", "0", "0", "0", "0",
        "0", "0", "0", "0", "0", "0", "0", "0",
        "0", "0", "0", "0", "0", "0", "0", "0"
    ]
}
```

**Generate proof:**
```bash
snarkjs groth16 fullprove \
  ../../inputs/${HASH_NAME}/test_zeros.json \
  circom_js/circom.wasm \
  ${HASH_NAME}_0000.zkey \
  proof_test.json \
  public_test.json

echo "✅ Proof generated!"
cat public_test.json
```

---

### Step 10: Verify Output is Correct

```bash
node << 'EOF'
const fs = require('fs');
const crypto = require('crypto');

// Read circuit output
const publicOutput = JSON.parse(fs.readFileSync('public_test.json', 'utf8'));
const circuitHash = publicOutput.slice(0, 32).map(x => parseInt(x)); // Adjust size

// Compute expected hash (example for Node.js built-in hashes)
const input = Buffer.alloc(32, 0); // All zeros
const expectedHash = crypto.createHash('sha256').update(input).digest(); // Change algorithm

console.log('Circuit output:', circuitHash.join(','));
console.log('Expected hash: ', Array.from(expectedHash).join(','));
console.log('Match:', circuitHash.every((v, i) => v === expectedHash[i]));
EOF
```

**Important:** For non-standard hashes (Keccak, Poseidon, etc.), you'll need to use appropriate libraries or test vectors.

---

### Step 11: Verify the Proof

```bash
# Export verification key
snarkjs zkey export verificationkey \
  ${HASH_NAME}_0000.zkey \
  verification_key.json

# Verify proof
snarkjs groth16 verify \
  verification_key.json \
  public_test.json \
  proof_test.json

# Should output: [INFO] snarkJS: OK!
```

---

### Step 12: Test with Real Input

```bash
# Test with your actual input
snarkjs groth16 fullprove \
  ../../inputs/${HASH_NAME}/input_9.json \
  circom_js/circom.wasm \
  ${HASH_NAME}_0000.zkey \
  proof.json \
  public.json

# Verify
snarkjs groth16 verify \
  verification_key.json \
  public.json \
  proof.json

echo "✅ Circuit is ready for benchmarking!"
```

---

## 🐛 **Troubleshooting Common Issues**

### Issue 1: "Too many values for input signal"

**Cause:** Input JSON has fields that don't match circuit inputs.

**Fix:**
```bash
# Circuit expects only 'in', remove any other fields like 'hash', 'N', etc.
# Correct format:
{
  "in": [1, 2, 3, ...]
}
```

### Issue 2: "Assert Failed" or Wrong Hash Output

**Cause:** Bit ordering mismatch.

**Fix:** Check your hash library's expected bit ordering:

```circom
// Try MSB-first (like SHA256):
hash.in[i*8+j] <== byte_to_bits[i].out[7-j];

// OR try LSB-first (like Keccak):
hash.in[i*8+j] <== byte_to_bits[i].out[j];
```

**Verification:** Check the library's test files to see how they convert bytes to bits.

### Issue 3: "Not enough coefficients"

**Cause:** pot file is too small for your circuit.

**Fix:**
```bash
# Use a larger pot file
# pot14 → pot16 → pot18 → pot20
```

### Issue 4: Library Import Errors

**Cause:** Incorrect import paths.

**Fix:**
```circom
// If library expects node_modules:
include "../node_modules/library/circuits/file.circom";

// Change to:
include "../../library-name/circuits/file.circom";
```

---

## 📊 **Bit Ordering Reference**

### How to Determine Bit Ordering

1. **Check library test files** - Look for `bytesToBits()` or similar functions
2. **Look at test vectors** - Compare with known hash outputs
3. **Try both orderings** - Test and verify output

### Common Patterns

**MSB-First (Big-Endian):**
- SHA256 (circomlib)
- Most standard cryptographic hashes

```circom
// Byte 0x48 = 01001000
// MSB-first sends: 0,1,0,0,1,0,0,0
byte_to_bits[i].out[7-j]
bits_to_bytes[i].in[7-j]
```

**LSB-First (Little-Endian):**
- Keccak256 (vocdoni)
- Ethereum-compatible implementations

```circom
// Byte 0x48 = 01001000
// LSB-first sends: 0,0,0,1,0,0,1,0
byte_to_bits[i].out[j]
bits_to_bytes[i].in[j]
```

---

## 🔍 **Verification Checklist**

Before considering your circuit complete:

- [ ] Circuit compiles without errors
- [ ] Test with all-zeros input matches known test vector
- [ ] Test with "Hello World" matches expected hash
- [ ] Proof generation succeeds
- [ ] Proof verification succeeds (`OK!`)
- [ ] Public inputs/outputs are correctly configured
- [ ] File sizes are reasonable (zkey, wasm)
- [ ] Bit ordering is correct

---

## 📁 **Final Directory Structure**

```
benchmarking-suite/frameworks/circom/
├── circuits/
│   ├── sha256/           (reference implementation)
│   ├── keccak256/        (reference implementation)
│   ├── YOUR_HASH/
│   │   ├── circom.circom          # Main circuit
│   │   ├── YOUR_HASH.circom       # Wrapper circuit
│   │   ├── circom.r1cs            # Compiled constraints
│   │   ├── circom.sym             # Symbols
│   │   ├── circom_js/
│   │   │   └── circom.wasm        # Witness generator
│   │   ├── circom_cpp/            # C++ witness generator
│   │   ├── YOUR_HASH_0000.zkey    # Proving key
│   │   ├── verification_key.json  # Verification key
│   │   ├── proof.json             # Example proof
│   │   └── public.json            # Example public outputs
│   └── circomlib/
│       └── circuits/
│           └── YOUR_HASH-lib/     # External library (if needed)
├── inputs/
│   └── YOUR_HASH/
│       ├── input_9.json           # Test input
│       └── test_zeros.json        # Zero test vector
└── phase1/
    └── potXX_final.ptau           # Powers of tau
```

---

## 🎯 **Quick Copy-Paste Script**

Save this as `add_hash.sh`:

```bash
#!/bin/bash

# Configuration
HASH_NAME="$1"
INPUT_SIZE="${2:-32}"        # Default 32 bytes
OUTPUT_SIZE="${3:-32}"       # Default 32 bytes (256 bits)
POT_FILE="${4:-pot18_final.ptau}"

if [ -z "$HASH_NAME" ]; then
  echo "Usage: ./add_hash.sh <hash_name> [input_size] [output_size] [pot_file]"
  echo "Example: ./add_hash.sh blake2b 32 64 pot18_final.ptau"
  exit 1
fi

BASE_DIR="/Volumes/Senpai's SSD/Deimos/benchmarking-suite/frameworks/circom"
cd "$BASE_DIR"

echo "📦 Setting up $HASH_NAME circuit..."

# Step 1: Create directories
mkdir -p "circuits/${HASH_NAME}"
mkdir -p "inputs/${HASH_NAME}"

# Step 2: Create main circuit
cat > "circuits/${HASH_NAME}/circom.circom" << EOF
pragma circom 2.0.0;

include "./${HASH_NAME}.circom";

template ${HASH_NAME^}Bench(N) {
    signal input in[N];
    signal output out[${OUTPUT_SIZE}];

    component hash = ${HASH_NAME^}Bytes(N);
    hash.in <== in;
    out <== hash.out;
}

component main {public[in]} = ${HASH_NAME^}Bench(${INPUT_SIZE});
EOF

# Step 3: Create test input
cat > "inputs/${HASH_NAME}/input_9.json" << 'EOF'
{
    "in": [
        "72", "101", "108", "108", "111", "32", "87", "111",
        "114", "108", "100", "33", "32", "84", "104", "105",
        "115", "32", "105", "115", "32", "97", "32", "116",
        "101", "115", "116", "32", "109", "115", "103", "46"
    ]
}
EOF

# Step 4: Create zeros test
python3 << EOF
import json
zeros = {"in": ["0"] * ${INPUT_SIZE}}
with open("inputs/${HASH_NAME}/test_zeros.json", "w") as f:
    json.dump(zeros, f, indent=4)
EOF

echo "✅ Created directory structure"
echo "📝 Next steps:"
echo "   1. Implement circuits/${HASH_NAME}/${HASH_NAME}.circom"
echo "   2. cd circuits/${HASH_NAME}"
echo "   3. circom circom.circom --r1cs --wasm --sym --c"
echo "   4. snarkjs groth16 setup circom.r1cs ../../phase1/${POT_FILE} ${HASH_NAME}_0000.zkey"
echo "   5. snarkjs groth16 fullprove ../../inputs/${HASH_NAME}/input_9.json circom_js/circom.wasm ${HASH_NAME}_0000.zkey proof.json public.json"
```

**Usage:**
```bash
chmod +x add_hash.sh
./add_hash.sh blake2b 32 64 pot18_final.ptau
```

---

## 🚀 **Ready for MoPro Integration**

Once your circuit is verified, you can integrate it into MoPro for mobile benchmarking:


---

## 📚 **Additional Resources**

- **Circom Documentation**: https://docs.circom.io
- **snarkjs Guide**: https://github.com/iden3/snarkjs
- **circomlib Repository**: https://github.com/iden3/circomlib
- **Powers of Tau**: https://github.com/iden3/snarkjs#powers-of-tau

---

**Questions or Issues?**

Check the existing implementations:
- SHA256: `/circuits/sha256/` - Standard MSB-first pattern
- Keccak256: `/circuits/keccak256/` - LSB-first pattern with external library

