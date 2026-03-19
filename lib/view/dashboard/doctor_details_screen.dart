import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:public_hospital/model/user_model.dart';
import '../../color/app_color.dart';
import '../../model/home_item_model.dart';
import '../../viewmodel/dashboard/doctor_details_view_model.dart';
import '../../widgets/home_circle_item.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final UserModel doctor;

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
          final d = vm.doctor;
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
                    backgroundImage: d.imageUrl != null &&
                        d.imageUrl!.isNotEmpty
                        ? d.imageUrl!.startsWith('http')
                        ? NetworkImage(d.imageUrl!) as ImageProvider
                        : AssetImage(d.imageUrl!) as ImageProvider
                        : const AssetImage('assets/doctor_placeholder.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    d.name ?? "Unknown Doctor",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: ${d.nationalId ?? "N/A"}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: (d.isActive == true) ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (d.isActive == true) ? "Active" : "Inactive",
                        style: TextStyle(
                          fontSize: 14,
                          color: (d.isActive == true)
                              ? Colors.green
                              : Colors.red,
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
                            icon: Icons.verified,
                            value: d.license ?? "N/A",
                          ),
                          _buildDetailRow(
                            icon: Icons.cake,
                            value: d.dob != null
                                ? DateFormat('dd MMM yyyy').format(d.dob!)
                                : "N/A",
                          ),
                          _buildDetailRow(
                            icon: Icons.school_outlined,
                            value: d.institute ?? "N/A",
                          ),
                          _buildDetailRow(
                            icon: Icons.school,
                            value: d.degree ?? "N/A",
                          ),
                          _buildDetailRow(
                            icon: Icons.medical_services,
                            value: d.specialist ?? "N/A",
                          ),
                          _buildDetailRow(
                            icon: Icons.email,
                            value: d.email ?? "N/A",
                          ),
                          _buildDetailRow(
                            icon: Icons.location_on,
                            value: d.address ?? "N/A",
                          ),
                          _buildDetailRow(
                            icon: Icons.phone,
                            value: d.phone ?? "N/A",
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
                final phoneNumber = d.phone ?? "";
                if (phoneNumber.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Phone number not available'),
                    ),
                  );
                  return;
                }
                final Uri callUri = Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                );
                if (await canLaunchUrl(callUri)) {
                  await launchUrl(callUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Cannot make a call to $phoneNumber',
                      ),
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