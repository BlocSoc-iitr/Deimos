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
          'device': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'androidVersion': androidInfo.version.release,
          'androidId': androidInfo.id,
          ...systemInfo,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        final deviceName = _mapIOSDeviceName(iosInfo.utsname.machine);
        deviceData = {
          'platform': 'iOS',
          'device': deviceName, 
          'manufacturer': 'Apple',
          'model': iosInfo.model,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'osVersion': iosInfo.systemVersion,
          'androidVersion': iosInfo.systemVersion,
          'name': iosInfo.name,
          'identifierForVendor': iosInfo.identifierForVendor,
          'deviceId': iosInfo.identifierForVendor,
          'androidId': iosInfo.identifierForVendor,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
          'utsname': {
            'machine': iosInfo.utsname.machine,
            'sysname': iosInfo.utsname.sysname,
          },
          ...systemInfo,
        };
      }
    } catch (e) {
      print('Error collecting device info: $e');
      deviceData = {'platform': 'Unknown', 'error': e.toString()};
    }
    
    return deviceData;
  }

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
