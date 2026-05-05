import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/attendance_list_view_model.dart';
import 'attendance_screen.dart';

class AttendanceListScreen extends StatelessWidget {
  const AttendanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AttendanceListViewModel()..init(),
      child: const _AttendanceListView(),
    );
  }
}

class _AttendanceListView extends StatelessWidget {
  const _AttendanceListView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AttendanceListViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance List"), centerTitle: true),
      floatingActionButton: vm.isAdmin
          ? FloatingActionButton(
              onPressed: () => _openAttendancePage(context),
              backgroundColor: AppColors.blue_200,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          _searchBox(vm),
          Expanded(child: _buildBody(vm)),
        ],
      ),
    );
  }

  Widget _searchBox(AttendanceListViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: vm.searchController,
        decoration: InputDecoration(
          hintText: "Search by National ID",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: vm.searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    vm.searchController.clear();
                    vm.searchByNationalId("");
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: vm.searchByNationalId,
      ),
    );
  }

  Widget _buildBody(AttendanceListViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.list.isEmpty) {
      return const Center(child: Text("No Attendance Found"));
    }
    return RefreshIndicator(
      onRefresh: vm.loadAttendance,
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: vm.list.length,
        itemBuilder: (context, index) {
          final item = vm.list[index];
          return Card(
            child: ListTile(
              onTap: () => _showAttendancePopup(context, item),
              title: Text(item.name),
              subtitle: Text(item.nationalId),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
    );
  }

  void _openAttendancePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AttendanceScreen()),
    ).then((_) {
      context.read<AttendanceListViewModel>().loadAttendance();
    });
  }

  void _showAttendancePopup(BuildContext context, item) {
    final screenWidth = MediaQuery.of(context).size.width;
    double dialogWidth;
    if (screenWidth < 600) {
      dialogWidth = screenWidth * 0.90;
    } else if (screenWidth < 1000) {
      dialogWidth = 500;
    } else {
      dialogWidth = 600;
    }
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogWidth),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 40, color: Colors.blue),
                  const SizedBox(height: 10),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  _infoRow("ID", item.nationalId),
                  const Divider(),
                  _infoRow("Date", item.date),
                  const Divider(),
                  _infoRow("Check In", item.checkIn ?? "-"),
                  const Divider(),
                  _infoRow("Check Out", item.checkOut ?? "-"),
                  const Divider(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue_200,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
