import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../model/medicine_model.dart';
import '../../viewModel/dashboard/medicine_update_view_model.dart';

class MedicineUpdateScreen extends StatelessWidget {
  final MedicineModel medicine;

  const MedicineUpdateScreen({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicineUpdateViewModel()..setMedicine(medicine),
      child: const _MedicineUpdateView(),
    );
  }
}

class _MedicineUpdateView extends StatelessWidget {
  const _MedicineUpdateView();

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: isNumber ? TextInputType.number : TextInputType.multiline,
        maxLines: isNumber ? 1 : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicineUpdateViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: AppColors.blue_200,
            centerTitle: true,
            title: const Text(
              "Update Medicine",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: vm.medicine?.name ?? "",
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Pharmaceutical Name",
                      prefixIcon: const Icon(Icons.business),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildField(
                    controller: vm.medicineNameController,
                    label: "Medicine Name",
                    icon: Icons.medication,
                  ),
                  buildField(
                    controller: vm.powerController,
                    label: "Power",
                    icon: Icons.bolt,
                  ),
                  buildField(
                    controller: vm.unitPriceController,
                    label: "Unit Price",
                    icon: Icons.attach_money,
                    isNumber: true,
                  ),
                  buildField(
                    controller: vm.totalPriceController,
                    label: "Total Price",
                    icon: Icons.payments,
                    isNumber: true,
                  ),
                  buildField(
                    controller: vm.indicationsController,
                    label: "Indications",
                    icon: Icons.description,
                  ),
                  buildField(
                    controller: vm.pharmacologyController,
                    label: "Pharmacology",
                    icon: Icons.science,
                  ),
                  buildField(
                    controller: vm.dosageController,
                    label: "Dosage",
                    icon: Icons.access_time,
                  ),
                  buildField(
                    controller: vm.interactionController,
                    label: "Interaction",
                    icon: Icons.warning_amber,
                  ),
                  buildField(
                    controller: vm.contraindicationsController,
                    label: "Contraindications",
                    icon: Icons.block,
                  ),
                  buildField(
                    controller: vm.sideEffectsController,
                    label: "Side Effects",
                    icon: Icons.sick,
                  ),
                  buildField(
                    controller: vm.pregnancyController,
                    label: "Pregnancy & Lactation",
                    icon: Icons.pregnant_woman,
                  ),
                  buildField(
                    controller: vm.precautionsController,
                    label: "Precautions & Warnings",
                    icon: Icons.health_and_safety,
                  ),
                  buildField(
                    controller: vm.specialPopulationController,
                    label: "Special Populations",
                    icon: Icons.groups,
                  ),
                  buildField(
                    controller: vm.overdoseController,
                    label: "Overdose Effects",
                    icon: Icons.warning,
                  ),
                  buildField(
                    controller: vm.reconstitutionController,
                    label: "Reconstitution",
                    icon: Icons.water_drop,
                  ),
                  buildField(
                    controller: vm.storageController,
                    label: "Storage Conditions",
                    icon: Icons.storage,
                  ),
                  buildField(
                    controller: vm.chemicalController,
                    label: "Chemical Structure",
                    icon: Icons.biotech,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: vm.isLoading
                          ? null
                          : () async {
                              final success = await vm.updateMedicine();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: success
                                        ? Colors.green
                                        : Colors.red,
                                    content: Text(
                                      success
                                          ? "Medicine Updated Successfully"
                                          : "Failed To Update Medicine",
                                    ),
                                  ),
                                );
                                if (success) {
                                  Navigator.pop(context, true);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue_200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: vm.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Update Medicine",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}