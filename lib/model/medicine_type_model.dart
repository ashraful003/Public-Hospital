class MedicineTypeModel {
  final int? id;
  final String medicineType;
  final String nationalId;

  MedicineTypeModel({
    this.id,
    required this.medicineType,
    required this.nationalId,
  });

  factory MedicineTypeModel.fromJson(Map<String, dynamic> json) {
    return MedicineTypeModel(
      id: json["id"],
      medicineType: json["medicineType"],
      nationalId: json["nationalId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"medicineType": medicineType, "nationalId": nationalId};
  }
}
