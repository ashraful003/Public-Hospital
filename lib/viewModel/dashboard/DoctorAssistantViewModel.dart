import 'package:flutter/material.dart';
import 'package:public_hospital/model/DoctorAssistantModel.dart';
enum DoctorAssistantTab{all, active}
class DoctorAssistantViewModel extends ChangeNotifier{
  DoctorAssistantTab _selectedTab = DoctorAssistantTab.all;
  DoctorAssistantTab get selectedTab => _selectedTab;
  final List<DoctorAssistantModel> _allDoctorAssistants =[
    DoctorAssistantModel(
        nationalId: '123456',
        name: 'John Smith',
        email: 'johnsmith@gmail.com',
        address: 'West Rajabazar, Dhaka-1215',
        phone: '01717078044',
        dob: DateTime(1997,12,12),
        institute: 'Dhaka Medical College & Hospital',
        degree: 'Honers',
        isActive: true
    ),
    DoctorAssistantModel(
        nationalId: '987654',
        name: 'Smith',
        email: 'smith@gmail.com',
        address: 'West Rajabazar, Dhaka-1215',
        phone: '01717078044',
        dob: DateTime(1997,12,12),
        institute: 'Dhaka Medical College & Hospital',
        degree: 'Honers',
        isActive: false
    ),
  ];
  List<DoctorAssistantModel> _filteredDoctorAssistants =[];
  List<DoctorAssistantModel> get assistants => _filteredDoctorAssistants;
  DoctorAssistantViewModel(){
    _filteredDoctorAssistants = List.from(_allDoctorAssistants);
  }
  void changeTab(DoctorAssistantTab tab){
    _selectedTab = tab;
    if(tab == DoctorAssistantTab.all){
      _filteredDoctorAssistants = List.from(_allDoctorAssistants);
    }else{
      _filteredDoctorAssistants = _allDoctorAssistants.where((assistants)=> assistants.isActive).toList();
    }
    notifyListeners();
  }
  void searchByNationalId(String id){
    List<DoctorAssistantModel> baseList = _selectedTab == DoctorAssistantTab.all
        ? _allDoctorAssistants
        : _allDoctorAssistants.where((d)=> d.isActive).toList();
    if(id.isEmpty){
      _filteredDoctorAssistants = baseList;
    }else{
      _filteredDoctorAssistants = baseList
          .where((assistant)=> assistant.nationalId.contains(id))
          .toList();
    }
    notifyListeners();
  }
}