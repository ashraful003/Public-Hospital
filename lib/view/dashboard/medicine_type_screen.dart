import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/medicine_type_model.dart';
import '../../viewModel/dashboard/medicine_type_view_model.dart';

class MedicineTypeScreen extends StatelessWidget {
  final String role;
  final String nationalId;

  const MedicineTypeScreen({
    super.key,
    required this.role,
    required this.nationalId,
  });

  bool get isDoctor => role.toLowerCase() == "doctor";

  bool get isAdmin => role.toLowerCase() == "admin";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicineTypeViewModel(nationalId)..initLoad(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Medicine Type")),
        floatingActionButton: isDoctor
            ? Consumer<MedicineTypeViewModel>(
                builder: (context, vm, child) {
                  return FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      _showCreateDialog(context, vm);
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  );
                },
              )
            : null,
        body: Consumer<MedicineTypeViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: vm.searchMedicineType,
                    decoration: InputDecoration(
                      hintText: "Search Medicine Type",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                if (vm.filteredMedicineTypes.isEmpty)
                  const Expanded(
                    child: Center(child: Text("No Medicine Type Found")),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: vm.filteredMedicineTypes.length,
                      itemBuilder: (context, index) {
                        final item = vm.filteredMedicineTypes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.medication,
                              color: Colors.blue,
                            ),
                            title: Text(item.medicineType),
                            subtitle: Text(item.nationalId),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isDoctor)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _showEditDialog(context, vm, item);
                                    },
                                  ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _showDeleteDialog(context, vm, item);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, MedicineTypeViewModel vm) {
    if (!isDoctor) return;
    final controller = TextEditingController();
    String? errorText;
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create Medicine Type"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Medicine Type",
                      border: const OutlineInputBorder(),
                      errorText: errorText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                      errorText = null;
                    });
                    final msg = await vm.createMedicineType(
                      controller.text.trim(),
                    );
                    setState(() {
                      isLoading = false;
                    });
                    if (msg.toLowerCase().contains("success")) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(msg)));
                    } else {
                      setState(() {
                        errorText = msg;
                      });
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    MedicineTypeViewModel vm,
    MedicineTypeModel item,
  ) {
    if (!isDoctor) return;
    final controller = TextEditingController(text: item.medicineType);
    String? errorText;
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Medicine Type"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: item.nationalId,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "National ID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Medicine Type",
                      border: const OutlineInputBorder(),
                      errorText: errorText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                      errorText = null;
                    });
                    final msg = await vm.updateMedicineType(
                      item.id!,
                      controller.text.trim(),
                    );
                    setState(() {
                      isLoading = false;
                    });
                    if (msg.toLowerCase().contains("success")) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(msg)));
                    } else {
                      setState(() {
                        errorText = msg;
                      });
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    MedicineTypeViewModel vm,
    MedicineTypeModel item,
  ) {
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Delete Medicine Type"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Are you sure to delete this medicine type?"),
                  const SizedBox(height: 12),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("No"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final msg = await vm.deleteMedicineType(item.id!);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
