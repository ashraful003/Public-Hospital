import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';
import '../../model/appointment_model.dart';
import '../../model/user_model.dart';
import '../../service/appointment_service.dart';
import '../../service/profile_service.dart';

enum PatientType { self, other }

class NewAppointmentViewModel extends ChangeNotifier {
  final AppointmentService appointmentService;
  final ProfileService profileService;

  NewAppointmentViewModel({
    required this.appointmentService,
    required this.profileService,
  });

  bool loading = false;
  bool submitting = false;
  String? error;
  String? successMessage;
  UserModel? doctor;
  UserModel? patient;
  PatientType patientType = PatientType.self;
  String otherPatientName = "";
  String otherPatientId = "";
  List<AppointmentModel> schedules = [];

  List<String> get availableDates {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dates = schedules
        .map((s) => s.date)
        .whereType<String>()
        .where((d) => d.isNotEmpty)
        .map((d) {
          try {
            return DateTime.parse(d);
          } catch (e) {
            return null;
          }
        })
        .whereType<DateTime>()
        .where((date) => date.isAtSameMomentAs(today) || date.isAfter(today))
        .map((date) => date.toIso8601String().split("T").first)
        .toSet()
        .toList();
    dates.sort();
    return dates;
  }

  AppointmentModel? selectedSchedule;
  String? selectedDate;
  String day = "";
  String startTime = "";
  String endTime = "";

  void setPatientType(PatientType type) {
    patientType = type;
    if (type == PatientType.self) {
      otherPatientName = "";
      otherPatientId = "";
    }
    notifyListeners();
  }

  void setOtherPatientName(String value) {
    otherPatientName = value;
    notifyListeners();
  }

  void setOtherPatientId(String value) {
    otherPatientId = value;
    notifyListeners();
  }

  Future<void> loadInfo({required UserModel doctorInfo}) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      doctor = doctorInfo;
      final email = SharedPrefService.getString("remember_email");
      if (email == null || email.isEmpty) {
        throw Exception("User not logged in");
      }
      patient = await profileService.getProfile(email);

      if (patient == null) {
        throw Exception("Patient profile not found");
      }
      schedules = await appointmentService.getDoctorSchedules(
        doctor!.nationalId ?? "",
      );
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  void selectDate(String date) {
    selectedDate = date;
    final match = schedules.where((s) => s.date == date).toList();
    if (match.isEmpty) {
      selectedSchedule = null;
      day = "";
      startTime = "";
      endTime = "";
      error = "No schedule found for the selected date.";
      notifyListeners();
      return;
    }
    selectedSchedule = match.first;
    day = selectedSchedule?.day ?? "";
    startTime = selectedSchedule?.startTime ?? "-";
    endTime = selectedSchedule?.endTime ?? "-";
    error = null;
    notifyListeners();
  }

  bool get isFormValid {
    final baseValid =
        doctor != null && selectedSchedule != null && selectedDate != null;
    if (patientType == PatientType.self) {
      return baseValid && patient != null;
    } else {
      return baseValid &&
          otherPatientName.isNotEmpty &&
          otherPatientId.isNotEmpty;
    }
  }

  Future<bool> submitAppointment() async {
    if (!isFormValid) {
      error = "Please complete all required fields";
      notifyListeners();
      return false;
    }
    submitting = true;
    error = null;
    successMessage = null;
    notifyListeners();
    try {
      final appointment = AppointmentModel(
        doctorId: doctor!.nationalId ?? "",
        doctorName: doctor!.name ?? "",
        specialist: doctor!.specialist ?? "",
        patientId: patientType == PatientType.self
            ? (patient?.nationalId ?? "")
            : otherPatientId,
        patientName: patientType == PatientType.self
            ? (patient?.name ?? "")
            : otherPatientName,
        date: selectedSchedule!.date,
        day: selectedSchedule!.day,
        startTime: selectedSchedule!.startTime,
        endTime: selectedSchedule!.endTime,
      );
      final response = await appointmentService.createAppointment(appointment);
      successMessage = response.message ?? "Appointment booked successfully";
      error = null;
      return true;
    } catch (e) {
      successMessage = null;
      error = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      submitting = false;
      notifyListeners();
    }
  }
}
