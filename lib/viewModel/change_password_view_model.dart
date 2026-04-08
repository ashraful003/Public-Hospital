import 'dart:convert';
import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final UserModel user;

  ChangePasswordViewModel({required this.user}) {
    _addListeners();
  }

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmVisible = false;
  bool isLoading = false;
  String? errorMessage;

  String get baseUrl => ApiConfig.baseUrl;

  void _addListeners() {
    passwordController.addListener(_validateForm);
    confirmController.addListener(_validateForm);
  }

  void togglePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirm() {
    isConfirmVisible = !isConfirmVisible;
    notifyListeners();
  }

  bool get isButtonEnabled {
    final pass = passwordController.text.trim();
    final confirm = confirmController.text.trim();
    return pass.isNotEmpty && confirm.isNotEmpty && pass == confirm;
  }

  void _validateForm() {
    final pass = passwordController.text.trim();
    final confirm = confirmController.text.trim();
    if (pass.isEmpty || confirm.isEmpty) {
      errorMessage = null;
    } else if (pass != confirm) {
      errorMessage = "Passwords do not match";
    } else {
      errorMessage = null;
    }
    notifyListeners();
  }

  Future<void> changePassword(BuildContext context) async {
    if (!isButtonEnabled) return;

    isLoading = true;
    notifyListeners();
    try {
      final response = await ApiClient.post("$baseUrl/change-password", {
        "email": user.email,
        "newPassword": passwordController.text.trim(),
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password changed successfully")),
        );
        Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      } else {
        throw data["message"] ?? "Failed to change password";
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}
