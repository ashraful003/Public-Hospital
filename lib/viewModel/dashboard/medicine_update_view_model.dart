import 'package:flutter/material.dart';
import '../../model/medicine_model.dart';
import '../../service/medicine_service.dart';

class MedicineUpdateViewModel extends ChangeNotifier {
  final MedicineService _service = MedicineService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  MedicineModel? medicine;
  final medicineNameController = TextEditingController();
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
  final specialPopulationController = TextEditingController();
  final overdoseController = TextEditingController();
  final reconstitutionController = TextEditingController();
  final storageController = TextEditingController();
  final chemicalController = TextEditingController();

  void setMedicine(MedicineModel m) {
    medicine = m;
    medicineNameController.text = m.medicineName ?? "";
    powerController.text = m.power ?? "";
    unitPriceController.text = m.unitPrice?.toString() ?? "";
    totalPriceController.text = m.totalPrice?.toString() ?? "";
    indicationsController.text = m.indications ?? "";
    pharmacologyController.text = m.pharmacology ?? "";
    dosageController.text = m.dosage ?? "";
    interactionController.text = m.interaction ?? "";
    contraindicationsController.text = m.contraindications ?? "";
    sideEffectsController.text = m.sideEffects ?? "";
    pregnancyController.text = m.pregnancyLactation ?? "";
    precautionsController.text = m.precautionsWarnings ?? "";
    specialPopulationController.text = m.specialPopulations ?? "";
    overdoseController.text = m.overdoseEffects ?? "";
    reconstitutionController.text = m.reconstitution ?? "";
    storageController.text = m.storageConditions ?? "";
    chemicalController.text = m.chemicalStructure ?? "";
    notifyListeners();
  }

  Future<bool> updateMedicine() async {
    if (medicine == null || medicine!.id == null) {
      return false;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final updatedMedicine = MedicineModel(
        id: medicine!.id,
        name: medicine!.name,
        medicineName: medicineNameController.text.trim(),
        power: powerController.text.trim(),
        unitPrice: double.tryParse(unitPriceController.text.trim()),
        totalPrice: double.tryParse(totalPriceController.text.trim()),
        indications: indicationsController.text.trim(),
        pharmacology: pharmacologyController.text.trim(),
        dosage: dosageController.text.trim(),
        interaction: interactionController.text.trim(),
        contraindications: contraindicationsController.text.trim(),
        sideEffects: sideEffectsController.text.trim(),
        pregnancyLactation: pregnancyController.text.trim(),
        precautionsWarnings: precautionsController.text.trim(),
        specialPopulations: specialPopulationController.text.trim(),
        overdoseEffects: overdoseController.text.trim(),
        reconstitution: reconstitutionController.text.trim(),
        storageConditions: storageController.text.trim(),
        chemicalStructure: chemicalController.text.trim(),
      );
      return await _service.updateMedicine(
        id: medicine!.id!,
        medicine: updatedMedicine,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    medicineNameController.dispose();
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
    specialPopulationController.dispose();
    overdoseController.dispose();
    reconstitutionController.dispose();
    storageController.dispose();
    chemicalController.dispose();
    super.dispose();
  }
}
