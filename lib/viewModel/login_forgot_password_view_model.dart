import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../service/auth_service.dart';

class LoginForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isButtonEnabled = false;
  bool isLoading = false;
  String? errorMessage;

  LoginForgotPasswordViewModel() {
    emailController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      errorMessage = null;
      isButtonEnabled = false;
    } else if (!email.contains("@") || !email.contains(".")) {
      errorMessage = "Enter valid email";
      isButtonEnabled = false;
    } else {
      errorMessage = null;
      isButtonEnabled = true;
    }
    notifyListeners();
  }

  Future<UserModel?> sendOtp(BuildContext context) async {
    if (!isButtonEnabled) return null;
    isLoading = true;
    notifyListeners();
    try {
      final email = emailController.text.trim();
      final message = await _authService.sendOtpEmail(email);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return UserModel(email: email);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
