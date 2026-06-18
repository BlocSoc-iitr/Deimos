import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL is configured per-environment at build time, e.g.
  //   flutter run --dart-define=BENCHMARK_API_BASE_URL=https://api.example.com
  // Defaults to the staging host. Prefer an HTTPS URL to avoid exposing
  // benchmark/device data over plaintext.
  static const String _baseUrl = String.fromEnvironment(
    'BENCHMARK_API_BASE_URL',
    defaultValue: 'http://3.86.145.121',
  );

  static const String benchmarkEndpoint = '$_baseUrl/api/benchmark-result';

  static Future<bool> sendBenchmarkData(Map<String, dynamic> benchmarkData) async {
    try {
      print('=== Sending Data to Backend ===');
      print('Data: ${jsonEncode(benchmarkData)}');
      
      final response = await http.post(
        Uri.parse(benchmarkEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(benchmarkData),
      );

      print('=== Backend Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✓ Data successfully sent to backend');
        return true;
      } else {
        print('✗ Failed to send data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('✗ Error sending data to backend: $e');
      return false;
    }
  }
}
