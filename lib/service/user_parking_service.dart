import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/user_parking_model.dart';
import '../data/shared_pref_service.dart';
import 'api_config.dart';

class UserParkingService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>> createUserParking(
    UserParkingModel request,
  ) async {
    final token = await SharedPrefService.getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/create-user-parking"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Server Error ${response.statusCode}: ${response.body}");
  }

  Future<List<UserParkingModel>> getAllParking() async {
    final token = await SharedPrefService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/get-all-user-parking"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => UserParkingModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load parking");
  }

  Future<List<UserParkingModel>> getActiveParking() async {
    final token = await SharedPrefService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/get-active-user-parking"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => UserParkingModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load active parking");
  }

  Future<List<UserParkingModel>> getPatientParking(String patientId) async {
    final token = await SharedPrefService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/get-patient-parking/$patientId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => UserParkingModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load patient parking");
  }

  Future<Map<String, dynamic>> exitVehicle(String vehicleNo) async {
    final token = await SharedPrefService.getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/exit-vehicle/$vehicleNo"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Failed to exit vehicle");
  }
}