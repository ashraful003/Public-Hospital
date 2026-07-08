class DoctorBn {
  final int? id;
  final String doctorBnName;
  final String doctorBnId;
  final String doctorBnDegree;
  final String doctorBnSpecialist;
  final String doctorBnInstitute;
  final String doctorBnLicense;
  final String doctorBnVisitingTime;

  DoctorBn({
    this.id,
    required this.doctorBnName,
    required this.doctorBnId,
    required this.doctorBnDegree,
    required this.doctorBnSpecialist,
    required this.doctorBnInstitute,
    required this.doctorBnLicense,
    required this.doctorBnVisitingTime,
  });

  factory DoctorBn.fromJson(Map<String, dynamic> json) {
    return DoctorBn(
      id: json['id'],
      doctorBnName: json['doctorBnName'] ?? '',
      doctorBnId: json['doctorBnId'] ?? '',
      doctorBnDegree: json['doctorBnDegree'] ?? '',
      doctorBnSpecialist: json['doctorBnSpecialist'] ?? '',
      doctorBnInstitute: json['doctorBnInstitute'] ?? '',
      doctorBnLicense: json['doctorBnLicense'] ?? '',
      doctorBnVisitingTime: json['doctorBnVisitingTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "doctorBnName": doctorBnName,
      "doctorBnId": doctorBnId,
      "doctorBnDegree": doctorBnDegree,
      "doctorBnSpecialist": doctorBnSpecialist,
      "doctorBnInstitute": doctorBnInstitute,
      "doctorBnLicense": doctorBnLicense,
      "doctorBnVisitingTime": doctorBnVisitingTime,
    };
  }
}
