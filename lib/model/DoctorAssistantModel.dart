class DoctorAssistantModel {
  final String nationalId;
  final String name;
  final String email;
  final String address;
  final String phone;
  final DateTime dob;
  final String institute;
  final String degree;
  final bool isActive;
  final String? imageUrl;

  DoctorAssistantModel({
    required this.nationalId,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.dob,
    required this.institute,
    required this.degree,
    required this.isActive,
    this.imageUrl,
});
}