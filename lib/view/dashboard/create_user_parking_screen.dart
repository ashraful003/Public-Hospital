import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/user_parking_screen.dart';
import '../../model/parking_model.dart';
import '../../model/user_parking_model.dart';
import '../../viewModel/dashboard/profile_view_model.dart';
import '../../viewModel/dashboard/user_parking_view_model.dart';

class CreateUserParkingScreen extends StatefulWidget {
  final ParkingModel parking;
  final String patientId;
  final String role;

  const CreateUserParkingScreen({
    super.key,
    required this.parking,
    required this.patientId,
    required this.role,
  });

  @override
  State<CreateUserParkingScreen> createState() =>
      _CreateUserParkingScreenState();
}

class _CreateUserParkingScreenState extends State<CreateUserParkingScreen> {
  final formKey = GlobalKey<FormState>();
  final patientIdController = TextEditingController();
  final patientNameController = TextEditingController();
  final mobileController = TextEditingController();
  final floorController = TextEditingController();
  final parkingNoController = TextEditingController();
  final parkingFeeController = TextEditingController();
  final vehicleNoController = TextEditingController();
  String vehicleType = "Bike";
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    vehicleNoController.addListener(_checkForm);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileVm = Provider.of<ProfileViewModel>(context, listen: false);
      await profileVm.loadProfile("PATIENT");
      final user = profileVm.user;
      if (user != null && mounted) {
        patientIdController.text = widget.patientId.isNotEmpty
            ? widget.patientId
            : (user.nationalId ?? "");
        patientNameController.text = user.name ?? "";
        mobileController.text = user.phone ?? "";
      }
      floorController.text = widget.parking.floor ?? "";
      parkingNoController.text = widget.parking.parkingNo ?? "";
      parkingFeeController.text = widget.parking.parkingFee?.toString() ?? "";
      _checkForm();
    });
  }

  void _checkForm() {
    final ready =
        patientIdController.text.isNotEmpty &&
        patientNameController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        floorController.text.isNotEmpty &&
        parkingNoController.text.isNotEmpty &&
        parkingFeeController.text.isNotEmpty &&
        vehicleNoController.text.trim().isNotEmpty &&
        vehicleType.isNotEmpty;
    if (ready != isReady) {
      setState(() {
        isReady = ready;
      });
    }
  }

  @override
  void dispose() {
    vehicleNoController.removeListener(_checkForm);
    patientIdController.dispose();
    patientNameController.dispose();
    mobileController.dispose();
    floorController.dispose();
    parkingNoController.dispose();
    parkingFeeController.dispose();
    vehicleNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileVm = context.watch<ProfileViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text("Parking ${widget.parking.parkingNo}")),
      body: profileVm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<UserParkingViewModel>(
              builder: (context, vm, _) {
                return Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        _buildField("User ID", patientIdController, true),
                        const SizedBox(height: 12),
                        _buildField("User Name", patientNameController, true),
                        const SizedBox(height: 12),
                        _buildField("Phone Number", mobileController, true),
                        const SizedBox(height: 12),
                        _buildField("Floor", floorController, true),
                        const SizedBox(height: 12),
                        _buildField("Parking No", parkingNoController, true),
                        const SizedBox(height: 12),
                        _buildField(
                          "Parking Fee/Hours",
                          parkingFeeController,
                          true,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: vehicleNoController,
                          decoration: const InputDecoration(
                            labelText: "Vehicle Number",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Vehicle number is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: vehicleType,
                          decoration: const InputDecoration(
                            labelText: "Vehicle Type",
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "Bike",
                              child: Text("Bike"),
                            ),
                            DropdownMenuItem(value: "Car", child: Text("Car")),
                            DropdownMenuItem(
                              value: "Microbus",
                              child: Text("Microbus"),
                            ),
                            DropdownMenuItem(
                              value: "Ambulance",
                              child: Text("Ambulance"),
                            ),
                            DropdownMenuItem(value: "CNG", child: Text("CNG")),
                          ],
                          onChanged: (value) {
                            setState(() {
                              vehicleType = value!;
                            });
                            _checkForm();
                          },
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isReady
                                  ? Colors.blue
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: (!isReady || vm.loading)
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    final request = UserParkingModel(
                                      id: widget.parking.parkingId!,
                                      patientId: patientIdController.text
                                          .trim(),
                                      patientName: patientNameController.text
                                          .trim(),
                                      mobileNo: mobileController.text.trim(),
                                      vehicleNo: vehicleNoController.text
                                          .trim(),
                                      vehicleType: vehicleType,
                                      parkingId: widget.parking.parkingId!,
                                    );
                                    final success = await vm.createUserParking(
                                      request,
                                      context,
                                    );
                                    if (success && mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => UserParkingScreen(
                                            role: widget.role,
                                            patientId: widget.patientId,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: vm.loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Park Vehicle",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    bool readOnly,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}