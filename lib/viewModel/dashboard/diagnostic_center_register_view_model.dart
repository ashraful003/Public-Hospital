import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../service/auth_service.dart';

class DiagnosticCenterRegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final nationalIdController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final licenseController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isButtonEnable = false;

  DiagnosticCenterRegisterViewModel() {
    _addListeners();
  }

  void _addListeners() {
    nationalIdController.addListener(_validate);
    nameController.addListener(_validate);
    emailController.addListener(_validate);
    phoneController.addListener(_validate);
    addressController.addListener(_validate);
    dobController.addListener(_validate);
    licenseController.addListener(_validate);
    passwordController.addListener(_validate);
    confirmPasswordController.addListener(_validate);
  }

  void _validate() {
    final valid =
        nationalIdController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        licenseController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;
    if (isButtonEnable != valid) {
      isButtonEnable = valid;
      notifyListeners();
    }
  }

  void togglePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  UserModel _buildModel() {
    DateTime? dob;
    try {
      final parts = dobController.text.split("/");
      if (parts.length == 3) {
        dob = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}
    return UserModel(
      nationalId: nationalIdController.text.trim(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      dob: dob,
      license: licenseController.text.trim(),
      password: passwordController.text.trim(),
      role: UserRole.diagnosticCenter,
      isActive: true,
    );
  }

  Future<bool> register(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return false;
    }
    try {
      isLoading = true;
      notifyListeners();
      final user = _buildModel();
      await _authService.register(user);
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Diagnostic Center Registered")),
      );
      clear();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }

  void clear() {
    nationalIdController.clear();
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    dobController.clear();
    licenseController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void dispose() {
    nationalIdController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dobController.dispose();
    licenseController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}