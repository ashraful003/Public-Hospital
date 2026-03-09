import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../color/AppColor.dart';
import '../../widgets/HomeCircleItem.dart';
import '../../viewModel/dashboard/StaffViewModel.dart';
import 'StaffRegistrationScreen.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  bool get showBackButton {
    if (kIsWeb) return false;

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

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
    if (width < 900) return 5;

    double padding = _horizontalPadding(context);
    double availableWidth = width - (padding * 2);

    const double itemWidth = 110;

    int count = (availableWidth / itemWidth).floor();

    if (count > itemLength) {
      count = itemLength;
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StaffViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F7),

        appBar: AppBar(
          backgroundColor: AppColors.blue_200,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          leading: showBackButton
              ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
              : null,
        ),

        body: Consumer<StaffViewModel>(
          builder: (context, vm, child) {
            double padding = _horizontalPadding(context);

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
                top: 20,
                bottom: 20,
              ),
              child: GridView.builder(
                itemCount: vm.staffItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridCount(context, vm.staffItems.length),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 85,
                ),
                itemBuilder: (context, index) {
                  final item = vm.staffItems[index];

                  return HomeCircleItem(
                    item: item,
                    onTap: () => vm.onStaffTap(context, item),
                  );
                },
              ),
            );
          },
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StaffRegistrationScreen(),
              ),
            );
          },
          backgroundColor: AppColors.blue_200,
          icon: const Icon(Icons.person_add, color: Colors.white),
          label: const Text(
            "Registration",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}