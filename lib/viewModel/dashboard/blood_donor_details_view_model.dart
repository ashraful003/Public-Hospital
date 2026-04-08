import 'package:flutter/material.dart';
import '../../model/blood_donor_model.dart';

class BloodDonorDetailsViewModel extends ChangeNotifier {
  final BloodBankModel donor;

  BloodDonorDetailsViewModel({required this.donor});

  String get name => donor.name;
  String get email => donor.email;
  String get phone => donor.phoneNumber;
  String get bloodGroup => donor.bloodGroup;
  String get address => donor.address;
  String get nationalId => donor.nationalId;
  int get daysAgo => donor.daysAgo;
  DateTime get lastDonationDate => donor.lastDonationDate;
}