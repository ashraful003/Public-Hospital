import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../service/api_config.dart';

class SearchDoctorActivityViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isNotFound = false;

  void updateInput(String value) {
    isNotFound = false;
    notifyListeners();
  }

  Future<String?> searchDoctor(BuildContext context) async {
    final doctorId = searchController.text.trim();
    if (doctorId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter doctor ID')));
      return null;
    }
    try {
      isLoading = true;
      isNotFound = false;
      notifyListeners();
      final url = Uri.parse('${ApiConfig.baseUrl}/users/$doctorId');
      final response = await http.get(url);
      isLoading = false;
      notifyListeners();
      if (response.statusCode == 200) {
        return doctorId;
      } else {
        isNotFound = true;
        notifyListeners();
        return null;
      }
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
