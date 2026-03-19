import 'package:flutter/material.dart';
import '../../model/user_model.dart';

class StaffRegistrationViewModel extends ChangeNotifier {
  final nationalIdController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final instituteController = TextEditingController();
  final degreeController = TextEditingController();
  final licenseController = TextEditingController();
  final specialistController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  UserRole? selectedRole;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isButtonEnabled = false;

  StaffRegistrationViewModel() {
    _addListeners();
  }

  void _addListeners() {
    [
      nationalIdController,
      nameController,
      emailController,
      phoneController,
      addressController,
      dobController,
      instituteController,
      degreeController,
      licenseController,
      specialistController,
      passwordController,
      confirmPasswordController,
    ].forEach((controller) => controller.addListener(_validateForm));
  }

  bool get isDoctor => selectedRole == UserRole.doctor;

  bool get isNurse => selectedRole == UserRole.nurse;

  void setRole(UserRole role) {
    selectedRole = role;
    _validateForm();
    notifyListeners();
  }

  void togglePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  void _validateForm() {
    bool baseValid =
        nationalIdController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        instituteController.text.isNotEmpty &&
        degreeController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text &&
        selectedRole != null;

    bool roleValid = true;
    if (isDoctor) {
      roleValid =
          licenseController.text.isNotEmpty &&
          specialistController.text.isNotEmpty;
    } else if (isNurse) {
      roleValid = licenseController.text.isNotEmpty;
    }

    isButtonEnabled = baseValid && roleValid;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(1990),
    );
    if (picked != null) {
      dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      _validateForm();
    }
  }

  UserModel getStaffUserModel() {
    return UserModel(
      nationalId: nationalIdController.text,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
      dob: _parseDob(dobController.text),
      institute: instituteController.text,
      degree: degreeController.text,
      license: licenseController.text.isEmpty ? null : licenseController.text,
      specialist: specialistController.text.isEmpty
          ? null
          : specialistController.text,
      password: passwordController.text,
      role: selectedRole,
      isActive: true,
    );
  }

  DateTime? _parseDob(String text) {
    try {
      final parts = text.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return null;
  }

  @override
  void dispose() {
    [
      nationalIdController,
      nameController,
      emailController,
      phoneController,
      addressController,
      dobController,
      instituteController,
      degreeController,
      licenseController,
      specialistController,
      passwordController,
      confirmPasswordController,
    ].forEach((controller) => controller.dispose());
    super.dispose();
  }
}
