import 'package:flutter/material.dart';
import '../model/user_model.dart';

class SignUpViewModel extends ChangeNotifier {
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
    final parts = dobController.text.split("/");
    DateTime dob = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
    return UserModel(
      nationalId: nationalIdController.text,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
      dob: dob,
      password: passwordController.text,
      role: UserRole.patient,
      isActive: true,
    );
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
