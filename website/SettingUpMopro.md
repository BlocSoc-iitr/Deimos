Getting started
This tutorial walks you through building a static library from scratch using the Circom, Halo2, or Noir adapter, and demonstrates how to integrate it with Android, iOS, and Web platforms. It also shows how to create example templates for mobile development.

If you already have an existing Rust project and want to generate bindings for a mobile native SDK or to build a mobile native app, check out the Rust Setup guide for detailed instructions.

If you already have an existing mobile frontend, you only need to follow Steps #0 - #3 to generate the bindings, then proceed to the relevant integration guide below:

iOS Setup
Android Setup
React Native Setup
Flutter Setup
0. Prerequisites
Make sure you've installed the prerequisites.

1. Install CLI
Get published CLI
cargo install mopro-cli

note
Or get the latest CLI on GitHub
git clone https://github.com/zkmopro/mopro
cd mopro/cli
cargo install --path .

You can run

mopro --help

to see a full list of commands and their usage details with, for example,

mopro init --help

2. Initialize adapters
Navigate to the folder where you want to build the app. Select the adapters using the mopro CLI.

mopro init

note
The following prompt will appear:

$ mopro init
✔ Project name · mopro-example-app
? Pick the adapters you want (multiple selection with space)
⬚ circom
⬚ halo2
⬚ noir
⬚ none of above
🚀 Project 'mopro-example-app' initialized successfully! 🎉

Navigate to your project directory. (e.g. cd mopro-example-app)

cd mopro-example-app

3. Build bindings
Follow the steps below to build example circuits (e.g., Circom: multiplier2, Halo2: fibonacci, Noir: multiplier2).
If you have your own circuit, skip ahead to

5. Update Circuits to learn how to integrate it
or visit Rust setup section to learn how to customize and expose functions.
Build bindings for specific targets (iOS, Android, Web).

mopro build

note
The following prompt will appear:

$ mopro build
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
⬚ aarch64-linux-android

info
See more details about the architectures in Architectures Section

warning
The process of building bindings may take a few minutes.

info
Running your project in release mode significantly enhances performance compared to debug mode. This is because the Rust compiler applies optimizations that improve runtime speed and reduce binary size, making your application more efficient.

4. Create templates
Create templates for developing your mobile app.

mopro create

note
The following prompt will appear:

$ mopro create
? Create template ›
  ios
  android
  web
  flutter
  react-native

Only one template can be selected at a time. To build for additional frameworks, run mopro create again.

Follow the instructions to open the development tools

For iOS
open ios/MoproApp.xcodeproj

For Android
open android -a Android\ Studio

For Web
cd web && yarn && yarn start

For React Native
cd react-native && npm install

note
Setup the ANDROID_HOME environment for Android

export ANDROID_HOME=~/Library/Android/sdk

npm run ios # for iOS simulator
npm run ios:device # for iOS device
npm run android # for Android emulator/devices

info
See more details in react-native-app

For Flutter
Make sure Flutter is installed on your system.

flutter doctor

flutter pub get

Connect devices or turn on simulators before running

flutter run

info
See more details in flutter-app

5. Update circuits
For Circom Circuits
Ensure circom feature is activated in mopro-ffi
Follow the Circom documentation to generate the .wasm and .zkey files for your circuit.
Place the .wasm and .zkey files in the test-vectors/circom directory.
Generate the execution function using the rust_witness macro:
rust_witness::witness!(circuitname);
// ⚠️ The name should be the name of the wasm file all lowercase
// ⚠️ with all special characters removed
// ⚠️ Avoid using main as your circuit name, as it may cause conflicts during compilation and execution. Use a more descriptive and unique name instead.
//
// e.g.
// multiplier2 -> multiplier2
// keccak_256_256_main -> keccak256256main
// aadhaar-verifier -> aadhaarverifier
//


Bind the .zkey file to the witness generation function to enable proof generation. This ensures the circuit's proving key is correctly associated with its corresponding witness logic. Ensure that the witness function follows the naming convention circuitname_witness, as expected by the generated bindings and proof system:
mopro_ffi::set_circom_circuits! {
    ("circuitname.zkey", mopro_ffi::witness::WitnessFn::RustWitness(circuitname_witness))
}

Ensure the circuit input matches your circuit's expected format. Currently, only a flat (one-dimensional) JSON string mapping (String) is supported. For example:
"{
    \"a\": [\"3\"],
    \"b\": [\"5\"]
}"

For Halo2 Circuits
Ensure halo2 feature is activated in mopro-ffi

Build a Halo2 Rust crate with the example: plonkish-fibonacci-sample.
Expose the crate with the following public functions:

pub fn prove(
    srs_key_path: &str,
    proving_key_path: &str,
    input: HashMap<String, Vec<String>>,
) -> Result<GenerateProofResult, Box<dyn Error>>

pub fn verify(
    srs_key_path: &str,
    verifying_key_path: &str,
    proof: Vec<u8>,
    public_inputs: Vec<u8>,
) -> Result<bool, Box<dyn Error>>

Prepare the SRS, proving key, and verifying key files. Place the .bin files in the test-vectors/halo2 directory.

Bind the prove and verify functions with the corresponding proving and verifying keys.

mopro_ffi::set_halo2_circuits! {
    ("circuitname_pk.bin", rust_crate_name::prove, "circuitname_vk.bin", rust_crate_name::verify)
}

Ensure the circuit input matches your circuit's expected format. Currently, only a flat (one-dimensional) JSON string mapping (HashMap<String, Vec<String>>) is supported. For example:

{
    "a": ["3"],
    "b": ["5"]
}

For Noir Circuits
Ensure noir feature is activated in mopro-ffi
Follow the Noir documentation to generate the .json and the Downloading SRS to generate the .srs file.
Place the .json and .srs files in the test-vectors/noir directory.
Ensure the circuit input matches your circuit's expected format. Currently, only a flat (one-dimensional) string (Vec<String>) is supported. For example:
["3", "5"]

6. Update bindings
If you make changes to src/lib.rs—such as updating circuits or adding functions with #[uniffi::export]—and want to update the generated bindings across all platforms, simply run:

mopro build
mopro update

This will automatically detect and update the corresponding bindings in each platform template you've set up. If your mobile project lives elsewhere, provide explicit paths:

mopro update --src ./my_bindings --dest ../MyMobileApp

7. What's next
Update your ZK circuits as needed. After making changes, be sure to run:

mopro build
mopro update

This ensures the bindings are regenerated and reflect your latest updates.

Build your mobile app frontend according to your business logic and user flow.

Expose additional Rust functionality: If a function is missing in Swift, Kotlin, React Native, or Flutter, you can:

Add the required Rust crate in Cargo.toml
Annotate your function with #[uniffi::export] (See the Rust setup guide for details).
Once exported, the function will be available across all supported platforms.
warning
When using React Native or Flutter, don’t forget to update the module’s API definitions to ensure the framework can access the new Swift/Kotlin bindings.
See more details in react-native-app or flutter-app