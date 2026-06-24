import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/prescription_screen.dart';
import '../../model/appointment_model.dart';
import '../../viewModel/dashboard/patient_appointment_view_model.dart';

class PatientAppointmentScreen extends StatefulWidget {
  final String patientId;
  final String role;

  const PatientAppointmentScreen({
    super.key,
    required this.patientId,
    required this.role,
  });

  @override
  State<PatientAppointmentScreen> createState() =>
      _PatientAppointmentScreenState();
}

class _PatientAppointmentScreenState extends State<PatientAppointmentScreen> {
  bool showToday = true;

  Color _statusColor(String? status) {
    switch (status?.toUpperCase()) {
      case "VISITED":
        return Colors.green;
      case "CANCELLED":
      case "REJECTED":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  bool _isLocked(String? status) {
    switch (status?.toUpperCase()) {
      case "VISITED":
      case "CANCELLED":
      case "REJECTED":
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = widget.role.toUpperCase() == "DOCTOR";
    return ChangeNotifierProvider(
      create: (_) =>
          PatientAppointmentViewModel()
            ..fetchAppointments(userId: widget.patientId, role: widget.role),
      child: Scaffold(
        appBar: AppBar(title: const Text("My Appointments")),
        body: Consumer<PatientAppointmentViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.state == ViewState.loading ||
                viewModel.state == ViewState.idle) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.state == ViewState.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(viewModel.errorMessage ?? "Error"),
                    ElevatedButton(
                      onPressed: () => viewModel.fetchAppointments(
                        userId: widget.patientId,
                        role: widget.role,
                      ),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }
            final appointments = viewModel.appointments;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: showToday
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              foregroundColor: showToday
                                  ? Colors.white
                                  : Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() => showToday = true);
                              viewModel.toggleView(true);
                            },
                            child: const Text(
                              "Appointments",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !showToday
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              foregroundColor: !showToday
                                  ? Colors.white
                                  : Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() => showToday = false);
                              viewModel.toggleView(false);
                            },
                            child: const Text(
                              "Old Appointments",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => viewModel.refresh(
                      userId: widget.patientId,
                      role: widget.role,
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final item = appointments[index];
                        final locked = _isLocked(item.status);
                        return Card(
                          child: InkWell(
                            onTap: isDoctor
                                ? () => _showPrescriptionDialog(context, item)
                                : null,
                            child: Opacity(
                              opacity: isDoctor ? 1.0 : 0.7,
                              child: ListTile(
                                title: Text(
                                  item.patientName ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ID: ${item.patientId ?? '-'}"),
                                    Text("Serial: ${item.serialNo ?? '-'}"),
                                    Text("Date: ${item.date ?? ''}"),
                                    Text("Time: ${item.startTime ?? ''}"),
                                    Text("Status: ${item.status ?? ''}"),
                                    if (item.reason != null &&
                                        item.reason!.isNotEmpty)
                                      Text("Reason: ${item.reason}"),
                                  ],
                                ),
                                trailing: isDoctor
                                    ? GestureDetector(
                                        onTap: locked
                                            ? null
                                            : () => _showStatusDialog(
                                                context,
                                                item,
                                                viewModel,
                                              ),
                                        child: Opacity(
                                          opacity: locked ? 0.5 : 1.0,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: _statusColor(
                                                item.status,
                                              ).withOpacity(0.15),
                                              border: Border.all(
                                                color: _statusColor(
                                                  item.status,
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              item.status ?? "WAITING",
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showStatusDialog(
    BuildContext context,
    AppointmentModel item,
    PatientAppointmentViewModel viewModel,
  ) async {
    String selectedStatus = "VISITED";
    final reasonController = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Status"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: const [
                      DropdownMenuItem(
                        value: "VISITED",
                        child: Text("VISITED"),
                      ),
                      DropdownMenuItem(
                        value: "CANCELLED",
                        child: Text("CANCELLED"),
                      ),
                      DropdownMenuItem(
                        value: "REJECTED",
                        child: Text("REJECTED"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => selectedStatus = value!);
                    },
                  ),
                  const SizedBox(height: 10),
                  if (selectedStatus == "CANCELLED" ||
                      selectedStatus == "REJECTED")
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                        labelText: "Reason (required)",
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Close"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if ((selectedStatus == "CANCELLED" ||
                            selectedStatus == "REJECTED") &&
                        reasonController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Reason is required")),
                      );
                      return;
                    }
                    await viewModel.updateStatus(
                      appointmentId: item.id!,
                      status: selectedStatus,
                      reason:
                          (selectedStatus == "CANCELLED" ||
                              selectedStatus == "REJECTED")
                          ? reasonController.text.trim()
                          : null,
                      userId: widget.patientId,
                      role: widget.role,
                    );
                    Navigator.pop(dialogContext);
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

  Future<void> _showPrescriptionDialog(
    BuildContext context,
    AppointmentModel item,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Prescription"),
          content: const Text("Do you want to open the prescription screen?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    if (result == true && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PrescriptionScreen(
            patientId: item.patientId ?? "",
            role: widget.role,
          ),
        ),
      );
    }
  }
}
