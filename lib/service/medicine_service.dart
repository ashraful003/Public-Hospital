import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/medicine_model.dart';
import '../service/api_config.dart';
import '../data/shared_pref_service.dart';

class MedicineService {
  String get baseUrl => ApiConfig.baseUrl;

  Future<List<MedicineModel>> getAllMedicines() async {
    final token = SharedPrefService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/all-medicine"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((e) => MedicineModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load medicines");
    }
  }

  Future<List<MedicineModel>> getMyMedicines(String pharmaName) async {
    final token = SharedPrefService.getToken();
    final url =
        "$baseUrl/all-my-medicine"
        "?name=${Uri.encodeComponent(pharmaName)}";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((e) => MedicineModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load pharmaceutical medicines");
    }
  }

  Future<bool> deleteMedicine(int id) async {
    final token = SharedPrefService.getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/delete/medicine/$id"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> updateMedicine({
    required int id,
    required MedicineModel medicine,
  }) async {
    try {
      final token = SharedPrefService.getToken();
      final response = await http.put(
        Uri.parse("$baseUrl/update/medicine/$id"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(medicine.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addMedicine(MedicineModel medicine) async {
    try {
      final token = SharedPrefService.getToken();
      final response = await http.post(
        Uri.parse("$baseUrl/add-medicine"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(medicine.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      }
      if (response.body.isNotEmpty) {
        final body = response.body.toLowerCase();
        if (body.contains("already exists")) {
          throw Exception("Medicine already exists for this pharmaceutical");
        }
      }
      throw Exception("Failed to add medicine");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
