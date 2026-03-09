class DoctorModel {
  final String nationalId;
  final String name;
  final String specialist;
  final String degree;
  final String hospital;
  final String address;
  final String phone;
  final DateTime dob;
  final String institute;
  final String? imageUrl;
  final bool isActive;

  DoctorModel({
    this.nationalId = '',
    required this.name,
    required this.specialist,
    required this.degree,
    required this.hospital,
    required this.address,
    required this.phone,
    required this.dob,
    required this.institute,
    this.imageUrl,
    required this.isActive,
  });
}