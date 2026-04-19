import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/color/app_color.dart';
import 'package:public_hospital/view/dashboard/drawer_layout.dart';
import 'package:public_hospital/viewModel/dashboard/home_view_model.dart';
import 'package:public_hospital/widgets/home_circle_item.dart';

class HomeScreen extends StatelessWidget {
  final String role;

  const HomeScreen({super.key, required this.role});

  double _horizontalPadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 16;
    if (width < 900) return 24;
    if (width < 1200) return 32;
    return 48;
  }

  int _gridCount(BuildContext context, int itemLength) {
    final width = MediaQuery.of(context).size.width;
    if (itemLength == 0) return 1;
    if (width < 600) {
      return min(4, itemLength);
    }
    if (width < 900) {
      return min(6, itemLength);
    }
    return min(8, itemLength);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(role.toLowerCase()),
      child: Scaffold(
        drawer: const DrawerLayout(),
        backgroundColor: const Color(0xffF2F3F7),
        body: Consumer<HomeViewModel>(
          builder: (context, vm, child) {
            double padding = _horizontalPadding(context);
            return Stack(
              children: [
                Container(height: 145, color: AppColors.blue_200),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 38),
                    _buildHeader(context, padding),
                    const SizedBox(height: 8),
                    _buildTopItems(context, vm, padding),
                    const SizedBox(height: 28),
                    Expanded(
                      child:
                          vm.sections.isEmpty || vm.sections.first.items.isEmpty
                          ? const Center(child: Text("No data available"))
                          : SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: vm.sections.map((section) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: padding,
                                    ),
                                    child: _gridSection(
                                      section.items,
                                      vm,
                                      context,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Builder(
        builder: (menuContext) => Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(menuContext).openDrawer(),
            ),
            const SizedBox(width: 5),
            const Text(
              "Public Hospital",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopItems(
    BuildContext context,
    HomeViewModel vm,
    double padding,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: vm.topItems.map((item) {
            return Expanded(
              child: HomeCircleItem(
                item: item,
                onTap: () => vm.onItemTap(context, item),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _gridSection(List items, HomeViewModel vm, BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text("No items"));
    }
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridCount(context, items.length),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        return HomeCircleItem(
          item: items[index],
          onTap: () => vm.onItemTap(context, items[index]),
        );
      },
    );
  }
}
