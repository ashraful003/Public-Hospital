import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/attendance_view_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController nationalIdController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    nationalIdController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showPopup({
    required String title,
    required String subtitle,
    required String imagePath,
    required Color color,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Image.asset(imagePath, height: 120),
                    );
                  },
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(subtitle),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  void _onSearchChanged(String value, AttendanceViewModel vm) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        vm.loadUser(value);
      } else {
        vm.clearUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AttendanceViewModel(),
      child: Consumer<AttendanceViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Attendance System")),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: nationalIdController,
                    onChanged: (value) => _onSearchChanged(value, vm),
                    decoration: const InputDecoration(
                      labelText: "Enter National ID",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (vm.user != null)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            (vm.user?.name ?? "").isNotEmpty
                                ? (vm.user?.name ?? "")[0]
                                : "?",
                          ),
                        ),
                        title: Text(vm.user?.name ?? "Unknown"),
                        subtitle: Text(vm.user?.nationalId ?? ""),
                        trailing: Icon(
                          vm.user?.isActive == true
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: vm.user?.isActive == true
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (vm.user != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: vm.isLoading
                              ? null
                              : () async {
                                  final result = await vm.checkIn(
                                    nationalIdController.text,
                                  );
                                  if (result.toLowerCase().contains(
                                    "successful",
                                  )) {
                                    _showPopup(
                                      title: "Lets start Work 🚀",
                                      subtitle: "Have a productive day!",
                                      imagePath: "assets/images/start.png",
                                      color: Colors.green,
                                    );
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result)),
                                  );
                                },
                          child: const Text("Check In"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: vm.isLoading
                              ? null
                              : () async {
                                  final result = await vm.checkOut(
                                    nationalIdController.text,
                                  );
                                  if (result.toLowerCase().contains(
                                    "successful",
                                  )) {
                                    _showPopup(
                                      title: "Well Done 😴",
                                      subtitle: "Go and rest well!",
                                      imagePath: "assets/images/end.png",
                                      color: Colors.orange,
                                    );
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result)),
                                  );
                                },
                          child: const Text("Check Out"),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  if (vm.isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
