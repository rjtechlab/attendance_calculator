import 'package:flutter/material.dart';
class AttendanceScreen extends StatelessWidget {
  String subject;
  AttendanceScreen({required this.subject});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text(subject,),),
    );
  }
}
