import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../service/auth_service.dart';
class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final nationalIdController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isButtonEnable = false;
  bool isLoading = false;
  SignUpViewModel() {
    _addListeners();
  }
  void _addListeners() {
    nationalIdController.addListener(_validateForm);
    nameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    addressController.addListener(_validateForm);
    dobController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
  }
  void _validateForm() {
    final isValid =
        nationalIdController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;
    if (isButtonEnable != isValid) {
      isButtonEnable = isValid;
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
  UserModel createUser() {
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
    } catch (_) {
      dob = null;
    }
    return UserModel(
      nationalId: nationalIdController.text.trim(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      dob: dob,
      password: passwordController.text.trim(),
      role: UserRole.admin,
      isActive: true,
    );
  }
  Future<bool> registerUser(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return false;
    }
    try {
      isLoading = true;
      notifyListeners();
      final user = createUser();
      final response = await _authService.register(user);
      isLoading = false;
      notifyListeners();
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration successful"),
          ),
        );
        clearFields();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${e.toString()}")));

      return false;
    }
  }
  void clearFields() {
    nationalIdController.clear();
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    dobController.clear();
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
