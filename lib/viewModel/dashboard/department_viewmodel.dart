import 'package:flutter/material.dart';
import '../../model/department_model.dart';

class DepartmentViewModel extends ChangeNotifier {
  final List<DepartmentModel> departments = [
    DepartmentModel(name: "Cardiology", icon: Icons.monitor_heart),
    DepartmentModel(name: "Medicine", icon: Icons.local_hospital),
    DepartmentModel(name: "Dermatology", icon: Icons.face),
    DepartmentModel(name: "Orthopedic", icon: Icons.accessibility_new),
    DepartmentModel(name: "Neurology", icon: Icons.psychology),
    DepartmentModel(name: "Pediatrics", icon: Icons.child_care),
  ];
}