enum UserRole { patient, doctor, nurse, doctorAssistant, cleaner }

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
    this.password,
    this.institute,
    this.degree,
    this.license,
    this.specialist,
    this.weight,
    this.imageUrl,
    this.isActive,
    this.role,
  });

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
      institute: institute ?? this.institute,
      degree: degree ?? this.degree,
      license: license ?? this.license,
      specialist: specialist ?? this.specialist,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "phone": phone,
    };
  }
  int? get age {
    if (dob == null) return null; // handle nullable dob
    final today = DateTime.now();
    int age = today.year - dob!.year;

    if (today.month < dob!.month ||
        (today.month == dob!.month && today.day < dob!.day)) {
      age--;
    }
    return age;
  }
}