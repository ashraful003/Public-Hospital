class EmergencyContact {
  final int id;
  final String emergencyNumber;
  final String emergencyDoctorNumber;
  final String emergencyDoctorWhatsappNumber;

  EmergencyContact({
    required this.id,
    required this.emergencyNumber,
    required this.emergencyDoctorNumber,
    required this.emergencyDoctorWhatsappNumber,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      emergencyNumber: json['emergencyNumber'],
      emergencyDoctorNumber: json['emergencyDoctorNumber'],
      emergencyDoctorWhatsappNumber: json['emergencyDoctorWhatsappNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emergencyNumber': emergencyNumber,
      'emergencyDoctorNumber': emergencyDoctorNumber,
      'emergencyDoctorWhatsappNumber': emergencyDoctorWhatsappNumber,
    };
  }
}