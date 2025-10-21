# Cross-Platform Mobile ZKPs

Flutter is a popular cross-platform mobile app development framework. Mopro Flutter shows an example of integrating ZK-proving into a Flutter app, allowing for streamlined creation of ZK-enabled mobile apps.

> [!IMPORTANT]
> Please refer to the latest [mopro documentation](https://zkmopro.org/docs/next/setup/flutter-setup) for the most up-to-date information.

## Running The Example App

### Prerequisites

1. **Install Flutter**

    If Flutter is not already installed, you can follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install) for your operating system.

2. **Check Flutter Environment**

    After installing Flutter, verify that your development environment is properly set up by running the following command in your terminal:

    ```bash
    flutter doctor
    ```

    This command will identify any missing dependencies or required configurations.

3. **Install Flutter Dependencies**

    Navigate to the root directory of the project in your terminal and run:

    ```bash
    flutter pub get
    ```

    This will install the necessary dependencies for the project.

### Running the App via VS Code

1. Open the project in VS Code.
2. Open the "Run and Debug" panel.
3. Start an emulator (iOS/Android) or connect your physical device.
4. Select "example" in the run menu and press "Run".

### Running the App via Console

If you prefer using the terminal to run the app, use the following steps:

1. For Android:

    Ensure you have an Android emulator running or a device connected. Then run:

    ```bash
    flutter run
    ```

2. For iOS:

    Make sure you have an iOS simulator running or a device connected. Then run:

    ```bash
    flutter run
    ```

## Integrating Your ZKP

The example app comes with a simple prover generated from a Circom circuit. To integrate your own prover, follow the steps below.

### Setup

Follow the [Rust Setup steps from the MoPro official docs](https://zkmopro.org/docs/setup/rust-setup) to generate the platform-specific libraries.

### Copying The Generated Libraries

#### iOS

1. Replace `mopro.swift` at [`mopro_flutter_plugin/ios/Classes/mopro.swift`](mopro_flutter_plugin/ios/Classes/mopro.swift) with the file generated during the [Setup](#setup).
2. Replace the directory [`mopro_flutter_plugin/ios/MoproBindings.xcframework`](mopro_flutter_plugin/ios/MoproBindings.xcframework) with the one generated during the [Setup](#setup).
3. Then define the native module API in [`mopro_flutter_plugin/ios/Classes/MoproFlutterPlugin.swift`](mopro_flutter_plugin/ios/Classes/MoproFlutterPlugin.swift) to match the Flutter type. Please refer to [Flutter - Data types support](https://docs.flutter.dev/platform-integration/platform-channels#codec)

#### Android

1. Replace the directory [`mopro_flutter_plugin/android/src/main/jniLibs`](mopro_flutter_plugin/android/src/main/jniLibs) with the one generated during the [Setup](#setup).
2. Replace `mopro.kt` at [`mopro_flutter_plugin/android/src/main/kotlin/uniffi/mopro/mopro.kt`](mopro_flutter_plugin/android/src/main/kotlin/uniffi/mopro/mopro.kt) with the file generated during the [Setup](#setup).
3. Then define the native module API in [`mopro_flutter_plugin/android/src/main/kotlin/com/example/mopro_flutter/MoproFlutterPlugin.kt`](mopro_flutter_plugin/android/src/main/kotlin/com/example/mopro_flutter/MoproFlutterPlugin.kt) to match the Flutter type. Please refer to [Flutter - Data types support](https://docs.flutter.dev/platform-integration/platform-channels#codec)

### Flutter Module

1.  Define Flutter's platform channel APIs to pass messages between Flutter and your desired platforms.

-   [`mopro_flutter_plugin/lib/mopro_flutter_method_channel.dart`](mopro_flutter_plugin/lib/mopro_flutter_method_channel.dart)
-   [`mopro_flutter_plugin/lib/mopro_flutter_platform_interface.dart`](mopro_flutter_plugin/lib/mopro_flutter_platform_interface.dart)
-   [`mopro_flutter_plugin/lib/mopro_flutter.dart`](mopro_flutter_plugin/lib/mopro_flutter.dart)
-   ([`mopro_flutter_plugin/lib/mopro_types.dart`](mopro_flutter_plugin/lib/mopro_types.dart))

### zKey

1. Place your `.zkey` file in your app's assets folder. For example, to run the included example app, you need to replace the `.zkey` at [`assets/multiplier2_final.zkey`](assets/multiplier2_final.zkey) with your file. If you change the `.zkey` file name, don't forget to update the asset definition in your app's [`pubspec.yaml`](pubspec.yaml):

    ```yaml
    assets:
        - assets/your_new_zkey_file.zkey
    ```

2. Load the new `.zkey` file properly in your Dart code. For example, update the file path in [`lib/main.dart`](lib/main.dart):

    ```dart
    var inputs = "{\"a\":[\"3\"],\"b\":[\"5\"]}";
    proofResult = await _moproFlutterPlugin.generateCircomProof("assets/multiplier2_final.zkey", inputs, ProofLib.arkworks);
    ```

Don't forget to modify the input values for your specific case!

## Developing The Plugin

### Android

Open the `./android` directory in Android Studio. You will be able to browse to the plugin code in `Android` and `Project` view.

## E2E Tests

### End-to-End (E2E) / Integration Tests

1. Start an emulator or simulator

    - iOS: Open the iOS simulator via Xcode or `open -a Simulator`.

    - Android: Launch an emulator using Android Studio or `emulator -avd <your_avd_name>`.
        > [!NOTE]  
        > If you encounter the error `command not found: emulator`, ensure the emulator binary is present in one of the following locations:
        >
        > - `~/Library/Android/sdk/emulator/emulator`
        > - `~/Android/Sdk/emulator/emulator`
        >
        > To resolve this issue, update your shell configuration file (likely `~/.zshrc`) by adding the following lines:
        >
        > ```sh
        > export ANDROID_SDK_ROOT=~/Library/Android/sdk
        > export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
        > ```
        >
        > After making these changes, verify that the issue is resolved by running:
        >
        > ```sh
        > emulator -list-avds
        > ```

2. Run the integration test

```sh
flutter test integration_test/plugin_integration_test.dart
```

> Make sure you're using a real or virtual device (not just a Dart VM), as integration tests require it.

### Widget & Unit Tests

To run unit and widget tests (headless, using Dart VM):

```sh
flutter test
```

These are ideal for testing individual widgets, business logic, and pure Dart code.
