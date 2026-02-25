import 'package:public_hospital/model/UserModel.dart';
import 'DoctorModel.dart';

class MakePrescriptionModel {
  final DoctorModel doctor;
  final UserModel patient;
  final String complaints;
  final String diagnosis;
  final List<String> medicines;
  final DateTime date;

  MakePrescriptionModel({
    required this.doctor,
    required this.patient,
    required this.complaints,
    required this.diagnosis,
    required this.medicines,
    required this.date,
  });
}