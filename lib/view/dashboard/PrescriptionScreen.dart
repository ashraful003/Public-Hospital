import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/PrescriptionViewModel.dart';
import 'MakePrescriptionScreen.dart';
import 'PdfViewerScreen.dart';

class PrescriptionScreen extends StatelessWidget {
  final String patientId;

  const PrescriptionScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrescriptionViewModel(patientId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Prescriptions')),

        // ✅ Floating Button works now
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MakePrescriptionScreen(patientId: patientId),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        body: Consumer<PrescriptionViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.prescriptions.isEmpty) {
              return const Center(child: Text("No prescriptions found."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: viewModel.prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = viewModel.prescriptions[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 35),
                    title: Text(prescription.patientName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Date: ${prescription.date}"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfViewerScreen(pdfPath: prescription.pdfUrl),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}