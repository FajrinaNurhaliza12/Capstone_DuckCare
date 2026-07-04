import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ReportProvider {
  final _box = GetStorage();

  static const String _base = 'http://192.168.1.3/duckcare_api/auth';

  Map<String, String> get _headers {
    final token = _box.read('token')?.toString() ?? '';

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    print('REPORT API STATUS: ${response.statusCode}');
    print('REPORT API BODY: ${response.body}');

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {
        'success': false,
        'message': 'Response report tidak sesuai format',
        'raw': response.body,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Response report tidak valid',
        'raw': response.body,
      };
    }
  }

  Future<Map<String, dynamic>> getReport() async {
    final response = await http.get(
      Uri.parse('$_base/get_report.php'),
      headers: _headers,
    );

    return _decodeResponse(response);
  }
}