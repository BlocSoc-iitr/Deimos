'use client';

export default function Circuits() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Circuit Implementation Guide</h1>
      
      <section id="overview" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Overview</h2>
        <p className="mb-4">
          This guide explains how to implement and add new cryptographic hash functions to the Circom benchmarking suite. 
          All circuits follow a consistent pattern for benchmarking purposes.
        </p>
      </section>

      <section id="circuit-pattern" className="mb-12">
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

component main {public[in]} = HashBench(32);`}
          </pre>
        </div>
        <p className="mb-4">
          Key points:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><code>{'{public[in]}'}</code> makes the input public</li>
          <li>Default input size is N bytes</li>
          <li>Output size is typically 32 bytes</li>
        </ul>
      </section>

      <section id="implemented-circuits" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Implemented Circuits</h2>
        
        <h3 id="sha-256" className="text-xl font-bold mb-2">SHA-256</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Location:</strong> <code>circuits/sha256/</code></li>
          <li><strong>Library:</strong> Built-in circomlib</li>
          <li><strong>Constraints:</strong>
            <ul className="list-disc ml-6 mt-2">
              <li>Non-linear: 29,668</li>
              <li>Linear: 1,916</li>
            </ul>
          </li>
        </ul>


        <h3 id="keccak-256" className="text-xl font-bold mb-2">Keccak-256</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Location:</strong> <code>circuits/keccak256/</code></li>
          <li><strong>Library:</strong> vocdoni/keccak256-circom</li>
          <li><strong>Constraints:</strong>
            <ul className="list-disc ml-6 mt-2">
              <li>Non-linear: 152,832</li>
              <li>Linear: 86,664</li>
            </ul>
          </li>
        </ul>

        <h3 id="blake2s-256" className="text-xl font-bold mb-2">BLAKE2s-256</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Location:</strong> <code>circuits/blake2s256/</code></li>
          <li><strong>Library:</strong> hash-circuits by Faulhorn Labs</li>
          <li><strong>Constraints:</strong>
            <ul className="list-disc ml-6 mt-2">
              <li>Non-linear: 32,832</li>
              <li>Linear: 1,719</li>
            </ul>
          </li>
        </ul>

        <h3 id="poseidon" className="text-xl font-bold mb-2">Poseidon</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Location:</strong> <code>circuits/poseidon/</code></li>
          <li><strong>Library:</strong> circomlib and hash-circuits</li>
          <li><strong>Constraints:</strong>
            <ul className="list-disc ml-6 mt-2">
              <li>Non-linear: 405</li>
              <li>Linear: 766</li>
            </ul>
          </li>
          <li><strong>Note:</strong> ZK-friendly hash function optimized for arithmetic circuits. Significantly fewer constraints than traditional hashes.</li>
        </ul>

        <h3 id="mimc-256" className="text-xl font-bold mb-2">MiMC-256</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Location:</strong> <code>circuits/mimc256/</code></li>
          <li><strong>Library:</strong> hash-circuits</li>
          <li><strong>Constraints:</strong>
            <ul className="list-disc ml-6 mt-2">
              <li>Non-linear: 11,904</li>
              <li>Linear: 65</li>
            </ul>
          </li>
          <li><strong>Note:</strong> Minimal multiplicative complexity hash function for ZK applications.</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Pedersen Hash</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Location:</strong> <code>circuits/pedersen/</code></li>
          <li><strong>Library:</strong> circomlib</li>
          <li><strong>Constraints:</strong>
            <ul className="list-disc ml-6 mt-2">
              <li>Non-linear: 383</li>
              <li>Linear: 18</li>
            </ul>
          </li>
          <li><strong>Note:</strong> Elliptic curve based hash function commonly used in ZK systems.</li>
        </ul>
      </section>

      <section id="adding-new-hash-functions" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Adding New Hash Functions</h2>
        
        <h3 className="text-xl font-bold mb-2">Step 1: Create Directory Structure</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd benchmarking-suite/frameworks/circom

# Create directory for your circuit
mkdir -p circuits/your_hash

# Create input for your circuit
mkdir -p inputs/your_hash 
touch inputs/your_hash/input_9.json`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 2: Create Test Input</h3>
        <p className="mb-4">
          Create <code>inputs/your_hash/input_9.json</code> with your test data:
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
        <p className="mb-4 text-sm text-gray-600">
          <em>This is &quot;Hello World! This is a test msg.&quot; in decimal bytes.</em>
        </p>

        <h3 className="text-xl font-bold mb-2">Step 3: Create Circuit</h3>
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

        <h3 className="text-xl font-bold mb-2">Step 4: Compile Circuit</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd circuits/your_hash

# Compile circuit
circom circom.circom --r1cs --wasm --sym --c`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 5: Compute Witness</h3>
        <p className="mb-4">
          Copy your <code>input_9.json</code> to the appropriate directory based on your chosen method:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>For WebAssembly: <code>circuits/your_hash/circom_js/</code></li>
          <li>For C++: <code>circuits/your_hash/circom_cpp/</code></li>
        </ul>

        <p className="mb-2"><strong>Option 1: Computing Witness with WebAssembly</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd circom_js

node generate_witness.js circom.wasm input_9.json witness.wtns`}
          </pre>
        </div>

        <p className="mb-2"><strong>Option 2: Computing Witness with C++</strong></p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd circom_cpp

make
./circom input_9.json witness.wtns`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 6: Generate Proving Keys</h3>
        <p className="mb-4">
          Choose the appropriate Powers of Tau file based on your circuit&apos;s constraint count:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>pot14</strong> = 16,384 constraints</li>
          <li><strong>pot16</strong> = 65,536 constraints</li>
          <li><strong>pot18</strong> = 262,144 constraints</li>
          <li><strong>pot20</strong> = 1,048,576 constraints</li>
        </ul>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Start Powers of Tau ceremony (if not already done)
snarkjs powersoftau new bn128 18 pot18_0000.ptau -v
snarkjs powersoftau contribute pot18_0000.ptau pot18_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot18_0001.ptau pot18_final.ptau -v

# Generate circuit-specific keys
snarkjs groth16 setup circom.r1cs ../../phase1/pot18_final.ptau your_hash_0000.zkey
snarkjs zkey contribute your_hash_0000.zkey your_hash_0001.zkey --name="1st Contributor" -v
snarkjs zkey export verificationkey your_hash_0001.zkey verification_key.json`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 7: Generate and Verify Proof</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Generate proof
snarkjs groth16 prove your_hash_0001.zkey circom_js/witness.wtns proof.json public.json

# Verify proof
snarkjs groth16 verify verification_key.json public.json proof.json

# Expected output: [INFO] snarkJS: OK!`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">Step 8: Document Your Circuit</h3>
        <p className="mb-4">
          Add your circuit to the documentation with the following information:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Circuit name and location</li>
          <li>Library/source used</li>
          <li>Constraint counts (non-linear and linear)</li>
          <li>Any special considerations or notes</li>
        </ul>

      </section>

      <section id="common-issues" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Common Issues</h2>
        
        <h3 className="text-xl font-bold mb-2">Too Many Values for Input Signal</h3>
        <p className="mb-4">
          <strong>Cause:</strong> Input JSON has fields that don&apos;t match circuit inputs.
        </p>
        <p className="mb-4">
          <strong>Fix:</strong> Circuit expects only &apos;in&apos;, remove any other fields like &apos;hash&apos;, &apos;N&apos;, etc.
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

      <section id="circuit-verification-checklist" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Circuit Verification Checklist</h2>
        <p className="mb-4">Before considering your circuit complete:</p>
        <ul className="list-disc ml-6 mb-4">
          <li>Circuit compiles without errors</li>
          <li>Proof generation succeeds</li>
          <li>Proof verification succeeds</li>
          <li>Public inputs/outputs are correctly configured</li>
          <li>Constraint count is documented</li>
        </ul>
      </section>

      <section id="performance-optimization" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Performance Optimization</h2>
        <p className="mb-4">
          The R1CS / arithmetic circuit format allows limited opportunities for optimization, but some strategies help:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Use ZK-friendly hash functions (Poseidon, MiMC) when possible - they have far fewer constraints</li>
          <li>Reuse components instead of creating new instances</li>
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
