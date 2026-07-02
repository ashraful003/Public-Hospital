class HospitalAdmission {
  final int? id;
  final String? patientId;
  final String? patientName;
  final int? patientAge;
  final double? patientWeight;
  final String? patientAddress;
  final int? doctorId;
  final String? doctorName;
  final String? seatNo;
  final String? admissionType;
  final String? diagnosis;
  final String? remarks;
  final DateTime? admissionDate;
  final DateTime? expectedDischargeDate;
  final DateTime? dischargeDate;
  final String? status;
  final int? admitedById;
  final String? admitedByName;
  final int? dischargedById;
  final String? dischargedByName;

  HospitalAdmission({
    this.id,
    this.patientId,
    this.patientName,
    this.patientAge,
    this.patientWeight,
    this.patientAddress,
    this.doctorId,
    this.doctorName,
    this.seatNo,
    this.admissionType,
    this.diagnosis,
    this.remarks,
    this.admissionDate,
    this.expectedDischargeDate,
    this.dischargeDate,
    this.status,
    this.admitedById,
    this.admitedByName,
    this.dischargedById,
    this.dischargedByName,
  });

  factory HospitalAdmission.fromJson(Map<String, dynamic> json) {
    return HospitalAdmission(
      id: json['id'],
      patientId: json['patientId']?.toString(),
      patientName: json['patientName'],
      patientAge: json['patientAge'],
      patientWeight: (json['patientWeight'] as num?)?.toDouble(),
      patientAddress: json['patientAddress'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      seatNo: json['seatNo'],
      admissionType: json['admissionType'],
      diagnosis: json['diagnosis'],
      remarks: json['remarks'],
      admissionDate: json['admissionDate'] != null
          ? DateTime.parse(json['admissionDate'])
          : null,
      expectedDischargeDate: json['expectedDischargeDate'] != null
          ? DateTime.parse(json['expectedDischargeDate'])
          : null,
      dischargeDate: json['dischargeDate'] != null
          ? DateTime.parse(json['dischargeDate'])
          : null,
      status: json['status'],
      admitedById: json['admitedById'],
      admitedByName: json['admitedByName'],
      dischargedById: json['dischargedById'],
      dischargedByName: json['dischargedByName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientWeight': patientWeight,
      'patientAddress': patientAddress,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'seatNo': seatNo,
      'admissionType': admissionType,
      'diagnosis': diagnosis,
      'remarks': remarks,
      'admissionDate': admissionDate?.toIso8601String(),
      'expectedDischargeDate': expectedDischargeDate?.toIso8601String(),
      'dischargeDate': dischargeDate?.toIso8601String(),
      'status': status,
      'admitedById': admitedById,
      'admitedByName': admitedByName,
      'dischargedById': dischargedById,
      'dischargedByName': dischargedByName,
    };
  }
}