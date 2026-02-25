import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/color/AppColor.dart';
import 'package:public_hospital/model/HomeItemModel.dart';
import 'package:public_hospital/view/dashboard/drawer_layout.dart';
import 'package:public_hospital/viewModel/dashboard/HomeViewModel.dart';
import 'package:public_hospital/widgets/HomeCircleItem.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        drawer: const DrawerLayout(),
        backgroundColor: const Color(0xffF2F3F7),
        body: Consumer<HomeViewModel>(
          builder: (context, vm, child) {
            return Stack(
              children: [
                Container(
                  height: 145,
                  color: AppColors.blue_200,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 38),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Builder(
                        builder: (menuContext) => Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white),
                              onPressed: () {
                                Scaffold.of(menuContext).openDrawer();
                              },
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
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          HomeCircleItem(
                            item: vm.topItems[0],
                            onTap: () => vm.onItemTap(context, vm.topItems[0]),
                          ),

                          Expanded(
                            child: Center(
                              child: HomeCircleItem(
                                item: vm.topItems[1],
                                onTap: () => vm.onItemTap(context, vm.topItems[1]),
                              ),
                            ),
                          ),

                          HomeCircleItem(
                            item: vm.topItems[2],
                            onTap: () => vm.onItemTap(context, vm.topItems[2]),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _sectionTitle("Patient",context),
                            const SizedBox(height: 4),
                            _gridSection(vm.patientItems, vm, context),
                            _sectionTitle("Service",context),
                            const SizedBox(height: 4),
                            _gridSection(vm.serviceItems, vm, context),
                            _sectionTitle("Staff",context),
                            const SizedBox(height: 4),
                            _gridSection(vm.staffItem, vm, context),
                            const SizedBox(height: 10),
                          ],
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

  Widget _sectionTitle(String title, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding = 16;
        if (constraints.maxWidth >= 1200) {
          horizontalPadding = 40;
        } else if (constraints.maxWidth >= 800) {
          horizontalPadding = 28;
        }

        return Padding(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.blue100,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _gridSection(
      List<HomeItemModel> items,
      HomeViewModel vm,
      BuildContext context,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        int crossAxisCount;
        double childAspectRatio;

        if (width < 500) {
          crossAxisCount = 4;
          childAspectRatio = 0.75;
        }

        else if (width < 900) {
          crossAxisCount = 6;
          childAspectRatio = 1.1;
        }

        else if (width < 1200) {
          crossAxisCount = 7;
          childAspectRatio = 1.15;
        }
        else {
          crossAxisCount = 8;
          childAspectRatio = 1.2;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 4,
              crossAxisSpacing: 8,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              return HomeCircleItem(
                item: items[index],
                onTap: () => vm.onItemTap(context, items[index]),
              );
            },
          ),
        );
      },
    );
  }
}