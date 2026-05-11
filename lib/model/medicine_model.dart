class MedicineModel {
  final int? id;
  final String? medicineName;
  final String? power;
  final String? name;
  final double? unitPrice;
  final double? totalPrice;
  final String? indications;
  final String? pharmacology;
  final String? dosage;
  final String? interaction;
  final String? contraindications;
  final String? sideEffects;
  final String? pregnancyLactation;
  final String? precautionsWarnings;
  final String? specialPopulations;
  final String? overdoseEffects;
  final String? reconstitution;
  final String? storageConditions;
  final String? chemicalStructure;

  MedicineModel({
    this.id,
    this.medicineName,
    this.power,
    this.name,
    this.unitPrice,
    this.totalPrice,
    this.indications,
    this.pharmacology,
    this.dosage,
    this.interaction,
    this.contraindications,
    this.sideEffects,
    this.pregnancyLactation,
    this.precautionsWarnings,
    this.specialPopulations,
    this.overdoseEffects,
    this.reconstitution,
    this.storageConditions,
    this.chemicalStructure,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json["id"],
      medicineName: json["medicineName"],
      power: json["power"],
      name: json["name"],
      unitPrice: json["unitPrice"] != null
          ? (json["unitPrice"] as num).toDouble()
          : null,
      totalPrice: json["totalPrice"] != null
          ? (json["totalPrice"] as num).toDouble()
          : null,
      indications: json["indications"],
      pharmacology: json["pharmacology"],
      dosage: json["dosage"],
      interaction: json["interaction"],
      contraindications: json["contraindications"],
      sideEffects: json["sideEffects"],
      pregnancyLactation: json["pregnancyLactation"],
      precautionsWarnings: json["precautionsWarnings"],
      specialPopulations: json["specialPopulations"],
      overdoseEffects: json["overdoseEffects"],
      reconstitution: json["reconstitution"],
      storageConditions: json["storageConditions"],
      chemicalStructure: json["chemicalStructure"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "medicineName": medicineName,
      "power": power,
      "name": name,
      "unitPrice": unitPrice,
      "totalPrice": totalPrice,
      "indications": indications,
      "pharmacology": pharmacology,
      "dosage": dosage,
      "interaction": interaction,
      "contraindications": contraindications,
      "sideEffects": sideEffects,
      "pregnancyLactation": pregnancyLactation,
      "precautionsWarnings": precautionsWarnings,
      "specialPopulations": specialPopulations,
      "overdoseEffects": overdoseEffects,
      "reconstitution": reconstitution,
      "storageConditions": storageConditions,
      "chemicalStructure": chemicalStructure,
    };
  }

  MedicineModel copyWith({
    int? id,
    String? medicineName,
    String? power,
    String? name,
    double? unitPrice,
    double? totalPrice,
    String? indications,
    String? pharmacology,
    String? dosage,
    String? interaction,
    String? contraindications,
    String? sideEffects,
    String? pregnancyLactation,
    String? precautionsWarnings,
    String? specialPopulations,
    String? overdoseEffects,
    String? reconstitution,
    String? storageConditions,
    String? chemicalStructure,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      power: power ?? this.power,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      indications: indications ?? this.indications,
      pharmacology: pharmacology ?? this.pharmacology,
      dosage: dosage ?? this.dosage,
      interaction: interaction ?? this.interaction,
      contraindications: contraindications ?? this.contraindications,
      sideEffects: sideEffects ?? this.sideEffects,
      pregnancyLactation: pregnancyLactation ?? this.pregnancyLactation,
      precautionsWarnings: precautionsWarnings ?? this.precautionsWarnings,
      specialPopulations: specialPopulations ?? this.specialPopulations,
      overdoseEffects: overdoseEffects ?? this.overdoseEffects,
      reconstitution: reconstitution ?? this.reconstitution,
      storageConditions: storageConditions ?? this.storageConditions,
      chemicalStructure: chemicalStructure ?? this.chemicalStructure,
    );
  }
}
