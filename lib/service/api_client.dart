import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/shared_pref_service.dart';
import '../utils/pref_keys.dart';

class ApiClient {
  static Future<Map<String, String>> getHeaders() async {
    final token = await SharedPrefService.getString(PrefKeys.token);

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> post(String url, dynamic body) async {
    final headers = await getHeaders();

    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
