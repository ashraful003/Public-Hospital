class AppointmentModel {
  final int? id;
  final String? serialNo;
  final String? doctorId;
  final String? doctorName;
  final String? specialist;
  final String? patientId;
  final String? patientName;
  final String? date;
  final String? day;
  final String? startTime;
  final String? endTime;
  final String? status;
  final String? reason;
  final String? message;

  AppointmentModel({
    this.id,
    this.serialNo,
    this.doctorId,
    this.doctorName,
    this.specialist,
    this.patientId,
    this.patientName,
    this.date,
    this.day,
    this.startTime,
    this.endTime,
    this.status,
    this.reason,
    this.message,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      serialNo: json['serialNo']?.toString(),
      doctorId: json['doctorId']?.toString(),
      doctorName: json['doctorName']?.toString(),
      specialist: json['specialist']?.toString(),
      patientId: json['patientId']?.toString(),
      patientName: json['patientName']?.toString(),
      date: json['date']?.toString(),
      day: json['day']?.toString(),
      startTime: json['startTime']?.toString(),
      endTime: json['endTime']?.toString(),
      status: json['status']?.toString(),
      reason: json['reason']?.toString(),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "doctorId": doctorId,
      "doctorName": doctorName,
      "specialist": specialist,
      "patientId": patientId,
      "patientName": patientName,
      "date": date,
      "day": day,
      "startTime": startTime,
      "endTime": endTime,
      if (status != null) "status": status,
      if (reason != null) "reason": reason,
    };
  }
}