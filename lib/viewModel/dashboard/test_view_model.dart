import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';
import '../../model/test_model.dart';
import '../../model/user_model.dart';
import '../../service/profile_service.dart';
import '../../service/test_service.dart';

class TestViewModel extends ChangeNotifier {
  final TestService _service = TestService();
  final ProfileService _profileService = ProfileService();

  bool get canAdd => role == "DIAGNOSTIC_CENTER";

  bool get canEdit => role == "DIAGNOSTIC_CENTER";

  bool get canDelete => role == "ADMIN" || role == "DIAGNOSTIC_CENTER";
  List<TestModel> testList = [];
  List<TestModel> _allTests = [];
  String role = "";
  UserModel? currentUser;
  bool isLoading = false;
  String? errorMessage;
  String? addErrorMessage;
  String searchQuery = "";

  void setRole(String value) {
    role = value.toUpperCase();
  }

  Future<bool> addTest(Map<String, dynamic> body) async {
    try {
      isLoading = true;
      addErrorMessage = null;
      notifyListeners();
      await _service.addTest(body);
      await loadTests();
      return true;
    } catch (e) {
      addErrorMessage = e.toString().replaceAll("Exception:", "").trim();
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTests() async {
    try {
      isLoading = true;
      notifyListeners();
      final role = await SharedPrefService.getString("user_role") ?? "";
      final email = await SharedPrefService.getString("remember_email");
      if (email != null && email.isNotEmpty) {
        currentUser = await _profileService.getProfile(email);
      }
      List<TestModel> fetchedList = [];
      if (role.toUpperCase() == "ADMIN") {
        fetchedList = await _service.getAllTests();
      } else if (role.toUpperCase() == "DIAGNOSTIC_CENTER") {
        final diagnosticCenterName = currentUser?.name ?? "";
        fetchedList = await _service.getCenterTests(diagnosticCenterName);
      }
      final Map<String, TestModel> uniqueMap = {};
      for (var test in fetchedList) {
        final key = test.testName.trim().toLowerCase();
        if (!uniqueMap.containsKey(key)) {
          uniqueMap[key] = test;
        }
      }
      _allTests = uniqueMap.values.toList()
        ..sort(
          (a, b) =>
              a.testName.toLowerCase().compareTo(b.testName.toLowerCase()),
        );
      _applySearch();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTest(int id) async {
    try {
      isLoading = true;
      notifyListeners();
      await _service.deleteTest(id);
      await loadTests();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTest(int id, Map<String, dynamic> body) async {
    try {
      isLoading = true;
      notifyListeners();
      await _service.updateTest(id, body);
      await loadTests();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSearch(String value) {
    searchQuery = value;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (searchQuery.isEmpty) {
      testList = _allTests;
    } else {
      testList = _allTests
          .where(
            (test) =>
                test.testName.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }
  }
}
