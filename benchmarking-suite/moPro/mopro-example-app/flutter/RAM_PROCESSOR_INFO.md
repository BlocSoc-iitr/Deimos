# RAM and Processor Information Collection

## Overview

The Flutter app now collects comprehensive RAM usage and processor information along with device details.

## New Data Collected

### **Processor Information**
- **Name**: Processor model name
- **Architecture**: Processor architecture (e.g., x86_64, ARM64)
- **Vendor**: Processor manufacturer (e.g., Intel, AMD, Qualcomm)
- **Socket**: Processor socket type
- **Cores**: Number of CPU cores
- **Kernel Bitness**: 32-bit or 64-bit kernel
- **Kernel Architecture**: Kernel architecture type
- **Kernel Name**: Operating system kernel name
- **Kernel Version**: Kernel version string

### **Memory (RAM) Information**

#### Physical Memory:
- **Total Physical Memory**: Total RAM in bytes, MB, and GB
- **Used Physical Memory**: Currently used RAM in bytes, MB, and GB
- **Free Physical Memory**: Available RAM in bytes, MB, and GB
- **Memory Usage Percent**: Percentage of RAM being used

#### Virtual Memory:
- **Total Virtual Memory**: Total virtual memory in bytes and MB
- **Used Virtual Memory**: Used virtual memory in bytes and MB
- **Free Virtual Memory**: Free virtual memory in bytes and MB

## Example Data Structure

```json
{
  "circuit": "SHA256",
  "framework": "MoPro",
  "language": "Circom",
  "platform": "Android",
  "device": "Google sdk gphone64 x86 64",
  "provingTime": 1234,
  "verificationTime": 567,
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
    
    "processor": {
      "name": "Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz",
      "architecture": "ProcessorArchitecture.x86_64",
      "vendor": "GenuineIntel",
      "socket": "U3E1",
      "cores": 8,
      "kernelBitness": 64,
      "kernelArchitecture": "KernelArchitecture.x86_64",
      "kernelName": "Linux",
      "kernelVersion": "6.14.0-35-generic"
    },
    
    "memory": {
      "totalPhysicalMemory": 16777216000,
      "freePhysicalMemory": 8388608000,
      "usedPhysicalMemory": 8388608000,
      "totalPhysicalMemoryMB": "16000.00",
      "freePhysicalMemoryMB": "8000.00",
      "usedPhysicalMemoryMB": "8000.00",
      "totalPhysicalMemoryGB": "16.00",
      "freePhysicalMemoryGB": "8.00",
      "usedPhysicalMemoryGB": "8.00",
      "memoryUsagePercent": "50.00",
      "totalVirtualMemory": 33554432000,
      "freeVirtualMemory": 25165824000,
      "usedVirtualMemory": 8388608000,
      "totalVirtualMemoryMB": "32000.00",
      "freeVirtualMemoryMB": "24000.00",
      "usedVirtualMemoryMB": "8000.00"
    }
  }
}
```

## Backend Console Output

When data is received, the backend logs it in a structured format:

```
[INFO] 2024-11-09T11:22:33.000Z - === Received Benchmark Result from Mobile App ===
[INFO] 2024-11-09T11:22:33.000Z - Circuit: SHA256
[INFO] 2024-11-09T11:22:33.000Z - Framework: MoPro
[INFO] 2024-11-09T11:22:33.000Z - Language: Circom
[INFO] 2024-11-09T11:22:33.000Z - Platform: Android
[INFO] 2024-11-09T11:22:33.000Z - Device: Google sdk gphone64 x86 64
[INFO] 2024-11-09T11:22:33.000Z - Proving Time: 1.234s (1234ms)
[INFO] 2024-11-09T11:22:33.000Z - Verification Time: 0.567s (567ms)
[INFO] 2024-11-09T11:22:33.000Z - Proof Valid: true
[INFO] 2024-11-09T11:22:33.000Z - Proof Size: 1024 bytes

[INFO] 2024-11-09T11:22:33.000Z - === Device Information ===
[INFO] 2024-11-09T11:22:33.000Z - platform: Android
[INFO] 2024-11-09T11:22:33.000Z - device: sdk gphone64 x86 64
[INFO] 2024-11-09T11:22:33.000Z - manufacturer: Google
[INFO] 2024-11-09T11:22:33.000Z - brand: google
[INFO] 2024-11-09T11:22:33.000Z - androidVersion: 14
[INFO] 2024-11-09T11:22:33.000Z - sdkInt: 34

[INFO] 2024-11-09T11:22:33.000Z - === Processor Information ===
[INFO] 2024-11-09T11:22:33.000Z - name: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
[INFO] 2024-11-09T11:22:33.000Z - architecture: ProcessorArchitecture.x86_64
[INFO] 2024-11-09T11:22:33.000Z - vendor: GenuineIntel
[INFO] 2024-11-09T11:22:33.000Z - socket: U3E1
[INFO] 2024-11-09T11:22:33.000Z - cores: 8
[INFO] 2024-11-09T11:22:33.000Z - kernelBitness: 64
[INFO] 2024-11-09T11:22:33.000Z - kernelArchitecture: KernelArchitecture.x86_64
[INFO] 2024-11-09T11:22:33.000Z - kernelName: Linux
[INFO] 2024-11-09T11:22:33.000Z - kernelVersion: 6.14.0-35-generic

[INFO] 2024-11-09T11:22:33.000Z - === Memory Information ===
[INFO] 2024-11-09T11:22:33.000Z - Total RAM: 16.00 GB (16000.00 MB)
[INFO] 2024-11-09T11:22:33.000Z - Used RAM: 8.00 GB (8000.00 MB)
[INFO] 2024-11-09T11:22:33.000Z - Free RAM: 8.00 GB (8000.00 MB)
[INFO] 2024-11-09T11:22:33.000Z - Memory Usage: 50.00%
[INFO] 2024-11-09T11:22:33.000Z - Total Virtual Memory: 32000.00 MB
[INFO] 2024-11-09T11:22:33.000Z - Used Virtual Memory: 8000.00 MB
[INFO] 2024-11-09T11:22:33.000Z - Free Virtual Memory: 24000.00 MB
```

## Dependencies Added

```yaml
dependencies:
  system_info2: ^4.0.0  # For RAM and processor information
```

## How to Test

1. **Start Backend:**
   ```bash
   cd /home/mahoraga/vscodeprojects/Deimos_Fork/backend
   npm start
   ```

2. **Run Flutter App:**
   ```bash
   cd /home/mahoraga/vscodeprojects/Deimos_Fork/benchmarking-suite/moPro/mopro-example-app/flutter
   flutter run
   ```

3. **Generate and Verify Proof:**
   - Select framework and algorithm
   - Click "Run"
   - Wait for proof generation
   - Click "Verify Proof"
   - Check backend console for RAM and processor info

## Key Features

✅ **Real-time RAM usage** - Shows current memory consumption
✅ **Detailed processor info** - CPU name, cores, architecture
✅ **Multiple memory formats** - Bytes, MB, GB for easy reading
✅ **Memory usage percentage** - Quick overview of RAM utilization
✅ **Virtual memory tracking** - Includes swap/page file usage
✅ **Cross-platform** - Works on Android and iOS
✅ **Error handling** - Gracefully handles collection failures
✅ **Structured logging** - Backend displays data in organized format

## Memory Usage Calculation

```dart
// Physical Memory
usedPhysicalMemory = totalPhysicalMemory - freePhysicalMemory
memoryUsagePercent = (usedPhysicalMemory / totalPhysicalMemory) * 100

// Virtual Memory
usedVirtualMemory = totalVirtualMemory - freeVirtualMemory
```

## Notes

- Memory values are captured at the moment of proof verification
- RAM usage reflects the app's memory consumption during benchmark
- Processor information is static (doesn't change during runtime)
- Virtual memory includes swap space on Android/Linux
- All memory values provided in multiple units for convenience
