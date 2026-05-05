import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/my_attendance_view_model.dart';
import '../../model/user_model.dart';

class MyAttendanceScreen extends StatelessWidget {
  final UserModel user;

  const MyAttendanceScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          MyAttendanceViewModel()..loadMyAttendance(user.nationalId ?? ""),
      child: const _MyAttendanceView(),
    );
  }
}

class _MyAttendanceView extends StatelessWidget {
  const _MyAttendanceView();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MyAttendanceViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("My Attendance")),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody(vm)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      color: Colors.blue.shade100,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: const Row(
          children: [
            Expanded(
              child: Text(
                "Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                "Check In",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                "Check Out",
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(MyAttendanceViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(
        child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (vm.attendanceList.isEmpty) {
      return const Center(child: Text("No attendance found"));
    }
    return ListView.builder(
      itemCount: vm.attendanceList.length,
      itemBuilder: (context, index) {
        final item = vm.attendanceList[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: Text(item.date)),
                Expanded(
                  child: Text(
                    item.checkIn ?? "--",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(item.checkOut ?? "--", textAlign: TextAlign.end),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
