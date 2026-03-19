import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/color/app_color.dart';
import 'package:public_hospital/view/dashboard/doctor_assistant_details_screen.dart';
import 'package:public_hospital/viewModel/dashboard/doctor_assistant_view_model.dart';

class DoctorAssistantScreen extends StatelessWidget {
  const DoctorAssistantScreen({super.key});

  bool get showBackButton {
    if (kIsWeb) return false;

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorAssistantViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F7),
        appBar: AppBar(
          backgroundColor: AppColors.blue_200,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'Doctor Assistant',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: showBackButton
              ? IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.arrow_back),
          )
              : null,
        ),
        body: Consumer<DoctorAssistantViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                // Tabs
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildTab(
                        title: 'Doctor Assistant',
                        isSelected: vm.selectedTab == DoctorAssistantTab.all,
                        onTab: () => vm.changeTab(DoctorAssistantTab.all),
                      ),
                      _buildTab(
                        title: 'Active Assistant',
                        isSelected: vm.selectedTab == DoctorAssistantTab.active,
                        onTab: () => vm.changeTab(DoctorAssistantTab.active),
                      ),
                    ],
                  ),
                ),

                // Search + List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Search Field
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search by National ID',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: vm.searchByNationalId,
                        ),
                        const SizedBox(height: 20),

                        // Assistant List
                        Expanded(
                          child: vm.assistants.isEmpty
                              ? const Center(
                            child: Text(
                              'No Assistant Found',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                              : ListView.builder(
                            itemCount: vm.assistants.length,
                            itemBuilder: (context, index) {
                              final assistant = vm.assistants[index];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: assistant.imageUrl != null &&
                                        assistant.imageUrl!.isNotEmpty
                                        ? AssetImage(assistant.imageUrl!)
                                    as ImageProvider
                                        : null,
                                    child: assistant.imageUrl == null ||
                                        assistant.imageUrl!.isEmpty
                                        ? const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    )
                                        : null,
                                  ),
                                  title: Text(
                                    assistant.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'National ID: ${assistant.nationalId}',
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DoctorAssistantDetailsScreen(
                                              assistant: assistant,
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
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTab,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTab,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.blue_200 : Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 3,
              color: isSelected ? AppColors.blue_200 : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}