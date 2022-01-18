import 'package:attendance_calculator/main.dart';
import 'package:attendance_calculator/model/attendance_model.dart';
import 'package:attendance_calculator/screens/add_attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatelessWidget {
  String subject;
  int totalstudents;

  AttendanceScreen({required this.subject, required this.totalstudents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$subject Attendance'),),
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)
          {
            return AddAttendanceScreen(
              subject: subject, totalstudents: totalstudents);}));
        },
        child:Icon(Icons.add)),
        body:SafeArea(
          child: ValueListenableBuilder(
            valueListenable: attendance_box.listenable(),
            builder: (BuildContext context, Box<AttendenceModel> value, Widget? child) {
              final keys= value.keys.cast().where((element) => value.get(element)!.subject==subject).toList();
              return ListView.separated(
                  itemBuilder: (context,index){
                    final attendance_item=value.get(keys[index]);
                    return ListTile(
                      title: Text(attendance_item!.rollnumberlist.toString()),
                      subtitle: Text(attendance_item.periods.toString()),
                    leading: Text(DateFormat.yMMMd().format(attendance_item.date)),
                    );
                  },
                  separatorBuilder:(context,index){
                    return Divider(thickness: 2);
                  },
                  itemCount: keys.length);
            },

          ),
        ) );
  }
}
