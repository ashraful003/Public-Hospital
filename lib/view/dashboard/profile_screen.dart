import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/blood_profile_screen.dart';
import '../../data/shared_pref_service.dart';
import '../../service/api_config.dart';
import '../../viewModel/dashboard/profile_view_model.dart';
import '../../model/user_model.dart';
import 'change_old_password_screen.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String dashboardRole;

  const ProfileScreen({super.key, required this.dashboardRole});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadProfile(dashboardRole),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.user == null) {
            final email = SharedPrefService.getString("remember_email");
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_off,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Profile data not found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          vm.loadProfile(dashboardRole);
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final user = vm.user!;
          return Scaffold(
            backgroundColor: const Color(0xffF2F2F7),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundImage: _getProfileImage(vm, user),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(user.email ?? ""),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UpdateProfileScreen(
                                  user: user,
                                  dashboardRole: dashboardRole,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _sectionCard(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text("Settings"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: vm.toggleChangePassword,
                        ),
                        if (vm.showChangePassword)
                          ListTile(
                            leading: const Icon(Icons.lock_outline),
                            title: const Text("Change Password"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ChangeOldPasswordScreen(user: user),
                                ),
                              );
                            },
                          ),
                        ListTile(
                          leading: const Icon(Icons.notifications_none),
                          title: const Text("Notifications"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.bloodtype,
                            color: Colors.red,
                          ),
                          title: const Text(
                            "Blood Profile",
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BloodProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _sectionCard(
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showLogoutDialog(context, vm),
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

  ImageProvider _getProfileImage(ProfileViewModel vm, UserModel user) {
    try {
      if (vm.pickedImage != null) {
        return FileImage(vm.pickedImage!);
      }
      if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
        String url = user.imageUrl!;
        if (!url.startsWith("http")) {
          url = "${ApiConfig.baseUrl}$url";
        }
        return NetworkImage(url);
      }
    } catch (e) {
      debugPrint("Image error: $e");
    }
    return const AssetImage("assets/images/logo.png");
  }

  Widget _sectionCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: child,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await vm.logout(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
