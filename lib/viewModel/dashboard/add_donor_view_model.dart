import 'dart:convert';
import 'package:flutter/material.dart';
import '../../model/blood_bank_model.dart';
import '../../data/shared_pref_service.dart';
import '../../model/user_model.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';
import '../../service/blood_service.dart';

class AddDonorViewModel extends ChangeNotifier {
  final BloodService _service = BloodService();
  UserModel? _user;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final List<String> bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-",
  ];
  String? selectedBloodGroup;
  DateTime? selectedDate;
  bool isValid = false;
  bool isLoading = false;

  Future<void> loadProfile() async {
    try {
      isLoading = true;
      notifyListeners();
      final email = SharedPrefService.getString("remember_email");
      if (email == null || email.isEmpty) {
        throw Exception("Email not found");
      }
      final url = "${ApiConfig.baseUrl}/profile?email=$email";
      final response = await ApiClient.get(url);
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = jsonData is Map && jsonData.containsKey("data")
            ? jsonData["data"]
            : jsonData;
        _user = UserModel.fromJson(data);
        nameController.text = _user?.name ?? "";
        emailController.text = _user?.email ?? email;
        phoneController.text = _user?.phone ?? "";
        addressController.text = _user?.address ?? "";
        validateForm();
      } else {
        throw Exception(jsonData["message"] ?? "Failed to load profile");
      }
    } catch (e) {
      debugPrint("Load Profile Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setBloodGroup(String? value) {
    selectedBloodGroup = value;
    validateForm();
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate = picked;
      validateForm();
    }
  }

  void validateForm() {
    isValid =
        nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        selectedBloodGroup != null &&
        selectedDate != null;
    notifyListeners();
  }

  Future<bool> submit() async {
    final donor = BloodBankModel(
      name: nameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      address: addressController.text,
      bloodGroup: selectedBloodGroup!,
      lastDonateDate: selectedDate!,
    );
    return await _service.addProfile({
      "name": donor.name,
      "email": donor.email,
      "phoneNumber": donor.phoneNumber,
      "address": donor.address,
      "bloodGroup": donor.bloodGroup,
      "lastDonateDate": donor.lastDonateDate!.toIso8601String(),
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
