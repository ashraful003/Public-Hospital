import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/MakePrescriptionViewModel.dart';

class MakePrescriptionScreen extends StatelessWidget {
  final String patientId;

  const MakePrescriptionScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MakePrescriptionViewModel(),
      child: _MakePrescriptionBody(patientId: patientId),
    );
  }
}

class _MakePrescriptionBody extends StatefulWidget {
  final String patientId;

  const _MakePrescriptionBody({required this.patientId});

  @override
  State<_MakePrescriptionBody> createState() =>
      _MakePrescriptionBodyState();
}

class _MakePrescriptionBodyState extends State<_MakePrescriptionBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<MakePrescriptionViewModel>();
      vm.loadDoctor();
      vm.loadPatient(widget.patientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MakePrescriptionViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Make Prescription"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Weight Field
            _buildField(vm.weightController, "Weight (kg)"),
            const SizedBox(height: 12),

            // ✅ Complaints Field
            _buildField(vm.complaintsController, "Problems", maxLines: 3),
            const SizedBox(height: 12),

            // ✅ Diagnosis Field
            _buildField(vm.diagnosisController, "Diagnosis", maxLines: 2),
            const SizedBox(height: 12),

            // ✅ Medicines Field
            _buildField(
              vm.medicineController,
              "Medicines",
              maxLines: 8,
            ),
            const SizedBox(height: 24),

            // ✅ Generate PDF Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await vm.generatePrescription();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Prescription PDF Generated"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text(
                  "Generate PDF",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ✅ Submit to Server Button (only visible after PDF generated)
            if (vm.isPdfGenerated) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: vm.isSubmitting
                      ? null
                      : () async {
                    final success = await vm.submitToServer();

                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "✅ Prescription submitted to server!",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "❌ ${vm.errorMessage ?? 'Submission failed'}",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: vm.isSubmitting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : vm.isSubmitted
                      ? const Icon(Icons.check_circle)
                      : const Icon(Icons.cloud_upload),
                  label: Text(
                    vm.isSubmitting
                        ? "Submitting..."
                        : vm.isSubmitted
                        ? "Submitted ✓"
                        : "Submit to Server",
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vm.isSubmitted
                        ? Colors.green
                        : Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],

            // ✅ Show error message if any
            if (vm.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        vm.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ✅ Success message
            if (vm.isSubmitted) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Prescription has been submitted successfully!",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}