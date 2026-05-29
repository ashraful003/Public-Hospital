import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/prescription_view_model.dart';
import 'make_prescription_screen.dart';
import 'prescription_details_screen.dart';

class PrescriptionScreen extends StatefulWidget {
  final String patientId;
  final String role;

  const PrescriptionScreen({
    super.key,
    required this.patientId,
    required this.role,
  });

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  late PrescriptionViewModel vm;

  bool get isDoctor => widget.role.toLowerCase() == "doctor";

  @override
  void initState() {
    super.initState();
    vm = PrescriptionViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadPrescriptions(widget.patientId);
    });
  }

  Future<void> _refreshData() async {
    await vm.loadPrescriptions(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Scaffold(
        appBar: AppBar(title: const Text("Prescriptions")),
        floatingActionButton: isDoctor
            ? FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MakePrescriptionScreen(patientId: widget.patientId),
                    ),
                  );
                  if (result == true) {
                    await vm.loadPrescriptions(widget.patientId);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Prescription list updated"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              )
            : null,
        body: Consumer<PrescriptionViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading && vm.prescriptions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null && vm.prescriptions.isEmpty) {
              return Center(
                child: Text(
                  vm.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (vm.prescriptions.isEmpty) {
              return const Center(child: Text("No prescriptions found"));
            }
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: vm.prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = vm.prescriptions[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: SizedBox(
                        height: 40,

                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                DateFormat(
                                  "dd MMM yyyy",
                                ).format(prescription.date),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  prescription.doctorName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 34,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              PrescriptionDetailScreen(
                                                prescriptionId: prescription.id,
                                                role: widget.role,
                                              ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text("View"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
