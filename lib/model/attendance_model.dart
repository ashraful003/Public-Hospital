class AttendanceModel {
  final int? id;
  final String nationalId;
  final String name;
  final String date;
  final String? checkIn;
  final String? checkOut;

  AttendanceModel({
    this.id,
    required this.nationalId,
    required this.name,
    required this.date,
    this.checkIn,
    this.checkOut,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      nationalId: json['nationalId'],
      name: json['name'],
      date: json['date'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
    );
  }
}