import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/blood_bank_model.dart';
import '../../model/home_item_model.dart';
import '../../viewModel/dashboard/blood_donor_details_view_model.dart';
import '../../widgets/home_circle_item.dart';

class BloodDonorDetailsScreen extends StatelessWidget {
  final BloodBankModel donor;

  const BloodDonorDetailsScreen({super.key, required this.donor});

  Future<void> _makeCall(BuildContext context, String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open dial pad")));
    }
  }

  bool get isMobile {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BloodDonorDetailsViewModel(donor: donor),
      child: Scaffold(
        appBar: AppBar(title: const Text("Donor Details")),
        floatingActionButton: isMobile
            ? Consumer<BloodDonorDetailsViewModel>(
                builder: (context, vm, _) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: HomeCircleItem(
                      item: HomeItemModel(
                        icon: Icons.phone,
                        bgColor: const Color(0xFF4CAF50),
                        title: '',
                      ),
                      circleSize: 60,
                      iconSize: 28,
                      onTap: () async {
                        final phoneNumber = vm.phone;
                        if (phoneNumber.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Phone number not available'),
                            ),
                          );
                          return;
                        }
                        final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
                        try {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cannot call $phoneNumber')),
                          );
                        }
                      },
                    ),
                  );
                },
              )
            : null,
        body: Consumer<BloodDonorDetailsViewModel>(
          builder: (context, vm, child) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16, top: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow("Name", vm.name),
                    _buildRow("Blood Group", vm.bloodGroup),
                    _buildRow("Duration", "${vm.daysAgo} days"),
                    _buildRow("Email", vm.email),
                    _buildRow("Phone", vm.phone),
                    _buildRow("Address", vm.address),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
