import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../service/auth_service.dart';

class StaffRegistrationViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
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
  bool isLoading = false;

  StaffRegistrationViewModel() {
    _addListeners();
  }

  bool get isDoctor => selectedRole == UserRole.doctor;

  bool get isNurse => selectedRole == UserRole.nurse;

  bool get isDriver => selectedRole == UserRole.driver;

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
    ].forEach((c) => c.addListener(_validateForm));
  }

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

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(1995),
    );
    if (picked != null) {
      dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      _validateForm();
    }
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
    } else if (isNurse || isDriver) {
      roleValid = licenseController.text.isNotEmpty;
    }
    isButtonEnabled = baseValid && roleValid;
    notifyListeners();
  }

  Future<bool> submitStaff(BuildContext context) async {
    if (isLoading) return false;
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return false;
    }
    try {
      isLoading = true;
      notifyListeners();
      final user = _buildUserModel();
      final response = await _authService.register(user);
      isLoading = false;
      notifyListeners();
      if (response != null) {
        clearFields();
        return true;
      }
      return false;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      return false;
    }
  }

  UserModel _buildUserModel() {
    return UserModel(
      nationalId: nationalIdController.text.trim(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      dob: _parseDob(),
      institute: instituteController.text.trim(),
      degree: degreeController.text.trim(),
      license: licenseController.text.isEmpty
          ? null
          : licenseController.text.trim(),
      specialist: specialistController.text.isEmpty
          ? null
          : specialistController.text.trim(),
      password: passwordController.text.trim(),
      role: selectedRole,
      isActive: true,
    );
  }

  DateTime? _parseDob() {
    try {
      final parts = dobController.text.split('/');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  void clearFields() {
    nationalIdController.clear();
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    dobController.clear();
    instituteController.clear();
    degreeController.clear();
    licenseController.clear();
    specialistController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    selectedRole = null;
    isButtonEnabled = false;
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
