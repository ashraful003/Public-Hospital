class DurationModel {
  final int id;
  final String nationalId;
  final String duration;

  DurationModel({
    required this.id,
    required this.nationalId,
    required this.duration,
  });

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(
      id: json['id'],
      nationalId: json['nationalId'],
      duration: json['duration'],
    );
  }
}