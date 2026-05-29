class AdviceModel {
  final String? id;
  final String nationalId;
  final String title;
  final String advice;

  AdviceModel({
    this.id,
    required this.nationalId,
    required this.title,
    required this.advice,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nationalId": nationalId,
      "title": title,
      "advice": advice,
    };
  }

  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    return AdviceModel(
      id: json["id"]?.toString(),
      nationalId: json["nationalId"],
      title: json["title"],
      advice: json["advice"],
    );
  }
}