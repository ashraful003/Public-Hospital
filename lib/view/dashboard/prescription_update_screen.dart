import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/prescription_update_view_model.dart';

class PrescriptionUpdateScreen extends StatefulWidget {
  final int prescriptionId;

  const PrescriptionUpdateScreen({super.key, required this.prescriptionId});

  @override
  State<PrescriptionUpdateScreen> createState() =>
      _PrescriptionUpdateScreenState();
}

class _PrescriptionUpdateScreenState extends State<PrescriptionUpdateScreen> {
  final List<String> medicineTypes = [];
  final List<String> doseTime = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrescriptionUpdateViewModel()..load(widget.prescriptionId),
      child: Consumer<PrescriptionUpdateViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.error != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vm.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => vm.load(widget.prescriptionId),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }
          final p = vm.prescription;
          if (p == null) {
            return const Scaffold(
              body: Center(child: Text("No Prescription Found")),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text("Update Prescription")),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _buildDoctorSection(p),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildPatientSection(vm, p),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 25),
                  const Text(
                    "Rx",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildMedicineList(vm),
                  const SizedBox(height: 12),
                  _buildAddMedicineButton(vm),
                  const SizedBox(height: 30),
                  _buildTestHeader(),
                  const SizedBox(height: 12),
                  _buildTestList(vm),
                  const SizedBox(height: 30),
                  _buildAdviceSection(vm),
                  const SizedBox(height: 30),
                  _buildNextMeet(vm),
                  const SizedBox(height: 40),
                  _buildUpdateButton(vm),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorSection(p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.doctorName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(p.doctorDegree),
        Text(p.doctorSpecialist),
        Text(p.doctorInstitute),
        Text("License: ${p.doctorLicense}"),
      ],
    );
  }

  Widget _buildPatientSection(PrescriptionUpdateViewModel vm, dynamic p) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _readOnlyField("Patient ID", p.patientId)),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: _readOnlyField("Patient Name", p.patientName),
            ),
            const SizedBox(width: 10),
            Expanded(child: _readOnlyField("Age", "${p.patientAge} Years")),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: vm.weightController,
                decoration: InputDecoration(
                  labelText: "Weight",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: vm.bpController,
                decoration: InputDecoration(
                  labelText: "BP",
                  hintText: "120/80",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: vm.pulseController,
                decoration: InputDecoration(
                  labelText: "Pulse",
                  hintText: "72 bpm",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: vm.temperatureController,
                decoration: InputDecoration(
                  labelText: "Temp",
                  hintText: "98.6°F",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicineList(PrescriptionUpdateViewModel vm) {
    return Column(
      children: List.generate(vm.medicines.length, (i) {
        final med = vm.medicines[i];
        return Card(
          elevation: 1.5,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Medicine ${i + 1}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        vm.removeMedicine(i);
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownSearch<String>(
                        items: vm.medicineTypes,
                        selectedItem: med["type"],
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Type",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onChanged: (v) {
                          med["type"] = v ?? "";
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: DropdownSearch<String>(
                        items: vm.medicinesList,
                        selectedItem: med["medicine"],
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Medicine",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onChanged: (v) {
                          med["medicine"] = v ?? "";
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownSearch<String>(
                        items: vm.doses,
                        selectedItem: med["dose"],
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Dose",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onChanged: (v) {
                          med["dose"] = v ?? "";
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownSearch<String>(
                        items: vm.doseTimes,
                        selectedItem: med["doseTime"],
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Dose Time",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onChanged: (v) {
                          med["doseTime"] = v ?? "";
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownSearch<String>(
                        items: vm.durations,
                        selectedItem: med["duration"],
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Duration",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onChanged: (v) {
                          med["duration"] = v ?? "";
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAddMedicineButton(PrescriptionUpdateViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: vm.addMedicine,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text(
          "Add Medicine",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildTestHeader() {
    return const Row(
      children: [
        Icon(Icons.science_outlined, color: Colors.blue),
        SizedBox(width: 8),
        Text(
          "Tests",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTestList(PrescriptionUpdateViewModel vm) {
    return Column(
      children: [
        ...List.generate(vm.tests.length, (i) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownSearch<String>(
                      items: vm.testsList,
                      selectedItem: vm.tests[i],
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        constraints: const BoxConstraints(maxHeight: 250),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Test ${i + 1}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      onChanged: (v) {
                        vm.tests[i] = v ?? "";
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      vm.removeTest(i);
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: vm.addTest,
            icon: const Icon(Icons.add),
            label: const Text("Add Test"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdviceSection(PrescriptionUpdateViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Advice",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DropdownSearch<String>(
          items: vm.adviceList,
          selectedItem: vm.adviceController.text,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            constraints: const BoxConstraints(
              maxHeight: 250, // 👈 shows ~5 items + scroll
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Select Advice",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          onChanged: (v) {
            vm.adviceController.text = v ?? "";
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: vm.adviceController,
          minLines: 5,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Write advice...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildNextMeet(PrescriptionUpdateViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Next Meet",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: DropdownSearch<String>(
            items: vm.nextMeetList,
            selectedItem: vm.nextMeetController.text,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              constraints: const BoxConstraints(maxHeight: 250),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Next Meet Time",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            onChanged: (v) {
              vm.nextMeetController.text = v ?? "";
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton(PrescriptionUpdateViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: vm.isSaving
            ? null
            : () async {
                final success = await vm.updatePrescription();
                if (!mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Prescription Updated Successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context, vm.prescription?.id);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(vm.error ?? "Update failed"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: vm.isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Update Prescription",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}