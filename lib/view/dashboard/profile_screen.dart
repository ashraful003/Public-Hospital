import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/profile_view_model.dart';
import '../../model/user_model.dart';
import 'change_old_password_screen.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel? currentUser;

  const ProfileScreen({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    final user =
        currentUser ??
        UserModel(
          nationalId: '0123456789',
          name: "Ashraful Alam",
          email: "admin@gmail.com",
          phone: '01717078044',
          address: 'West Rajabazar, Dhaka-1215',
          weight: '70',
          dob: DateTime(1997, 12, 12),
          degree: "Bsc In CSE",
          institute: 'Daffodil International University',
          specialist: 'Android Application',
          imageUrl: 'assets/images/logo.png',
          license: '123456789',
          role: UserRole.patient,
        );

    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(user: user),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: const Color(0xffF2F2F7),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            top: 5,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: vm.pickedImage != null
                                    ? Image.file(
                                        vm.pickedImage!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        vm.user.imageUrl ??
                                            "assets/images/default_user.png",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vm.user.name ?? "",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      vm.user.email ?? "",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          UpdateProfileScreen(user: vm.user),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text("Settings"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              vm.toggleChangePassword();
                            },
                          ),
                          if (vm.showChangePassword)
                            Column(
                              children: [
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
                                        builder: (_) => ChangeOldPasswordScreen(
                                          user: vm.user,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          _menuItem(
                            icon: Icons.notifications_none,
                            title: "Notifications",
                            color: Colors.black,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: _menuItem(
                        icon: Icons.logout,
                        title: "Logout",
                        color: Colors.red,
                        onTap: () => _showLogoutDialog(context, vm),
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

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24, color: color),
      title: Text(title, style: TextStyle(fontSize: 16, color: color)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              vm.logout(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
