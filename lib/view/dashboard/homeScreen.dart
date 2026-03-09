import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/color/AppColor.dart';
import 'package:public_hospital/view/dashboard/drawer_layout.dart';
import 'package:public_hospital/viewModel/dashboard/HomeViewModel.dart';
import 'package:public_hospital/widgets/HomeCircleItem.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  double _horizontalPadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 16;
    if (width < 900) return 24;
    if (width < 1200) return 32;
    return 48;
  }

  int _gridCount(BuildContext context, int itemLength) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 4;
    if (width < 900) return 6;
    double padding = _horizontalPadding(context);
    double availableWidth = width - (padding * 2);
    const double itemWidth = 100;
    int count = (availableWidth / itemWidth).floor();
    if (count <= 0) count = 1;
    if (count > itemLength) {
      count = itemLength;
    }
    return count;
  }

  double _calculateItemWidth(BuildContext context, int itemLength) {
    double padding = _horizontalPadding(context);
    double width = MediaQuery.of(context).size.width;
    int crossAxisCount = _gridCount(context, itemLength);
    double totalSpacing = (crossAxisCount - 1) * 12;
    double availableWidth = width - (padding * 2) - totalSpacing;
    availableWidth = max(availableWidth, crossAxisCount * 80);
    return availableWidth / crossAxisCount;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
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
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: vm.sections.map((section) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: padding,
                              ),
                              child: _buildSection(section, vm, context),
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

  Widget _buildSection(
    dynamic section,
    HomeViewModel vm,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(section.title),
        _gridSection(section.items, vm, context),
        if (section.title == "Service") ...[
          const SizedBox(height: 16),
          _buildResponsiveStaffButton(context, vm),
        ],
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.blue100,
        ),
      ),
    );
  }

  Widget _gridSection(List items, HomeViewModel vm, BuildContext context) {
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

  Widget _buildResponsiveStaffButton(BuildContext context, HomeViewModel vm) {
    double itemWidth = _calculateItemWidth(context, 8);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: itemWidth > 0 ? itemWidth : 80,
          child: HomeCircleItem(
            item: vm.staffButton,
            onTap: () => vm.onItemTap(context, vm.staffButton),
          ),
        ),
      ],
    );
  }
}
