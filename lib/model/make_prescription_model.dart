import 'doctor_model.dart';
import 'user_model.dart';

class MakePrescriptionModel {
  final DoctorModel doctor;
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

  /// Convert object to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      "doctor": {
        "name": doctor.name,
        "degree": doctor.degree,
        "hospital": doctor.hospital,
        "address": doctor.address,
        "phone": doctor.phone,
      },
      "patient": {
        "name": patient.name,
        "patientId": patient.patientId,
        "age": patient.age,
        "weight": weight,
      },
      "complaints": problems,
      "diagnosis": bloodPressure,
      "medicines": medicines,
      "date": date.toIso8601String(),
    };
  }

  /// Create model from API JSON
  factory MakePrescriptionModel.fromJson(Map<String, dynamic> json) {
    return MakePrescriptionModel(
      doctor: DoctorModel(
        name: "Dr. John Doe",
        degree: "MBBS",
        hospital: "City Hospital",
        address: "123 Street",
        phone: "1234567890",
        specialist: 'Cardiologist',
        isActive: true,
        dob: DateTime(1980, 5, 15),
        institute: 'Medical Institute',
      ),

      patient: UserModel(
        name: json["patient"]["name"],
        email: "",
        phone: "",
        address: "",
        dob: DateTime.now(),
        password: "",
        patientId: json["patient"]["patientId"],
        weight: json["patient"]["weight"] ?? "",
      ),

      weight: json["patient"]["weight"] ?? "",
      problems: json["complaints"] ?? "",
      bloodPressure: json["diagnosis"] ?? "",
      medicines: List<String>.from(json["medicines"] ?? []),
      date: DateTime.parse(json["date"]),
    );
  }
}