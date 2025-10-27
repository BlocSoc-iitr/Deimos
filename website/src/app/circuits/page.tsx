'use client';

export default function Circuits() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Circuit Implementation Guide</h1>
      
      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Overview</h2>
        <p className="mb-4">
          This guide explains how to implement and add new cryptographic hash functions to the Circom benchmarking suite. 
          All circuits follow a consistent pattern for benchmarking purposes.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Circuit Pattern</h2>
        <p className="mb-4">
          All hash circuits in Deimos follow this standard pattern:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`pragma circom 2.0.0;

include "./hash_function.circom";

template HashBench(N) {
    signal input in[N];      // Input bytes
    signal output out[32];   // Hash output (32 bytes for 256-bit)
    
    component hash = HashFunctionBytes(N);
    hash.in <== in;
    out <== hash.out;
}

// Public input for verifiable computation benchmarking
component main {public[in]} = HashBench(32);`}
          </pre>
        </div>
        <p className="mb-4">
          Key points:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><code>{'{public[in]}'}</code> makes the input public for benchmarking</li>
          <li>Default input size is 32 bytes (can be adjusted)</li>
          <li>Output size depends on hash function (32 bytes for 256-bit hashes)</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Implemented Circuits</h2>
        
        <h3 className="text-xl font-bold mb-2">SHA-256</h3>
        <p className="mb-4">
          <strong>Location:</strong> <code>circuits/sha256/</code>
        </p>
        <p className="mb-4">
          <strong>Library:</strong> Built-in circomlib
        </p>
        <p className="mb-4">
          <strong>Bit Ordering:</strong> MSB-first (Big-Endian)
        </p>
        <p className="mb-4">
          <strong>Constraints:</strong> ~26,200 per chunk, ~410 per byte
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`template Sha256Bench(N) {
    signal input in[N];
    signal output out[32];
    
    component sha256 = Sha256Bytes(N);
    sha256.in <== in;
    out <== sha256.out;
}

component main {public[in]} = Sha256Bench(32);`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Keccak-256</h3>
        <p className="mb-4">
          <strong>Location:</strong> <code>circuits/keccak256/</code>
        </p>
        <p className="mb-4">
          <strong>Library:</strong> vocdoni/keccak256-circom
        </p>
        <p className="mb-4">
          <strong>Bit Ordering:</strong> LSB-first (Little-Endian)
        </p>
        <p className="mb-4">
          <strong>Constraints:</strong> ~147,000 per chunk, ~1,100 per byte
        </p>
        <p className="mb-4">
          Implementation follows the SHA256 pattern but uses Keccak component with LSB-first bit ordering:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Input: in[N*8] bits (N bytes converted to bits)</li>
          <li>Output: out[256] bits (32 bytes)</li>
          <li>Uses Keccak(N*8, 256) component from external library</li>
          <li>Bit-by-bit comparison for verification</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">BLAKE2s-256</h3>
        <p className="mb-4">
          <strong>Location:</strong> <code>circuits/blake2s256/</code>
        </p>
        <p className="mb-4">
          <strong>Library:</strong> hash-circuits by Faulhorn Labs
        </p>
        <p className="mb-4">
          <strong>Constraints:</strong> ~32,600 per chunk, ~509 per byte
        </p>

        <h3 className="text-xl font-bold mb-2">Poseidon</h3>
        <p className="mb-4">
          <strong>Location:</strong> <code>circuits/poseidon/</code>
        </p>
        <p className="mb-4">
          <strong>Library:</strong> circomlib and hash-circuits
        </p>
        <p className="mb-4">
          <strong>Constraints:</strong> ~250 per chunk, ~8 per byte
        </p>
        <p className="mb-4">
          ZK-friendly hash function optimized for arithmetic circuits. Significantly fewer constraints than traditional hashes.
        </p>

        <h3 className="text-xl font-bold mb-2">MiMC-256</h3>
        <p className="mb-4">
          <strong>Location:</strong> <code>circuits/mimc256/</code>
        </p>
        <p className="mb-4">
          <strong>Library:</strong> hash-circuits
        </p>
        <p className="mb-4">
          <strong>Constraints:</strong> ~330 per chunk, ~10.5 per byte
        </p>
        <p className="mb-4">
          Minimal multiplicative complexity hash function for ZK applications.
        </p>

        <h3 className="text-xl font-bold mb-2">Pedersen Hash</h3>
        <p className="mb-4">
          <strong>Location:</strong> <code>circuits/pedersen/</code>
        </p>
        <p className="mb-4">
          <strong>Library:</strong> circomlib
        </p>
        <p className="mb-4">
          Elliptic curve based hash function commonly used in ZK systems.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Adding New Hash Functions</h2>
        
        <h3 className="text-xl font-bold mb-2">Step 1: Create Directory Structure</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd benchmarking-suite/frameworks/circom

# Create directories for your hash function
mkdir -p circuits/your_hash
mkdir -p inputs/your_hash`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 2: Implement Core Circuit</h3>
        <p className="mb-4">
          Create <code>circuits/your_hash/your_hash.circom</code> with the wrapper that converts bytes to bits:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`pragma circom 2.1.2;

include "../circomlib/circuits/bitify.circom";

template YourHashBytes(n) {
  signal input in[n];
  signal output out[32]; // Adjust output size
  
  // Convert bytes to bits
  component byte_to_bits[n];
  for (var i = 0; i < n; i++) {
    byte_to_bits[i] = Num2Bits(8);
    byte_to_bits[i].in <== in[i];
  }
  
  // Call core hash circuit
  component hash = YourHashCircuit(n*8, 256);
  
  // IMPORTANT: Check bit ordering!
  // MSB-first (like SHA256): use [7-j]
  // LSB-first (like Keccak): use [j]
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < 8; j++) {
      hash.in[i*8+j] <== byte_to_bits[i].out[7-j]; // or [j]
    }
  }
  
  // Convert output bits back to bytes
  component bits_to_bytes[32];
  for (var i = 0; i < 32; i++) {
    bits_to_bytes[i] = Bits2Num(8);
    for (var j = 0; j < 8; j++) {
      bits_to_bytes[i].in[j] <== hash.out[i*8+j]; // or [7-j]
    }
    out[i] <== bits_to_bytes[i].out;
  }
}`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 3: Create Main Circuit</h3>
        <p className="mb-4">
          Create <code>circuits/your_hash/circom.circom</code>:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`pragma circom 2.0.0;

include "./your_hash.circom";

template YourHashBench(N) {
    signal input in[N];
    signal output out[32];
    
    component hash = YourHashBytes(N);
    hash.in <== in;
    out <== hash.out;
}

component main {public[in]} = YourHashBench(32);`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 4: Create Test Input</h3>
        <p className="mb-4">
          Create <code>inputs/your_hash/input_9.json</code>:
        </p>
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
        <p className="mb-4">
          This is "Hello World! This is a test msg." in decimal bytes.
        </p>

        <h3 className="text-xl font-bold mb-2">Step 5: Compile Circuit</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd circuits/your_hash

# Compile circuit
circom circom.circom --r1cs --wasm --sym --c

# Check constraint count
circom circom.circom --r1cs 2>&1 | grep "non-linear constraints"`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 6: Determine Powers of Tau</h3>
        <p className="mb-4">
          Based on your constraint count, choose the appropriate pot file:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>pot14 = 16,384 constraints</li>
          <li>pot16 = 65,536 constraints</li>
          <li>pot18 = 262,144 constraints</li>
          <li>pot20 = 1,048,576 constraints</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Step 7: Generate Proving Key</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`snarkjs groth16 setup \\
  circom.r1cs \\
  ../../phase1/pot18_final.ptau \\
  your_hash_0000.zkey

snarkjs zkey export verificationkey \\
  your_hash_0000.zkey \\
  verification_key.json`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 8: Test with Known Vector</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Generate proof
snarkjs groth16 fullprove \\
  ../../inputs/your_hash/input_9.json \\
  circom_js/circom.wasm \\
  your_hash_0000.zkey \\
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

        <h3 className="text-xl font-bold mb-2">Step 9: Verify Output Correctness</h3>
        <p className="mb-4">
          Compare the circuit output with the expected hash from a reference implementation. 
          Use Node.js crypto library or external tools to verify correctness.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Bit Ordering</h2>
        <p className="mb-4">
          One of the most critical aspects when implementing hash circuits is bit ordering. Different libraries 
          use different conventions.
        </p>
        
        <h3 className="text-xl font-bold mb-2">MSB-First (Big-Endian)</h3>
        <p className="mb-4">Used by: SHA-256, most standard cryptographic hashes</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// Byte 0x48 = 01001000
// MSB-first sends: 0,1,0,0,1,0,0,0
byte_to_bits[i].out[7-j]
bits_to_bytes[i].in[7-j]`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">LSB-First (Little-Endian)</h3>
        <p className="mb-4">Used by: Keccak-256, Ethereum-compatible implementations</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`// Byte 0x48 = 01001000
// LSB-first sends: 0,0,0,1,0,0,1,0
byte_to_bits[i].out[j]
bits_to_bytes[i].in[j]`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">How to Determine Bit Ordering</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Check library test files for bytesToBits() functions</li>
          <li>Look at test vectors and compare with known hash outputs</li>
          <li>Try both orderings and verify output</li>
          <li>Consult library documentation</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Common Issues</h2>
        
        <h3 className="text-xl font-bold mb-2">Too Many Values for Input Signal</h3>
        <p className="mb-4">
          <strong>Cause:</strong> Input JSON has fields that don't match circuit inputs.
        </p>
        <p className="mb-4">
          <strong>Fix:</strong> Circuit expects only 'in', remove any other fields like 'hash', 'N', etc.
        </p>

        <h3 className="text-xl font-bold mb-2">Assert Failed or Wrong Hash Output</h3>
        <p className="mb-4">
          <strong>Cause:</strong> Bit ordering mismatch.
        </p>
        <p className="mb-4">
          <strong>Fix:</strong> Try switching between MSB-first [7-j] and LSB-first [j] ordering.
        </p>

        <h3 className="text-xl font-bold mb-2">Not Enough Coefficients</h3>
        <p className="mb-4">
          <strong>Cause:</strong> Powers of Tau file is too small for your circuit.
        </p>
        <p className="mb-4">
          <strong>Fix:</strong> Use a larger pot file (pot14 → pot16 → pot18 → pot20).
        </p>

        <h3 className="text-xl font-bold mb-2">Library Import Errors</h3>
        <p className="mb-4">
          <strong>Cause:</strong> Incorrect import paths.
        </p>
        <p className="mb-4">
          <strong>Fix:</strong> Use relative paths to circomlib and other libraries. Check existing circuits for examples.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Circuit Verification Checklist</h2>
        <p className="mb-4">Before considering your circuit complete:</p>
        <ul className="list-disc ml-6 mb-4">
          <li>Circuit compiles without errors</li>
          <li>Test with all-zeros input matches known test vector</li>
          <li>Test with "Hello World" matches expected hash</li>
          <li>Proof generation succeeds</li>
          <li>Proof verification succeeds (OK!)</li>
          <li>Public inputs/outputs are correctly configured</li>
          <li>File sizes are reasonable (zkey, wasm)</li>
          <li>Bit ordering is correct</li>
          <li>Constraint count is documented</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Performance Optimization</h2>
        <p className="mb-4">
          The R1CS / arithmetic circuit format allows limited opportunities for optimization, but some strategies help:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Use ZK-friendly hash functions (Poseidon, MiMC) when possible - they have far fewer constraints</li>
          <li>Minimize bit conversions by working with native field elements when possible</li>
          <li>Reuse components instead of creating new instances</li>
          <li>Consider using lookup tables for repeated operations</li>
          <li>Profile constraint count per operation to identify bottlenecks</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Testing Strategy</h2>
        <p className="mb-4">Comprehensive testing is essential:</p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Zero Input Test:</strong> All zeros should produce known hash</li>
          <li><strong>Known Vector Test:</strong> "Hello World" or standard test strings</li>
          <li><strong>Edge Cases:</strong> Maximum input size, minimum input size</li>
          <li><strong>Random Inputs:</strong> Multiple random inputs to verify consistency</li>
          <li><strong>Cross-Verification:</strong> Compare with reference implementations</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Integration with MoPro</h2>
        <p className="mb-4">
          Once your circuit is verified, you can integrate it into MoPro for mobile benchmarking:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Copy the compiled circuit files to MoPro project</li>
          <li>Update Rust FFI bindings to include your circuit</li>
          <li>Run <code>mopro build</code> to generate mobile bindings</li>
          <li>Test on physical devices for accurate performance measurements</li>
          <li>Document benchmark results</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Resources</h2>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Circom Documentation:</strong> https://docs.circom.io</li>
          <li><strong>snarkjs Guide:</strong> https://github.com/iden3/snarkjs</li>
          <li><strong>circomlib Repository:</strong> https://github.com/iden3/circomlib</li>
          <li><strong>hash-circuits:</strong> Faulhorn Labs implementation reference</li>
          <li><strong>Powers of Tau:</strong> https://github.com/iden3/snarkjs#powers-of-tau</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Reference Implementations</h2>
        <p className="mb-4">Check existing implementations for guidance:</p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>SHA-256:</strong> <code>circuits/sha256/</code> - Standard MSB-first pattern</li>
          <li><strong>Keccak-256:</strong> <code>circuits/keccak256/</code> - LSB-first pattern with external library</li>
          <li><strong>Poseidon:</strong> <code>circuits/poseidon/</code> - ZK-friendly hash example</li>
        </ul>
      </section>
    </div>
  );
}
