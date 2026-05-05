import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:public_hospital/color/app_color.dart';
import 'package:public_hospital/model/user_model.dart';
import 'package:public_hospital/viewModel/dashboard/nurse_details_view_model.dart';
import 'package:public_hospital/model/home_item_model.dart';
import 'package:public_hospital/widgets/home_circle_item.dart';

class NurseDetailsScreen extends StatelessWidget {
  final UserModel nurse;

  const NurseDetailsScreen({super.key, required this.nurse});

  bool get isMobilePlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NurseDetailsViewModel(nurse: nurse),
      child: Consumer<NurseDetailsViewModel>(
        builder: (context, vm, _) {
          final dob = vm.nurse.dob;
          final formattedDate = dob != null
              ? DateFormat('dd MMM yyyy').format(dob)
              : "N/A";
          final image = vm.nurse.imageUrl;
          ImageProvider? _getImage() {
            final img = vm.nurse.imageUrl;
            if (img == null || img.isEmpty) return null;
            if (img.startsWith("http")) {
              return NetworkImage(img);
            } else {
              return AssetImage(img);
            }
          }

          return Scaffold(
            backgroundColor: const Color(0xffF2F3F7),
            appBar: AppBar(
              backgroundColor: AppColors.blue_200,
              title: const Text(
                "Nurse Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 20,
                    bottom: 100,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _getImage(),
                        child: _getImage() == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        vm.nurse.name ?? "Unknown Nurse",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ID: ${vm.nurse.nationalId ?? "N/A"}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: vm.nurse.isActive == true
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            vm.nurse.isActive == true ? "Active" : "Inactive",
                            style: TextStyle(
                              color: vm.nurse.isActive == true
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
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
                                icon: Icons.verified,
                                value: vm.nurse.license ?? "N/A",
                              ),
                              _buildDetailRow(
                                icon: Icons.cake,
                                value: formattedDate,
                              ),
                              _buildDetailRow(
                                icon: Icons.school,
                                value: vm.nurse.institute ?? "N/A",
                              ),
                              _buildDetailRow(
                                icon: Icons.workspace_premium,
                                value: vm.nurse.degree ?? "N/A",
                              ),
                              _buildDetailRow(
                                icon: Icons.email,
                                value: vm.nurse.email ?? "N/A",
                              ),
                              _buildDetailRow(
                                icon: Icons.location_on,
                                value: vm.nurse.address ?? "N/A",
                              ),
                              _buildDetailRow(
                                icon: Icons.phone,
                                value: vm.nurse.phone ?? "N/A",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 220),
                    ],
                  ),
                ),
                if (isMobilePlatform)
                  Positioned(
                    bottom: 25,
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
                        final phone = vm.nurse.phone;
                        if (phone == null || phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Phone number not available'),
                            ),
                          );
                          return;
                        }
                        final Uri callUri = Uri(scheme: 'tel', path: phone);
                        if (await canLaunchUrl(callUri)) {
                          await launchUrl(callUri);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cannot call $phone')),
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
