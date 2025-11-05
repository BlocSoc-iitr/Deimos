'use client';

export default function NoirIntegration() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Noir Circuit Integration Guide for MoPro</h1>
      
      <p className="mb-8 text-lg text-gray-700">
        This guide explains how to integrate Noir circuits into the app for mobile zero-knowledge proof benchmarking.
      </p>

      <section id="prerequisites" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Prerequisites</h2>
        <ul className="list-disc ml-6 mb-4">
          <li>A Noir circuit compiled for noirc v1.0.0-beta.8 (see Compiler compatibility below)</li>
          <li>MoPro CLI installed (<code>cargo install --path mopro/cli</code>)</li>
          <li>Android Studio (for Android development) or a USB cable to test with an actual mobile</li>
          <li>The circuit artifacts: the compiled circuit JSON (<code>.json</code>) and the SRS/proving parameters (<code>.srs</code>). Optionally a verification key file (<code>.vk</code>) if you plan to use local VK instead of fetching it from the network.</li>
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
          <li><strong>Asset Management:</strong> Circuit files (<code>.json</code>, <code>.srs</code>, and optional <code>.vk</code>) bundled with apps</li>
        </ul>
      </section>

      <section id="step-by-step-integration" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Step-by-Step Integration</h2>
        <p className="mb-4">
          Noir integration in MoPro is lightweight: copy the compiled circuit artifacts to the Flutter assets, 
          add them to <code>pubspec.yaml</code>, and use the existing Noir flow in the UI (<code>flutter/lib/main.dart</code>) 
          which already has helper functions to load assets and call the MoPro plugin.
        </p>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 1: Build Your Noir Circuit for Compatibility</h3>
        <p className="mb-4">
          Ensure your Noir circuit is compiled with the required compiler version and target:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Required noirc version:</strong> <code>v1.0.0-beta.8</code></li>
        </ul>
        <p className="mb-4">
          If you have <code>rustup</code> and <code>cargo</code> installed, install or pin the <code>noirc</code> toolchain 
          as documented in the Noir docs. Verify your installation:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`noirc --version  # verify installed version is v1.0.0-beta.8`}
          </pre>
        </div>
        <p className="mb-4">
          Build the circuit to get the <code>.json</code> and <code>.srs</code> (and optionally <code>.vk</code>) files. Typical outputs are:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><code>my_circuit.json</code> - the compiled circuit description used by the mobile prover</li>
          <li><code>my_circuit.srs</code> - structured reference string / proving parameters</li>
          <li><code>my_circuit.vk</code> - optional verification key blob for local verification</li>
        </ul>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 2: Copy Artifacts into Flutter Assets</h3>
        <p className="mb-4">
          From your Noir build output folder, copy the <code>.json</code> and <code>.srs</code> files into the MoPro Flutter assets directory. 
          Optionally copy a <code>.vk</code> if you plan to use a local verification key.
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# From the repository root
cp path/to/my_circuit.json benchmarking-suite/moPro/mopro-example-app/flutter/assets/my_circuit.json
cp path/to/my_circuit.srs benchmarking-suite/moPro/mopro-example-app/flutter/assets/my_circuit.srs

# Optional local verification key
cp path/to/my_circuit.vk benchmarking-suite/moPro/mopro-example-app/flutter/assets/my_circuit.vk`}
          </pre>
        </div>
        <p className="mb-4 text-sm text-gray-600">
          <em>If you want the asset to use a standardized name (so the UI mapping picks it up), prefer names like <code>sha256.json</code>, 
          <code>sha256.srs</code>, <code>keccak256.json</code>, etc. — matching the algorithm labels used in the app.</em>
        </p>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 3: Update pubspec.yaml</h3>
        <p className="mb-4">
          Add your assets to the Flutter <code>pubspec.yaml</code> so they are bundled into the app:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`flutter:
  assets:
    - assets/sha256.json
    - assets/sha256.srs
    - assets/sha256.vk # optional

    # other Noir circuits
    - assets/keccak256.json
    - assets/keccak256.srs`}
          </pre>
        </div>
        <p className="mb-4">
          Run <code>flutter pub get</code> to ensure assets are recognized.
        </p>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 4: UI Integration (No Code Compile Required in Most Cases)</h3>
        <p className="mb-4">
          The <code>mopro-example-app</code> Flutter code already contains Noir-specific helper logic in <code>flutter/lib/main.dart</code>. 
          Key points to verify or adapt in the UI:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><code>_getNoirSettings()</code> selects the correct asset file names and attempts to load a <code>.vk</code> (verification key) from bundled assets; if missing, it falls back to asking the MoPro plugin to provide it at runtime.</li>
          <li><code>_textToNoirInput()</code> converts string input into a 32-byte padded byte array (as a list of decimal strings) expected by Noir circuits.</li>
          <li><code>_generateNoirProof()</code> and <code>_verifyNoirProof()</code> call the plugin methods <code>generateNoirProof</code> and <code>verifyNoirProof</code> with the parameters returned by <code>_getNoirSettings()</code>.</li>
        </ul>
        <p className="mb-4">
          You usually don&apos;t need to change the UI beyond adding your algorithm name to the algorithm selection mapping in 
          <code>_getAlgorithmsForFramework()</code> if you want it to appear in the selection UI.
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`case 'noir':
  return ['SHA256', 'Keccak256', 'Poseidon', 'MiMC', 'Pedersen'];`}
          </pre>
        </div>
        <p className="mb-4">
          If you add new algorithm names, update <code>_getNoirSettings()</code> with a case that returns the 
          <code>(assetPath, srsPath, onChain, verificationKey)</code> tuple for that algorithm.
        </p>

        <h3 className="text-xl font-bold mb-2 mt-6">Step 5: Build & Run the App</h3>
        <p className="mb-4">
          From the <code>mopro-example-app</code> directory:
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`cd benchmarking-suite/moPro/mopro-example-app/flutter
flutter pub get
flutter run`}
          </pre>
        </div>
        <p className="mb-4">
          On first runs, the app will attempt to load <code>.vk</code> files from assets. If they aren&apos;t present, 
          the app will call the MoPro plugin to fetch the verification key (this behavior is implemented in <code>_getNoirSettings()</code> in <code>main.dart</code>).
        </p>
      </section>

      <section id="troubleshooting" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Troubleshooting Common Issues</h2>
        
        <h3 className="text-xl font-bold mb-2">Issue: App Can&apos;t Find Assets at Runtime</h3>
        <p className="mb-4">
          <strong>Solution:</strong>
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Verify <code>pubspec.yaml</code> contains the asset entries and <code>flutter pub get</code> ran successfully.</li>
          <li>Confirm the asset file names match those referenced in <code>_getNoirSettings()</code>.</li>
        </ul>

        <h3 className="text-xl font-bold mb-2 mt-6">Issue: Proof Generation Fails</h3>
        <p className="mb-4">
          <strong>Solution:</strong>
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Check input format — Noir circuits will expect fields in the format you compiled the circuit for. The default helper in <code>main.dart</code> pads to 32 bytes.</li>
          <li>Check the Noir compiler version — mismatch between the circuit&apos;s expected runtime and the mobile plugin can cause errors. Recompile the circuit with <code>noirc v1.0.0-beta.8</code>.</li>
        </ul>
      </section>

      <section id="compiler-compatibility" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Noir Compiler Compatibility (v1.0.0-beta.8)</h2>
        <p className="mb-4">
          To ensure circuits compile correctly for the MoPro mobile runtime, compile using <code>noirc v1.0.0-beta.8</code>:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Verify your local <code>noirc</code> matches the version: <code>noirc --version</code> (should report <code>v1.0.0-beta.8</code>)</li>
          <li>Recompile your circuits with the exact toolchain and export the <code>.json</code> and <code>.srs</code> artifacts.</li>
          <li>If you encounter ABI or format errors, re-check the Noir release notes between your installed version and the required version for changes to output formats.</li>
        </ul>
      </section>

      <section id="qa-checklist" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Quick QA Checklist</h2>
        <ul className="list-disc ml-6 mb-4">
          <li><code>.json</code> and <code>.srs</code> are copied into <code>benchmarking-suite/moPro/mopro-example-app/flutter/assets</code></li>
          <li><code>pubspec.yaml</code> includes the new assets and <code>flutter pub get</code> completes</li>
          <li>UI algorithm list includes the new Noir circuit name (if you want it selectable)</li>
          <li><code>_getNoirSettings()</code> returns the right paths for the algorithm</li>
          <li>Running the app can generate and verify a proof for the circuit on device/emulator</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">References</h2>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>MoPro Documentation:</strong> <a href="https://zkmopro.org" className="text-blue-600 hover:underline" target="_blank" rel="noopener noreferrer">https://zkmopro.org</a></li>
          <li><strong>Noir (noirc) Releases and Docs:</strong> <a href="https://noir-lang.org" className="text-blue-600 hover:underline" target="_blank" rel="noopener noreferrer">https://noir-lang.org</a></li>
        </ul>
      </section>
    </div>
  );
}
