import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/user_parking_screen.dart';
import '../../model/parking_model.dart';
import '../../viewModel/dashboard/parking_view_model.dart';
import '../../viewModel/dashboard/profile_view_model.dart';
import '../../viewModel/dashboard/user_parking_view_model.dart';
import 'add_parking_screen.dart';
import 'create_user_parking_screen.dart';

class ParkingScreen extends StatelessWidget {
  final String patientId;
  final String role;

  const ParkingScreen({super.key, required this.patientId, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParkingViewModel()..loadParking(),
      child: _ParkingScreenBody(role: role, patientId: patientId),
    );
  }
}

class _ParkingScreenBody extends StatefulWidget {
  final String role;
  final String patientId;

  const _ParkingScreenBody({required this.role, required this.patientId});

  @override
  State<_ParkingScreenBody> createState() => _ParkingScreenBodyState();
}

class _ParkingScreenBodyState extends State<_ParkingScreenBody> {
  String? selectedFloor;
  static const double _smallSlot = 60;
  static const double _mediumSlot = 85;
  static const double _largeSlot = 110;
  static const double _smallGap = 40;
  static const double _mediumGap = 90;
  static const double _largeGap = 160;

  bool get isAdmin => widget.role.toLowerCase() == "admin";

  int _floorRank(String floor) {
    final f = floor.toLowerCase().trim();
    if (f.contains("ground")) return 0;
    if (f.contains("1")) return 1;
    if (f.contains("2")) return 2;
    if (f.contains("3")) return 3;
    if (f.contains("4")) return 4;
    return 999;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        title: const Text("Parking Area"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserParkingScreen(
                      role: widget.role,
                      patientId: widget.patientId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.history, color: Colors.white, size: 20),
              label: const Text(
                "History",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF2E446C),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: context.read<ParkingViewModel>(),
                      child: const AddParkingScreen(),
                    ),
                  ),
                );
                if (result == true && mounted) {
                  context.read<ParkingViewModel>().loadParking();
                }
              },
            )
          : null,
      body: Consumer<ParkingViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.errorMessage.isNotEmpty) {
            return Center(child: Text(vm.errorMessage));
          }
          final parkingList = vm.parkingList;
          final Map<String, List<ParkingModel>> grouped = {};
          for (var item in parkingList) {
            grouped.putIfAbsent(item.floor, () => []);
            grouped[item.floor]!.add(item);
          }
          final floors = grouped.keys.toList()
            ..sort((a, b) => _floorRank(a).compareTo(_floorRank(b)));
          if (selectedFloor == null || !floors.contains(selectedFloor)) {
            selectedFloor = floors.isNotEmpty ? floors.first : null;
          }
          final List<ParkingModel> list = selectedFloor != null
              ? grouped[selectedFloor]!
              : [];
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final slotSize = width < 600
                  ? _smallSlot
                  : width < 1024
                  ? _mediumSlot
                  : _largeSlot;
              final centerGap = width < 600
                  ? _smallGap
                  : width < 1024
                  ? _mediumGap
                  : _largeGap;
              return Column(
                children: [
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LegendItem(
                        color: Colors.white,
                        border: true,
                        text: "Available",
                      ),
                      SizedBox(width: 20),
                      _LegendItem(
                        color: Color(0xFFE6922D),
                        text: "Not Available",
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: floors.map((floor) {
                        final isSelected = floor == selectedFloor;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? const Color(0xFF2E446C)
                                  : Colors.white,
                              foregroundColor: isSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedFloor = floor;
                              });
                            },
                            child: Text(floor),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: (list.length / 4).ceil(),
                      itemBuilder: (context, rowIndex) {
                        final startIndex = rowIndex * 4;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: slotSize * 2 + 12,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSlot(
                                      context,
                                      vm,
                                      list,
                                      startIndex,
                                      slotSize,
                                    ),
                                    _buildSlot(
                                      context,
                                      vm,
                                      list,
                                      startIndex + 1,
                                      slotSize,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: centerGap),
                              SizedBox(
                                width: slotSize * 2 + 12,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSlot(
                                      context,
                                      vm,
                                      list,
                                      startIndex + 2,
                                      slotSize,
                                    ),
                                    _buildSlot(
                                      context,
                                      vm,
                                      list,
                                      startIndex + 3,
                                      slotSize,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSlot(
    BuildContext context,
    ParkingViewModel vm,
    List<ParkingModel> list,
    int index,
    double size,
  ) {
    if (index >= list.length) {
      return SizedBox(width: size, height: size);
    }
    final item = list[index];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: item.isActive
              ? () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (_) => UserParkingViewModel(),
                          ),
                          ChangeNotifierProvider(
                            create: (_) => ProfileViewModel(),
                          ),
                        ],
                        child: CreateUserParkingScreen(
                          parking: item,
                          patientId: widget.patientId,
                          role: widget.role,
                        ),
                      ),
                    ),
                  );
                  if (result == true) {
                    vm.loadParking();
                  }
                }
              : null,
          child: ParkingSlotWidget(
            parkingNo: item.parkingNo,
            isAvailable: item.isActive,
            size: size,
          ),
        ),
        if (isAdmin)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                    onPressed: () => _editParkingDialog(context, vm, item),
                  ),
                  IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    onPressed: () =>
                        _deleteParking(context, vm, item.parkingId!),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _deleteParking(BuildContext context, ParkingViewModel vm, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Parking"),
        content: const Text("Are you sure!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await vm.deleteParking(id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editParkingDialog(
    BuildContext context,
    ParkingViewModel vm,
    ParkingModel item,
  ) {
    final floorController = TextEditingController(text: item.floor);
    final parkingNoController = TextEditingController(text: item.parkingNo);
    final feeController = TextEditingController(
      text: item.parkingFee.toString(),
    );
    bool isActive = item.isActive;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Parking"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: floorController,
                      decoration: const InputDecoration(labelText: "Floor"),
                    ),
                    TextField(
                      controller: parkingNoController,
                      decoration: const InputDecoration(
                        labelText: "Parking No",
                      ),
                    ),
                    TextField(
                      controller: feeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Parking Fee",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Active"),
                        Switch(
                          value: isActive,
                          onChanged: (value) {
                            setDialogState(() => isActive = value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final fee = double.tryParse(feeController.text);
                    if (fee == null) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text("Invalid parking fee")),
                      );
                      return;
                    }
                    final updated = ParkingModel(
                      parkingId: item.parkingId,
                      floor: floorController.text.trim(),
                      parkingNo: parkingNoController.text.trim(),
                      parkingFee: fee,
                      isActive: isActive,
                    );
                    try {
                      await vm.updateParking(updated);
                      if (dialogContext.mounted) Navigator.pop(dialogContext);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Updated successfully")),
                        );
                      }
                    } catch (e) {
                      if (dialogContext.mounted) {
                        ScaffoldMessenger.of(
                          dialogContext,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ParkingSlotWidget extends StatelessWidget {
  final String parkingNo;
  final bool isAvailable;
  final double size;

  const ParkingSlotWidget({
    super.key,
    required this.parkingNo,
    required this.isAvailable,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isAvailable ? Colors.white : const Color(0xFFE6922D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E446C)),
      ),
      child: Text(
        parkingNo,
        style: TextStyle(
          fontSize: size * 0.22,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final bool border;
  final Color textColor;

  const _LegendItem({
    required this.color,
    required this.text,
    this.border = false,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            border: border ? Border.all(color: Colors.black54) : null,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: textColor)),
      ],
    );
  }
}
