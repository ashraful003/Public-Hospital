class AppointmentSchedule {
  final int? id;
  final String nationalId;
  final String day;
  final DateTime date;
  final String startTime;
  final String endTime;

  AppointmentSchedule({
    this.id,
    required this.nationalId,
    required this.day,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory AppointmentSchedule.fromJson(Map<String, dynamic> json) {
    return AppointmentSchedule(
      id: json['id'] as int?,
      nationalId: json['nationalId'] as String,
      day: json['day'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nationalId': nationalId,
      'day': day,
      'date': date.toIso8601String().split('T').first,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  String get formattedDate =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  @override
  String toString() {
    return 'AppointmentSchedule{id: $id, nationalId: $nationalId, day: $day, '
        'date: $date, startTime: $startTime, endTime: $endTime}';
  }
}
