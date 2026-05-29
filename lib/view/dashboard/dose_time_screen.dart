import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/dose_time_model.dart';
import '../../viewModel/dashboard/dose_time_view_model.dart';

class DoseTimeScreen extends StatefulWidget {
  final String role;
  final String nationalId;

  const DoseTimeScreen({
    super.key,
    required this.role,
    required this.nationalId,
  });

  @override
  State<DoseTimeScreen> createState() => _DoseTimeScreenState();
}

class _DoseTimeScreenState extends State<DoseTimeScreen> {
  late DoseTimeViewModel vm;
  final TextEditingController searchController = TextEditingController();

  bool get isDoctor => widget.role.toLowerCase() == "doctor";

  @override
  void initState() {
    super.initState();
    vm = DoseTimeViewModel(widget.nationalId);
    vm.loadDoseTimes();
  }

  Future<void> _refresh() async {
    await vm.loadDoseTimes();
  }

  void _onSearch(String value) {
    vm.searchDoseTime(value);
  }

  void _showCreateDialog() {
    if (!isDoctor) return;
    final TextEditingController controller = TextEditingController();
    String? errorText;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create Dose Time"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ID: ${widget.nationalId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Dose Time",
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
                    final res = await vm.createDoseTime(controller.text.trim());
                    if (!context.mounted) return;
                    if (res.toLowerCase().contains("success")) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(res)));
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

  void _showEditDialog(DoseTimeModel item) {
    if (!isDoctor) return;
    final TextEditingController controller = TextEditingController(
      text: item.doseTime,
    );
    String? errorText;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Dose Time"),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Dose Time",
                  border: const OutlineInputBorder(),
                  errorText: errorText,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final res = await vm.updateDoseTime(
                      item.id!,
                      controller.text.trim(),
                    );
                    if (res["success"] == true) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(res["message"])));
                    } else {
                      setState(() => errorText = res["message"]);
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

  void _deleteDialog(DoseTimeModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool loading = false;
            String? error;
            return AlertDialog(
              title: const Text("Delete Dose Time"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Are you sure you want to delete?"),
                  if (error != null) ...[
                    const SizedBox(height: 10),
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  ],
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator(),
                    ),
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
                    setState(() => loading = true);
                    final res = await vm.deleteDoseTime(item.id!);
                    setState(() => loading = false);
                    if (res.toLowerCase().contains("success")) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(res)));
                    } else {
                      setState(() => error = res);
                    }
                  },
                  child: const Text("Yes"),
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
      child: Consumer<DoseTimeViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Dose Time")),
            floatingActionButton: isDoctor
                ? FloatingActionButton(
                    onPressed: _showCreateDialog,
                    child: const Icon(Icons.add),
                  )
                : null,
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: searchController,
                          onChanged: _onSearch,
                          decoration: InputDecoration(
                            hintText: "Search Dose Time...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: vm.filteredDoseTimes.isEmpty
                            ? const Center(child: Text("No Dose Time Found"))
                            : RefreshIndicator(
                                onRefresh: _refresh,
                                child: ListView.builder(
                                  itemCount: vm.filteredDoseTimes.length,
                                  itemBuilder: (context, index) {
                                    final item = vm.filteredDoseTimes[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.schedule,
                                          color: Colors.blue,
                                        ),
                                        title: Text(item.doseTime),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isDoctor)
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () =>
                                                    _showEditDialog(item),
                                              ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  _deleteDialog(item),
                                            ),
                                          ],
                                        ),
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
