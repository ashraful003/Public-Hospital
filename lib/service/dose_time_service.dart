import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/dose_time_model.dart';
import '../utils/pref_keys.dart';
import 'api_config.dart';

class DoseTimeService {
  Future<String?> getNationalIdFromEmail() async {
    final pref = await SharedPreferences.getInstance();
    final email = pref.getString(PrefKeys.rememberEmail);
    if (email == null || email.isEmpty) return null;
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/profile?email=$email"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['nationalId'];
    }
    return null;
  }

  Future<String> createDoseTime(String doseTime, String nationalId) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/create/dose-time"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"doseTime": doseTime, "nationalId": nationalId}),
    );
    return response.body;
  }

  Future<List<DoseTimeModel>> getDoseTimes(String nationalId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/dose-time/$nationalId"),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => DoseTimeModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> updateDoseTime(
    int id,
    String doseTime,
    String nationalId,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/update/dose-time/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"doseTime": doseTime, "nationalId": nationalId}),
    );
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = response.body;
    }
    return {"statusCode": response.statusCode, "body": body};
  }

  Future<String> deleteDoseTime(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/delete/dose-time/$id"),
    );
    return response.body;
  }
}
