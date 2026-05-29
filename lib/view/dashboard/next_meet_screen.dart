import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/next_meet_view_model.dart';

class NextMeetScreen extends StatefulWidget {
  final String role;
  final String nationalId;

  const NextMeetScreen({
    super.key,
    required this.role,
    required this.nationalId,
  });

  @override
  State<NextMeetScreen> createState() => _NextMeetScreenState();
}

class _NextMeetScreenState extends State<NextMeetScreen> {
  late NextMeetViewModel vm;
  final TextEditingController searchController = TextEditingController();

  bool get isDoctor => widget.role.toLowerCase() == "doctor";

  bool get isAdmin => widget.role.toLowerCase() == "admin";

  @override
  void initState() {
    super.initState();
    vm = NextMeetViewModel(widget.nationalId);
    vm.loadCurrentUserAndMeetTime();
  }

  Future<void> _refresh() async {
    await vm.loadCurrentUserAndMeetTime();
  }

  void _onSearch(String value) {
    vm.searchMeet(value);
  }

  void _showAddDialog() {
    if (!isDoctor) return;
    vm.durationController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Next Meet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ID: ${vm.nationalId}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: vm.durationController,
                decoration: const InputDecoration(
                  labelText: "Duration",
                  border: OutlineInputBorder(),
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
                final success = await vm.createMeet();
                if (!context.mounted) return;
                if (success) {
                  Navigator.pop(context);
                  vm.loadCurrentUserAndMeetTime();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Created successfully")),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog({
    required int id,
    required String nationalId,
    required String duration,
  }) {
    if (!isDoctor) return;
    vm.setEditData(duration);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Meet Time"),
          content: TextField(
            controller: vm.durationController,
            decoration: const InputDecoration(
              labelText: "Duration",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await vm.updateMeetTime(id);
                if (!context.mounted) return;
                if (success) {
                  Navigator.pop(context);
                  vm.loadCurrentUserAndMeetTime();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Updated successfully")),
                  );
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _deleteMeet(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
    if (confirm != true) return;
    await vm.deleteMeet(id);
    vm.loadCurrentUserAndMeetTime();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Deleted successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<NextMeetViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Next Meet Time")),
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
                            hintText: "Search Meet Time",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: vm.meetList.isEmpty
                            ? const Center(child: Text("No meet time found"))
                            : RefreshIndicator(
                                onRefresh: _refresh,
                                child: ListView.builder(
                                  itemCount: vm.filteredMeetList.length,
                                  itemBuilder: (context, index) {
                                    final meet = vm.filteredMeetList[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                meet.duration,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),

                                            Row(
                                              children: [
                                                if (isDoctor)
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      _showEditDialog(
                                                        id: meet.id,
                                                        nationalId:
                                                            meet.nationalId,
                                                        duration: meet.duration,
                                                      );
                                                    },
                                                  ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () =>
                                                      _deleteMeet(meet.id),
                                                ),
                                              ],
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
            floatingActionButton: isDoctor
                ? FloatingActionButton(
                    onPressed: _showAddDialog,
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        },
      ),
    );
  }
}
