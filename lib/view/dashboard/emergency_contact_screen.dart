import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/emergency_contact_view_model.dart';
import '../../model/emergency_contact.dart';

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmergencyContactViewModel(),
      child: const _EmergencyContactView(),
    );
  }
}

class _EmergencyContactView extends StatefulWidget {
  const _EmergencyContactView();

  @override
  State<_EmergencyContactView> createState() => _EmergencyContactViewState();
}

class _EmergencyContactViewState extends State<_EmergencyContactView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmergencyContactViewModel>().fetchAllContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Consumer<EmergencyContactViewModel>(
              builder: (_, vm, __) => IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black87),
                onPressed: vm.retry,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<EmergencyContactViewModel>(
        builder: (context, vm, child) {
          if (vm.contacts.isNotEmpty) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton(
            backgroundColor: Colors.red,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _showAddDialog(context, vm);
            },
          );
        },
      ),
      body: Consumer<EmergencyContactViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "No",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Emergency",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Doctor",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "WhatsApp",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Action",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: vm.contacts.isEmpty
                      ? const Center(
                          child: Text(
                            "No Emergency Contact Found",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: vm.contacts.length,
                          itemBuilder: (context, index) {
                            final contact = vm.contacts[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "${index + 1}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        contact.emergencyNumber,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        contact.emergencyDoctorNumber,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        contact.emergencyDoctorWhatsappNumber,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              _showEditDialog(context, contact);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              final vm = context
                                                  .read<
                                                    EmergencyContactViewModel
                                                  >();
                                              _showDeleteDialog(
                                                context,
                                                contact,
                                                vm,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    EmergencyContact contact,
  ) async {
    final emergencyCtrl = TextEditingController(text: contact.emergencyNumber);
    final doctorCtrl = TextEditingController(
      text: contact.emergencyDoctorNumber,
    );
    final whatsappCtrl = TextEditingController(
      text: contact.emergencyDoctorWhatsappNumber,
    );
    String? errorMessage;
    bool isLoading = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text("Update Contact"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emergencyCtrl,
                    decoration: const InputDecoration(
                      labelText: "Emergency Number",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: doctorCtrl,
                    decoration: const InputDecoration(
                      labelText: "Doctor Number",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: whatsappCtrl,
                    decoration: const InputDecoration(
                      labelText: "WhatsApp Number",
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          try {
                            final vm = context
                                .read<EmergencyContactViewModel>();
                            final success = await vm.updateContact(
                              id: contact.id,
                              emergencyNumber: emergencyCtrl.text.trim(),
                              emergencyDoctorNumber: doctorCtrl.text.trim(),
                              emergencyDoctorWhatsappNumber: whatsappCtrl.text
                                  .trim(),
                            );
                            if (!context.mounted) return;
                            if (success) {
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Updated Successfully"),
                                ),
                              );
                            } else {
                              setState(() {
                                errorMessage =
                                    "Update failed. Please try again.";
                              });
                            }
                          } catch (e) {
                            setState(() {
                              errorMessage = e.toString();
                            });
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    EmergencyContact contact,
    EmergencyContactViewModel vm,
  ) async {
    String error = '';
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                "Delete Emergency Contact",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure to delete this item?",
                    textAlign: TextAlign.center,
                  ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final success = await vm.deleteContact(contact.id!);
                    if (success) {
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        error = vm.errorMessage.isNotEmpty
                            ? vm.errorMessage
                            : "Delete failed";
                      });
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

  Future<void> _showAddDialog(
    BuildContext context,
    EmergencyContactViewModel vm,
  ) async {
    final emergencyCtrl = TextEditingController();
    final doctorCtrl = TextEditingController();
    final whatsappCtrl = TextEditingController();
    bool isLoading = false;
    String? errorMessage;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Center(child: Text("Add Emergency Contact")),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emergencyCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Emergency Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: doctorCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Doctor Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: whatsappCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "WhatsApp Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (emergencyCtrl.text.trim().isEmpty ||
                              doctorCtrl.text.trim().isEmpty ||
                              whatsappCtrl.text.trim().isEmpty) {
                            setState(() {
                              errorMessage = "All fields are required";
                            });
                            return;
                          }
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          try {
                            final success = await vm.createContact(
                              emergencyNumber: emergencyCtrl.text.trim(),
                              emergencyDoctorNumber: doctorCtrl.text.trim(),
                              emergencyDoctorWhatsappNumber: whatsappCtrl.text
                                  .trim(),
                            );
                            if (!mounted) return;
                            if (success) {
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Contact Added Successfully"),
                                ),
                              );
                            } else {
                              setState(() {
                                errorMessage = vm.errorMessage;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              errorMessage = e.toString();
                            });
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
