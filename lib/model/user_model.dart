class UserModel {
  final String name;
  final String email;
  final String phone;
  final String address;
  final DateTime dob;
  final String password;
  final String? patientId;
  final String weight;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.dob,
    required this.password,
    this.patientId,
    required this.weight,
  });

  int get age {
    final today = DateTime.now();
    int age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }
}