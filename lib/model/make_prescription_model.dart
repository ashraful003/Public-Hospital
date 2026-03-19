import 'user_model.dart';

class MakePrescriptionModel {
  final UserModel doctor;
  final UserModel patient;
  final String weight;
  final String problems;
  final String bloodPressure;
  final List<String> medicines;
  final DateTime date;

  MakePrescriptionModel({
    required this.doctor,
    required this.patient,
    required this.weight,
    required this.problems,
    required this.bloodPressure,
    required this.medicines,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      "doctor": {
        "name": doctor.name,
        "degree": doctor.degree,
        "address": doctor.address,
        "phone": doctor.phone,
        "specialist": doctor.specialist,
      },
      "patient": {
        "patientId": patient.nationalId,
        "name": patient.name,
        "age": patient.age,
        "weight": weight,
      },
      "complaints": problems,
      "diagnosis": bloodPressure,
      "medicines": medicines,
      "date": date.toIso8601String(),
    };
  }

  factory MakePrescriptionModel.fromJson(Map<String, dynamic> json) {
    return MakePrescriptionModel(
      doctor: UserModel(
        name: json["doctor"]["name"] ?? "Unknown",
        degree: json["doctor"]["degree"] ?? "",
        address: json["doctor"]["address"] ?? "",
        phone: json["doctor"]["phone"] ?? "",
        specialist: json["doctor"]["specialist"] ?? "",
        institute: json["doctor"]["institute"] ?? "",
        role: UserRole.doctor,
      ),

      patient: UserModel(
        name: json["patient"]["name"] ?? "",
        dob: DateTime.now(),
        nationalId: json["patient"]["patientId"] ?? "",
        weight: json["patient"]["weight"] ?? "",
        role: UserRole.patient,
      ),

      weight: json["patient"]["weight"] ?? "",
      problems: json["complaints"] ?? "",
      bloodPressure: json["diagnosis"] ?? "",
      medicines: List<String>.from(json["medicines"] ?? []),
      date: DateTime.parse(json["date"] ?? DateTime.now().toIso8601String()),
    );
  }
}