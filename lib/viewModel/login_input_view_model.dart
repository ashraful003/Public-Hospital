import 'package:flutter/material.dart';

import '../data/shared_pref_service.dart';
import '../utils/pref_keys.dart';
import '../service/auth_service.dart';

class LoginInputViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;
  bool isButtonEnable = false;
  bool isLoading = false;

  LoginInputViewModel() {
    _addListener();
    _loadRememberMe();
  }

  void _addListener() {
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;

    if (isButtonEnable != isValid) {
      isButtonEnable = isValid;
      notifyListeners();
    }
  }

  void togglePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  Future<void> _loadRememberMe() async {
    final savedEmail = await SharedPrefService.getString(
      PrefKeys.rememberEmail,
    );
    final savedPassword = await SharedPrefService.getString(
      PrefKeys.rememberPassword,
    );
    if (savedEmail != null &&
        savedEmail.isNotEmpty &&
        savedPassword != null &&
        savedPassword.isNotEmpty) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe = true;
      notifyListeners();
    }
  }

  Future<bool> login() async {
    if (!isButtonEnable || isLoading) return false;
    isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final token = response["token"] ?? response["accessToken"];
      if (token == null || token.isEmpty) {
        throw Exception("Token not found in response");
      }
      await SharedPrefService.setString(PrefKeys.token, token);
      await SharedPrefService.setBool(PrefKeys.isLoggedIn, true);
      await SharedPrefService.setString(
        PrefKeys.userEmail,
        emailController.text.trim(),
      );
      if (rememberMe) {
        await SharedPrefService.setString(
          PrefKeys.rememberEmail,
          emailController.text.trim(),
        );
        await SharedPrefService.setString(
          PrefKeys.rememberPassword,
          passwordController.text.trim(),
        );
      } else {
        await SharedPrefService.remove(PrefKeys.rememberEmail);
        await SharedPrefService.remove(PrefKeys.rememberPassword);
      }
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
