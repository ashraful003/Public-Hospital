import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../model/attendance_model.dart';
import '../model/user_model.dart';

class AttendanceService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<UserModel> getUser(String nationalId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/user/$nationalId"),
      headers: {"Content-Type": "application/json"},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? "User not found");
    }
  }

  Future<List<AttendanceModel>> fetchAllAttendance() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all-attendance"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => AttendanceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load attendance");
    }
  }

  Future<List<AttendanceModel>> fetchMyAttendance(String nationalId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/my/$nationalId"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => AttendanceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load attendance");
    }
  }

  Future<List<AttendanceModel>> getTodayAttendance() async {
    final response = await http.get(
      Uri.parse("$baseUrl/today"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => AttendanceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load today's attendance");
    }
  }

  Future<String> checkIn(String nationalId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/check-in/$nationalId"),
      headers: {"Content-Type": "application/json"},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['message'] ?? "Check-in successful";
    } else {
      throw Exception(data['message'] ?? "Check-in failed");
    }
  }

  Future<String> checkOut(String nationalId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/check-out/$nationalId"),
      headers: {"Content-Type": "application/json"},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['message'] ?? "Check-out successful";
    } else {
      throw Exception(data['message'] ?? "Check-out failed");
    }
  }
}
