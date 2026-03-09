import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/color/app_color.dart';
import 'package:public_hospital/viewModel/dashboard/nurse_details_view_model.dart';
import 'package:public_hospital/model/nurse_model.dart';
import 'package:public_hospital/model/home_item_model.dart';
import 'package:public_hospital/widgets/home_circle_item.dart';
import 'package:url_launcher/url_launcher.dart';

class NurseDetailsScreen extends StatelessWidget {
  final NurseModel nurse;

  const NurseDetailsScreen({super.key, required this.nurse});

  bool get isMobilePlatform {
    if (kIsWeb) return false;

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NurseDetailsViewModel>(
      create: (_) => NurseDetailsViewModel(nurse: nurse),
      child: Consumer<NurseDetailsViewModel>(
        builder: (context, vm, _) {
          final formattedDate = DateFormat('dd MMM yyyy').format(vm.nurse.dob);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.blue_200,
              title: const Text("Nurse Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                    bottom: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            vm.nurse.imageUrl != null &&
                                vm.nurse.imageUrl!.isNotEmpty
                            ? NetworkImage(vm.nurse.imageUrl!)
                            : const AssetImage('assets/doctor_placeholder.png')
                                  as ImageProvider,
                      ),

                      const SizedBox(height: 8),
                      Text(
                        vm.nurse.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),
                      Text(
                        "ID: ${vm.nurse.nationalId}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: vm.nurse.isActive
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vm.nurse.isActive ? "Active" : "Inactive",
                            style: TextStyle(
                              fontSize: 14,
                              color: vm.nurse.isActive
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
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
                                icon: Icons.phone,
                                value: vm.nurse.phone,
                              ),
                              _buildDetailRow(
                                icon: Icons.email,
                                value: vm.nurse.email,
                              ),
                              _buildDetailRow(
                                icon: Icons.location_on,
                                value: vm.nurse.address,
                              ),
                              _buildDetailRow(
                                icon: Icons.cake,
                                value: formattedDate,
                              ),
                              _buildDetailRow(
                                icon: Icons.school,
                                value: vm.nurse.institute,
                              ),
                              _buildDetailRow(
                                icon: Icons.workspace_premium,
                                value: vm.nurse.degree,
                              ),
                              _buildDetailRow(
                                icon: Icons.verified,
                                value: vm.nurse.license,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                if (isMobilePlatform)
                  Positioned(
                    bottom: 40,
                    right: 0,
                    child: HomeCircleItem(
                      item: HomeItemModel(
                        icon: Icons.phone,
                        bgColor: const Color(0xFF7E86E8),
                        title: '',
                      ),
                      circleSize: 60,
                      iconSize: 30,
                      onTap: () async {
                        final phoneNumber = vm.nurse.phone;
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
                    ),
                  ),
              ],
            ),
          );
        },
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
