import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String benchmarkEndpoint = 'https://deimos-fork.onrender.com/api/benchmark-result';

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
