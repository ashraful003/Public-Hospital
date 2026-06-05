import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../model/user_model.dart';
import '../../service/diagnostic_center_service.dart';
import '../../viewModel/dashboard/diagnostic_center_view_model.dart';

class DiagnosticCenterDetailsScreen extends StatelessWidget {
  final UserModel diagnosticCenter;
  final DiagnosticCenterService service;

  const DiagnosticCenterDetailsScreen({
    super.key,
    required this.diagnosticCenter,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiagnosticCenterViewModel(service: service),
      child: Consumer<DiagnosticCenterViewModel>(
        builder: (context, vm, _) {
          final formattedDate = diagnosticCenter.dob != null
              ? DateFormat('dd MMM yyyy').format(diagnosticCenter.dob!)
              : "N/A";
          ImageProvider? getImage() {
            final img = diagnosticCenter.imageUrl;
            if (img == null || img.isEmpty) return null;
            if (img.startsWith("http")) {
              return NetworkImage(img);
            }
            return AssetImage(img);
          }

          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: getImage(),
                    child: getImage() == null
                        ? const Icon(Icons.science)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    diagnosticCenter.name ?? "Unknown Center",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: ${diagnosticCenter.nationalId ?? "N/A"}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          buildRow(Icons.verified, diagnosticCenter.license),
                          buildRow(Icons.cake, formattedDate),
                          buildRow(Icons.email, diagnosticCenter.email),
                          buildRow(Icons.phone, diagnosticCenter.phone),
                          buildRow(Icons.location_on, diagnosticCenter.address),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: vm.loading
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Delete Center"),
                                  content: const Text("Are you sure?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        final id = diagnosticCenter.id;
                                        if (id != null) {
                                          final success = await vm.deleteCenter(
                                            id,
                                          );
                                          if (success && context.mounted) {
                                            Navigator.pop(context, true);
                                          }
                                        }
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              );
                            },
                      icon: vm.loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Icon(Icons.delete),
                      label: Text(vm.loading ? "Deleting..." : "Delete"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRow(IconData icon, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.blue_200),
          const SizedBox(width: 12),
          Expanded(child: Text(value ?? "N/A")),
        ],
      ),
    );
  }
}