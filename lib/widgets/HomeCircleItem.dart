import 'package:flutter/material.dart';
import 'package:public_hospital/model/HomeItemModel.dart';

class HomeCircleItem extends StatelessWidget {
  final HomeItemModel item;
  final VoidCallback onTap;

  final double circleSize;
  final double iconSize;

  const HomeCircleItem({
    super.key,
    required this.item,
    required this.onTap,
    this.circleSize = 50,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.bgColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Center(
              child: Icon(
                item.icon,
                size: iconSize,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: circleSize + 50,
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}