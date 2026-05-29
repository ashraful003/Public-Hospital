import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import 'api_config.dart';

class ProfileService {
  Future<UserModel?> getProfile(String email) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/profile?email=$email"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception("Failed to load profile");
    }
  }
}
