import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/pharmaceutical_register_screen.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/pharmaceutical_view_model.dart';
import '../../model/user_model.dart';
import 'pharmaceutical_details_screen.dart';

class PharmaceuticalScreen extends StatelessWidget {
  const PharmaceuticalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PharmaceuticalViewModel()..loadPharmaceuticals(),
      child: const _PharmaceuticalView(),
    );
  }
}

class _PharmaceuticalView extends StatelessWidget {
  const _PharmaceuticalView();

  ImageProvider? _getImage(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith("http")) {
      return NetworkImage(url);
    }
    return AssetImage(url);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmaceuticalViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Pharmaceutical List",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.blue_200,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: vm.searchController,
                  onChanged: vm.search,
                  decoration: InputDecoration(
                    hintText: "Search pharmaceutical",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : vm.pharmaceuticals.isEmpty
                    ? const Center(child: Text("No Pharmaceutical Found"))
                    : ListView.builder(
                        itemCount: vm.pharmaceuticals.length,
                        itemBuilder: (context, index) {
                          final UserModel item = vm.pharmaceuticals[index];
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
                                            : "P",
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
                                    builder: (_) => PharmaceuticalDetailsScreen(
                                      pharmaceutical: item,
                                    ),
                                  ),
                                ).then((value) {
                                  vm.loadPharmaceuticals();
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
                  builder: (_) => const PharmaceuticalRegisterScreen(),
                ),
              ).then((value) {
                vm.loadPharmaceuticals();
              });
            },
          ),
        );
      },
    );
  }
}
