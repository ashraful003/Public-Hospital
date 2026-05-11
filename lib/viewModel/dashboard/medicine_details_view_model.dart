import 'package:flutter/material.dart';

import '../../data/shared_pref_service.dart';
import '../../service/medicine_service.dart';

class MedicineDetailsViewModel extends ChangeNotifier {

  final MedicineService _service = MedicineService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// ROLE
  String _role = "";

  String get role => _role;

  /// ADMIN -> DELETE ONLY
  bool get canDeleteMedicine {

    final roleUpper =
    _role.trim().toUpperCase();

    return roleUpper == "ADMIN" ||
        roleUpper == "PHARMACEUTICAL";
  }

  /// PHARMACEUTICAL -> EDIT + DELETE
  bool get canEditMedicine {

    final roleUpper =
    _role.trim().toUpperCase();

    return roleUpper == "PHARMACEUTICAL";
  }

  /// LOAD ROLE
  void loadRole() {

    _role =
        SharedPrefService.getRole()?.trim() ?? "";

    notifyListeners();
  }

  /// DELETE MEDICINE
  Future<bool> deleteMedicine({

    required BuildContext context,

    required int id,
  }) async {

    _isLoading = true;

    notifyListeners();

    try {

      final success =
      await _service.deleteMedicine(id);

      if (success) {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(

            content: Text(
              "Medicine deleted successfully",
            ),
          ),
        );

        return true;
      }

      return false;

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            "Delete failed: $e",
          ),
        ),
      );

      return false;

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }
}