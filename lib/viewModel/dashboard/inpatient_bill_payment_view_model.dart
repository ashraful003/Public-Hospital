import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/inpatient_bill.dart';
import '../../model/user_model.dart';
import '../../service/inpatient_bill_service.dart';
import '../../service/profile_service.dart';

enum PaymentSubmitState { idle, submitting, success, error }

class InpatientBillPaymentViewModel extends ChangeNotifier {
  InpatientBillPaymentViewModel({
    InpatientBillService? billService,
    ProfileService? profileService,
  }) : _billService = billService ?? InpatientBillService(),
       _profileService = profileService ?? ProfileService() {
    discountController.addListener(_onInputChanged);
    totalPayController.addListener(_onInputChanged);
  }

  final InpatientBillService _billService;
  final ProfileService _profileService;
  static const String _emailPrefsKey = 'remember_email';
  static const double vatRate = 0.15;
  bool isLoading = false;
  String? loadError;
  InpatientBill? bill;
  UserModel? currentUser;
  PaymentSubmitState submitState = PaymentSubmitState.idle;
  String? submitError;
  final TextEditingController discountController = TextEditingController();
  final TextEditingController totalPayController = TextEditingController();
  String paymentMethod = 'CASH';
  final List<String> paymentMethods = const [
    'CASH',
    'CARD',
    'MOBILE_BANKING',
    'BANK_TRANSFER',
  ];

  double get subtotal => bill?.subtotal ?? 0.0;

  double get vatAmount => subtotal * vatRate;

  bool get hasDiscountInput => discountController.text.trim().isNotEmpty;

  bool get hasTotalPayInput => totalPayController.text.trim().isNotEmpty;

  double get discount => double.tryParse(discountController.text.trim()) ?? 0.0;

  double get totalPay => double.tryParse(totalPayController.text.trim()) ?? 0.0;

  double get grandTotal {
    final value = subtotal - discount + vatAmount;
    return value < 0 ? 0.0 : value;
  }

  double get currentDue {
    final alreadyPaid = bill?.paidAmount ?? 0.0;
    final value = grandTotal - alreadyPaid;
    return value < 0 ? 0.0 : value;
  }

  bool get isUnderpaid => hasTotalPayInput && totalPay < currentDue;

  bool get isOverpaid => hasTotalPayInput && totalPay > currentDue;

  bool get isExactPayment => hasTotalPayInput && totalPay == currentDue;

  double get remainingDue {
    final diff = currentDue - totalPay;
    return diff > 0 ? diff : 0.0;
  }

  double get changeAmount {
    final diff = totalPay - currentDue;
    return diff > 0 ? diff : 0.0;
  }

  double get newPaidAmount => (bill?.paidAmount ?? 0.0) + totalPay;

  double get newDueAmount {
    final value = grandTotal - newPaidAmount;
    return value < 0 ? 0.0 : value;
  }

  String get newPaymentStatus {
    if (newPaidAmount <= 0) return 'UNPAID';
    if (newDueAmount <= 0) return 'PAID';
    return 'PARTIAL';
  }

  void _onInputChanged() => notifyListeners();

  Future<void> init(int billId) async {
    isLoading = true;
    loadError = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_emailPrefsKey);
      if (email == null || email.isEmpty) {
        throw Exception('No logged-in user email found. Please log in again.');
      }
      final results = await Future.wait([
        _billService.getBillById(billId),
        _profileService.getProfile(email),
      ]);
      bill = results[0] as InpatientBill;
      currentUser = results[1] as UserModel?;
      if (currentUser == null) {
        throw Exception('Failed to load current user profile.');
      }
    } catch (e) {
      loadError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshBill() async {
    final currentBill = bill;
    if (currentBill?.id == null) return;
    try {
      bill = await _billService.getBillById(currentBill!.id!);
      notifyListeners();
    } catch (_) {}
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    notifyListeners();
  }

  Future<bool> submitPayment() async {
    submitError = null;
    final currentBill = bill;
    final user = currentUser;
    if (currentBill?.id == null) {
      submitError = 'Bill not loaded.';
      notifyListeners();
      return false;
    }
    if (user == null) {
      submitError = 'Current user not loaded.';
      notifyListeners();
      return false;
    }
    if (!hasTotalPayInput || totalPay <= 0) {
      submitError = 'Please enter a valid total pay amount.';
      notifyListeners();
      return false;
    }
    if (hasDiscountInput && discount < 0) {
      submitError = 'Discount cannot be negative.';
      notifyListeners();
      return false;
    }
    submitState = PaymentSubmitState.submitting;
    notifyListeners();
    try {
      final billToSend = currentBill!;
      final updatedBill = InpatientBill(
        id: billToSend.id,
        admissionId: billToSend.admissionId,
        patientId: billToSend.patientId,
        patientName: billToSend.patientName,
        doctorId: billToSend.doctorId,
        doctorName: billToSend.doctorName,
        seatNo: billToSend.seatNo,
        seatType: billToSend.seatType,
        totalDays: billToSend.totalDays,
        bedCharge: billToSend.bedCharge,
        doctorCharge: billToSend.doctorCharge,
        operationCharge: billToSend.operationCharge,
        medicineCharge: billToSend.medicineCharge,
        pathologyCharge: billToSend.pathologyCharge,
        radiologyCharge: billToSend.radiologyCharge,
        nursingCharge: billToSend.nursingCharge,
        oxygenCharge: billToSend.oxygenCharge,
        otherCharge: billToSend.otherCharge,
        discount: discount,
        vat: vatAmount,
        subtotal: subtotal,
        grandTotal: grandTotal,
        paidAmount: newPaidAmount,
        dueAmount: newDueAmount,
        paymentStatus: newPaymentStatus,
        paymentMethod: paymentMethod,
        paidById: int.tryParse(user.nationalId.toString()),
        paidByName: user.name,
        paymentDate: DateTime.now(),
        billStatus: billToSend.billStatus,
        billDate: billToSend.billDate,
        createdById: billToSend.createdById,
        createdByName: billToSend.createdByName,
      );
      bill = await _billService.updateBill(billToSend.id!, updatedBill);
      discountController.clear();
      totalPayController.clear();
      submitState = PaymentSubmitState.success;
      notifyListeners();
      return true;
    } catch (e) {
      submitError = e.toString();
      submitState = PaymentSubmitState.error;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    discountController.removeListener(_onInputChanged);
    totalPayController.removeListener(_onInputChanged);
    discountController.dispose();
    totalPayController.dispose();
    super.dispose();
  }
}