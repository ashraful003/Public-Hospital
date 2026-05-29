import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/test_model.dart';
import 'api_config.dart';

class TestService {
  Future<String> addTest(Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/add-test");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    final message = response.body;
    if (response.statusCode == 200) {
      return message;
    } else {
      throw message;
    }
  }

  Future<List<TestModel>> getAllTests() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/all-test");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TestModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tests");
    }
  }

  Future<List<TestModel>> getCenterTests(String name) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/center/test/$name");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TestModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load center tests");
    }
  }

  Future<void> updateTest(int id, Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/update-test/$id");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to update test");
    }
  }

  Future<void> deleteTest(int id) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/delete-test/$id");
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to delete test");
    }
  }
}
