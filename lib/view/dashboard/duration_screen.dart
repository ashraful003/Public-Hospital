import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/duration_model.dart';
import '../../viewModel/dashboard/duration_view_model.dart';

class DurationScreen extends StatefulWidget {
  final String role;
  final String nationalId;

  const DurationScreen({
    super.key,
    required this.role,
    required this.nationalId,
  });

  @override
  State<DurationScreen> createState() => _DurationScreenState();
}

class _DurationScreenState extends State<DurationScreen> {
  late DurationViewModel vm;
  final TextEditingController searchController = TextEditingController();

  bool get isDoctor => widget.role.toLowerCase() == "doctor";

  @override
  void initState() {
    super.initState();
    vm = DurationViewModel(widget.nationalId);
    vm.loadDurations();
  }

  Future<void> _refresh() async {
    await vm.loadDurations();
  }

  void _onSearch(String value) {
    vm.searchDuration(value);
  }

  void _showCreateDialog() {
    if (!isDoctor) return;
    final controller = TextEditingController();
    String? errorText;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create Duration"),
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
                      labelText: "Duration",
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
                    final res = await vm.createDuration(controller.text.trim());
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

  void _showEditDialog(DurationModel item) {
    if (!isDoctor) return;
    final controller = TextEditingController(text: item.duration);
    String? errorText;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Duration"),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Duration",
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
                    final res = await vm.updateDuration(
                      item.id,
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

  void _deleteDialog(DurationModel item) {
    showDialog(
      context: context,
      builder: (context) {
        bool loading = false;
        String? error;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Delete Duration"),
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
                    final res = await vm.deleteDuration(item.id);
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
      child: Consumer<DurationViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Duration")),
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
                            hintText: "Search Duration...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: vm.filteredDurations.isEmpty
                            ? const Center(child: Text("No Duration Found"))
                            : RefreshIndicator(
                                onRefresh: _refresh,
                                child: ListView.builder(
                                  itemCount: vm.filteredDurations.length,
                                  itemBuilder: (context, index) {
                                    final item = vm.filteredDurations[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.access_time,
                                          color: Colors.blue,
                                        ),
                                        title: Text(item.duration),
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
