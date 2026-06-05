import 'dart:convert';
import 'package:flutter/material.dart';
import '../../model/report_model.dart';
import '../../service/report_service.dart';

class ReportUpdateViewModel extends ChangeNotifier {
  final ReportService service;

  ReportUpdateViewModel({required this.service});

  bool _loading = false;

  bool get loading => _loading;
  late ReportModel report;
  List<Map<String, dynamic>> tests = [];
  final Map<int, TextEditingController> resultControllers = {};
  final TextEditingController labNoController = TextEditingController();
  final TextEditingController sampleDateController = TextEditingController();
  final TextEditingController reviewDateController = TextEditingController();
  final TextEditingController reportDateController = TextEditingController();
  String status = "PENDING";

  List<Map<String, dynamic>> _parse(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (_) {
      return [];
    }
  }

  Future<void> loadReport(int reportId) async {
    try {
      _loading = true;
      notifyListeners();
      report = await service.getReportById(reportId);
      labNoController.text = report.labNo;
      sampleDateController.text = report.sampleDate;
      reviewDateController.text = report.reviewDate;
      reportDateController.text = report.reportDate;
      tests = _parse(report.tests);
      _initControllers();
      _updateStatus();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void _initControllers() {
    resultControllers.clear();
    for (int i = 0; i < tests.length; i++) {
      resultControllers[i] = TextEditingController(
        text: tests[i]["result"] ?? "",
      )..addListener(_updateStatus);
    }
    labNoController.addListener(_updateStatus);
    sampleDateController.addListener(_updateStatus);
    reviewDateController.addListener(_updateStatus);
    reportDateController.addListener(_updateStatus);
  }

  void _updateStatus() {
    final values = [
      labNoController.text,
      sampleDateController.text,
      reviewDateController.text,
      reportDateController.text,
      ...resultControllers.values.map((e) => e.text),
    ];
    final emptyCount = values.where((e) => e.trim().isEmpty).length;
    if (emptyCount == values.length) {
      status = "PENDING";
    } else if (emptyCount == 0) {
      status = "FINAL";
    } else {
      status = "PROCESSING";
    }
    notifyListeners();
  }

  Future<bool> updateReport() async {
    try {
      _loading = true;
      notifyListeners();
      for (int i = 0; i < tests.length; i++) {
        tests[i]["result"] = resultControllers[i]?.text.trim() ?? "";
      }
      final Map<String, dynamic> requestBody = {
        "id": report.id,
        "billId": report.billId,
        "centerName": report.centerName,
        "centerAddress": report.centerAddress,
        "patientId": report.patientId,
        "patientName": report.patientName,
        "patientAge": report.patientAge,
        "patientWeight": report.patientWeight,
        "doctorName": report.doctorName,
        "labNo": labNoController.text.trim(),
        "sampleDate": sampleDateController.text.trim(),
        "reviewDate": reviewDateController.text.trim(),
        "reportDate": reportDateController.text.trim(),
        "testStatus": status,
        "tests": tests,
      };
      await service.updateReport(reportId: report.id!, body: requestBody);
      return true;
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
    for (final controller in resultControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}