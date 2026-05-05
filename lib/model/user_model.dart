enum UserRole {
  admin,
  patient,
  doctor,
  nurse,
  doctorAssistant,
  cleaner,
  accountant,
  pharmacist,
  receptionist,
  pharmaceutical,
  diagnosticCenter,
  driver,
}

class UserModel {
  final String? nationalId;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final DateTime? dob;
  final String? weight;
  final String? imageUrl;
  final String? password;
  final String? newPassword;
  final String? institute;
  final String? degree;
  final String? license;
  final String? specialist;
  final bool? isActive;
  final UserRole? role;

  UserModel({
    this.nationalId,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.dob,
    this.weight,
    this.imageUrl,
    this.password,
    this.newPassword,
    this.institute,
    this.degree,
    this.license,
    this.specialist,
    this.isActive,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nationalId: json["nationalId"]?.toString() ?? '',
      name: json["name"] ?? '',
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
      weight: json["weight"]?.toString(),
      imageUrl: json["imageUrl"],
      password: json["password"],
      newPassword: json["newPassword"],
      institute: json["institute"],
      degree: json["degree"],
      license: json["license"],
      specialist: json["specialist"],
      isActive: json["isActive"] ?? false,
      dob: json["dob"] != null ? DateTime.tryParse(json["dob"]) : null,
      role: _parseRole(json["role"]),
    );
  }

  static UserRole? _parseRole(String? role) {
    switch (role?.toUpperCase()) {
      case "ADMIN":
        return UserRole.admin;
      case "PATIENT":
        return UserRole.patient;
      case "DOCTOR":
        return UserRole.doctor;
      case "NURSE":
        return UserRole.nurse;
      case "DOCTOR_ASSISTANT":
        return UserRole.doctorAssistant;
      case "CLEANER":
        return UserRole.cleaner;
      case "ACCOUNTANT":
        return UserRole.accountant;
      case "PHARMACIST":
        return UserRole.pharmacist;
      case "RECEPTIONIST":
        return UserRole.receptionist;
      case "PHARMACEUTICAL":
        return UserRole.pharmaceutical;
      case "DIAGNOSTIC_CENTER":
        return UserRole.diagnosticCenter;
      case "DRIVER":
        return UserRole.driver;
      default:
        return null;
    }
  }

  UserModel copyWith({
    String? nationalId,
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? dob,
    String? weight,
    String? imageUrl,
    String? password,
    String? newPassword,
    String? institute,
    String? degree,
    String? license,
    String? specialist,
    bool? isActive,
    UserRole? role,
  }) {
    return UserModel(
      nationalId: nationalId ?? this.nationalId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
      password: password ?? this.password,
      newPassword: newPassword ?? this.newPassword,
      institute: institute ?? this.institute,
      degree: degree ?? this.degree,
      license: license ?? this.license,
      specialist: specialist ?? this.specialist,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }

  String? get roleValue {
    switch (role) {
      case UserRole.admin:
        return "ADMIN";
      case UserRole.patient:
        return "PATIENT";
      case UserRole.doctor:
        return "DOCTOR";
      case UserRole.nurse:
        return "NURSE";
      case UserRole.doctorAssistant:
        return "DOCTOR_ASSISTANT";
      case UserRole.cleaner:
        return "CLEANER";
      case UserRole.accountant:
        return "ACCOUNTANT";
      case UserRole.pharmacist:
        return "PHARMACIST";
      case UserRole.receptionist:
        return "RECEPTIONIST";
      case UserRole.pharmaceutical:
        return "PHARMACEUTICAL";
      case UserRole.diagnosticCenter:
        return "DIAGNOSTIC_CENTER";
      case UserRole.driver:
        return "DRIVER";
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "nationalId": nationalId,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "dob": dob != null
          ? "${dob!.year}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}"
          : null,
      "password": password,
      "newPassword": newPassword,
      "weight": weight,
      "imageUrl": imageUrl,
      "institute": institute,
      "degree": degree,
      "license": license,
      "specialist": specialist,
      "isActive": isActive,
      "role": roleValue,
    };
  }

  int? get age {
    if (dob == null) return null;
    final today = DateTime.now();
    int age = today.year - dob!.year;

    if (today.month < dob!.month ||
        (today.month == dob!.month && today.day < dob!.day)) {
      age--;
    }
    return age;
  }
}
