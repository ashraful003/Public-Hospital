import 'dart:convert';
import 'package:flutter/material.dart';
import '../../model/report_model.dart';
import '../../service/report_service.dart';

class ReportDetailsViewModel extends ChangeNotifier {
  final ReportService service;

  ReportDetailsViewModel({required this.service});

  bool _loading = false;

  bool get loading => _loading;
  ReportModel? _report;

  ReportModel? get report => _report;
  List<Map<String, dynamic>> _tests = [];

  List<Map<String, dynamic>> get tests => _tests;
  String _role = "";

  String get role => _role;

  void setRole(String role) {
    _role = role;
  }

  bool get canEdit => _role.toLowerCase() == "diagnostic_center";

  Future<void> loadReportById(int id) async {
    try {
      _loading = true;
      notifyListeners();
      _report = await service.getReportById(id);
      _tests = [];
      if (_report != null && _report!.tests.isNotEmpty) {
        final decoded = jsonDecode(_report!.tests);
        _tests = List<Map<String, dynamic>>.from(decoded);
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> reload() async {
    if (_report?.id != null) {
      await loadReportById(_report!.id!);
    }
  }
}