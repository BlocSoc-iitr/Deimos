import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:system_info2/system_info2.dart';
import 'package:mopro_flutter/mopro_flutter.dart';

class DeviceStatsService {
  static Future<Map<String, dynamic>> collectDeviceInfo(Map<String, dynamic> systemInfo) async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = {};

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceData = {
          'platform': 'Android',
          'device': androidInfo.model,                  // model code, e.g. SM-A525F
          'manufacturer': androidInfo.manufacturer,
          'deviceId': androidInfo.id,                   // one Android device -> one proof
          'systemVersion': androidInfo.version.release, // OS version, e.g. 14
          ...systemInfo,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData = {
          'platform': 'iOS',
          'device': _mapIOSDeviceName(iosInfo.utsname.machine),
          'manufacturer': 'Apple',
          'deviceId': iosInfo.identifierForVendor,
          'systemVersion': iosInfo.systemVersion,
          ...systemInfo,
        };
      }
    } catch (e) {
      print('Error collecting device info: $e');
      deviceData = {'platform': 'Unknown', 'error': e.toString()};
    }

    return deviceData;
  }

  /// Whole-device free/total physical memory. Used on iOS (process-level via the
  /// native channel) for peak sampling; on Android prefer the process-level
  /// `/proc/self/status` readers below for low-noise measurement.
  static Future<({int free, int total})> getMemorySnapshot() async {
    if (Platform.isAndroid) {
      try {
        return (
          free: SysInfo.getFreePhysicalMemory(),
          total: SysInfo.getTotalPhysicalMemory()
        );
      } catch (e) {
        print("Error getting memory info: $e");
      }
    } else if (Platform.isIOS) {
      try {
        final memoryInfo = await MoproFlutter().getIOSMemoryUsage();
        final used = memoryInfo['used'] ?? 0;
        final total = memoryInfo['total'] ?? 0;
        return (free: total - used, total: total);
      } catch (e) {
        print("Error getting iOS memory info: $e");
      }
    }
    return (free: 0, total: 0);
  }

  /// Reads a `/proc/self/status` size field (e.g. `VmRSS:`, `VmHWM:`), reported
  /// in kB, and returns it in bytes. Android-only (Linux procfs).
  static int _readProcStatusBytes(String key) {
    try {
      for (final line in File('/proc/self/status').readAsLinesSync()) {
        if (line.startsWith(key)) {
          final parts = line.trim().split(RegExp(r'\s+'));
          return (int.tryParse(parts[1]) ?? 0) * 1024;
        }
      }
    } catch (_) {}
    return 0;
  }

  /// Resets the process peak-RSS counter (`VmHWM`) to the current RSS so that a
  /// subsequent `VmHWM` read reflects the peak of just the next measured window
  /// rather than the whole process lifetime. No-op if unsupported.
  static void _resetProcPeakRss() {
    try {
      File('/proc/self/clear_refs').writeAsStringSync('5');
    } catch (_) {}
  }

  /// Total process CPU time (utime + stime) in milliseconds.
  /// Android: parsed from `/proc/self/stat`. iOS: native mach thread times.
  static Future<int> getProcessCpuMs() async {
    if (Platform.isAndroid) {
      try {
        final content = File('/proc/self/stat').readAsStringSync();
        // The comm field (2nd) may contain spaces/parens; fields after the last
        // ')' start at `state`. utime/stime are overall fields 14/15 -> indices
        // 11/12 in this remainder.
        final after = content.substring(content.lastIndexOf(')') + 1).trim();
        final fields = after.split(RegExp(r'\s+'));
        final utime = int.tryParse(fields[11]) ?? 0;
        final stime = int.tryParse(fields[12]) ?? 0;
        const clkTck = 100; // sysconf(_SC_CLK_TCK), 100 on Android/Linux
        return ((utime + stime) * 1000 / clkTck).round();
      } catch (e) {
        print("Error reading Android CPU time: $e");
      }
    } else if (Platform.isIOS) {
      try {
        final cpu = await MoproFlutter().getIOSCpuUsage();
        return cpu['cpuTimeMs'] ?? 0;
      } catch (e) {
        print("Error getting iOS CPU time: $e");
      }
    }
    return 0;
  }

  /// Builds the canonical memory metric map shared by single-run and batch flows.
  /// All inputs are process-level bytes; percentages are relative to device total.
  static Map<String, dynamic> buildMemoryInfo({
    required int totalPhysicalMemory,
    required int usedBeforeProof,
    required int peakUsedMemory,
  }) {
    final consumed = peakUsedMemory - usedBeforeProof;
    return {
      'totalPhysicalMemory': totalPhysicalMemory,
      'memoryUsedBeforeProof': usedBeforeProof,
      'peakMemoryUsage': peakUsedMemory,
      'memoryConsumedByProof': consumed,
      'peakMemoryLoadInPercentage':
          totalPhysicalMemory > 0 ? (peakUsedMemory / totalPhysicalMemory * 100) : 0.0,
      'memoryConsumedInPercentage':
          totalPhysicalMemory > 0 ? (consumed / totalPhysicalMemory * 100) : 0.0,
    };
  }

  static String _mapIOSDeviceName(String machineId) {
    switch (machineId) {
      case 'iPhone14,5': return 'iPhone 13';
      case 'iPhone14,4': return 'iPhone 13 Mini';
      case 'iPhone14,2': return 'iPhone 13 Pro';
      case 'iPhone14,3': return 'iPhone 13 Pro Max';
      case 'iPhone14,7': return 'iPhone 14';
      case 'iPhone14,8': return 'iPhone 14 Plus';
      case 'iPhone15,2': return 'iPhone 14 Pro';
      case 'iPhone15,3': return 'iPhone 14 Pro Max';
      case 'iPhone16,1': return 'iPhone 15 Pro';
      case 'iPhone16,2': return 'iPhone 15 Pro Max';
      default: return machineId;
    }
  }
}

/// Captures process-level memory (peak) and CPU time across a single measured
/// operation (one proof). Usage: [start] immediately before, [finish] right after.
///
/// - Android: peak RSS comes from the kernel-tracked `VmHWM` (reset at [start]),
///   so no sampling is needed.
/// - iOS: no kernel HWM, so resident memory is sampled every 100 ms for the peak.
class ResourceMonitor {
  Timer? _timer;
  int _total = 0;
  int _usedBefore = 0;
  int _cpuBefore = 0;
  int _iosPeakUsed = 0;

  Future<void> start() async {
    _cpuBefore = await DeviceStatsService.getProcessCpuMs();

    if (Platform.isAndroid) {
      _total = SysInfo.getTotalPhysicalMemory();
      DeviceStatsService._resetProcPeakRss();
      _usedBefore = DeviceStatsService._readProcStatusBytes('VmRSS:');
    } else if (Platform.isIOS) {
      final snap = await DeviceStatsService.getMemorySnapshot();
      _total = snap.total;
      _usedBefore = snap.total - snap.free;
      _iosPeakUsed = _usedBefore;
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
        final s = await DeviceStatsService.getMemorySnapshot();
        final used = s.total - s.free;
        if (used > _iosPeakUsed) _iosPeakUsed = used;
      });
    }
  }

  /// Returns `{ 'memory': {...6 fields}, 'cpu': { cpuTimeMs, cpuPercent } }`.
  /// [wallMs] is the wall-clock duration of the measured operation (proving time),
  /// used to derive average CPU utilisation (>100% indicates multi-core use).
  Future<Map<String, dynamic>> finish(int wallMs) async {
    final cpuAfter = await DeviceStatsService.getProcessCpuMs();
    final cpuTimeMs = (cpuAfter - _cpuBefore) < 0 ? 0 : (cpuAfter - _cpuBefore);

    int peak;
    if (Platform.isAndroid) {
      peak = DeviceStatsService._readProcStatusBytes('VmHWM:');
      if (peak < _usedBefore) peak = _usedBefore;
    } else {
      _timer?.cancel();
      _timer = null;
      peak = _iosPeakUsed;
    }

    final cpuPercent = wallMs > 0 ? (cpuTimeMs / wallMs * 100) : 0.0;

    return {
      'memory': DeviceStatsService.buildMemoryInfo(
        totalPhysicalMemory: _total,
        usedBeforeProof: _usedBefore,
        peakUsedMemory: peak,
      ),
      'cpu': {
        'cpuTimeMs': cpuTimeMs,
        'cpuPercent': double.parse(cpuPercent.toStringAsFixed(2)),
      },
    };
  }
}
