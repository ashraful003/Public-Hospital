import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../model/user_model.dart';
import '../../model/home_item_model.dart';
import '../../viewModel/dashboard/pharmacist_details_view_model.dart';
import '../../widgets/home_circle_item.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacistDetailsScreen extends StatelessWidget {
  final UserModel pharmacist;

  const PharmacistDetailsScreen({super.key, required this.pharmacist});

  bool get isMobilePlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PharmacistDetailsViewModel>(
      create: (_) => PharmacistDetailsViewModel(pharmacist: pharmacist),
      child: Consumer<PharmacistDetailsViewModel>(
        builder: (context, vm, _) {
          final formattedDate = vm.pharmacist.dob != null
              ? DateFormat('dd MMM yyyy').format(vm.pharmacist.dob!)
              : "N/A";
          ImageProvider? _getImage() {
            final img = vm.pharmacist.imageUrl;
            if (img == null || img.isEmpty) return null;
            if (img.startsWith("http")) {
              return NetworkImage(img);
            } else {
              return AssetImage(img);
            }
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.blue_200,
              title: const Text(
                'Pharmacist Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: !kIsWeb,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      const SizedBox(height: 8),
                      Text(
                        vm.pharmacist.name ?? "Unknown Pharmacist",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID : ${vm.pharmacist.nationalId ?? "N/A"}',
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
                            color: vm.pharmacist.isActive == true
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vm.pharmacist.isActive == true
                                ? 'Active'
                                : 'Inactive',
                            style: TextStyle(
                              fontSize: 14,
                              color: vm.pharmacist.isActive == true
                                  ? Colors.green
                                  : Colors.red,
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
                              _buildDetailsRow(
                                icon: Icons.cake,
                                value: formattedDate,
                              ),
                              _buildDetailsRow(
                                icon: Icons.school,
                                value: vm.pharmacist.institute ?? "N/A",
                              ),
                              _buildDetailsRow(
                                icon: Icons.workspace_premium,
                                value: vm.pharmacist.degree ?? "N/A",
                              ),
                              _buildDetailsRow(
                                icon: Icons.email,
                                value: vm.pharmacist.email ?? "N/A",
                              ),
                              _buildDetailsRow(
                                icon: Icons.location_on,
                                value: vm.pharmacist.address ?? "N/A",
                              ),
                              _buildDetailsRow(
                                icon: Icons.phone,
                                value: vm.pharmacist.phone ?? "N/A",
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
                    bottom: 20,
                    right: 0,
                    child: SafeArea(
                      child: HomeCircleItem(
                        item: HomeItemModel(
                          title: '',
                          icon: Icons.phone,
                          bgColor: const Color(0xFF7E86E8),
                        ),
                        circleSize: 60,
                        iconSize: 30,
                        onTap: () async {
                          final phoneNumber = vm.pharmacist.phone ?? '';
                          if (phoneNumber.isEmpty) return;
                          final Uri callUri = Uri(
                            scheme: 'tel',
                            path: phoneNumber,
                          );
                          if (await canLaunchUrl(callUri)) {
                            await launchUrl(callUri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Cannot call $phoneNumber'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailsRow({required IconData icon, required String value}) {
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
