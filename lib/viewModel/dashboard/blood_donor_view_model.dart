import 'package:flutter/material.dart';
import '../../model/blood_donor_model.dart';

class BloodBankViewModel extends ChangeNotifier {
  final List<BloodBankModel> _allDonors = [
    BloodBankModel(
      nationalId: "123",
      name: "Rahim Uddin",
      email: "rahim@gmail.com",
      phoneNumber: "01700000001",
      bloodGroup: "A+",
      lastDonationDate: DateTime.now().subtract(const Duration(days: 5)),
      address: "Dhaka",
    ),
    BloodBankModel(
      nationalId: "124",
      name: "Karim Hasan",
      email: "karim@gmail.com",
      phoneNumber: "01700000002",
      bloodGroup: "B+",
      lastDonationDate: DateTime.now().subtract(const Duration(days: 12)),
      address: "Gazipur",
    ),
    BloodBankModel(
      nationalId: "125",
      name: "Sadia Islam",
      email: "sadia@gmail.com",
      phoneNumber: "01700000003",
      bloodGroup: "O-",
      lastDonationDate: DateTime.now().subtract(const Duration(days: 30)),
      address: "Chattogram",
    ),
    BloodBankModel(
      nationalId: "126",
      name: "Nusrat Jahan",
      email: "nusrat@gmail.com",
      phoneNumber: "01700000004",
      bloodGroup: "AB+",
      lastDonationDate: DateTime.now().subtract(const Duration(days: 2)),
      address: "Khulna",
    ),
  ];
  List<BloodBankModel> _filteredDonors = [];

  List<BloodBankModel> get donors => _filteredDonors;

  BloodBankViewModel() {
    _filteredDonors = _allDonors;
  }

  void searchByBloodGroup(String query) {
    if (query.isEmpty) {
      _filteredDonors = _allDonors;
    } else {
      _filteredDonors = _allDonors
          .where(
            (donor) =>
                donor.bloodGroup.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  void addDonor(BloodBankModel donor) {
    _allDonors.add(donor);
    searchByBloodGroup("");
  }
}
