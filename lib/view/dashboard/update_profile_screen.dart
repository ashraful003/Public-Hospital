import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_model.dart';
import '../../viewModel/dashboard/profile_view_model.dart';

class UpdateProfileScreen extends StatelessWidget {
  final UserModel user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(user: user),
      child: const _UpdateProfileView(),
    );
  }
}

class _UpdateProfileView extends StatefulWidget {
  const _UpdateProfileView();

  @override
  State<_UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<_UpdateProfileView> {
  final Map<String, TextEditingController> controllers = {};

  void initControllers(ProfileViewModel vm) {
    for (var field in vm.visibleFields) {
      if (field != "imageUrl") {
        controllers[field] = TextEditingController(
          text: vm.getFieldValue(field),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void save(ProfileViewModel vm) {
    vm.updateUser(
      name: controllers['name']?.text,
      email: controllers['email']?.text,
      phone: controllers['phone']?.text,
      address: controllers['address']?.text,
      weight: controllers['weight']?.text,
      degree: controllers['degree']?.text,
      institute: controllers['institute']?.text,
      specialist: controllers['specialist']?.text,
      license: controllers['license']?.text,
      imagePath: vm.pickedImage?.path ?? vm.user.imageUrl,
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profile Updated")));
    Navigator.pop(context);
  }

  Widget buildProfileImage(ProfileViewModel vm) {
    ImageProvider? image;

    if (vm.pickedImage != null) {
      image = FileImage(vm.pickedImage!);
    } else if (vm.user.imageUrl != null && vm.user.imageUrl!.isNotEmpty) {
      final path = vm.user.imageUrl!;
      if (path.startsWith("http") || path.startsWith("https")) {
        image = NetworkImage(path);
      } else {
        image = AssetImage(path);
      }
    }
    return Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: vm.pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: image,
                backgroundColor: Colors.grey.shade200,
                child: image == null
                    ? const Icon(Icons.person, size: 45)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget buildField(ProfileViewModel vm, String field) {
    if (field == "dob") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          controller: controllers[field],
          readOnly: true,
          decoration: InputDecoration(
            labelText: getFieldLabel(field),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          onTap: () async {
            DateTime initialDate = DateTime.now();
            if (controllers[field]!.text.isNotEmpty) {
              initialDate =
                  DateTime.tryParse(controllers[field]!.text) ?? DateTime.now();
            }
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              controllers[field]!.text =
                  "${picked.year}-${picked.month}-${picked.day}";
            }
          },
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controllers[field],
        readOnly: !vm.isEditable(field),
        keyboardType: getKeyboardType(field),
        decoration: InputDecoration(
          labelText: getFieldLabel(field),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, child) {
        if (controllers.isEmpty) initControllers(vm);
        final List<String> fields = [];
        if (vm.visibleFields.contains('nationalId')) fields.add('nationalId');
        if (vm.visibleFields.contains('license')) fields.add('license');
        fields.addAll(
          vm.visibleFields.where(
            (f) => f != 'imageUrl' && f != 'nationalId' && f != 'license',
          ),
        );
        return Scaffold(
          appBar: AppBar(
            title: const Text("Update Profile"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildProfileImage(vm),
                for (var field in fields) buildField(vm, field),
                const SizedBox(height: 25),
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
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  TextInputType getKeyboardType(String field) {
    switch (field) {
      case "email":
        return TextInputType.emailAddress;
      case "phone":
      case "weight":
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  String getFieldLabel(String field) {
    switch (field) {
      case "nationalId":
        return "National ID";
      case "name":
        return "Name";
      case "email":
        return "Email";
      case "phone":
        return "Phone";
      case "address":
        return "Address";
      case "weight":
        return "Weight";
      case "dob":
        return "Date of Birth";
      case "degree":
        return "Degree";
      case "institute":
        return "Institute";
      case "specialist":
        return "Specialist";
      case "license":
        return "License";
      default:
        return field;
    }
  }
}
