import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';
import '../../model/report_model.dart';
import '../../model/user_model.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';
import '../../service/report_service.dart';

class ReportsViewModel extends ChangeNotifier {
  final ReportService service;

  ReportsViewModel({required this.service});

  bool _loading = false;

  bool get loading => _loading;
  bool _isSearching = false;

  bool get isSearching => _isSearching;
  String _error = "";

  String get error => _error;
  String _role = "";

  String get role => _role;
  String _patientId = "";
  final TextEditingController searchController = TextEditingController();
  List<ReportModel> _reports = [];
  List<ReportModel> _allReports = [];

  List<ReportModel> get reports => _reports;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  final Map<int, TextEditingController> resultControllers = {};

  Future<void> initialize({
    required String role,
    required String patientId,
  }) async {
    _role = role;
    _patientId = patientId;
    await loadCurrentUser(role);
    await loadReports(role: role, patientId: patientId);
  }

  Future<void> reload() async {
    await loadReports(role: _role, patientId: _patientId);
  }

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

  Future<void> loadReports({
    required String role,
    required String patientId,
  }) async {
    try {
      _loading = true;
      notifyListeners();
      if (role == "diagnostic_center") {
        final centerName = _currentUser?.name ?? "";
        _allReports = await service.getReportsByCenterName(centerName);
      } else {
        _allReports = await service.getReportsByPatientId(patientId);
        _allReports = _allReports
            .where((report) => report.testStatus.toUpperCase() == "FINAL")
            .toList();
      }
      _allReports.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      _reports = List.from(_allReports);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void searchByPatientId(String value) {
    final query = value.trim().toLowerCase();
    _isSearching = query.isNotEmpty;
    if (query.isEmpty) {
      _reports = List.from(_allReports);
    } else {
      _reports = _allReports.where((report) {
        final patientId = report.patientId.toLowerCase();
        final testStatus = report.testStatus.toLowerCase();
        return patientId.contains(query) || testStatus.contains(query);
      }).toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
