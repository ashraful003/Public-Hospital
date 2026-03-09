import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/AppColor.dart';
import '../../viewModel/dashboard/drawer_viewmodel.dart';

class DrawerLayout extends StatelessWidget {
  const DrawerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawerViewModel(),
      child: Consumer<DrawerViewModel>(
        builder: (context, vm, child) {
          return Drawer(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(color: AppColors.blue100),
                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=3",
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Ashraful Alam",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "ashraful1510178@gmail.com",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ...vm.drawerItems.map((item) {
                  bool isSelected = vm.selectedIndex == item.index;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? AppColors.blue100.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child: ListTile(
                      leading: Icon(
                        vm.getIcon(item.iconName),
                        color: item.title == "Logout"
                            ? Colors.red
                            : (isSelected
                                  ? AppColors.blue100
                                  : Colors.grey[700]),
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.bold,
                          color: isSelected
                              ? AppColors.blue100
                              : Colors.black87,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () {
                        vm.selectItem(item.index);
                        vm.showToast('${item.title} clicked');
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),

                const Spacer(),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
