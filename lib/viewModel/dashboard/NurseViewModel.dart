import 'package:flutter/material.dart';
import '../../model/NurseModel.dart';
enum NurseTab{all, active}
class NurseViewModel extends ChangeNotifier {
   NurseTab _selectedTab = NurseTab.all;
  NurseTab get selectedTab => _selectedTab;
  final List<NurseModel> _allNurses =[
    NurseModel(
        nationalId: '123456',
        name: 'Jobayer',
        email: 'jobayer@gmail.com',
        address: 'West Rajabazar, Dhaka-1215',
        phone: '01700000000',
        dob: DateTime(1998, 12, 12),
        institute: 'Dhaka Medical College & Hospital',
        degree: 'BSc in Nursing',
        license: '12345678',
        isActive: true
    ),
    NurseModel(
        nationalId: '98765432',
        name: 'Milon',
        email: 'milon@gmail.com',
        address: 'West Rajabazar, Dhaka-1215',
        phone: '01700000000',
        dob: DateTime(1998, 12, 12),
        institute: 'Dhaka Medical College & Hospital',
        degree: 'BSc in Nursing',
        license: '12345678',
        isActive: false
    ),
  ];
   List<NurseModel> _filteredNurses = [];
  List<NurseModel> get nurses => _filteredNurses;
  NurseViewModel(){
    _filteredNurses = List.from(_allNurses);
  }
  void changeTab(NurseTab tab){
    _selectedTab = tab;
    if(tab == NurseTab.all){
      _filteredNurses = List.from(_allNurses);
    }else{
      _filteredNurses = _allNurses.where((nurses)=> nurses.isActive).toList();
    }
    notifyListeners();
  }
   void searchByNationalId(String id) {
     List<NurseModel> baseList =
     _selectedTab == NurseTab.all
         ? _allNurses
         : _allNurses.where((d) => d.isActive).toList();
     if (id.isEmpty) {
       _filteredNurses = baseList;
     } else {
       _filteredNurses = baseList
           .where((nurse) => nurse.nationalId.contains(id))
           .toList();
     }
     notifyListeners();
   }
}