import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../service/diagnostic_center_service.dart';

class DiagnosticCenterViewModel extends ChangeNotifier {
  final DiagnosticCenterService service;

  DiagnosticCenterViewModel({required this.service});

  bool _loading = false;

  bool get loading => _loading;
  String? _error;

  String? get error => _error;
  List<UserModel> _allCenters = [];

  List<UserModel> get allCenters => _allCenters;
  List<UserModel> _centers = [];

  List<UserModel> get centers => _centers;
  final TextEditingController searchController = TextEditingController();

  Future<void> loadDiagnosticCenters() async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();
      _allCenters = await service.getAllDiagnosticCenters();
      _allCenters.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      _centers = List.from(_allCenters);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void search(String value) {
    if (value.trim().isEmpty) {
      _centers = List.from(_allCenters);
    } else {
      final query = value.toLowerCase();
      _centers = _allCenters.where((center) {
        return (center.name ?? "").toLowerCase().contains(query) ||
            (center.email ?? "").toLowerCase().contains(query) ||
            (center.phone ?? "").toLowerCase().contains(query);
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> deleteCenter(int id) async {
    try {
      _loading = true;
      notifyListeners();
      await service.deleteDiagnosticCenter(id);
      _allCenters.removeWhere((e) => e.id == id);
      _centers.removeWhere((e) => e.id == id);
      return true;
    } catch (e) {
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> reload() async {
    await loadDiagnosticCenters();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}