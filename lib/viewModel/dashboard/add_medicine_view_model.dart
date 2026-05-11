import 'package:flutter/material.dart';
import '../../model/medicine_model.dart';
import '../../service/medicine_service.dart';
import 'profile_view_model.dart';

class AddMedicineViewModel extends ChangeNotifier {
  final MedicineService _service = MedicineService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  final nameController = TextEditingController();
  final powerController = TextEditingController();
  final unitPriceController = TextEditingController();
  final totalPriceController = TextEditingController();
  final indicationsController = TextEditingController();
  final pharmacologyController = TextEditingController();
  final dosageController = TextEditingController();
  final interactionController = TextEditingController();
  final contraindicationsController = TextEditingController();
  final sideEffectsController = TextEditingController();
  final pregnancyController = TextEditingController();
  final precautionsController = TextEditingController();
  final specialPopController = TextEditingController();
  final overdoseController = TextEditingController();
  final reconstitutionController = TextEditingController();
  final storageController = TextEditingController();
  final chemicalController = TextEditingController();

  AddMedicineViewModel() {
    final controllers = [
      nameController,
      powerController,
      unitPriceController,
      totalPriceController,
      indicationsController,
      pharmacologyController,
      dosageController,
      interactionController,
      contraindicationsController,
      sideEffectsController,
      pregnancyController,
      precautionsController,
      specialPopController,
      overdoseController,
      reconstitutionController,
      storageController,
      chemicalController,
    ];
    for (final controller in controllers) {
      controller.addListener(_refresh);
    }
  }

  void _refresh() {
    notifyListeners();
  }

  bool get isButtonEnabled {
    return nameController.text.trim().isNotEmpty &&
        powerController.text.trim().isNotEmpty &&
        unitPriceController.text.trim().isNotEmpty &&
        totalPriceController.text.trim().isNotEmpty &&
        indicationsController.text.trim().isNotEmpty &&
        pharmacologyController.text.trim().isNotEmpty &&
        dosageController.text.trim().isNotEmpty &&
        interactionController.text.trim().isNotEmpty &&
        contraindicationsController.text.trim().isNotEmpty &&
        sideEffectsController.text.trim().isNotEmpty &&
        pregnancyController.text.trim().isNotEmpty &&
        precautionsController.text.trim().isNotEmpty &&
        specialPopController.text.trim().isNotEmpty &&
        overdoseController.text.trim().isNotEmpty &&
        reconstitutionController.text.trim().isNotEmpty &&
        storageController.text.trim().isNotEmpty &&
        chemicalController.text.trim().isNotEmpty;
  }

  Future<bool> addMedicine({
    required BuildContext context,
    required ProfileViewModel profileVM,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final pharmaName = profileVM.user?.name?.trim() ?? "";
      if (pharmaName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pharmaceutical profile not loaded")),
        );
        return false;
      }
      final medicine = MedicineModel(
        medicineName: nameController.text.trim(),
        power: powerController.text.trim(),
        name: pharmaName,
        unitPrice: double.tryParse(unitPriceController.text.trim()) ?? 0,
        totalPrice: double.tryParse(totalPriceController.text.trim()) ?? 0,
        indications: indicationsController.text.trim(),
        pharmacology: pharmacologyController.text.trim(),
        dosage: dosageController.text.trim(),
        interaction: interactionController.text.trim(),
        contraindications: contraindicationsController.text.trim(),
        sideEffects: sideEffectsController.text.trim(),
        pregnancyLactation: pregnancyController.text.trim(),
        precautionsWarnings: precautionsController.text.trim(),
        specialPopulations: specialPopController.text.trim(),
        overdoseEffects: overdoseController.text.trim(),
        reconstitution: reconstitutionController.text.trim(),
        storageConditions: storageController.text.trim(),
        chemicalStructure: chemicalController.text.trim(),
      );
      final success = await _service.addMedicine(medicine);
      if (success) {
        _clearFields();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Medicine added successfully")),
          );
        }
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to add medicine")),
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clearFields() {
    nameController.clear();
    powerController.clear();
    unitPriceController.clear();
    totalPriceController.clear();
    indicationsController.clear();
    pharmacologyController.clear();
    dosageController.clear();
    interactionController.clear();
    contraindicationsController.clear();
    sideEffectsController.clear();
    pregnancyController.clear();
    precautionsController.clear();
    specialPopController.clear();
    overdoseController.clear();
    reconstitutionController.clear();
    storageController.clear();
    chemicalController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    powerController.dispose();
    unitPriceController.dispose();
    totalPriceController.dispose();
    indicationsController.dispose();
    pharmacologyController.dispose();
    dosageController.dispose();
    interactionController.dispose();
    contraindicationsController.dispose();
    sideEffectsController.dispose();
    pregnancyController.dispose();
    precautionsController.dispose();
    specialPopController.dispose();
    overdoseController.dispose();
    reconstitutionController.dispose();
    storageController.dispose();
    chemicalController.dispose();
    super.dispose();
  }
}
