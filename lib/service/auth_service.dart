import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:public_hospital/data/shared_pref_service.dart';
import '../model/user_model.dart';
import 'api_config.dart';
import 'package:public_hospital/service/api_client.dart';

class AuthService {
  String get baseUrl => ApiConfig.baseUrl;

  Future<Map<String, dynamic>> register(UserModel user) async {
    try {
      final url = Uri.parse("$baseUrl/register");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(user.toJson()),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(responseData["message"] ?? "Registration failed");
      }
    } catch (e) {
      throw Exception(" $e");
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post("$baseUrl/login", {
        "email": email,
        "password": password,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await SharedPrefService.saveLogin(
          token: data["accessToken"],
          role: data["role"],
        );

        return data;
      } else {
        throw data["message"] ?? "Invalid email or password";
      }
    } catch (e) {
      if (e.toString().contains("Invalid password")) {
        throw "Invalid email or password";
      }
      throw "Something went wrong";
    }
  }

  Future<String> sendOtpEmail(String email) async {
    try {
      final response = await ApiClient.post("$baseUrl/send-otp", {
        "email": email,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data.toString();
      } else {
        throw data["message"] ?? "Failed to send OTP";
      }
    } catch (e) {
      throw "Error: $e";
    }
  }

  Future<bool> verifyOtpEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await ApiClient.post("$baseUrl/verify-otp", {
        "email": email,
        "code": otp,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        throw data["message"] ?? "Invalid OTP";
      }
    } catch (e) {
      throw "Verification failed: $e";
    }
  }

  static Future<String> changeOldPassword({
    required String email,
    required String password,
    required String newPassword,
  }) async {
    final token = SharedPrefService.getToken();

    final url = Uri.parse("${ApiConfig.baseUrl}/change-old-password");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "email": email,
        "oldPassword": password,
        "newPassword": newPassword,
      }),
    );
    final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode == 200) {
      return data["message"] ?? "Password changed successfully";
    } else {
      throw Exception(data["message"] ?? "Something went wrong");
    }
  }
}
