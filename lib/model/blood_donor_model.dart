class BloodBankModel {
  final String nationalId;
  final String name;
  final String email;
  final String phoneNumber;
  final String bloodGroup;
  final DateTime lastDonationDate;
  final String address;

  BloodBankModel({
    required this.nationalId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.lastDonationDate,
    required this.address,
  });

  int get daysAgo {
    return DateTime.now().difference(lastDonationDate).inDays;
  }
}