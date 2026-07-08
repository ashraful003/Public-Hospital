import 'package:flutter/material.dart';
import '../../model/doctor_bn.dart';
import '../../service/doctor_bn_service.dart';

class DoctorBnProfileUpdateViewModel extends ChangeNotifier {
  final DoctorBnService _doctorBnService = DoctorBnService();
  bool isLoading = false;
  String? error;
  String? successMessage;
  DoctorBn? doctor;
  final nameController = TextEditingController();
  final doctorBnIdController = TextEditingController();
  final degreeController = TextEditingController();
  final specialistController = TextEditingController();
  final instituteController = TextEditingController();
  final LicenseController = TextEditingController();
  final visitingTimeController = TextEditingController();

  Future<void> loadDoctor(String id) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      doctor = await _doctorBnService.getDoctorBnById(id);
      _populateControllers(doctor!);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _populateControllers(DoctorBn doctor) {
    nameController.text = doctor.doctorBnName;
    doctorBnIdController.text = doctor.doctorBnId;
    degreeController.text = doctor.doctorBnDegree;
    specialistController.text = doctor.doctorBnSpecialist;
    instituteController.text = doctor.doctorBnInstitute;
    LicenseController.text = doctor.doctorBnLicense;
    visitingTimeController.text = doctor.doctorBnVisitingTime;
  }

  Future<bool> updateDoctor(String id) async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();
    try {
      final updatedDoctor = DoctorBn(
        id: doctor?.id,
        doctorBnName: nameController.text.trim(),
        doctorBnId: doctor?.doctorBnId ?? doctorBnIdController.text.trim(),
        doctorBnDegree: degreeController.text.trim(),
        doctorBnSpecialist: specialistController.text.trim(),
        doctorBnInstitute: instituteController.text.trim(),
        doctorBnLicense: LicenseController.text.trim(),
        doctorBnVisitingTime: visitingTimeController.text.trim(),
      );
      successMessage = await _doctorBnService.updateDoctorBn(id, updatedDoctor);
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
