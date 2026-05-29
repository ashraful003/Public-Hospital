class DoseModel {
  final int? id;
  final String dose;
  final String nationalId;

  DoseModel({
    this.id,
    required this.dose,
    required this.nationalId,
  });

  factory DoseModel.fromJson(Map<String, dynamic> json) {
    return DoseModel(
      id: json['id'],
      dose: json['dose'] ?? '',
      nationalId: json['nationalId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "dose": dose,
      "nationalId": nationalId,
    };
  }
}