import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/user_parking_model.dart';
import '../../viewModel/dashboard/user_parking_view_model.dart';

class UserParkingScreen extends StatefulWidget {
  final String role;
  final String patientId;

  const UserParkingScreen({
    super.key,
    required this.role,
    required this.patientId,
  });

  @override
  State<UserParkingScreen> createState() => _UserParkingScreenState();
}

class _UserParkingScreenState extends State<UserParkingScreen> {
  final TextEditingController searchController = TextEditingController();
  late UserParkingViewModel vm;
  bool showActiveParking = true;

  @override
  void initState() {
    super.initState();
    vm = UserParkingViewModel();
    vm.loadData(role: widget.role, patientId: widget.patientId);
  }

  List<UserParkingModel> filterList(List<UserParkingModel> list) {
    final query = searchController.text.toLowerCase().trim();
    if (query.isEmpty) return list;
    return list.where((item) {
      return (item.patientName ?? "").toLowerCase().contains(query) ||
          item.patientId.toLowerCase().contains(query) ||
          (item.vehicleType ?? "").toLowerCase().contains(query);
    }).toList();
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat("dd/MM/yyyy HH:mm").format(date);
  }

  List<UserParkingModel> applyParkingFilter(List<UserParkingModel> list) {
    if (showActiveParking) {
      return list.where((e) => e.isActive == true).toList();
    } else {
      return list.where((e) => e.isActive == false).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Scaffold(
        appBar: AppBar(title: const Text("Parking History"), centerTitle: true),
        body: Consumer<UserParkingViewModel>(
          builder: (_, vm, __) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Search parking...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                if (widget.role.toLowerCase() == "admin")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: showActiveParking
                                  ? Colors.blue
                                  : Colors.white,
                              foregroundColor: showActiveParking
                                  ? Colors.white
                                  : Colors.black,
                              elevation: 0,
                              side: const BorderSide(
                                color: Colors.blue,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              setState(() => showActiveParking = true);
                            },
                            child: const Text(
                              "Active Parking",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 45),
                              backgroundColor: !showActiveParking
                                  ? Colors.blue
                                  : Colors.white,
                              foregroundColor: !showActiveParking
                                  ? Colors.white
                                  : Colors.blue,
                              elevation: 0,
                              side: const BorderSide(
                                color: Colors.blue,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              setState(() => showActiveParking = false);
                            },
                            child: const Text(
                              "Exit Parking",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      _HeaderCell(text: "No", flex: 1),
                      _HeaderCell(text: "Name", flex: 2),
                      _HeaderCell(text: "User ID", flex: 2),
                      _HeaderCell(text: "Vehicle Type", flex: 2),
                      _HeaderCell(text: "Entry Time", flex: 3),
                      _HeaderCell(text: "Exit Time", flex: 3),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "Action",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Builder(
                    builder: (_) {
                      List<UserParkingModel> data;
                      if (widget.role.toLowerCase() == "admin") {
                        data = showActiveParking
                            ? vm.activeParking
                            : vm.allParking;
                        data = applyParkingFilter(data);
                      } else {
                        data = vm.patientParking;
                      }
                      final filtered = filterList(data);
                      if (filtered.isEmpty) {
                        return const Center(child: Text("No Parking Found"));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filtered.length,
                        itemBuilder: (_, index) {
                          return parkingCard(filtered[index], index + 1);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget parkingCard(UserParkingModel item, int index) {
    return InkWell(
      onTap: () => _showParkingDetails(context, item),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _Cell(text: index.toString(), flex: 1),
                _Cell(text: item.patientName ?? "-", flex: 2),
                _Cell(text: item.patientId, flex: 2),
                _Cell(text: item.vehicleType ?? "-", flex: 2),
                _Cell(text: formatDate(item.entryTime), flex: 3),
                _Cell(text: formatDate(item.exitTime), flex: 3),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: item.isActive == true
                        ? SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 20,
                              icon: const Icon(
                                Icons.exit_to_app,
                                color: Colors.red,
                                size: 24,
                              ),
                              tooltip: "Exit Vehicle",
                              onPressed: () {
                                _showExitConfirmation(item);
                              },
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showParkingDetails(BuildContext context, UserParkingModel item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (item.isActive == true) {
              Future.delayed(const Duration(minutes: 1), () {
                if (Navigator.canPop(context)) {
                  setDialogState(() {});
                }
              });
            }
            final durationText = calculateDuration(
              item.entryTime,
              item.exitTime,
            );
            final totalAmount = calculateTotalAmount(
              item.entryTime,
              item.exitTime,
              item.parkingFee ?? 0,
            );
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 450,
                  maxHeight: MediaQuery.of(context).size.height * 0.80,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Parking Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            splashRadius: 20,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _info("User Name", item.patientName ?? "-"),
                              _info("User ID", item.patientId),
                              _info("Mobile No", item.mobileNo ?? "-"),
                              _info("Vehicle No", item.vehicleNo),
                              _info("Vehicle Type", item.vehicleType ?? "-"),
                              _info("Floor", item.floor ?? "-"),
                              _info("Parking No", item.parkingNo ?? "-"),
                              _info("Entry Time", formatDate(item.entryTime)),
                              _info("Exit Time", formatDate(item.exitTime)),
                              _info("Duration", durationText),
                              _info("Fee / Hour", "${item.parkingFee ?? 0}"),
                              _info(
                                "Total Fee",
                                totalAmount.toStringAsFixed(2),
                              ),
                              _info("Status", item.status ?? "-"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(title, style: const TextStyle(fontSize: 15)),
          ),
          const Text(":\t\t\t"),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  String calculateDuration(DateTime? entryTime, DateTime? exitTime) {
    if (entryTime == null) return "-";
    final endTime = exitTime ?? DateTime.now();
    final duration = endTime.difference(entryTime);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    if (days > 0) {
      return "$days Day(s), $hours Hour(s), $minutes Minute(s)";
    }
    return "$hours Hour(s), $minutes Minute(s)";
  }

  double calculateTotalAmount(
    DateTime? entryTime,
    DateTime? exitTime,
    double parkingFee,
  ) {
    if (entryTime == null) return 0;
    final endTime = exitTime ?? DateTime.now();
    final duration = endTime.difference(entryTime);
    final totalHours = (duration.inMinutes / 60).ceil();
    return totalHours * parkingFee;
  }

  void _showExitConfirmation(UserParkingModel item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Colors.red,
                    size: 35,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Exit Parking",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("No"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showExitPaymentDialog(item);
                          },
                          child: const Text("Yes"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExitPaymentDialog(UserParkingModel item) {
    final paidController = TextEditingController();
    final duration = calculateDuration(item.entryTime, DateTime.now());
    final totalAmount = calculateTotalAmount(
      item.entryTime,
      DateTime.now(),
      item.parkingFee ?? 0,
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final paidAmount = double.tryParse(paidController.text.trim()) ?? 0;
            final canExit =
                paidController.text.isNotEmpty && paidAmount >= totalAmount;
            final dueAmount = totalAmount - paidAmount;
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 420,
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Parking Payment",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            splashRadius: 20,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 0,
                        color: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              _info("User Name", item.patientName ?? "-"),
                              _info("Vehicle No", item.vehicleNo),
                              _info("Duration", duration),
                              _info("Fee / Hours", "${item.parkingFee ?? 0}"),
                              _info("Total Fee", totalAmount.toStringAsFixed(2)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: paidController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) {
                          setDialogState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: "Paid Amount",
                          prefixText: " ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (paidController.text.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            paidAmount >= totalAmount
                                ? "Change: ${(paidAmount - totalAmount).toStringAsFixed(2)}"
                                : "Due: ${dueAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: paidAmount >= totalAmount
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: canExit
                                    ? () async {
                                        final success = await vm.exitVehicle(
                                          item.vehicleNo,
                                        );
                                        if (success) {
                                          await vm.loadData(
                                            role: widget.role,
                                            patientId: widget.patientId,
                                          );
                                          if (mounted) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Vehicle exited successfully",
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Exit"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderCell({required this.text, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final int flex;

  const _Cell({required this.text, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}