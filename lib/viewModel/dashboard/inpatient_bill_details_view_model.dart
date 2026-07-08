import 'package:flutter/material.dart';
import '../../model/inpatient_bill.dart';
import '../../service/inpatient_bill_service.dart';

enum BillDetailsStatus { initial, loading, loaded, error }

class InpatientBillDetailsViewModel extends ChangeNotifier {
  final InpatientBillService _service = InpatientBillService();
  final String role;
  final int billId;

  InpatientBillDetailsViewModel({required this.role, required this.billId});

  InpatientBill? bill;
  BillDetailsStatus status = BillDetailsStatus.initial;
  String? errorMessage;

  Future<void> loadBill() async {
    status = BillDetailsStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      bill = await _service.getBillById(billId);
      status = BillDetailsStatus.loaded;
    } catch (e) {
      errorMessage = e.toString();
      status = BillDetailsStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => loadBill();
}