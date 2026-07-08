import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/doctor_bn_view_model.dart';
import 'doctor_bn_profile_create_screen.dart';
import 'doctor_bn_profile_update_screen.dart';

class DoctorBnScreen extends StatelessWidget {
  final String doctorId;

  const DoctorBnScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorBnViewModel(doctorId: doctorId)..loadDoctor(),
      child: _DoctorBnView(doctorId: doctorId),
    );
  }
}

class _DoctorBnView extends StatelessWidget {
  final String doctorId;

  const _DoctorBnView({required this.doctorId});

  bool _hasId(DoctorBnViewModel vm) {
    return vm.doctor != null && vm.doctor!.id != null;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DoctorBnViewModel>();
    return Scaffold(
      appBar: _buildAppBar(context, vm),
      body: RefreshIndicator(onRefresh: vm.loadDoctor, child: _buildBody(vm)),
      floatingActionButton: _hasId(vm)
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.blue_200,
              tooltip: "Create Profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoctorBnCreateScreen(doctorBnId: doctorId),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, DoctorBnViewModel vm) {
    final doctor = vm.doctor;
    return AppBar(
      backgroundColor: AppColors.blue_200,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        "Profile",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        if (doctor != null && doctor.id != null)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              tooltip: "Edit Profile",
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoctorBnProfileUpdateScreen(
                      id: doctor.id!.toString(),
                      doctorBnId: doctor.doctorBnId,
                    ),
                  ),
                );
                if (result == true) {
                  vm.loadDoctor();
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(DoctorBnViewModel vm) {
    if (vm.isLoading && vm.doctor == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null && vm.doctor == null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(child: Text(vm.error!)),
        ],
      );
    }
    if (vm.doctor == null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Center(child: Text("Doctor not found.")),
        ],
      );
    }
    final doctor = vm.doctor!;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage("assets/images/person.png"),
          ),
          const SizedBox(height: 12),
          Text(
            doctor.doctorBnName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            "ID: ${doctor.doctorBnId}",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 25),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.school,
                    value: doctor.doctorBnDegree,
                  ),
                  _buildDetailRow(
                    icon: Icons.medical_services,
                    value: doctor.doctorBnSpecialist,
                  ),
                  _buildDetailRow(
                    icon: Icons.location_city,
                    value: doctor.doctorBnInstitute,
                  ),
                  _buildDetailRow(
                    icon: Icons.verified_user,
                    value: doctor.doctorBnLicense,
                  ),
                  _buildDetailRow(
                    icon: Icons.access_time,
                    value: doctor.doctorBnVisitingTime,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.blue_200),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}