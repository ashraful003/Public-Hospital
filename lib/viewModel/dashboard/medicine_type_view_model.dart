import 'package:flutter/material.dart';
import '../../model/medicine_type_model.dart';
import '../../service/medicine_type_service.dart';

class MedicineTypeViewModel extends ChangeNotifier {
  final MedicineTypeService _service = MedicineTypeService();
  List<MedicineTypeModel> medicineTypes = [];
  List<MedicineTypeModel> filteredMedicineTypes = [];
  final String nationalId;
  bool isLoading = false;

  MedicineTypeViewModel(this.nationalId);

  Future<void> initLoad() async {
    await loadMedicineTypes();
  }

  Future<void> loadMedicineTypes() async {
    isLoading = true;
    notifyListeners();
    try {
      medicineTypes = await _service.getMedicineTypes(nationalId);
      filteredMedicineTypes = medicineTypes;
    } catch (e) {
      medicineTypes = [];
      filteredMedicineTypes = [];
      debugPrint(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  void searchMedicineType(String query) {
    if (query.trim().isEmpty) {
      filteredMedicineTypes = medicineTypes;
    } else {
      filteredMedicineTypes = medicineTypes
          .where(
            (e) => e.medicineType.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<String> createMedicineType(String medicineType) async {
    try {
      final res = await _service.createMedicineType(medicineType, nationalId);
      await loadMedicineTypes();
      return res;
    } catch (e) {
      return "Create failed";
    }
  }

  Future<String> updateMedicineType(int id, String medicineType) async {
    try {
      final res = await _service.updateMedicineType(
        id,
        medicineType,
        nationalId,
      );
      await loadMedicineTypes();
      return res;
    } catch (e) {
      return "Update failed";
    }
  }

  Future<String> deleteMedicineType(int id) async {
    try {
      final res = await _service.deleteMedicineType(id);
      await loadMedicineTypes();
      return res;
    } catch (e) {
      return "Delete failed";
    }
  }
}
