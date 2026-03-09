import 'package:flutter/material.dart';

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
  String? selectedRole;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isButtonEnable = false;

  StaffRegistrationViewModel() {
    _addListeners();
  }

  void _addListeners() {
    nationalIdController.addListener(_validateForm);
    nameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    addressController.addListener(_validateForm);
    dobController.addListener(_validateForm);
    instituteController.addListener(_validateForm);
    degreeController.addListener(_validateForm);
    licenseController.addListener(_validateForm);
    specialistController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
  }

  bool get isDoctor => selectedRole == "Doctor";

  bool get isNurse => selectedRole == "Nurse";

  void setRole(String role) {
    selectedRole = role;
    notifyListeners();
    _validateForm();
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

    final isValid = baseValid && roleValid;

    if (isButtonEnable != isValid) {
      isButtonEnable = isValid;
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text = "${picked.day}/${picked.month}/${picked.year}";
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

  @override
  void dispose() {
    nationalIdController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dobController.dispose();
    instituteController.dispose();
    degreeController.dispose();
    licenseController.dispose();
    specialistController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
