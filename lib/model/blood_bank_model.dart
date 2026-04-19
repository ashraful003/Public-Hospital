class BloodBankModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String bloodGroup;
  final DateTime? lastDonateDate;

  BloodBankModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.bloodGroup,
    this.lastDonateDate,
  });

  int get daysAgo {
    if (lastDonateDate == null) return 0;
    return DateTime.now().difference(lastDonateDate!).inDays;
  }

  factory BloodBankModel.fromJson(Map<String, dynamic> json) {
    return BloodBankModel(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      address: json['address'] ?? "",
      bloodGroup: json['bloodGroup'] ?? "",
      lastDonateDate: _parseDate(json['lastDonateDate']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    final str = value.toString().trim();
    if (str.isEmpty) return null;

    return DateTime.tryParse(str);
  }
}
