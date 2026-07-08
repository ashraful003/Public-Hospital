import 'dart:convert';

class PrescriptionModel {
  final int id;
  final String doctorName;
  final String doctorBnName;
  final String doctorDegree;
  final String doctorBnDegree;
  final String doctorSpecialist;
  final String doctorBnSpecialist;
  final String doctorInstitute;
  final String doctorBnInstitute;
  final String doctorLicense;
  final String doctorBnLicense;
  final String doctorBnVisitingTime;
  final String patientId;
  final String patientName;
  final String patientAge;
  final String patientWeight;
  final String problems;
  final String bloodPressure;
  final String pulse;
  final String temperature;
  final List<Map<String, dynamic>> medicines;
  final List<String> tests;
  final String advice;
  final String nextMeet;
  final DateTime date;

  PrescriptionModel({
    required this.id,
    required this.doctorName,
    required this.doctorBnName,
    required this.doctorDegree,
    required this.doctorBnDegree,
    required this.doctorSpecialist,
    required this.doctorBnSpecialist,
    required this.doctorInstitute,
    required this.doctorBnInstitute,
    required this.doctorLicense,
    required this.doctorBnLicense,
    required this.doctorBnVisitingTime,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientWeight,
    required this.problems,
    required this.bloodPressure,
    required this.pulse,
    required this.temperature,
    required this.medicines,
    required this.tests,
    required this.advice,
    required this.nextMeet,
    required this.date,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> medicinesData = [];
    try {
      final rawMedicines = json["medicines"];
      if (rawMedicines != null) {
        if (rawMedicines is String && rawMedicines.isNotEmpty) {
          final decoded = jsonDecode(rawMedicines);
          medicinesData = List<Map<String, dynamic>>.from(decoded);
        } else if (rawMedicines is List) {
          medicinesData = List<Map<String, dynamic>>.from(rawMedicines);
        }
      }
    } catch (e) {
      print("Medicine Parse Error: $e");
      medicinesData = [];
    }
    List<String> testsData = [];
    try {
      final rawTests = json["tests"];
      if (rawTests != null) {
        if (rawTests is String && rawTests.isNotEmpty) {
          final decoded = jsonDecode(rawTests);
          testsData = List<String>.from(decoded);
        } else if (rawTests is List) {
          testsData = List<String>.from(rawTests);
        }
      }
    } catch (e) {
      print("Test Parse Error: $e");
      testsData = [];
    }
    return PrescriptionModel(
      id: json["id"],
      doctorName: json["doctorName"]?.toString() ?? "",
      doctorBnName: json["doctorBnName"]?.toString() ?? "",
      doctorDegree: json["doctorDegree"]?.toString() ?? "",
      doctorBnDegree: json["doctorBnDegree"]?.toString() ?? "",
      doctorSpecialist: json["doctorSpecialist"]?.toString() ?? "",
      doctorBnSpecialist: json["doctorBnSpecialist"]?.toString() ?? "",
      doctorInstitute: json["doctorInstitute"]?.toString() ?? "",
      doctorBnInstitute: json["doctorBnInstitute"]?.toString() ?? "",
      doctorLicense: json["doctorLicense"]?.toString() ?? "",
      doctorBnLicense: json["doctorBnLicense"]?.toString() ?? "",
      doctorBnVisitingTime: json["doctorBnVisitingTime"]?.toString() ?? "",
      patientId: json["patientId"]?.toString() ?? "",
      patientName: json["patientName"]?.toString() ?? "",
      patientAge: json["patientAge"]?.toString() ?? "",
      patientWeight: json["patientWeight"]?.toString() ?? "",
      problems: json["problems"]?.toString() ?? "",
      bloodPressure: json["bloodPressure"]?.toString() ?? "",
      pulse: json["pulse"]?.toString() ?? "",
      temperature: json["temperature"]?.toString() ?? "",
      medicines: medicinesData,
      tests: testsData,
      advice: json["advice"]?.toString() ?? "",
      nextMeet: json["nextMeet"]?.toString() ?? "",
      date: json["date"] != null
          ? DateTime.tryParse(json["date"].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}