import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../data/shared_pref_service.dart';
import '../../model/user_model.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';
import '../../view/login/login_input_screen.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel? _user;
  File? _pickedImage;
  bool isLoading = false;
  bool showChangePassword = false;

  UserModel? get user => _user;

  File? get pickedImage => _pickedImage;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> loadProfile(String dashboardRole) async {
    try {
      isLoading = true;
      notifyListeners();
      final email = SharedPrefService.getString("remember_email");
      if (email == null || email.isEmpty) {
        throw Exception("Email not found in SharedPreferences");
      }
      if (dashboardRole.isEmpty) {
        throw Exception("Role not found");
      }
      final url =
          "${ApiConfig.baseUrl}/profile?email=$email&role=$dashboardRole";
      final response = await ApiClient.get(url);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _user = UserModel.fromJson(json);
      } else {
        throw Exception(json["message"] ?? "Failed to load profile");
      }
    } catch (e) {
      debugPrint("Load Profile Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String email,
    required String name,
    required String phone,
    required String address,
    required String weight,
    required String license,
    required String degree,
    required String institute,
    required String specialist,
    required String dob,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      final url = Uri.parse("${ApiConfig.baseUrl}/update-profile");
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "name": name,
          "phone": phone,
          "address": address,
          "weight": weight,
          "license": license,
          "degree": degree,
          "institute": institute,
          "specialist": specialist,
          "dob": formatDob(dob),
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      debugPrint("Update Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> uploadProfileImage({
    required String email,
    required File imageFile,
  }) async {
    try {
      var uri = Uri.parse("${ApiConfig.baseUrl}/update-profile-image");
      var request = http.MultipartRequest("PUT", uri);
      request.fields['email'] = email;
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      var response = await request.send();
      final resBody = await response.stream.bytesToString();
      if (response.statusCode != 200) {
        throw Exception(resBody);
      }
      final data = jsonDecode(resBody);
      debugPrint("Upload Success: $data");
      return data["imageUrl"];
    } catch (e) {
      debugPrint("Upload Error: $e");
      return null;
    }
  }

  Future<void> pickImageAndUpload(String email) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;
    _pickedImage = File(picked.path);
    notifyListeners();
    final imageUrl = await uploadProfileImage(
      email: email,
      imageFile: _pickedImage!,
    );
    if (imageUrl != null) {
      _user = _user?.copyWith(imageUrl: imageUrl);
    }
    notifyListeners();
  }

  void toggleChangePassword() {
    showChangePassword = !showChangePassword;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await SharedPrefService.clear();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginInputScreen()),
      (route) => false,
    );
  }

  String formatDob(String input) {
    try {
      final parts = input.split("/");
      return "${parts[2]}-${parts[1]}-${parts[0]}";
    } catch (e) {
      return input;
    }
  }
}