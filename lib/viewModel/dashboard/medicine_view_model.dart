import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';
import '../../model/medicine_model.dart';
import '../../service/medicine_service.dart';
import 'profile_view_model.dart';

class MedicineViewModel extends ChangeNotifier {
  final MedicineService _service = MedicineService();
  List<MedicineModel> _list = [];
  List<MedicineModel> _filtered = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<MedicineModel> get medicines => _filtered;
  final searchController = TextEditingController();
  String _role = "";

  String get role => _role;

  bool get canAddMedicine {
    final roleUpper = _role.trim().toUpperCase();
    return roleUpper == "PHARMACEUTICAL";
  }

  void loadRole() {
    _role = SharedPrefService.getRole()?.trim() ?? "";
    notifyListeners();
  }

  Future<void> loadMedicines(ProfileViewModel profileVM) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = profileVM.user;
      if (user == null) {
        _list = [];
        _filtered = [];
        return;
      }
      final role = user.roleValue?.trim().toUpperCase();
      List<MedicineModel> data = [];
      if (role == "PHARMACEUTICAL") {
        final pharmaName = user.name?.trim() ?? "";
        if (pharmaName.isNotEmpty) {
          data = await _service.getMyMedicines(pharmaName);
        } else {
          data = [];
        }
      } else {
        data = await _service.getAllMedicines();
      }
      data.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      _list = data;
      _filtered = data;
    } catch (e) {
      _list = [];
      _filtered = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String value) {
    final query = value.toLowerCase();
    if (query.isEmpty) {
      _filtered = List.from(_list);
    } else {
      _filtered = _list.where((m) {
        return (m.medicineName ?? '').toLowerCase().contains(query) ||
            (m.power ?? '').toLowerCase().contains(query) ||
            (m.name ?? '').toLowerCase().contains(query);
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
