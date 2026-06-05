import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class DiagnosticCenterService {
  final String baseUrl;

  DiagnosticCenterService({required this.baseUrl});

  Future<Map<String, dynamic>> registerDiagnosticCenter(UserModel user) async {
    try {
      final url = Uri.parse("$baseUrl/register-diagnosticCenter");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(user.toJson()),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(responseData["message"] ?? "Registration failed");
      }
    } catch (e) {
      throw Exception("Failed to register diagnostic center: $e");
    }
  }

  Future<List<UserModel>> getAllDiagnosticCenters() async {
    try {
      final url = Uri.parse("$baseUrl/all-diagnosticCenter");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
          responseData["message"] ?? "Failed to load diagnostic centers",
        );
      }
    } catch (e) {
      throw Exception("Failed to fetch diagnostic centers: $e");
    }
  }

  Future<void> deleteDiagnosticCenter(int id) async {
    try {
      final url = Uri.parse("$baseUrl/delete-diagnosticCenter/$id");
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }
      final responseData = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {};
      throw Exception(
        responseData["message"] ?? "Failed to delete diagnostic center",
      );
    } catch (e) {
      throw Exception("Failed to delete diagnostic center: $e");
    }
  }
}