import 'package:attendance_calculator/main.dart';
import 'package:attendance_calculator/model/subject_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CalculationScreen extends StatelessWidget {
  List<int> rollnumber_calculation=[];
  List<int> period_calculation=[];
  List<int> totalstudent_list=[];
 SubjectModel passingmodel;
  double percentage=0;

  CalculationScreen({required this.passingmodel});



  @override
  Widget build(BuildContext context) {

    final attendancekeys= attendance_box.keys.cast().where((element) => attendance_box.get(element)!.submodel.id==passingmodel.id).toList();

    attendancekeys.forEach((element) {
      rollnumber_calculation.addAll(attendance_box.get(element)!.rollnumberlist);
      period_calculation.addAll(attendance_box.get(element)!.periods);

    });
      totalstudent_list.clear();
     for(int i=1;i<=passingmodel.totalstrength;i++)
     {
       totalstudent_list.add(i);
     }
     totalstudent_list.addAll(rollnumber_calculation);
     totalstudent_list.sort();

     var map =Map();
     totalstudent_list.forEach((element) {
       if(!map.containsKey(element))
       {
         map[element]=1;
       }
       else
       {
         map[element] =map[element]+1;
       }
     });

   print(map);
    final displaywidgets=listwidget(map);

    return Scaffold(
      appBar: AppBar(title: Text('Final Attendance'),),
      body: SafeArea(
        child:ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: Colors.black)),
                title: Text(passingmodel.subject,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                subtitle: ListView(
                  shrinkWrap: true,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(passingmodel.semester,style: TextStyle(color: Colors.teal),),
                        SizedBox(width: 10),
                        Text(passingmodel.dept,style: TextStyle(color: Colors.teal),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Student : '+ passingmodel.totalstrength.toString(),style: TextStyle(color: Colors.indigo),),
                        //SizedBox(width: 25),
                        Text('Total Hours Handled : ' + period_calculation.length.toString(),style: TextStyle(color: Colors.deepPurple)),
                      ],
                    ),
                    SizedBox(width: 10),

                  ],
                ),
              ),
            ),

            ...displaywidgets


          ],
        ),


        ),
      );
  }
  List<Widget>listwidget(Map map){
    List<Widget> widgets=[];
    map.forEach((key, value) {
      value=value-1;
      percentage=((period_calculation.length - value)/period_calculation.length)*100;
     widgets.add(
       ListTile(

         title: Text('Roll Number : $key'),
         subtitle: Text('Total Absent Hours : $value'),
         trailing: Text('$percentage%'),

       ),


     );
      widgets.add(Divider(thickness: 2,));
    });

    return widgets;
  }
}
