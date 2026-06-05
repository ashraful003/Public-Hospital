import 'package:flutter/material.dart';
import '../../model/bill_model.dart';
import '../../service/bill_service.dart';

class BillHistoryViewModel extends ChangeNotifier {
  final BillService billService;

  BillHistoryViewModel({required this.billService});

  List<BillModel> _bills = [];

  List<BillModel> get bills => _bills;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String _error = '';

  String get error => _error;

  Future<void> loadPaidBills(String patientId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await billService.getPatientBills(patientId);
      _bills = result
          .where((bill) => bill.status.toUpperCase() == "PAID")
          .toList();
      _bills.sort((a, b) {
        final dateA = a.createdDate ?? DateTime.fromMillisecondsSinceEpoch(0);
        final dateB = b.createdDate ?? DateTime.fromMillisecondsSinceEpoch(0);
        return dateB.compareTo(dateA);
      });
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}