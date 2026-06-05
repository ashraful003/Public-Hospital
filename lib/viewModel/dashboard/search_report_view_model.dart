import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../service/api_config.dart';

class SearchReportViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isNotFound = false;

  void updateInput(String value) {
    isNotFound = false;
    notifyListeners();
  }

  Future<String?> searchReport(BuildContext context) async {
    final patientId = searchController.text.trim();
    if (patientId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter Patient ID")));
      return null;
    }
    try {
      isLoading = true;
      isNotFound = false;
      notifyListeners();
      final url = Uri.parse('${ApiConfig.baseUrl}/patient/report/$patientId');
      final response = await http.get(url);
      isLoading = false;
      notifyListeners();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isEmpty) {
          isNotFound = true;
          notifyListeners();
          return null;
        }
        return patientId;
      }
      isNotFound = true;
      notifyListeners();
      return null;
    } catch (e) {
      isLoading = false;
      isNotFound = true;
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}