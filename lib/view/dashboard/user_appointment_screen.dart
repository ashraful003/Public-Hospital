import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/appointment_model.dart';
import '../../viewModel/dashboard/user_appointment_view_model.dart';

class UserAppointmentScreen extends StatefulWidget {
  final String patientId;

  const UserAppointmentScreen({super.key, required this.patientId});

  @override
  State<UserAppointmentScreen> createState() => _UserAppointmentScreenState();
}

class _UserAppointmentScreenState extends State<UserAppointmentScreen> {
  bool showCurrent = true;

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          UserAppointmentViewModel()..fetchAppointments(widget.patientId),
      child: Scaffold(
        appBar: AppBar(title: const Text("My Appointments")),
        body: Consumer<UserAppointmentViewModel>(
          builder: (context, vm, child) {
            if (vm.state == ViewState.loading || vm.state == ViewState.idle) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.state == ViewState.error) {
              return Center(child: Text(vm.errorMessage ?? "Error"));
            }
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
                            onPressed: () {
                              setState(() {
                                showCurrent = true;
                              });
                              vm.toggleView(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: showCurrent
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              foregroundColor: showCurrent
                                  ? Colors.white
                                  : Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                            onPressed: () {
                              setState(() {
                                showCurrent = false;
                              });
                              vm.toggleView(false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !showCurrent
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              foregroundColor: !showCurrent
                                  ? Colors.white
                                  : Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text(
                              "History",
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
                    onRefresh: () => vm.refresh(widget.patientId),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: vm.appointments.length,
                      itemBuilder: (context, index) {
                        final AppointmentModel item = vm.appointments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              item.doctorName ?? "Unknown Doctor",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Specialist: ${item.specialist ?? '-'}"),
                                Text("Date: ${item.date ?? '-'}"),
                                Text("Time: ${item.startTime ?? '-'}"),
                                Text("Serial No: ${item.serialNo ?? '-'}"),
                                Text("Status: ${item.status ?? '-'}"),
                                if (item.reason != null &&
                                    item.reason!.isNotEmpty)
                                  Text("Reason: ${item.reason}"),
                              ],
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
}
