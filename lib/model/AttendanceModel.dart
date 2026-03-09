class AttendanceModel {
  final String nationalId;
  final String name;
  String? checkIn;
  String? checkOut;
  bool isPresent;
  String time;
  String date;

  AttendanceModel({
    required this.nationalId,
    required this.name,
    this.checkIn,
    this.checkOut,
    this.isPresent = false,
    required this.time,
    required this.date,
  });
}