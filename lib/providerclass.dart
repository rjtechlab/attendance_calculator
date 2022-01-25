
import 'package:attendance_calculator/model/subject_model.dart';
import 'package:flutter/material.dart';

class Assigncontrollers with ChangeNotifier{

  var subject_controller=TextEditingController();
  var dept_controller=TextEditingController();
  var semester_controller=TextEditingController();
  var totalstudent_controller=TextEditingController();
  String id='';


  void Assign(SubjectModel model){
  subject_controller.text=model.subject;
  dept_controller.text=model.dept;
  semester_controller.text=model.semester;
  totalstudent_controller.text=model.totalstrength.toString();
   id=model.id;
   notifyListeners();
  }
  void Clearprovider(){
    subject_controller.clear();
    dept_controller.clear();
    semester_controller.clear();
    totalstudent_controller.clear();

  }
}