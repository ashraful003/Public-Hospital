class DoseTimeModel {
  final int? id;
  final String doseTime;
  final String nationalId;

  DoseTimeModel({this.id, required this.doseTime, required this.nationalId});

  factory DoseTimeModel.fromJson(Map<String, dynamic> json) {
    return DoseTimeModel(
      id: json['id'],
      doseTime: json['doseTime'],
      nationalId: json['nationalId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"doseTime": doseTime, "nationalId": nationalId};
  }
}
