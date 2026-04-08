import 'package:flutter/material.dart';
import 'package:public_hospital/view/dashboard/prescription_screen.dart';

class SearchPrescriptionViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  void updateInput(String value) {
    notifyListeners();
  }

  Future<void> searchPrescription(BuildContext context) async {
    final patientId = searchController.text.trim();

    if (patientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter patient Id')),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    notifyListeners();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrescriptionScreen(
          patientId: patientId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}