import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/activity_view_model.dart';
import '../../widgets/home_circle_item.dart';
import '../../color/app_color.dart';

class ActivityScreen extends StatelessWidget {
  final String role;
  final String nationalId;

  const ActivityScreen({
    super.key,
    required this.role,
    required this.nationalId,
  });

  double _horizontalPadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 16;
    if (width < 900) return 24;
    if (width < 1200) return 32;
    return 48;
  }

  int _gridCount(BuildContext context, int length) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return 2;
    if (width < 900) return 3;
    double padding = _horizontalPadding(context);
    double availableWidth = width - (padding * 2);
    const double itemWidth = 110;
    int count = (availableWidth / itemWidth).floor();
    if (count > length) count = length;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ActivityViewModel(role: role, nationalId: nationalId)..init(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F7),
        appBar: AppBar(
          backgroundColor: AppColors.blue_200,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Activity"),
        ),
        body: Consumer<ActivityViewModel>(
          builder: (context, vm, child) {
            double padding = _horizontalPadding(context);
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
                top: 50,
                bottom: 20,
              ),
              child: GridView.builder(
                itemCount: vm.items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridCount(context, vm.items.length),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 95,
                ),
                itemBuilder: (context, index) {
                  final item = vm.items[index];
                  return HomeCircleItem(
                    item: item,
                    onTap: () => vm.onItemTap(context, item),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
