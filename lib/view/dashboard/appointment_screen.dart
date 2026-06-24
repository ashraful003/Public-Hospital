import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_model.dart';
import '../../service/appointment_service.dart';
import '../../viewModel/dashboard/appointment_viewmodel.dart';
import 'new_appointment_screen.dart';

class AppointmentScreen extends StatefulWidget {
  final String role;
  final String patientId;
  final String department;

  const AppointmentScreen({
    super.key,
    required this.role,
    required this.patientId,
    required this.department,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late AppointmentViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = AppointmentViewModel(service: AppointmentService());
    vm.loadDoctors(widget.department);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Scaffold(
        appBar: AppBar(title: const Text("Doctors")),
        body: Consumer<AppointmentViewModel>(
          builder: (context, vm, child) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(child: Text(vm.error!));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Text(
                    widget.department,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final UserModel doctor = vm.filteredDoctors[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.blue),
                          title: Text(doctor.name ?? "No Name"),
                          subtitle: Text(doctor.specialist ?? "General Doctor"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NewAppointmentScreen(doctor: doctor),
                              ),
                            );
                          },
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
}
