import 'package:flutter/material.dart';
import '../../model/bill_model.dart';
import '../../model/user_model.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';
import '../../service/bill_service.dart';
import '../../data/shared_pref_service.dart';
import 'dart:convert';

class PaymentViewModel extends ChangeNotifier {
  final BillService billService;

  PaymentViewModel({required this.billService});

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String _error = "";

  String get error => _error;
  UserModel? accountant;

  Future<void> loadCurrentUser(String role) async {
    try {
      _isLoading = true;
      _error = "";
      notifyListeners();
      final email = SharedPrefService.getString("remember_email");
      if (email == null || email.isEmpty) {
        throw Exception("Email not found");
      }
      final url = "${ApiConfig.baseUrl}/profile?email=$email&role=$role";
      final response = await ApiClient.get(url);
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        accountant = UserModel.fromJson(json);
      } else {
        throw Exception(json["message"] ?? "Failed to load user");
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> payBill({
    required BillModel bill,
    required double payAmount,
    required double discountAmount,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final result = await billService.payBill(
        billId: bill.id!,
        payAmount: payAmount,
        discountAmount: discountAmount,
        accountantName: accountant?.name ?? "",
        accountantId: accountant?.nationalId ?? "",
      );
      return result;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}