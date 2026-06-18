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

  /// Builds the memory metric map: just the peak (process RSS at its highest)
  /// and its share of device RAM. The "before/consumed" delta was dropped — it
  /// was residency-sensitive and misleading across a long-lived process.
  static Map<String, dynamic> buildMemoryInfo({
    required int totalPhysicalMemory,
    required int peakUsedMemory,
  }) {
    return {
      'totalPhysicalMemory': totalPhysicalMemory,
      'peakMemoryUsage': peakUsedMemory,
      'peakMemoryLoadInPercentage':
          totalPhysicalMemory > 0 ? (peakUsedMemory / totalPhysicalMemory * 100) : 0.0,
    };
  }

  /// Battery temperature in °C (proxy for device thermal state), or null if
  /// unavailable. Android only.
  static Future<double?> getBatteryTemperatureC() async {
    if (!Platform.isAndroid) return null;
    try {
      return await MoproFlutter().getBatteryTemperature();
    } catch (e) {
      print('Error reading battery temperature: $e');
      return null;
    }
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

/// Captures process-level peak memory and CPU time across one measured operation.
/// Usage: [start] immediately before, [finish] right after.
///
/// Two peak-memory modes:
/// - poll=true (batch "Prove & Verify All"): sample RSS every 100 ms for the peak.
///   Required there because the kernel `VmHWM` high-water mark is monotonic since
///   process start and can't be reset per-proof (clear_refs is SELinux-blocked).
/// - poll=false (single run): read `VmHWM` once at the end — no sampling timer,
///   a clean single measurement. Fine for a single proof per page launch.
class ResourceMonitor {
  Timer? _timer;
  bool _poll = true;
  final Stopwatch _window = Stopwatch();
  int _total = 0;
  int _cpuBefore = 0;
  int _peakUsed = 0;

  /// Current process resident memory in bytes (Android: VmRSS; iOS: footprint).
  Future<int> _currentUsedBytes() async {
    if (Platform.isAndroid) {
      return DeviceStatsService._readProcStatusBytes('VmRSS:');
    } else if (Platform.isIOS) {
      final s = await DeviceStatsService.getMemorySnapshot();
      return s.total - s.free;
    }
    return 0;
  }

  Future<void> start({bool poll = true}) async {
    _poll = poll;
    _cpuBefore = await DeviceStatsService.getProcessCpuMs();
    if (Platform.isAndroid) {
      _total = SysInfo.getTotalPhysicalMemory();
    } else if (Platform.isIOS) {
      _total = (await DeviceStatsService.getMemorySnapshot()).total;
    }
    _peakUsed = await _currentUsedBytes();
    _window
      ..reset()
      ..start();

    if (_poll) {
      // Sample resident memory during the window to capture the per-run peak.
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
        final used = await _currentUsedBytes();
        if (used > _peakUsed) _peakUsed = used;
      });
    }
  }

  /// Returns `{ 'memory': { totalPhysicalMemory, peakMemoryUsage,
  /// peakMemoryLoadInPercentage }, 'cpu': { cpuTimeMs, cpuPercent } }`.
  /// CPU utilisation is averaged over the monitor's own window.
  Future<Map<String, dynamic>> finish() async {
    _window.stop();
    if (_poll) {
      _timer?.cancel();
      _timer = null;
      final last = await _currentUsedBytes();
      if (last > _peakUsed) _peakUsed = last;
    } else if (Platform.isAndroid) {
      // No-poll: one kernel high-water-mark read is the peak for this run.
      final hwm = DeviceStatsService._readProcStatusBytes('VmHWM:');
      if (hwm > _peakUsed) _peakUsed = hwm;
    } else {
      final last = await _currentUsedBytes();
      if (last > _peakUsed) _peakUsed = last;
    }

    final cpuAfter = await DeviceStatsService.getProcessCpuMs();
    final cpuTimeMs = (cpuAfter - _cpuBefore) < 0 ? 0 : (cpuAfter - _cpuBefore);
    final wallMs = _window.elapsedMilliseconds;
    final cpuPercent = wallMs > 0 ? (cpuTimeMs / wallMs * 100) : 0.0;

    return {
      'memory': DeviceStatsService.buildMemoryInfo(
        totalPhysicalMemory: _total,
        peakUsedMemory: _peakUsed,
      ),
      'cpu': {
        'cpuTimeMs': cpuTimeMs,
        'cpuPercent': double.parse(cpuPercent.toStringAsFixed(2)),
      },
    };
  }
}
