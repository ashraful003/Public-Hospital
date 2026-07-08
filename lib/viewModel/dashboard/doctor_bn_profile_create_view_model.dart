import 'package:flutter/material.dart';
import '../../model/doctor_bn.dart';
import '../../service/doctor_bn_service.dart';

class DoctorBnCreateViewModel extends ChangeNotifier {
  final DoctorBnService _doctorBnService = DoctorBnService();
  final String doctorBnId;

  DoctorBnCreateViewModel({required this.doctorBnId}) {
    doctorBnIdController.text = doctorBnId;
  }

  bool isLoading = false;
  String? error;
  String? successMessage;
  final nameController = TextEditingController();
  final doctorBnIdController = TextEditingController();
  final degreeController = TextEditingController();
  final specialistController = TextEditingController();
  final instituteController = TextEditingController();
  final LicenseController = TextEditingController();
  final visitingTimeController = TextEditingController();

  Future<bool> createDoctor() async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();
    try {
      final newDoctor = DoctorBn(
        doctorBnName: nameController.text.trim(),
        doctorBnId: doctorBnId,
        doctorBnDegree: degreeController.text.trim(),
        doctorBnSpecialist: specialistController.text.trim(),
        doctorBnInstitute: instituteController.text.trim(),
        doctorBnLicense: LicenseController.text.trim(),
        doctorBnVisitingTime: visitingTimeController.text.trim(),
      );
      successMessage = await _doctorBnService.createDoctorBn(newDoctor);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    doctorBnIdController.dispose();
    degreeController.dispose();
    specialistController.dispose();
    instituteController.dispose();
    LicenseController.dispose();
    visitingTimeController.dispose();
    super.dispose();
  }
}
