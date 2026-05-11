import 'dart:convert';
import '../model/user_model.dart';
import 'api_config.dart';
import 'api_client.dart';

class PharmaceuticalService {
  String get baseUrl => ApiConfig.baseUrl;

  Future<List<UserModel>> getAllPharmaceuticals() async {
    try {
      final response = await ApiClient.get("$baseUrl/all-pharmaceuticals");
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load pharmaceuticals");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<String> deletePharmaceutical(int id) async {
    try {
      final response = await ApiClient.delete(
        "$baseUrl/delete-pharmaceutical/$id",
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data["message"] ?? "Delete failed");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
