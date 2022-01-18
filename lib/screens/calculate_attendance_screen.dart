import 'package:attendance_calculator/main.dart';
import 'package:flutter/material.dart';
class CalculationScreen extends StatelessWidget {
  List<int> rollnumber_calculation=[];
  List<int> period_calculation=[];
 String passingsubject;

  CalculationScreen({required this.passingsubject});



  @override
  Widget build(BuildContext context) {

    final attendancekeys= attendance_box.keys.cast().where((element) => attendance_box.get(element)!.subject==passingsubject).toList();
    final subjectkeys= subject_box.keys.cast().where((element) => subject_box.get(element)!.subject==passingsubject).toList();
    attendancekeys.forEach((element) {
      rollnumber_calculation.addAll(attendance_box.get(element)!.rollnumberlist);
      period_calculation.addAll(attendance_box.get(element)!.periods);

    });
    print(rollnumber_calculation);
    print(period_calculation);
    return Scaffold(
      appBar: AppBar(title: Text('Final Attendance'),),
      body: SafeArea(
        child: Text(rollnumber_calculation.toString()),
      ),
    );
  }
}
