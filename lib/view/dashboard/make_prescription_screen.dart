import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import '../../model/ui_models.dart';
import '../../viewModel/dashboard/make_prescription_view_model.dart';

class MakePrescriptionScreen extends StatefulWidget {
  final String patientId;

  const MakePrescriptionScreen({super.key, required this.patientId});

  @override
  State<MakePrescriptionScreen> createState() => _MakePrescriptionScreenState();
}

class _MakePrescriptionScreenState extends State<MakePrescriptionScreen> {
  final List<RxUIModel> rxList = [RxUIModel()];
  final List<TestUIModel> testList = [];
  final List<String> medicineTypes = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MakePrescriptionViewModel()..load(widget.patientId),
      child: Consumer<MakePrescriptionViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final today = DateTime.now();
          final medicineList = vm.medicines.toSet().toList();
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctor(vm),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildPatientInfo(vm, today),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: const Text(
                      "Rx",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRxList(vm, medicineList),
                  const SizedBox(height: 10),
                  _buildAddMedicineButton(),
                  const SizedBox(height: 25),
                  _buildTestHeader(),
                  _buildTestList(vm),
                  const SizedBox(height: 30),
                  _buildAdviceField(vm),
                  const SizedBox(height: 30),
                  _buildNextMeetField(vm),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: vm.isSubmitting
                            ? null
                            : () async {
                                final success = await vm.submit(
                                  rxList: rxList,
                                  testList: testList,
                                );
                                if (!mounted) return;
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Prescription Created Successfully",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context, true);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(vm.error ?? "Failed"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: vm.isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Create Prescription",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRxList(MakePrescriptionViewModel vm, List<String> medicineList) {
    return Column(
      children: List.generate(rxList.length, (i) {
        final item = rxList[i];
        return Card(
          elevation: 1.5,
          margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _rxHeader(i),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownSearch<String>(
                        items: vm.medicineTypes,
                        selectedItem: item.type.trim().isEmpty
                            ? null
                            : item.type,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search medicine type...",
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Medicine Type",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
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
                        onChanged: (value) {
                          setState(() {
                            item.type = value ?? "";
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: DropdownSearch<String>(
                        items: medicineList,
                        selectedItem: medicineList.contains(item.medicine)
                            ? item.medicine
                            : null,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search medicine...",
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
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
                          setState(() {
                            item.medicine = v ?? "";
                          });
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
                        items: vm.doses.toSet().toList(),
                        selectedItem: vm.doses.contains(item.dose)
                            ? item.dose
                            : null,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search dose...",
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
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
                          setState(() {
                            item.dose = v ?? "";
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownSearch<String>(
                        items: vm.doseTimes,
                        selectedItem: item.doseTime.isNotEmpty
                            ? item.doseTime
                            : null,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search dose time...",
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
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
                          setState(() {
                            item.doseTime = v ?? "";
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownSearch<String>(
                        items: vm.durations.toSet().toList(),
                        selectedItem: vm.durations.contains(item.duration)
                            ? item.duration
                            : null,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search duration...",
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
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
                          setState(() {
                            item.duration = v ?? "";
                          });
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

  Widget _rxHeader(int i) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
              setState(() {
                rxList.removeAt(i);
              });
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMedicineButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              rxList.add(RxUIModel());
            });
          },
          icon: const Icon(Icons.add_circle_outline, size: 22),
          label: const Text(
            "Add Medicine",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTestHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: const Row(
        children: [
          Icon(Icons.science_outlined, color: Colors.blue, size: 24),
          SizedBox(width: 8),
          Text(
            "Tests",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTestList(MakePrescriptionViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          ...List.generate(testList.length, (i) {
            final item = testList[i];
            return Card(
              elevation: 1.2,
              margin: const EdgeInsets.only(top: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${i + 1}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownSearch<String>(
                        items: vm.tests.toSet().toList(),
                        selectedItem: vm.tests.contains(item.test)
                            ? item.test
                            : null,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          constraints: const BoxConstraints(maxHeight: 250),
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search test...",
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Select Test",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onChanged: (v) {
                          setState(() {
                            item.test = v ?? "";
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          testList.removeAt(i);
                        });
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  testList.add(TestUIModel());
                });
              },
              icon: const Icon(Icons.add_circle_outline, size: 22),
              label: const Text(
                "Add Test",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 2,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctor(vm) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vm.doctor?.name ?? "",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(vm.doctor?.degree ?? ""),
          Text(vm.doctor?.specialist ?? ""),
          Text("License: ${vm.doctor?.license ?? ""}"),
        ],
      ),
    );
  }

  Widget _buildPatientInfo(MakePrescriptionViewModel vm, DateTime today) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _readOnlyField(
                  label: "ID",
                  value: vm.patient?.nationalId ?? "",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _readOnlyField(
                  label: "Name",
                  value: vm.patient?.name ?? "",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _readOnlyField(
                  label: "Age",
                  value: vm.patient?.age != null ? "${vm.patient!.age}" : "",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _readOnlyField(
                  label: "Date",
                  value: "${today.day}/${today.month}/${today.year}",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: vm.weightController,
                  decoration: _inputDecoration("Weight", "70 kg"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: vm.bpController,
                  decoration: _inputDecoration("BP", "80/120"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: vm.pulseController,
                  decoration: _inputDecoration("Pulse", "72 bpm"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: vm.temperatureController,
                  decoration: _inputDecoration("Temperature", "98.6°F"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: vm.problemController,
            minLines: 2,
            maxLines: 10,
            decoration: _inputDecoration(
              "Problems",
              "Write patient problems...",
            ),
          ),
        ],
      ),
    );
  }

  Widget _readOnlyField({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _buildNextMeetField(MakePrescriptionViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, color: Colors.green),
              SizedBox(width: 8),
              Text(
                "Next Meet",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownSearch<String>(
            items: vm.nextMeetList,
            selectedItem: vm.nextMeetList.contains(vm.nextMeetController.text)
                ? vm.nextMeetController.text
                : null,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              constraints: const BoxConstraints(maxHeight: 250),
              searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Search next meet...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Select Next Meet Time",
                prefixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 1.5),
                ),
              ),
            ),
            onChanged: (v) {
              vm.nextMeetController.text = v ?? "";
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceField(MakePrescriptionViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                "Advice",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownSearch<String>(
            items: vm.adviceList,
            selectedItem: vm.adviceList.contains(vm.adviceController.text)
                ? vm.adviceController.text
                : null,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              constraints: const BoxConstraints(maxHeight: 250),
              searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Search advice...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Select Advice",
                prefixIcon: const Icon(Icons.medical_information_outlined),
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
                    color: Colors.orange,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            onChanged: (v) {
              vm.adviceController.text = v ?? "";
            },
          ),
        ],
      ),
    );
  }
}
