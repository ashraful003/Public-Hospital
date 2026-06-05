import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';
import '../../model/bill_model.dart';
import '../../model/user_model.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';
import '../../service/bill_service.dart';

class BillStatusViewModel extends ChangeNotifier {
  final BillService billService;

  BillStatusViewModel({required this.billService});

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  List<BillModel> _bills = [];

  List<BillModel> get bills => _bills;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String _error = '';

  String get error => _error;

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

  Future<void> loadBills(String patientId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await billService.getPatientBills(patientId);
      _bills = result.where((bill) {
        final status = bill.status.toUpperCase();
        return status == "PARTIAL" || status == "DUE" || status == "UNPAID";
      }).toList();
      _bills.sort((a, b) {
        final aDate = a.createdDate;
        final bDate = b.createdDate;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh(String patientId, String role) async {
    await loadCurrentUser(role);
    await loadBills(patientId);
  }

  Future<Map<String, dynamic>?> payBill({
    required int billId,
    required double payAmount,
    required double discountAmount,
  }) async {
    try {
      return await billService.payBill(
        billId: billId,
        payAmount: payAmount,
        discountAmount: discountAmount,
        accountantName: _currentUser?.name ?? "",
        accountantId: _currentUser?.nationalId ?? "",
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}