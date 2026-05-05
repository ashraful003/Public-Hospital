import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_model.dart';
import '../../viewModel/dashboard/ambulance_view_model.dart';
import 'ambulance_details_screen.dart';

class AmbulanceScreen extends StatelessWidget {
  const AmbulanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AmbulanceViewModel()..loadDrivers(),
      child: const _AmbulanceView(),
    );
  }
}

class _AmbulanceView extends StatelessWidget {
  const _AmbulanceView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AmbulanceViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text("Ambulance"), centerTitle: true),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(AmbulanceViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }
    if (vm.drivers.isEmpty) {
      return const Center(child: Text("No Active Drivers Found"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: vm.drivers.length,
      itemBuilder: (context, index) {
        final driver = vm.drivers[index];
        return _DriverCard(driver: driver);
      },
    );
  }
}

class _DriverCard extends StatelessWidget {
  final UserModel driver;

  const _DriverCard({required this.driver});

  ImageProvider? _getImage() {
    if (driver.imageUrl == null || driver.imageUrl!.isEmpty) return null;
    if (driver.imageUrl!.startsWith("http")) {
      return NetworkImage(driver.imageUrl!);
    } else {
      return AssetImage(driver.imageUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AmbulanceDetailsScreen(driver: driver),
              ),
            );
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _getImage(),
            child: _getImage() == null
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          title: Text(
            driver.name ?? "No Name",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("Address: ${driver.address ?? 'N/A'}")],
          ),
        ),
      ),
    );
  }
}
