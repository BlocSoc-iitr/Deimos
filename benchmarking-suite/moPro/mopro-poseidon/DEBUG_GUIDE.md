# Poseidon MoPro Android Debugging Guide

## Current Status
- ✅ Rust test passes: `cargo test test_circom`
- ✅ Circuit files are compatible: `snarkjs wtns calculate` works
- ✅ MoPro bindings rebuilt with correct circuit files
- ✅ Android assets updated with both `circom.wasm` and `circom.zkey`
- ✅ Input format matches Poseidon circuit expectations

## Files Verified
```
android/app/src/main/assets/
├── circom.wasm (2,548,703 bytes) ✅
├── circom.zkey (16,849,756 bytes) ✅
└── input_9.json (214 bytes) ✅
```

## Input Format
```json
{
    "inputs": ["123456789", "987654321", "555666777", "111222333", "444555666", "777888999", "123123123", "456456456"],
    "out": "14498150797847809509722717240901763875598208779232668488504554441876295521783"
}
```

## Debugging Steps

### 1. Check Android Studio Logcat
Look for specific error messages in Android Studio Logcat:
```
View → Tool Windows → Logcat
Filter by: "mopro" or "circom" or "rust"
```

### 2. Common Error Patterns
- **"File not found"**: Assets not copied correctly
- **"Invalid witness"**: Input format mismatch
- **"FFI error"**: Binding issues
- **"Circuit error"**: WASM/ZKEY compatibility

### 3. Verify Asset Loading
Add this debug code to MainActivity.kt to verify files are accessible:
```kotlin
// In MainActivity.onCreate()
try {
    val zkeyFile = File(filesDir, "circom.zkey")
    val wasmFile = File(filesDir, "circom.wasm")
    Log.d("DEBUG", "ZKEY exists: ${zkeyFile.exists()}, size: ${zkeyFile.length()}")
    Log.d("DEBUG", "WASM exists: ${wasmFile.exists()}, size: ${wasmFile.length()}")
} catch (e: Exception) {
    Log.e("DEBUG", "Asset check failed: ${e.message}")
}
```

### 4. Test Input Parsing
Add debug logging for input parsing:
```kotlin
// Before generateCircomProof call
val inputStr = File(inputPath).readText()
Log.d("DEBUG", "Input JSON: $inputStr")
```

### 5. Gradual Testing
1. **Clean build**: `./gradlew clean build`
2. **Fresh install**: Uninstall and reinstall the app
3. **Check emulator**: Ensure x86_64 emulator matches build target

### 6. Compare with Working SHA256
If still failing, compare with working mopro-sha256:
- Check asset file sizes
- Compare MainActivity.kt differences
- Verify binding versions match

### 7. Manual Circuit Test
Test circuit manually outside Android:
```bash
cd /home/anand/Deimos/benchmarking-suite/moPro/mopro-poseidon
snarkjs wtns calculate ./test-vectors/circom/circom.wasm ./android/app/src/main/assets/input_9.json witness.wtns
snarkjs groth16 prove ./test-vectors/circom/circom.zkey witness.wtns proof.json public.json
```

## Next Steps
1. Run the app and capture the exact error message from Logcat
2. Share the specific error details for targeted debugging
3. If needed, we can create a minimal test case to isolate the issue

## Files to Check
- Android assets are correctly copied
- Bindings are up to date (`mopro update` was run)
- App is built for correct architecture (x86_64 for emulator)
