import 'package:flutter/cupertino.dart';
import '../../model/blood_bank_model.dart';

class BloodDonorDetailsViewModel extends ChangeNotifier {
  final BloodBankModel donor;

  BloodDonorDetailsViewModel({required this.donor});

  String get name => donor.name;

  String get email => donor.email;

  String get phone => donor.phoneNumber;

  String get bloodGroup => donor.bloodGroup;

  String get address => donor.address;

  int get daysAgo => donor.daysAgo;

  DateTime? get lastDonationDate => donor.lastDonateDate;
}
