# Noir Circuit Integration Guide for MoPro

This guide explains how to integrate Noir circuits into the app for mobile zero-knowledge proof benchmarking. 
---

## 📋 Prerequisites

- A Noir circuit compiled for noirc v1.0.0-beta.8 (see Compiler compatibility below)
- MoPro CLI installed (`cargo install --path mopro/cli`)
- Android Studio (for Android development) or a USB cable to test with an actual mobile
- The circuit artifacts: the compiled circuit JSON (`.json`) and the SRS/proving parameters (`.srs`). Optionally a verification key file (`.vk`) if you plan to use local VK instead of fetching it from the network.

---

## 🎯 Integration Overview

MoPro enables mobile zero-knowledge proof generation through:

1. Rust Core: Circuit integration and FFI exports
2. UniFFI Bindings: Type-safe mobile bindings generation
3. Mobile Apps: Flutter/Android/iOS applications with benchmarking UI
4. Asset Management: Circuit files (`.json`, `.srs`, and optional `.vk`) bundled with apps

---

## 🚀 Step-by-Step Integration

Noir integration in MoPro is lightweight: copy the compiled circuit artifacts to the Flutter assets, add them to `pubspec.yaml`, and use the existing Noir flow in the UI (`flutter/lib/main.dart`) which already has helper functions to load assets and call the MoPro plugin.

### Step 1: Build your Noir circuit for compatibility

Ensure your Noir circuit is compiled with the required compiler version and target:

- Required noirc version: `v1.0.0-beta.8`

If you have `rustup` and `cargo` installed, install or pin the `noirc` toolchain as documented in the Noir docs. A simple way to install the correct version is to use the official release (replace with the project's recommended install instruction if different):

```bash
noirc --version  # verify installed version is v1.0.0-beta.8
```

Build the circuit to get the `.json` and get the `.srs` (and optionally `.vk`) files. Typical outputs are:

- `my_circuit.json`  (the compiled circuit description used by the mobile prover)
- `my_circuit.srs`   (structured reference string / proving parameters)
- `my_circuit.vk`    (optional verification key blob for local verification)

---

### Step 2: Copy artifacts into Flutter assets

From your Noir build output folder, copy the `.json` and `.srs` files into the MoPro Flutter assets directory. Optionally copy a `.vk` if you plan to use a local verification key.

```bash
# From the repository root
cp path/to/my_circuit.json benchmarking-suite/moPro/mopro-example-app/flutter/assets/my_circuit.json
cp path/to/my_circuit.srs benchmarking-suite/moPro/mopro-example-app/flutter/assets/my_circuit.srs
# Optional local verification key
cp path/to/my_circuit.vk benchmarking-suite/moPro/mopro-example-app/flutter/assets/my_circuit.vk
```

If you want the asset to use a standardized name (so the UI mapping picks it up), prefer names like `sha256.json`, `sha256.srs`, `keccak256.json`, etc. — matching the algorithm labels used in the app.

---

### Step 3: Update `pubspec.yaml`

Add your assets to the Flutter `pubspec.yaml` so they are bundled into the app. Example additions:

```yaml
flutter:
  assets:
    - assets/sha256.json
    - assets/sha256.srs
    - assets/sha256.vk # optional

    # other Noir circuits
    - assets/keccak256.json
    - assets/keccak256.srs
```

Run `flutter pub get` to ensure assets are recognized.

---

### Step 4: UI integration (no code compile required in most cases)

The `mopro-example-app` Flutter code already contains Noir-specific helper logic in `flutter/lib/main.dart`. Key points to verify or adapt in the UI:

- `_getNoirSettings()` selects the correct asset file names and attempts to load a `.vk` (verification key) from bundled assets; if missing, it falls back to asking the MoPro plugin to provide it at runtime.
- `_textToNoirInput()` converts string input into a 32-byte padded byte array (as a list of decimal strings) expected by Noir circuits.
- `_generateNoirProof()` and `_verifyNoirProof()` call the plugin methods `generateNoirProof` and `verifyNoirProof` with the parameters returned by `_getNoirSettings()`.

You usually don't need to change the UI beyond adding your algorithm name to the algorithm selection mapping in `_getAlgorithmsForFramework()` if you want it to appear in the selection UI. For example if you add a `blake2s256` Noir circuit, make sure that when the user selects `framework == 'noir'` the `algorithm` string (e.g., `sha256`, `keccak256`, `poseidon`, `mimc`, `pedersen`) matches the switch cases in `_getNoirSettings()` or add a corresponding case.

Example: add to the list returned by `_getAlgorithmsForFramework('noir')` in `main.dart`:

```dart
case 'noir':
  return ['SHA256', 'Keccak256', 'Poseidon', 'MiMC', 'Pedersen'];
```

If you add new algorithm names, update `_getNoirSettings()` with a case that returns the `(assetPath, srsPath, onChain, verificationKey)` tuple for that algorithm. See `main.dart` for the exact pattern used by existing algorithms.

---

### Step 5: Build & Run the app

From the `mopro-example-app` directory:

```bash
cd benchmarking-suite/moPro/mopro-example-app/flutter
flutter pub get
flutter run 
```

On first runs, the app will attempt to load `.vk` files from assets. If they aren't present, the app will call the MoPro plugin to fetch the verification key (this behavior is implemented in `_getNoirSettings()` in `main.dart`).

---

## 🐛 Troubleshooting Common Issues

Issue: App can't find assets at runtime
- Verify `pubspec.yaml` contains the asset entries and `flutter pub get` ran successfully.
- Confirm the asset file names match those referenced in `_getNoirSettings()`.

Issue: Proof generation fails
- Check input format — Noir circuits will expect fields in the format you compiled the circuit for. The default helper in `main.dart` pads to 32 bytes.
- Check the Noir compiler version — mismatch between the circuit's expected runtime and the mobile plugin can cause errors. Recompile the circuit with `noirc v1.0.0-beta.8`.

---

## 🔐 Noir Compiler Compatibility (v1.0.0-beta.8)

To ensure circuits compile correctly for the MoPro mobile runtime, compile using `noirc v1.0.0-beta.8`:

- Verify your local `noirc` matches the version: `noirc --version` (should report `v1.0.0-beta.8`)
- Recompile your circuits with the exact toolchain and export the `.json` and `.srs` artifacts.
- If you encounter ABI or format errors, re-check the Noir release notes between your installed version and the required version for changes to output formats.

---

## ✅ Quick QA Checklist

- [ ] `.json` and `.srs` are copied into `benchmarking-suite/moPro/mopro-example-app/flutter/assets`
- [ ] `pubspec.yaml` includes the new assets and `flutter pub get` completes
- [ ] UI algorithm list includes the new Noir circuit name (if you want it selectable)
- [ ] `_getNoirSettings()` returns the right paths for the algorithm
- [ ] Running the app can generate and verify a proof for the circuit on device/emulator

---

## 📚 References

- MoPro documentation: https://zkmopro.org
- Noir (noirc) releases and docs

---