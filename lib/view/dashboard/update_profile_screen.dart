import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_model.dart';
import '../../viewModel/dashboard/profile_view_model.dart';

class UpdateProfileScreen extends StatelessWidget {
  final UserModel user;
  final String dashboardRole;

  const UpdateProfileScreen({
    super.key,
    required this.user,
    required this.dashboardRole,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadProfile(dashboardRole),
      child: _UpdateProfileView(user: user, role: dashboardRole),
    );
  }
}

class _UpdateProfileView extends StatefulWidget {
  final UserModel user;
  final String role;

  const _UpdateProfileView({required this.user, required this.role});

  @override
  State<_UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<_UpdateProfileView> {
  final nationalId = TextEditingController();
  final license = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();
  final dob = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final weight = TextEditingController();
  final degree = TextEditingController();
  final institute = TextEditingController();
  final specialist = TextEditingController();
  bool initialized = false;

  String get role => widget.role.toLowerCase();

  bool get isAdmin => role == "admin";

  bool get isPatient => role == "patient";

  bool get isDoctor => role == "doctor";

  bool get isNurse => role == "nurse";

  bool get isDriver => role == "driver";

  bool get isPharmaOrDiagnostic =>
      role == "pharmaceutical" || role == "diagnosticcenter";

  bool get isBasicUser =>
      role == "admin" ||
      role == "patient" ||
      role == "receptionist" ||
      role == "cleaner" ||
      role == "accountant" ||
      role == "pharmacist" ||
      role == "doctorassistant";

  void init(ProfileViewModel vm) {
    final user = vm.user ?? widget.user;
    nationalId.text = user.nationalId ?? '';
    license.text = user.license ?? '';
    name.text = user.name ?? '';
    email.text = user.email ?? '';
    dob.text = user.dob != null
        ? "${user.dob!.day.toString().padLeft(2, '0')}/"
              "${user.dob!.month.toString().padLeft(2, '0')}/"
              "${user.dob!.year}"
        : '';
    phone.text = user.phone ?? '';
    address.text = user.address ?? '';
    weight.text = user.weight ?? '';
    degree.text = user.degree ?? '';
    institute.text = user.institute ?? '';
    specialist.text = user.specialist ?? '';
    initialized = true;
  }

  @override
  void dispose() {
    nationalId.dispose();
    license.dispose();
    name.dispose();
    email.dispose();
    dob.dispose();
    phone.dispose();
    address.dispose();
    weight.dispose();
    degree.dispose();
    institute.dispose();
    specialist.dispose();
    super.dispose();
  }

  Future<void> pickDOB() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        dob.text =
            "${date.day.toString().padLeft(2, '0')}/"
            "${date.month.toString().padLeft(2, '0')}/"
            "${date.year}";
      });
    }
  }

  Future<void> save(ProfileViewModel vm) async {
    final success = await vm.updateProfile(
      email: email.text,
      name: name.text,
      phone: phone.text,
      address: address.text,
      weight: weight.text,
      license: license.text,
      degree: degree.text,
      institute: institute.text,
      specialist: specialist.text,
      dob: dob.text,
    );
    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Update Failed")));
      return;
    }
    await vm.loadProfile(widget.role);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Profile Updated Successfully",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _profileImage(ProfileViewModel vm) {
    ImageProvider? image;
    final user = vm.user ?? widget.user;
    if (vm.pickedImage != null) {
      image = FileImage(vm.pickedImage!);
    } else if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
      image = NetworkImage(
        user.imageUrl!.startsWith("http")
            ? user.imageUrl!
            : "http://10.0.2.2:9090${user.imageUrl}",
      );
    }
    return GestureDetector(
      onTap: () {
        vm.pickImageAndUpload(widget.user.email ?? "");
      },
      child: CircleAvatar(
        radius: 55,
        backgroundImage: image,
        child: image == null ? const Icon(Icons.person, size: 45) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        if (!initialized) init(vm);

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: const Text("Update Profile"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(child: _profileImage(vm)),
                const SizedBox(height: 25),
                _buildField(
                  controller: nationalId,
                  label: "National ID",
                  icon: Icons.credit_card,
                  readOnly: true,
                ),
                if (!isPharmaOrDiagnostic && !isBasicUser)
                  _buildField(
                    controller: license,
                    label: "License Number",
                    icon: Icons.badge,
                    readOnly: true,
                  ),
                _buildField(
                  controller: name,
                  label: "Full Name",
                  icon: Icons.person,
                ),
                _buildField(
                  controller: email,
                  label: "Email",
                  icon: Icons.email,
                ),
                _buildField(
                  controller: dob,
                  label: "Date of Birth",
                  icon: Icons.calendar_month,
                  onTap: pickDOB,
                ),
                _buildField(
                  controller: phone,
                  label: "Phone Number",
                  icon: Icons.phone,
                ),
                _buildField(
                  controller: address,
                  label: "Address",
                  icon: Icons.location_on,
                ),
                if (isAdmin || isDoctor || isNurse || isDriver || isPatient)
                  _buildField(
                    controller: weight,
                    label: "Weight",
                    icon: Icons.monitor_weight,
                  ),
                if (isAdmin || isDoctor || isNurse || isDriver || isPatient)
                  _buildField(
                    controller: degree,
                    label: "Degree",
                    icon: Icons.school,
                  ),
                if (isAdmin || isDoctor || isNurse || isDriver || isPatient)
                  _buildField(
                    controller: institute,
                    label: "Institute",
                    icon: Icons.apartment,
                  ),
                if (isDoctor)
                  _buildField(
                    controller: specialist,
                    label: "Specialist",
                    icon: Icons.medical_services,
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => save(vm),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
