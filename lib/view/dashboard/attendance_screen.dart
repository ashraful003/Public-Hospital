import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/attendance_view_model.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  bool get isDesktop {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AttendanceViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F7),
        appBar: AppBar(
          backgroundColor:AppColors.blue_200,
          title: const Text(
            "Attendance",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<AttendanceViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildTab(
                        title: "List",
                        isSelected: vm.selectedTab == AttendanceTab.list,
                        onTap: () => vm.changeTab(AttendanceTab.list),
                      ),
                      _buildTab(
                        title: "Attendance",
                        isSelected: vm.selectedTab == AttendanceTab.attendance,
                        onTap: () => vm.changeTab(AttendanceTab.attendance),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by National ID",
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
                ),
                Expanded(
                  child: vm.selectedTab == AttendanceTab.list
                      ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.attendanceList.length,
                    itemBuilder: (context, index) {
                      final staff = vm.attendanceList[index];
                      if (staff.checkIn == null) return const SizedBox();
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          title: Text(
                            staff.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("National ID: ${staff.nationalId}"),
                              Text("Check In: ${staff.checkIn ?? "-"}"),
                              Text("Check Out: ${staff.checkOut ?? "-"}"),
                              Text("Date: ${staff.date}"),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : isDesktop
                      ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.attendanceList.length,
                    itemBuilder: (context, index) {
                      final staff = vm.attendanceList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          title: Text(
                            staff.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text("National ID: ${staff.nationalId}"),
                              Text("Check In: ${staff.checkIn ?? "-"}"),
                              Text(
                                  "Check Out: ${staff.checkOut ?? "-"}"),
                              Text("Date: ${staff.date}"),
                            ],
                          ),
                          trailing: staff.checkIn == null
                              ? ElevatedButton(
                            onPressed: () =>
                                vm.checkIn(staff.nationalId),
                            child: const Text("Check In"),
                          )
                              : staff.checkOut == null
                              ? ElevatedButton(
                            onPressed: () {
                              vm.checkOut(staff.nationalId);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) =>
                                    AnimatedCheckoutPopup(
                                        staffName:
                                        staff.name),
                              );
                            },
                            child:
                            const Text("Check Out"),
                          )
                              : const Icon(Icons.check_circle,
                              color: Colors.green),
                        ),
                      );
                    },
                  )
                      : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Attendance details available only on desktop.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
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
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 3,
              color: isSelected ? Colors.blue : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
class AnimatedCheckoutPopup extends StatefulWidget {
  final String staffName;
  const AnimatedCheckoutPopup({super.key, required this.staffName});

  @override
  State<AnimatedCheckoutPopup> createState() => _AnimatedCheckoutPopupState();
}

class _AnimatedCheckoutPopupState extends State<AnimatedCheckoutPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 20)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    _controller.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -_bounceAnimation.value),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, color: Colors.blue, size: 48),
                const SizedBox(height: 16),
                Text(
                  "${widget.staffName} checked out!",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}