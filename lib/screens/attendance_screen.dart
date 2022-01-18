import 'package:attendance_calculator/main.dart';
import 'package:attendance_calculator/model/attendance_model.dart';
import 'package:attendance_calculator/screens/add_attendance_screen.dart';
import 'package:attendance_calculator/screens/calculate_attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatelessWidget {
  String subject;
  int totalstudents;
  List<int>rollnumber_calculation=[];

  AttendanceScreen({required this.subject, required this.totalstudents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$subject Attendance'),actions: [
        IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)
          {
            return AddAttendanceScreen(
                subject: subject, totalstudents: totalstudents);}));

        }, icon: Icon(Icons.add))
      ],),

        body:SafeArea(
          child: Column(
            children: [
              ElevatedButton(onPressed: (){
                rollnumber_calculation.clear();
                Navigator.of(context).push(MaterialPageRoute(builder: (context){return CalculationScreen(passingsubject: subject);}));
              },
                child: Text('Calculate'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.teal)),),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: attendance_box.listenable(),
                  builder: (BuildContext context, Box<AttendenceModel> value, Widget? child) {
                    final keys= value.keys.cast().where((element) => value.get(element)!.subject==subject).toList();
                    return ListView.separated(
                        itemBuilder: (context,index){
                          final attendance_item=value.get(keys[index]);
                          rollnumber_calculation.addAll(attendance_item!.rollnumberlist);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.black)),
                              title: Text('Absentees : '+attendance_item.rollnumberlist.toString()),
                              subtitle: Text('Period : '+attendance_item.periods.toString()),
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.grey[200],
                                child: Text(parsedate(attendance_item.date),
                                  style: TextStyle(color: Colors.black,fontSize: 10),)),
                              trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){
                                attendance_box.delete(keys[index]);
                              },),
                            ),
                          );
                        },
                        separatorBuilder:(context,index){
                          return SizedBox();
                        },
                        itemCount: keys.length);
                  },

                ),
              ),
            ],
          ),
        ) );
  }

  String parsedate(DateTime date) {
   final date1 = DateFormat.yMMMd().format(date);
   final splittedDate = date1.split(",");
   return "${splittedDate.first} \n${splittedDate.last}";
    
  }
}
