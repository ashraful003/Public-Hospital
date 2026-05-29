import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:public_hospital/service/api_config.dart';
import '../model/next_meet_model.dart';

class NextMeetService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<bool> createMeetTime(String nationalId, String duration) async {
    final url = Uri.parse("$baseUrl/create-meet-time");
    final body = jsonEncode({"nationalId": nationalId, "duration": duration});
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) return true;
    throw Exception("Create failed");
  }

  Future<List<NextMeetModel>> getMeetTime(String nationalId) async {
    final url = Uri.parse("$baseUrl/meet-time/$nationalId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => NextMeetModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load meet time");
    }
  }

  Future<bool> deleteMeetTime(int id) async {
    final url = Uri.parse("$baseUrl/delete-meet-time/$id");
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete meet time");
    }
  }

  Future<bool> updateMeetTime(
    int id,
    String nationalId,
    String duration,
  ) async {
    final url = Uri.parse("$baseUrl/update-meet-time/$id");
    final body = jsonEncode({"nationalId": nationalId, "duration": duration});
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) return true;
    throw Exception("Update failed");
  }
}
