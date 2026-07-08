import 'package:flutter/material.dart';
import '../../model/inpatient_bill.dart';
import '../../service/inpatient_bill_service.dart';

enum BillUpdateSubmitState { idle, submitting, success, error }

class InpatientBillUpdateViewModel extends ChangeNotifier {
  InpatientBillUpdateViewModel({InpatientBillService? billService})
    : _billService = billService ?? InpatientBillService() {
    for (final controller in _editableControllers) {
      controller.addListener(_onInputChanged);
    }
  }

  final InpatientBillService _billService;
  bool isLoading = false;
  String? loadError;
  InpatientBill? bill;
  BillUpdateSubmitState submitState = BillUpdateSubmitState.idle;
  String? submitError;
  double _bedRatePerDay = 0.0;

  double get bedRatePerDay => _bedRatePerDay;

  double get bedCharge => _bedRatePerDay * computedTotalDays;
  final TextEditingController doctorChargeController = TextEditingController();
  final TextEditingController operationChargeController =
      TextEditingController();
  final TextEditingController medicineChargeController =
      TextEditingController();
  final TextEditingController pathologyChargeController =
      TextEditingController();
  final TextEditingController radiologyChargeController =
      TextEditingController();
  final TextEditingController nursingChargeController = TextEditingController();
  final TextEditingController oxygenChargeController = TextEditingController();
  final TextEditingController otherChargeController = TextEditingController();

  List<TextEditingController> get _editableControllers => [
    doctorChargeController,
    operationChargeController,
    medicineChargeController,
    pathologyChargeController,
    radiologyChargeController,
    nursingChargeController,
    oxygenChargeController,
    otherChargeController,
  ];

  void _onInputChanged() => notifyListeners();

  double _d(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0.0;

  double get doctorCharge => _d(doctorChargeController);

  double get operationCharge => _d(operationChargeController);

  double get medicineCharge => _d(medicineChargeController);

  double get pathologyCharge => _d(pathologyChargeController);

  double get radiologyCharge => _d(radiologyChargeController);

  double get nursingCharge => _d(nursingChargeController);

  double get oxygenCharge => _d(oxygenChargeController);

  double get otherCharge => _d(otherChargeController);

  double get discount => bill?.discount ?? 0.0;

  double get vat => bill?.vat ?? 0.0;

  int get computedTotalDays {
    final billDate = bill?.billDate;
    if (billDate == null) {
      return bill?.totalDays ?? 1;
    }
    final today = DateTime.now();
    final billDateOnly = DateTime(billDate.year, billDate.month, billDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    final differenceInDays = todayOnly.difference(billDateOnly).inDays;
    return differenceInDays < 1 ? 1 : differenceInDays + 1;
  }

  double get computedSubtotal =>
      bedCharge +
      doctorCharge +
      operationCharge +
      medicineCharge +
      pathologyCharge +
      radiologyCharge +
      nursingCharge +
      oxygenCharge +
      otherCharge;

  double get computedGrandTotal {
    final value = computedSubtotal - discount + vat;
    return value < 0 ? 0.0 : value;
  }

  double get existingPaidAmount => bill?.paidAmount ?? 0.0;

  double get computedDueAmount {
    final value = computedGrandTotal - existingPaidAmount;
    return value < 0 ? 0.0 : value;
  }

  Future<void> init(int billId) async {
    isLoading = true;
    loadError = null;
    notifyListeners();
    try {
      final loadedBill = await _billService.getBillById(billId);
      bill = loadedBill;
      _populateControllersFromBill(loadedBill);
    } catch (e) {
      loadError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _populateControllersFromBill(InpatientBill b) {
    final storedDays = b.totalDays ?? 0;
    _bedRatePerDay = storedDays > 0 ? (b.bedCharge / storedDays) : b.bedCharge;
    doctorChargeController.text = _formatOrEmpty(b.doctorCharge);
    operationChargeController.text = _formatOrEmpty(b.operationCharge);
    medicineChargeController.text = _formatOrEmpty(b.medicineCharge);
    pathologyChargeController.text = _formatOrEmpty(b.pathologyCharge);
    radiologyChargeController.text = _formatOrEmpty(b.radiologyCharge);
    nursingChargeController.text = _formatOrEmpty(b.nursingCharge);
    oxygenChargeController.text = _formatOrEmpty(b.oxygenCharge);
    otherChargeController.text = _formatOrEmpty(b.otherCharge);
  }

  String _formatOrEmpty(double value) =>
      value == 0.0 ? '' : value.toStringAsFixed(2);

  Future<void> refreshBill() async {
    final currentBill = bill;
    if (currentBill?.id == null) return;
    try {
      final refreshed = await _billService.getBillById(currentBill!.id!);
      bill = refreshed;
      notifyListeners();
    } catch (_) {}
  }

  void resetToLoadedBill() {
    final currentBill = bill;
    if (currentBill == null) return;
    _populateControllersFromBill(currentBill);
    notifyListeners();
  }

  Future<bool> submitUpdate() async {
    submitError = null;
    final currentBill = bill;
    if (currentBill?.id == null) {
      submitError = 'Bill not loaded.';
      notifyListeners();
      return false;
    }
    if ([
      doctorCharge,
      operationCharge,
      medicineCharge,
      pathologyCharge,
      radiologyCharge,
      nursingCharge,
      oxygenCharge,
      otherCharge,
    ].any((charge) => charge < 0)) {
      submitError = 'Charges cannot be negative.';
      notifyListeners();
      return false;
    }
    submitState = BillUpdateSubmitState.submitting;
    notifyListeners();
    try {
      final loaded = currentBill!;
      final updatedBill = InpatientBill(
        id: loaded.id,
        admissionId: loaded.admissionId,
        patientId: loaded.patientId,
        patientName: loaded.patientName,
        doctorId: loaded.doctorId,
        doctorName: loaded.doctorName,
        seatNo: loaded.seatNo,
        seatType: loaded.seatType,
        totalDays: computedTotalDays,
        bedCharge: bedCharge,
        doctorCharge: doctorCharge,
        operationCharge: operationCharge,
        medicineCharge: medicineCharge,
        pathologyCharge: pathologyCharge,
        radiologyCharge: radiologyCharge,
        nursingCharge: nursingCharge,
        oxygenCharge: oxygenCharge,
        otherCharge: otherCharge,
        discount: discount,
        vat: vat,
        subtotal: computedSubtotal,
        grandTotal: computedGrandTotal,
        paidAmount: loaded.paidAmount,
        dueAmount: computedDueAmount,
        paymentStatus: loaded.paymentStatus,
        paymentMethod: loaded.paymentMethod,
        paidById: loaded.paidById,
        paidByName: loaded.paidByName,
        paymentDate: loaded.paymentDate,
        billStatus: loaded.billStatus,
        billDate: loaded.billDate,
        createdById: loaded.createdById,
        createdByName: loaded.createdByName,
      );
      bill = await _billService.updateBill(loaded.id!, updatedBill);
      _populateControllersFromBill(bill!);
      submitState = BillUpdateSubmitState.success;
      notifyListeners();
      return true;
    } catch (e) {
      submitError = e.toString();
      submitState = BillUpdateSubmitState.error;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    for (final controller in _editableControllers) {
      controller.removeListener(_onInputChanged);
      controller.dispose();
    }
    super.dispose();
  }
}