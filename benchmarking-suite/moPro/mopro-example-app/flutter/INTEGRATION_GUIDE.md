# Backend Integration Guide

## Overview

The Flutter app now automatically sends benchmark data to the backend API after proof verification completes successfully.

## What Data is Collected

### 1. **Circuit & Framework Information**
- Circuit type (SHA256, Keccak256, etc.)
- Framework (MoPro)
- Language (Circom, Noir, Halo2)
- Platform (Android/iOS)
- Device name (manufacturer + model)

### 2. **Performance Metrics**
- Proving time (milliseconds and seconds)
- Verification time (milliseconds and seconds)
- Proof size (bytes)
- Proof validity status

### 3. **Device Information**

#### Android:
- Model
- Manufacturer
- Brand
- Android version
- SDK version
- Android ID
- Hardware
- Product name
- Physical device status
- Supported ABIs
- System features

#### iOS:
- Model
- System name
- System version
- Device name
- Identifier for vendor
- Physical device status
- Machine architecture
- System name

### 4. **Additional Metadata**
- Custom input text
- Timestamp (ISO 8601 format)

## How It Works

### Flow:
1. User selects framework and algorithm
2. User enters custom input
3. App generates proof (timing recorded)
4. User clicks "Verify Proof"
5. App verifies proof (timing recorded)
6. **If verification succeeds:**
   - Device info is collected
   - All data is packaged into JSON
   - HTTP POST request sent to backend
   - Response logged to console

### Code Location:
- **Device info collection:** `_collectDeviceInfo()` method
- **Data preparation:** `_prepareBenchmarkData()` method
- **API call:** `_sendDataToBackend()` method
- **Trigger:** Called in `_performRealVerification()` after successful verification

## Backend API Endpoint

### URL:
```
POST http://10.0.2.2:5000/api/benchmark-result
```

**Note:** `10.0.2.2` is the special IP for Android emulator to access host machine's localhost.

For physical devices, replace with your computer's IP address:
```dart
Uri.parse('http://YOUR_IP_ADDRESS:5000/api/benchmark-result')
```

### Request Format:
```json
{
  "circuit": "SHA256",
  "framework": "MoPro",
  "language": "Circom",
  "platform": "Android",
  "device": "Google sdk gphone64 x86 64",
  "provingTime": 1234,
  "verificationTime": 567,
  "provingTimeSeconds": 1.234,
  "verificationTimeSeconds": 0.567,
  "deviceInfo": {
    "platform": "Android",
    "device": "sdk gphone64 x86 64",
    "manufacturer": "Google",
    "brand": "google",
    "androidVersion": "14",
    "sdkInt": 34,
    "hardware": "ranchu",
    "isPhysicalDevice": false,
    "supportedAbis": ["x86_64", "arm64-v8a"],
    "systemFeatures": [...]
  },
  "customInput": "Hello World! This is a test msg.",
  "proofValid": true,
  "timestamp": "2024-11-09T10:30:00.000Z",
  "proofSize": 1024
}
```

### Response Format:
```json
{
  "success": true,
  "message": "Benchmark result received and logged successfully",
  "receivedAt": "2024-11-09T10:30:01.000Z"
}
```

## Viewing the Data

### In Flutter App:
Check the console/logcat output for:
```
=== Sending Data to Backend ===
Data: {...}
=== Backend Response ===
Status Code: 200
Response Body: {...}
✓ Data successfully sent to backend
```

### In Backend:
The backend logs all received data in a structured format:
```
[INFO] 2024-11-09T10:30:00.000Z - === Received Benchmark Result from Mobile App ===
[INFO] 2024-11-09T10:30:00.000Z - Circuit: SHA256
[INFO] 2024-11-09T10:30:00.000Z - Framework: MoPro
[INFO] 2024-11-09T10:30:00.000Z - Language: Circom
[INFO] 2024-11-09T10:30:00.000Z - Platform: Android
[INFO] 2024-11-09T10:30:00.000Z - Device: Google sdk gphone64 x86 64
[INFO] 2024-11-09T10:30:00.000Z - Proving Time: 1.234s (1234ms)
[INFO] 2024-11-09T10:30:00.000Z - Verification Time: 0.567s (567ms)
...
[INFO] 2024-11-09T10:30:00.000Z - === Complete Data ===
[INFO] 2024-11-09T10:30:00.000Z - {full JSON object}
```

## Testing

### 1. Start Backend Server:
```bash
cd /home/mahoraga/vscodeprojects/Deimos_Fork/backend
npm start
```

### 2. Run Flutter App:
```bash
cd /home/mahoraga/vscodeprojects/Deimos_Fork/benchmarking-suite/moPro/mopro-example-app/flutter
flutter run
```

### 3. Generate and Verify Proof:
1. Select a framework (Circom/Noir/Halo2)
2. Select an algorithm
3. Enter custom input (or use default)
4. Click "Run" button
5. Wait for proof generation
6. Click "Verify Proof"
7. Check console for API call logs

## Error Handling

The app handles errors gracefully:
- If backend is unreachable, error is logged but app continues
- If device info collection fails, sends minimal data
- Network errors are caught and logged
- Backend errors (4xx/5xx) are logged with status code

## Dependencies Added

### pubspec.yaml:
```yaml
dependencies:
  device_info_plus: ^10.1.0  # For device information
  http: ^1.2.0               # For HTTP requests
```

## Customization

### Change Backend URL:
Edit line 1449 in `main.dart`:
```dart
Uri.parse('http://YOUR_BACKEND_URL/api/benchmark-result')
```

### Add More Device Info:
Modify `_collectDeviceInfo()` method to collect additional data.

### Change Data Format:
Modify `_prepareBenchmarkData()` method to change the JSON structure.

### Disable API Calls:
Comment out line 1366 in `_performRealVerification()`:
```dart
// await _sendDataToBackend();
```

## Important Notes

1. **No existing functionality changed** - All original proof generation and verification logic remains intact
2. **API call is non-blocking** - Errors don't affect app functionality
3. **Data sent only on successful verification** - Failed proofs don't send data
4. **All data logged to console** - Easy debugging and monitoring
5. **Backend prints all received data** - Complete visibility of incoming data

## Troubleshooting

### Backend not receiving data:
- Check backend is running on port 5000
- Verify firewall allows connections
- For physical device, use computer's IP instead of 10.0.2.2
- Check network connectivity

### Device info not collected:
- Ensure permissions are granted (if required)
- Check platform-specific requirements
- Review error logs in console

### API call fails:
- Check backend URL is correct
- Verify backend endpoint exists
- Review network logs
- Check CORS settings if needed
