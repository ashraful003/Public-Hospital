import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/shared_pref_service.dart';
import '../model/medicine_type_model.dart';
import 'api_config.dart';
import 'profile_service.dart';

class MedicineTypeService {
  Future<String?> getNationalIdFromEmail() async {
    final email = await SharedPrefService.getString("remember_email");
    if (email == null || email.isEmpty) {
      return null;
    }
    final profile = await ProfileService().getProfile(email);
    return profile?.nationalId;
  }

  Future<List<MedicineTypeModel>> getMedicineTypes(String nationalId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/medicine_types/$nationalId"),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => MedicineTypeModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load medicine types");
  }

  Future<String> createMedicineType(
    String medicineType,
    String nationalId,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/create/medicine_types"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "medicineType": medicineType,
        "nationalId": nationalId,
      }),
    );
    return response.body;
  }

  Future<String> updateMedicineType(
    int id,
    String medicineType,
    String nationalId,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/update/medicine_types/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "medicineType": medicineType,
        "nationalId": nationalId,
      }),
    );
    return response.body;
  }

  Future<String> deleteMedicineType(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/delete/medicine_types/$id"),
    );
    return response.body;
  }
}
