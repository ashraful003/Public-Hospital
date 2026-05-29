import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/doses_model.dart';
import '../../viewModel/dashboard/dose_view_model.dart';

class DoseScreen extends StatefulWidget {
  final String role;
  final String nationalId;

  const DoseScreen({super.key, required this.role, required this.nationalId});

  @override
  State<DoseScreen> createState() => _DoseScreenState();
}

class _DoseScreenState extends State<DoseScreen> {
  late DoseViewModel vm;
  final TextEditingController searchController = TextEditingController();

  bool get isDoctor => widget.role.toLowerCase() == "doctor";

  @override
  void initState() {
    super.initState();
    vm = DoseViewModel(widget.nationalId);
    vm.loadCurrentUserAndDoses();
  }

  void _onSearch(String value) {
    vm.searchDose(value);
  }

  void _showAddDialog() {
    if (!isDoctor) return;
    final TextEditingController doseController = TextEditingController();
    String? errorText;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Dose"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: widget.nationalId,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "ID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: doseController,
                    onChanged: (_) {
                      setState(() => errorText = null);
                    },
                    decoration: InputDecoration(
                      labelText: "Dose",
                      border: const OutlineInputBorder(),
                      errorText: errorText,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final res = await vm.addDose(
                      dose: doseController.text.trim(),
                      nationalId: widget.nationalId,
                    );
                    if (!context.mounted) return;
                    if (res.toLowerCase().contains("success")) {
                      Navigator.pop(context);
                      vm.loadCurrentUserAndDoses();
                    } else {
                      setState(() => errorText = res);
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<DoseViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Doses")),
            floatingActionButton: isDoctor
                ? FloatingActionButton(
                    onPressed: _showAddDialog,
                    child: const Icon(Icons.add),
                  )
                : null,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: searchController,
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: "Search doses...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 0, 12),
                  color: Colors.grey.shade200,
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "No",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          "Dose",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "Action",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.doses.isEmpty
                      ? const Center(child: Text("No doses found"))
                      : RefreshIndicator(
                          onRefresh: vm.refreshDoses,
                          child: ListView.builder(
                            itemCount: vm.doses.length,
                            itemBuilder: (context, index) {
                              final DoseModel dose = vm.doses[index];
                              return Container(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  10,
                                  0,
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text("${index + 1}"),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        dose.dose,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (isDoctor)
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () {
                                                final TextEditingController
                                                editController =
                                                    TextEditingController(
                                                      text: dose.dose,
                                                    );
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Update Dose",
                                                      ),
                                                      content: TextField(
                                                        controller:
                                                            editController,
                                                        decoration:
                                                            const InputDecoration(
                                                              labelText: "Dose",
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                              ),
                                                          child: const Text(
                                                            "Cancel",
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            final res = await vm.updateDose(
                                                              id: dose.id!,
                                                              dose:
                                                                  editController
                                                                      .text
                                                                      .trim(),
                                                              nationalId: widget
                                                                  .nationalId,
                                                            );

                                                            if (!context
                                                                .mounted)
                                                              return;

                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            vm.loadCurrentUserAndDoses();
                                                          },
                                                          child: const Text(
                                                            "Submit",
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              final confirm = await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Delete Dose",
                                                    ),
                                                    content: const Text(
                                                      "Are you sure to delete this dose?",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                            false,
                                                          );
                                                        },
                                                        child: const Text("No"),
                                                      ),
                                                      ElevatedButton(
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                            true,
                                                          );
                                                        },
                                                        child: const Text(
                                                          "Yes",
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (confirm != true) return;
                                              final response = await vm
                                                  .deleteDose(dose.id!);
                                              if (!context.mounted) return;
                                              await vm
                                                  .loadCurrentUserAndDoses();
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(response),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
