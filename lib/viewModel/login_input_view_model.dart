import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../data/shared_pref_service.dart';
import '../service/auth_service.dart';
import '../utils/pref_keys.dart';

class LoginInputViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;
  bool isButtonEnable = false;
  bool isLoading = false;
  String? userRole;

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
            passwordController.text.trim().isNotEmpty &&
            rememberMe;

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
    _validateForm();
    notifyListeners();
  }

  void _loadRememberMe() {
    final savedEmail = SharedPrefService.getString(PrefKeys.rememberEmail);
    final savedPassword = SharedPrefService.getString(
      PrefKeys.rememberPassword,
    );
    if (savedEmail != null &&
        savedPassword != null &&
        savedEmail.isNotEmpty &&
        savedPassword.isNotEmpty) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe = true;
      notifyListeners();
    }
  }

  Future<String?> login() async {
    if (!isButtonEnable || isLoading) return null;

    isLoading = true;
    notifyListeners();

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final response = await _authService.login(
        email: email,
        password: password,
      );

      final token = response["accessToken"] ?? response["token"];
      if (token == null || token.toString().isEmpty) {
        throw Exception("Token not found");
      }

      Map<String, dynamic> decodedToken = {};
      String? role;

      try {
        decodedToken = JwtDecoder.decode(token);
        debugPrint("Decoded Token: $decodedToken");

        role = decodedToken["role"]?.toString();

        if (role == null || role.isEmpty) {
          final authorities = decodedToken["authorities"];
          if (authorities is List && authorities.isNotEmpty) {
            role = authorities.first.toString();
          }
        }
      } catch (e) {
        debugPrint("JWT decode failed: $e");
      }

      role ??= response["role"]?.toString() ?? response["ROLE"]?.toString();

      if (role == null || role.isEmpty) {
        throw Exception("Role not found");
      }
      userRole = role;
      await SharedPrefService.saveLogin(token: token, role: role);
      if (rememberMe) {
        await SharedPrefService.saveRememberMe(
          email: email,
          password: password,
        );
      } else {
        await SharedPrefService.clearRememberMe();
      }

      return role;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
