import 'user_model.dart';

class MakePrescriptionModel {
  final int? id;
  final UserModel? doctor;
  final UserModel? patient;
  final String? problems;
  final String? bloodPressure;
  final String? pulse;
  final String? temperature;
  final List<MedicineItem> medicines;
  final List<String> tests;
  final String? advice;
  final String? nextMeet;
  final DateTime? date;

  MakePrescriptionModel({
    this.id,
    this.doctor,
    this.patient,
    this.problems,
    this.bloodPressure,
    this.pulse,
    this.temperature,
    this.medicines = const [],
    this.tests = const [],
    this.advice,
    this.nextMeet,
    this.date,
  });

  factory MakePrescriptionModel.fromJson(Map<String, dynamic> json) {
    return MakePrescriptionModel(
      id: json["id"],
      doctor: json["doctor"] != null
          ? UserModel.fromJson(json["doctor"])
          : null,
      patient: json["patient"] != null
          ? UserModel.fromJson(json["patient"])
          : null,
      problems: json["problems"],
      bloodPressure: json["bloodPressure"],
      pulse: json["pulse"],
      temperature: json["temperature"],
      medicines: json["medicines"] != null
          ? List<MedicineItem>.from(
              json["medicines"].map((x) => MedicineItem.fromJson(x)),
            )
          : [],
      tests: json["tests"] != null ? List<String>.from(json["tests"]) : [],
      advice: json["advice"],
      nextMeet: json["nextMeet"],
      date: json["date"] != null ? DateTime.tryParse(json["date"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "doctor": doctor?.toJson(),
      "patient": patient?.toJson(),
      "problems": problems,
      "bloodPressure": bloodPressure,
      "pulse": pulse,
      "temperature": temperature,
      "medicines": medicines.map((e) => e.toJson()).toList(),
      "tests": tests,
      "advice": advice,
      "nextMeet": nextMeet,
      "date": date?.toIso8601String(),
    };
  }

  MakePrescriptionModel copyWith({
    int? id,
    UserModel? doctor,
    UserModel? patient,
    String? problems,
    String? bloodPressure,
    String? pulse,
    String? temperature,
    List<MedicineItem>? medicines,
    List<String>? tests,
    String? advice,
    String? nextMeet,
    DateTime? date,
  }) {
    return MakePrescriptionModel(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      patient: patient ?? this.patient,
      problems: problems ?? this.problems,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      pulse: pulse ?? this.pulse,
      temperature: temperature ?? this.temperature,
      medicines: medicines ?? this.medicines,
      tests: tests ?? this.tests,
      advice: advice ?? this.advice,
      nextMeet: nextMeet ?? this.nextMeet,
      date: date ?? this.date,
    );
  }
}

class MedicineItem {
  final String? type;
  final String? medicineName;
  final String? dose;
  final String? duration;
  final String? doseTime;

  MedicineItem({
    this.type,
    this.medicineName,
    this.dose,
    this.duration,
    this.doseTime,
  });

  factory MedicineItem.fromJson(Map<String, dynamic> json) {
    return MedicineItem(
      type: json["type"],
      medicineName: json["medicineName"],
      dose: json["dose"],
      duration: json["duration"],
      doseTime: json["doseTime"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "medicineName": medicineName,
      "dose": dose,
      "duration": duration,
      "doseTime": doseTime,
    };
  }

  MedicineItem copyWith({
    String? type,
    String? medicineName,
    String? dose,
    String? duration,
    String? instruction,
  }) {
    return MedicineItem(
      type: type ?? this.type,
      medicineName: medicineName ?? this.medicineName,
      dose: dose ?? this.dose,
      duration: duration ?? this.duration,
      doseTime: instruction ?? this.doseTime,
    );
  }
}
