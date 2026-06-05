import 'package:flutter/material.dart';
import 'package:public_hospital/service/report_service.dart';
import '../../model/bill_model.dart';

class TestQueueViewModel extends ChangeNotifier {
  final ReportService service;

  TestQueueViewModel({required this.service});

  bool _loading = false;

  bool get loading => _loading;
  List<BillModel> _bills = [];
  List<BillModel> _filteredBills = [];

  List<BillModel> get bills => _filteredBills;
  String _searchText = "";

  Future<void> loadBills() async {
    try {
      _loading = true;
      notifyListeners();
      final allBills = await service.getAllBills();
      _bills = allBills.where((bill) {
        final status = bill.status.toUpperCase();
        final testStatus = bill.testStatus.toUpperCase();
        return (status == "PAID" || status == "PARTIAL") &&
            (testStatus == "PENDING");
      }).toList();
      _filteredBills = _bills;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void searchByPatientId(String value) {
    _searchText = value;
    if (_searchText.isEmpty) {
      _filteredBills = _bills;
    } else {
      _filteredBills = _bills.where((bill) {
        return bill.patientId.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}