import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/diagnostic_center_register_screen.dart';
import '../../color/app_color.dart';
import '../../model/user_model.dart';
import '../../service/api_config.dart';
import '../../service/diagnostic_center_service.dart';
import '../../viewModel/dashboard/diagnostic_center_view_model.dart';
import 'diagnostic_center_details_screen.dart';

class DiagnosticCenterScreen extends StatelessWidget {
  const DiagnosticCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiagnosticCenterViewModel(
        service: DiagnosticCenterService(baseUrl: ApiConfig.baseUrl),
      )..loadDiagnosticCenters(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  ImageProvider? _getImage(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith("http")) {
      return NetworkImage(url);
    }
    return AssetImage(url);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiagnosticCenterViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: vm.searchController,
                  onChanged: vm.search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: vm.loading
                    ? const Center(child: CircularProgressIndicator())
                    : vm.centers.isEmpty
                    ? const Center(child: Text("No Diagnostic Center Found"))
                    : ListView.builder(
                        itemCount: vm.centers.length,
                        itemBuilder: (context, index) {
                          final UserModel item = vm.centers[index];
                          final image = _getImage(item.imageUrl);
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: image,
                                child: image == null
                                    ? Text(
                                        item.name != null &&
                                                item.name!.isNotEmpty
                                            ? item.name![0]
                                            : "D",
                                      )
                                    : null,
                              ),
                              title: Text(item.name ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.email ?? ''),
                                  Text(item.nationalId ?? ''),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DiagnosticCenterDetailsScreen(
                                          diagnosticCenter: item,
                                          service: vm.service,
                                        ),
                                  ),
                                ).then((_) {
                                  vm.loadDiagnosticCenters();
                                });
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.blue_200,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiagnosticCenterRegisterScreen(),
                ),
              ).then((_) {
                vm.loadDiagnosticCenters();
              });
            },
          ),
        );
      },
    );
  }
}