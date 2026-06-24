import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/user_appointment_screen.dart';
import '../../model/user_model.dart';
import '../../service/appointment_service.dart';
import '../../service/profile_service.dart';
import '../../viewModel/dashboard/new_appointment_viewmodel.dart';

class NewAppointmentScreen extends StatefulWidget {
  final UserModel doctor;

  const NewAppointmentScreen({super.key, required this.doctor});

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  late NewAppointmentViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = NewAppointmentViewModel(
      appointmentService: AppointmentService(),
      profileService: ProfileService(),
    );
    vm.loadInfo(doctorInfo: widget.doctor);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Scaffold(
        appBar: AppBar(title: const Text("New Appointment")),
        body: Consumer<NewAppointmentViewModel>(
          builder: (context, vm, child) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null && vm.patient == null) {
              return Center(child: Text(vm.error!));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Doctor: ${vm.doctor?.name ?? "-"}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Degree: ${vm.doctor?.degree ?? "-"}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Specialist: ${vm.doctor?.specialist ?? "-"}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Patient: ${vm.patient?.name ?? "-"}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: ${vm.patient?.nationalId ?? "-"}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Patient Type",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Radio<PatientType>(
                        value: PatientType.self,
                        groupValue: vm.patientType,
                        onChanged: (value) {
                          if (value != null) vm.setPatientType(value);
                        },
                      ),
                      const Text("Self"),
                      Radio<PatientType>(
                        value: PatientType.other,
                        groupValue: vm.patientType,
                        onChanged: (value) {
                          if (value != null) vm.setPatientType(value);
                        },
                      ),
                      const Text("Other"),
                    ],
                  ),
                  if (vm.patientType == PatientType.other) ...[
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: vm.setOtherPatientName,
                      decoration: const InputDecoration(
                        labelText: "Patient Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: vm.setOtherPatientId,
                      decoration: const InputDecoration(
                        labelText: "Patient ID",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    "Appointment Schedule",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  if (vm.availableDates.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("No available schedules for this doctor."),
                    )
                  else
                    DropdownButtonFormField<String>(
                      value: vm.selectedDate,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Select Date",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      items: vm.availableDates.map((date) {
                        return DropdownMenuItem(value: date, child: Text(date));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) vm.selectDate(value);
                      },
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: vm.day),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Day",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(text: vm.startTime),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Start Time",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(text: vm.endTime),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "End Time",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (vm.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        vm.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: vm.submitting
                          ? null
                          : () async {
                              final success = await vm.submitAppointment();
                              if (!context.mounted) return;
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      vm.successMessage ??
                                          "Appointment booked successfully",
                                    ),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UserAppointmentScreen(
                                      patientId: vm.patient!.nationalId!,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      vm.error ??
                                          "Appointment created successfully",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      child: vm.submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Confirm Appointment",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
