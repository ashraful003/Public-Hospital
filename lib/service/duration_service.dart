import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/duration_model.dart';
import 'api_config.dart';

class DurationService {
  Future<Map<String, dynamic>> addDuration(
    String nationalId,
    String duration,
  ) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/add-duration");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nationalId": nationalId, "duration": duration}),
    );
    final data = jsonDecode(response.body);
    return {
      "success": response.statusCode == 200,
      "message": data["message"] ?? "Unknown error",
    };
  }

  Future<List<DurationModel>> getDurations(String nationalId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/duration/$nationalId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => DurationModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load durations");
    }
  }

  Future<void> updateDuration(
    int id,
    String nationalId,
    String duration,
  ) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/update-duration/$id");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nationalId": nationalId, "duration": duration}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update duration");
    }
  }

  Future<void> deleteDuration(int id) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/delete-duration/$id");
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception("Failed to delete duration");
    }
  }
}
