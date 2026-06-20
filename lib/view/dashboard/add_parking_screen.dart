import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/parking_view_model.dart';

class AddParkingScreen extends StatefulWidget {
  const AddParkingScreen({super.key});

  @override
  State<AddParkingScreen> createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends State<AddParkingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController parkingNoController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  String? selectedFloor;
  bool isActive = true;
  final List<String> floors = [
    'Ground Floor',
    '1st Floor',
    '2nd Floor',
    '3rd Floor',
    '4th Floor',
  ];

  @override
  void dispose() {
    parkingNoController.dispose();
    feeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await context.read<ParkingViewModel>().createParking(
        floor: selectedFloor!,
        parkingNo: parkingNoController.text.trim(),
        parkingFee: double.parse(feeController.text.trim()),
        isActive: isActive,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parking created successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParkingViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),
      appBar: AppBar(title: const Text("Create Parking"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.local_parking,
                    size: 70,
                    color: Color(0xFF2E446C),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Create Parking Slot",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  DropdownButtonFormField<String>(
                    value: selectedFloor,
                    decoration: const InputDecoration(
                      labelText: "Floor",
                      prefixIcon: Icon(Icons.apartment),
                      border: OutlineInputBorder(),
                    ),
                    items: floors
                        .map(
                          (floor) => DropdownMenuItem(
                            value: floor,
                            child: Text(floor),
                          ),
                        )
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Select floor";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedFloor = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: parkingNoController,
                    decoration: const InputDecoration(
                      labelText: "Parking Number",
                      prefixIcon: Icon(Icons.pin),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter parking number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: feeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Parking Fee",
                      prefixIcon: Icon(Icons.money),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter parking fee";
                      }
                      final fee = double.tryParse(value);
                      if (fee == null) {
                        return "Invalid fee";
                      }
                      if (fee < 0) {
                        return "Fee cannot be negative";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      title: const Text("Active"),
                      subtitle: Text(
                        isActive ? "Available for booking" : "Not available",
                      ),
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: vm.isLoading ? null : _save,
                      icon: vm.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(vm.isLoading ? "Saving..." : "Save Parking"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E446C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
