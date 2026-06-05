import 'dart:convert';

class ReportModel {
  final int? id;
  final int? billId;
  final String centerName;
  final String centerAddress;
  final String patientId;
  final String patientName;
  final String patientAge;
  final String patientWeight;
  final String doctorName;
  final String labNo;
  final String sampleDate;
  final String reviewDate;
  final String reportDate;
  final String testStatus;
  final String tests;

  const ReportModel({
    this.id,
    this.billId,
    required this.centerName,
    required this.centerAddress,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientWeight,
    required this.doctorName,
    required this.labNo,
    required this.sampleDate,
    required this.reviewDate,
    required this.reportDate,
    required this.testStatus,
    required this.tests,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      billId: json['billId'],
      centerName: json['centerName'] ?? '',
      centerAddress: json['centerAddress'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientAge: json['patientAge'] ?? '',
      patientWeight: json['patientWeight'] ?? '',
      doctorName: json['doctorName'] ?? '',
      labNo: json['labNo'] ?? '',
      sampleDate: json['sampleDate'] ?? '',
      reviewDate: json['reviewDate'] ?? '',
      reportDate: json['reportDate'] ?? '',
      testStatus: json['testStatus'] ?? '',
      tests: json['tests'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      if (billId != null) "billId": billId,
      "centerName": centerName,
      "centerAddress": centerAddress,
      "patientId": patientId,
      "patientName": patientName,
      "patientAge": patientAge,
      "patientWeight": patientWeight,
      "doctorName": doctorName,
      "labNo": labNo,
      "sampleDate": sampleDate,
      "reviewDate": reviewDate,
      "reportDate": reportDate,
      "testStatus": testStatus,
      "tests": jsonDecode(tests),
    };
  }
}
