import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/appointment_screen.dart';
import '../../viewModel/dashboard/department_viewmodel.dart';

class DepartmentScreen extends StatelessWidget {
  final String role;
  final String patientId;

  const DepartmentScreen({
    super.key,
    required this.role,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DepartmentViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Departments")),
        body: Consumer<DepartmentViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.departments.length,
                    itemBuilder: (context, index) {
                      final department = vm.departments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Icon(department.icon, color: Colors.blue),
                          title: Text(department.name),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AppointmentScreen(
                                  role: role,
                                  patientId: patientId,
                                  department: department.name,
                                ),
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
