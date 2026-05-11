import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/add_medicine_view_model.dart';
import '../../viewModel/dashboard/profile_view_model.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  late ProfileViewModel profileVM;

  @override
  void initState() {
    super.initState();
    profileVM = ProfileViewModel();
    profileVM.loadProfile("PHARMACEUTICAL");
  }

  @override
  void dispose() {
    profileVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddMedicineViewModel()),
        ChangeNotifierProvider.value(value: profileVM),
      ],
      child: const _AddMedicineView(),
    );
  }
}

class _AddMedicineView extends StatelessWidget {
  const _AddMedicineView();

  Widget _field({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool readOnly = false,
    bool isNumber = false,
  }) {
    final isMultiLine = !isNumber;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: isMultiLine
            ? TextInputType.multiline
            : TextInputType.number,
        maxLines: isMultiLine ? null : 1,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddMedicineViewModel, ProfileViewModel>(
      builder: (context, vm, profileVM, _) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: const Text(
              "Add Medicine",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.blue_200,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SafeArea(
            child: profileVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: profileVM.user?.name ?? "",
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Pharmaceutical Name",
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.business),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _field(
                          controller: vm.nameController,
                          label: "Medicine Name",
                          icon: Icons.medication,
                        ),
                        _field(
                          controller: vm.powerController,
                          label: "Power",
                          icon: Icons.bolt,
                        ),
                        _field(
                          controller: vm.unitPriceController,
                          label: "Unit Price",
                          icon: Icons.attach_money,
                          isNumber: true,
                        ),
                        _field(
                          controller: vm.totalPriceController,
                          label: "Total Price",
                          icon: Icons.payments,
                          isNumber: true,
                        ),
                        _field(
                          controller: vm.indicationsController,
                          label: "Indications",
                          icon: Icons.description,
                        ),
                        _field(
                          controller: vm.pharmacologyController,
                          label: "Pharmacology",
                          icon: Icons.science,
                        ),
                        _field(
                          controller: vm.dosageController,
                          label: "Dosage",
                          icon: Icons.access_time,
                        ),
                        _field(
                          controller: vm.interactionController,
                          label: "Interaction",
                          icon: Icons.warning_amber,
                        ),
                        _field(
                          controller: vm.contraindicationsController,
                          label: "Contraindications",
                          icon: Icons.block,
                        ),
                        _field(
                          controller: vm.sideEffectsController,
                          label: "Side Effects",
                          icon: Icons.sick,
                        ),
                        _field(
                          controller: vm.pregnancyController,
                          label: "Pregnancy & Lactation",
                          icon: Icons.pregnant_woman,
                        ),
                        _field(
                          controller: vm.precautionsController,
                          label: "Precautions & Warnings",
                          icon: Icons.health_and_safety,
                        ),
                        _field(
                          controller: vm.specialPopController,
                          label: "Special Populations",
                          icon: Icons.groups,
                        ),
                        _field(
                          controller: vm.overdoseController,
                          label: "Overdose Effects",
                          icon: Icons.warning,
                        ),
                        _field(
                          controller: vm.reconstitutionController,
                          label: "Reconstitution",
                          icon: Icons.water_drop,
                        ),
                        _field(
                          controller: vm.storageController,
                          label: "Storage Conditions",
                          icon: Icons.storage,
                        ),
                        _field(
                          controller: vm.chemicalController,
                          label: "Chemical Structure",
                          icon: Icons.biotech,
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: vm.isButtonEnabled && !vm.isLoading
                                ? () async {
                                    final success = await vm.addMedicine(
                                      context: context,
                                      profileVM: profileVM,
                                    );
                                    if (success && context.mounted) {
                                      Navigator.pop(context, true);
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: vm.isButtonEnabled
                                  ? AppColors.blue_200
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: vm.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    "Add Medicine",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
