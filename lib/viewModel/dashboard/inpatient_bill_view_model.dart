import 'package:flutter/material.dart';
import '../../model/inpatient_bill.dart';
import '../../service/inpatient_bill_service.dart';

class InpatientBillViewModel extends ChangeNotifier {
  final InpatientBillService _service = InpatientBillService();
  final String role;
  final String patientId;

  InpatientBillViewModel({required this.role, required this.patientId});

  static const List<String> _privilegedRoles = [
    'admin',
    'accountant',
    'receptionist',
  ];
  List<InpatientBill> bills = [];
  List<InpatientBill> filteredBills = [];
  bool isLoading = false;

  bool get canViewAllBills =>
      _privilegedRoles.contains(role.trim().toLowerCase());

  Future<void> loadBills() async {
    isLoading = true;
    notifyListeners();
    try {
      bills = canViewAllBills
          ? await _service.getAllBills()
          : await _service.getBillsByPatientId(patientId);
      bills.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      filteredBills = List.from(bills);
    } catch (e) {
      bills = [];
      filteredBills = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void searchBills(String value) {
    if (value.isEmpty) {
      filteredBills = List.from(bills);
    } else {
      final query = value.toLowerCase();
      filteredBills = bills.where((bill) {
        return bill.patientName.toLowerCase().contains(query) ||
            bill.billStatus.toLowerCase().contains(query) ||
            bill.patientId.toString().contains(query) ||
            (bill.id?.toString() ?? '').contains(query);
      }).toList();
    }
    notifyListeners();
  }

  double get totalDue => bills.fold(0.0, (sum, bill) => sum + bill.dueAmount);
}