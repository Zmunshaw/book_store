import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService {
  // Update this to your backend URL
  static const String baseUrl = 'http://localhost:8000';

  static final Logger _logger = Logger();

  static Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      _logger.d('POST request to $url');
      _logger.d('Body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'error': responseData['detail'] ?? 'An error occurred',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      _logger.e('Error in POST request: $e');
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
        'statusCode': 0,
      };
    }
  }

  static Future<Map<String, dynamic>> get({
    required String endpoint,
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      _logger.d('GET request to $url');

      final response = await http.get(
        url,
        headers: headers,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'error': responseData['detail'] ?? 'An error occurred',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      _logger.e('Error in GET request: $e');
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
        'statusCode': 0,
      };
    }
  }

  static Future<Map<String, dynamic>> delete({
    required String endpoint,
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      _logger.d('DELETE request to $url');

      final response = await http.delete(
        url,
        headers: headers,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'error': responseData['detail'] ?? 'An error occurred',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      _logger.e('Error in DELETE request: $e');
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
        'statusCode': 0,
      };
    }
  }
}
