import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/shared_pref_service.dart';
import '../utils/pref_keys.dart';

class ApiClient {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefService.getString(PrefKeys.token);

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
    };
  }
  static Future<http.Response> get(String url) async {
    final headers = await _headers();

    return await http.get(
      Uri.parse(url),
      headers: headers,
    );
  }
  static Future<http.Response> post(String url, dynamic body) async {
    final headers = await _headers();

    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }
  static Future<http.Response> put(String url, dynamic body) async {
    final headers = await _headers();

    return await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }
  static Future<http.Response> delete(String url) async {
    final headers = await _headers();

    return await http.delete(
      Uri.parse(url),
      headers: headers,
    );
  }
}