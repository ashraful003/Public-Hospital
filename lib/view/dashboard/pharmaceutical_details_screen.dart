import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../model/user_model.dart';
import '../../viewModel/dashboard/pharmaceutical_view_model.dart';

class PharmaceuticalDetailsScreen extends StatelessWidget {
  final UserModel pharmaceutical;

  const PharmaceuticalDetailsScreen({super.key, required this.pharmaceutical});

  bool get isMobilePlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PharmaceuticalViewModel>(
      create: (_) => PharmaceuticalViewModel(),
      child: Consumer<PharmaceuticalViewModel>(
        builder: (context, vm, _) {
          final formattedDate = pharmaceutical.dob != null
              ? DateFormat('dd MMM yyyy').format(pharmaceutical.dob!)
              : "N/A";
          ImageProvider? getImage() {
            final img = pharmaceutical.imageUrl;
            if (img == null || img.isEmpty) {
              return null;
            }
            if (img.startsWith("http")) {
              return NetworkImage(img);
            } else {
              return AssetImage(img);
            }
          }

          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: getImage(),
                    child: getImage() == null
                        ? const Icon(
                            Icons.local_pharmacy,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pharmaceutical.name ?? "Unknown Pharmaceutical",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${pharmaceutical.nationalId ?? "N/A"}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          buildDetailsRow(
                            icon: Icons.verified,
                            value: pharmaceutical.license ?? "N/A",
                          ),
                          buildDetailsRow(
                            icon: Icons.cake,
                            value: formattedDate,
                          ),
                          buildDetailsRow(
                            icon: Icons.email,
                            value: pharmaceutical.email ?? "N/A",
                          ),
                          buildDetailsRow(
                            icon: Icons.phone,
                            value: pharmaceutical.phone ?? "N/A",
                          ),
                          buildDetailsRow(
                            icon: Icons.location_on,
                            value: pharmaceutical.address ?? "N/A",
                          ),
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
                      onPressed: vm.isLoading
                          ? null
                          : () async {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("Delete Pharmaceutical"),
                                    content: const Text(
                                      "Are you sure you want to delete this pharmaceutical?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          if (pharmaceutical.id != null) {
                                            final success = await vm
                                                .deletePharmaceutical(
                                                  context: context,
                                                  id: pharmaceutical.id!,
                                                );
                                            if (success && context.mounted) {
                                              Navigator.pop(context, true);
                                            }
                                          }
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                      icon: vm.isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.delete, color: Colors.white),
                      label: Text(
                        vm.isLoading ? "Deleting..." : "Delete Pharmaceutical",
                        style: const TextStyle(
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
          );
        },
      ),
    );
  }

  Widget buildDetailsRow({required IconData icon, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.blue_200),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
