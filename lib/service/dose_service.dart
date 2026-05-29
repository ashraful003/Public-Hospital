import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/shared_pref_service.dart';
import '../model/doses_model.dart';
import 'api_config.dart';

class DoseService {
  Future<String> addDose({
    required String dose,
    required String nationalId,
  }) async {
    final token = await SharedPrefService.getToken();
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/add-doses"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"dose": dose, "nationalId": nationalId}),
    );
    if (response.statusCode == 200) {
      return response.body.replaceAll('"', '');
    } else {
      throw Exception("Failed to add dose");
    }
  }

  Future<List<DoseModel>> getDosesByNationalId(String nationalId) async {
    final token = await SharedPrefService.getToken();
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/doses/$nationalId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => DoseModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load doses");
    }
  }

  Future<String> updateDose({
    required int id,
    required String dose,
    required String nationalId,
  }) async {
    final token = await SharedPrefService.getToken();
    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/update-doses/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"dose": dose, "nationalId": nationalId}),
    );
    if (response.statusCode == 200) {
      return response.body.replaceAll('"', '');
    } else {
      throw Exception("Failed to update dose");
    }
  }

  Future<String> deleteDose(int id) async {
    final token = await SharedPrefService.getToken();
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/delete-doses/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return response.body.replaceAll('"', '');
    } else {
      throw Exception("Failed to delete dose");
    }
  }
}
