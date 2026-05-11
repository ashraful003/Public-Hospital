import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../view/dashboard/add_medicine_screen.dart';
import '../../view/dashboard/medicine_details_screen.dart';
import '../../viewModel/dashboard/medicine_view_model.dart';
import '../../viewModel/dashboard/profile_view_model.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(
          create: (_) {
            final vm = MedicineViewModel();
            vm.loadRole();
            return vm;
          },
        ),
      ],
      child: const _MedicineView(),
    );
  }
}

class _MedicineView extends StatefulWidget {
  const _MedicineView();

  @override
  State<_MedicineView> createState() => _MedicineViewState();
}

class _MedicineViewState extends State<_MedicineView> {
  late ProfileViewModel profileVM;
  late MedicineViewModel medicineVM;
  bool _initialized = false;

  Future<void> loadData() async {
    await profileVM.loadProfile("PHARMACEUTICAL");
    await medicineVM.loadMedicines(profileVM);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      profileVM = context.read<ProfileViewModel>();
      medicineVM = context.read<MedicineViewModel>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadData();
      });
      _initialized = true;
    }
  }

  Future<void> refreshData() async {
    await medicineVM.loadMedicines(profileVM);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MedicineViewModel, ProfileViewModel>(
      builder: (context, vm, profileVM, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Medicine Store",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.blue_200,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          floatingActionButton: vm.canAddMedicine
              ? FloatingActionButton(
                  backgroundColor: AppColors.blue_200,
                  child: const Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddMedicineScreen(),
                      ),
                    );
                    if (result == true && context.mounted) {
                      await refreshData();
                    }
                  },
                )
              : null,
          body: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: vm.searchController,
                  onChanged: vm.search,
                  decoration: InputDecoration(
                    hintText: "Search medicine...",
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
                    : vm.medicines.isEmpty
                    ? const Center(child: Text("No Medicine Found"))
                    : RefreshIndicator(
                        onRefresh: refreshData,
                        child: ListView.builder(
                          itemCount: vm.medicines.length,
                          itemBuilder: (context, index) {
                            final m = vm.medicines[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MedicineDetailsScreen(medicine: m),
                                    ),
                                  );
                                  if (result == true) {
                                    medicineVM.loadMedicines(profileVM);
                                  }
                                },
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.blue.shade50,
                                  child: Text(
                                    m.medicineName?.isNotEmpty == true
                                        ? m.medicineName![0].toUpperCase()
                                        : "M",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  m.medicineName ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(m.power ?? ''),
                                      const SizedBox(height: 4),
                                      Text(
                                        m.name ?? '',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
