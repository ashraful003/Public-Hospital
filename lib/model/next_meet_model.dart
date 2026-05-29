class NextMeetModel {
  final int id;
  final String nationalId;
  final String duration;

  NextMeetModel({
    required this.id,
    required this.nationalId,
    required this.duration,
  });

  factory NextMeetModel.fromJson(Map<String, dynamic> json) {
    return NextMeetModel(
      id: json['id'],
      nationalId: json['nationalId'],
      duration: json['duration'],
    );
  }
}