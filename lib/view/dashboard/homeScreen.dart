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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: vm.topItems.map((item) {
                          return HomeCircleItem(
                            item: item,
                            onTap: () => vm.onItemTap(context, item),
                          );
                        }).toList(),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _sectionTitle("Patient"),
                            _gridSection(vm.patientItems, vm, context),
                            const SizedBox(height: 10),
                            _sectionTitle("Service"),
                            _gridSection(vm.serviceItems, vm, context),
                            const SizedBox(height: 10),
                            _sectionTitle("Staff"),
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 30,
        bottom: 0.1,
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
  }

  Widget _gridSection(
      List<HomeItemModel> items,
      HomeViewModel vm,
      BuildContext context,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 19,
          childAspectRatio: .65,
        ),
        itemBuilder: (context, index) {
          return HomeCircleItem(
            item: items[index],
            onTap: () => vm.onItemTap(context, items[index]),
          );
        },
      ),
    );
  }
}