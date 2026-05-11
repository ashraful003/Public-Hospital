import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../service/pharmaceutical_service.dart';

class PharmaceuticalViewModel extends ChangeNotifier {
  final PharmaceuticalService _service = PharmaceuticalService();
  List<UserModel> _pharmaceuticals = [];
  List<UserModel> _filteredList = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<UserModel> get pharmaceuticals => _filteredList;
  final TextEditingController searchController = TextEditingController();

  Future<void> loadPharmaceuticals() async {
    try {
      _isLoading = true;
      notifyListeners();
      final data = await _service.getAllPharmaceuticals();
      data.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      _pharmaceuticals = data;
      _filteredList = data;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String value) {
    if (value.isEmpty) {
      _filteredList = _pharmaceuticals;
    } else {
      _filteredList = _pharmaceuticals.where((item) {
        final name = item.name?.toLowerCase() ?? '';
        final email = item.email?.toLowerCase() ?? '';
        return name.contains(value.toLowerCase()) ||
            email.contains(value.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> deletePharmaceutical({
    required BuildContext context,
    required int id,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _service.deletePharmaceutical(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pharmaceutical deleted successfully")),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}