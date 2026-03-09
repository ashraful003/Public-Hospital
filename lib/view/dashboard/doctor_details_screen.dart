// doctor_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../color/app_color.dart';
import '../../model/home_item_model.dart';
import '../../model/doctor_model.dart';
import '../../viewmodel/dashboard/doctor_details_view_model.dart';
import '../../widgets/home_circle_item.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  bool get isMobile {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
  }

  bool get showBackButton {
    return !kIsWeb;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DoctorDetailsViewModel>(
      create: (_) => DoctorDetailsViewModel(doctor: doctor),
      child: Consumer<DoctorDetailsViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.blue_200,
              title: const Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              automaticallyImplyLeading: false,
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: vm.doctor.imageUrl != null
                        ? NetworkImage(vm.doctor.imageUrl!)
                        : const AssetImage('assets/doctor_placeholder.png')
                              as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    vm.doctor.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: ${vm.doctor.nationalId}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: vm.doctor.isActive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vm.doctor.isActive ? "Active" : "Inactive",
                        style: TextStyle(
                          fontSize: 14,
                          color: vm.doctor.isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.cake,
                            value: DateFormat(
                              'dd MMM yyyy',
                            ).format(vm.doctor.dob),
                          ),
                          _buildDetailRow(
                            icon: Icons.school_outlined,
                            value: vm.doctor.institute,
                          ),
                          _buildDetailRow(
                            icon: Icons.school,
                            value: vm.doctor.degree,
                          ),
                          _buildDetailRow(
                            icon: Icons.medical_services,
                            value: vm.doctor.specialist,
                          ),
                          _buildDetailRow(
                            icon: Icons.local_hospital,
                            value: vm.doctor.hospital,
                          ),
                          _buildDetailRow(
                            icon: Icons.location_on,
                            value: vm.doctor.address,
                          ),
                          _buildDetailRow(
                            icon: Icons.phone,
                            value: vm.doctor.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: isMobile
                ? HomeCircleItem(
                    item: HomeItemModel(
                      icon: Icons.phone,
                      bgColor: const Color(0xFF7E86E8),
                      title: '',
                    ),
                    circleSize: 60,
                    iconSize: 30,
                    onTap: () async {
                      final phoneNumber = vm.doctor.phone;
                      final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

                      if (await canLaunchUrl(callUri)) {
                        await launchUrl(callUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cannot make a call to $phoneNumber'),
                          ),
                        );
                      }
                    },
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
