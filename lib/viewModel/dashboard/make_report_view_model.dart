import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';
import '../../model/bill_model.dart';
import '../../model/report_model.dart';
import '../../model/user_model.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';
import '../../service/report_service.dart';

class MakeReportViewModel extends ChangeNotifier {
  final ReportService service;

  MakeReportViewModel({required this.service});

  bool _loading = false;

  bool get loading => _loading;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  String _error = '';

  String get error => _error;
  BillModel? _bill;

  BillModel? get bill => _bill;
  final TextEditingController labNoController = TextEditingController();
  final TextEditingController sampleDateController = TextEditingController();
  final TextEditingController reviewDateController = TextEditingController();
  final TextEditingController reportDateController = TextEditingController();
  String status = "PENDING";
  final Map<int, TextEditingController> resultControllers = {};

  Future<void> loadCurrentUser(String role) async {
    try {
      final email = SharedPrefService.getString("remember_email");
      if (email == null || email.isEmpty) {
        throw Exception("Email not found");
      }
      final url = "${ApiConfig.baseUrl}/profile?email=$email&role=$role";
      final response = await ApiClient.get(url);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _currentUser = UserModel.fromJson(json);
      } else {
        throw Exception(json["message"] ?? "Failed to load profile");
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadBillById(int billId) async {
    try {
      _loading = true;
      notifyListeners();
      _bill = await service.getBillById(billId);
      final tests = parseTests(_bill?.selectedTests ?? "[]");
      _initTestControllers(tests.length);
      labNoController.text = "";
      sampleDateController.text = "";
      reviewDateController.text = "";
      reportDateController.text = "";
      status = "PENDING";
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void _initTestControllers(int length) {
    resultControllers.clear();
    for (int i = 0; i < length; i++) {
      resultControllers[i] = TextEditingController()
        ..addListener(_updateStatus);
    }
  }

  List<dynamic> parseTests(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded;
    } catch (_) {}
    return [];
  }

  void _updateStatus() {
    final allValues = [
      labNoController.text,
      sampleDateController.text,
      reviewDateController.text,
      reportDateController.text,
      ...resultControllers.values.map((e) => e.text),
    ];
    final emptyCount = allValues.where((e) => e.trim().isEmpty).length;
    final total = allValues.length;
    if (emptyCount == total) {
      status = "PENDING";
    } else if (emptyCount == 0) {
      status = "FINAL";
    } else {
      status = "PROCESSING";
    }
    notifyListeners();
  }

  Future<bool> createReport() async {
    try {
      _loading = true;
      notifyListeners();
      final tests = parseTests(_bill!.selectedTests);
      final updatedTests = List.generate(tests.length, (index) {
        final test = Map<String, dynamic>.from(tests[index]);
        test["result"] = resultControllers[index]?.text.trim() ?? "";
        return test;
      });
      final model = ReportModel(
        billId: _bill!.id,
        centerName: _currentUser?.name ?? "",
        centerAddress: _currentUser?.address ?? "",
        patientId: _bill!.patientId,
        patientName: _bill!.patientName,
        patientAge: _bill!.patientAge,
        patientWeight: _bill!.patientWeight,
        doctorName: _bill!.doctorName,
        labNo: labNoController.text.trim(),
        sampleDate: sampleDateController.text.trim(),
        reviewDate: reviewDateController.text.trim(),
        reportDate: reportDateController.text.trim(),
        testStatus: status,
        tests: jsonEncode(updatedTests),
      );
      await service.createReport(model);
      return true;
    } catch (e) {
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    labNoController.dispose();
    sampleDateController.dispose();
    reviewDateController.dispose();
    reportDateController.dispose();
    for (var c in resultControllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
