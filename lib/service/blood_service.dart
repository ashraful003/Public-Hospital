import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/blood_bank_model.dart';
import 'api_config.dart';

class BloodService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<BloodBankModel?> getProfile(String email) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$email"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BloodBankModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> addProfile(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/blood"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          ...body,
          "lastDonateDate": body["lastDonateDate"].toString(),
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<BloodBankModel?> updateDonationDate(
    String email,
    DateTime date,
  ) async {
    final body = {"email": email, "lastDonateDate": date.toIso8601String()};
    final response = await http.put(
      Uri.parse("$baseUrl/$email"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return BloodBankModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to update");
  }

  Future<List<BloodBankModel>> getAllDonors() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/blood-list"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => BloodBankModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
