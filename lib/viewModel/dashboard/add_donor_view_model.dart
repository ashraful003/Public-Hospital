import 'package:flutter/material.dart';
import '../../model/blood_donor_model.dart';

class AddDonorViewModel extends ChangeNotifier {
  final nationalIdController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final lastDonationDateController = TextEditingController();
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
      lastDonationDateController.text =
          "${picked.day}/${picked.month}/${picked.year}";
      validateForm();
    }
  }

  void validateForm() {
    final emailPattern = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
    );
    isValid =
        nationalIdController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        emailPattern.hasMatch(emailController.text) &&
        phoneController.text.isNotEmpty &&
        selectedBloodGroup != null &&
        selectedDate != null;
    notifyListeners();
  }

  BloodBankModel getDonorModel() {
    return BloodBankModel(
      nationalId: nationalIdController.text,
      name: nameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      address: addressController.text,
      bloodGroup: selectedBloodGroup!,
      lastDonationDate: selectedDate!,
    );
  }

  void clearForm() {
    nationalIdController.clear();
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    selectedBloodGroup = null;
    lastDonationDateController.clear();
    selectedDate = null;
    isValid = false;
    notifyListeners();
  }
}
