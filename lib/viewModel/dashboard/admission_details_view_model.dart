import 'package:flutter/material.dart';
import '../../model/hospital_admission.dart';
import '../../model/inpatient_bill.dart';
import '../../service/hospital_admission_service.dart';
import '../../service/inpatient_bill_service.dart';

class AdmissionDetailsViewModel extends ChangeNotifier {
  final HospitalAdmissionService _admissionService = HospitalAdmissionService();
  final InpatientBillService _billService = InpatientBillService();
  HospitalAdmission? _admission;
  InpatientBill? _bill;
  bool _isLoading = false;
  bool _hasError = false;
  bool _billLookupFailed = false;
  String _errorMessage = '';

  HospitalAdmission? get admission => _admission;

  InpatientBill? get bill => _bill;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  String get errorMessage => _errorMessage;

  bool get canDischarge {
    if (_bill == null) return false;
    final status = _bill!.billStatus.trim().toLowerCase();
    return status == 'paid' || status == 'finalized';
  }

  String get dischargeBlockedReason {
    if (_billLookupFailed) {
      return 'Could not verify the bill status. Please refresh and try again.';
    }
    if (_bill == null) {
      return 'No bill found for this admission yet. Discharge is disabled until billing is complete.';
    }
    return 'Bill must be PAID or FINALIZED before this patient can be discharged.';
  }

  Future<void> loadAdmission({required int admissionId}) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      _admission = await _admissionService.getAdmissionById(admissionId);
      await _loadBillForAdmission();
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadBillForAdmission() async {
    _billLookupFailed = false;
    final admission = _admission;
    final patientId = admission?.patientId;
    if (admission == null || patientId == null) {
      _bill = null;
      return;
    }
    try {
      final bills = await _billService.getBillsByPatientId(patientId);
      _bill = bills.cast<InpatientBill?>().firstWhere(
        (bill) => bill?.admissionId == admission.id,
        orElse: () => null,
      );
    } catch (e) {
      _bill = null;
      _billLookupFailed = true;
    }
  }

  Future<void> refresh({required int admissionId}) async {
    await loadAdmission(admissionId: admissionId);
  }

  void clear() {
    _admission = null;
    _bill = null;
    _isLoading = false;
    _hasError = false;
    _billLookupFailed = false;
    _errorMessage = '';
    notifyListeners();
  }
}
