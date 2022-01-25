import 'package:attendance_calculator/main.dart';
import 'package:attendance_calculator/model/attendance_model.dart';
import 'package:attendance_calculator/model/subject_model.dart';
import 'package:attendance_calculator/screens/add_attendance_screen.dart';
import 'package:attendance_calculator/screens/calculate_attendance_screen.dart';
import 'package:attendance_calculator/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatelessWidget {
  SubjectModel subjectmodel;
  //String subject;
 // int totalstudents;
  List<int>rollnumber_calculation=[];


  AttendanceScreen({required this.subjectmodel});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(backgroundColor: Colors.brown,
        title: Text('${subjectmodel.subject} Attendance'),actions: [
        IconButton(onPressed: (){

          Navigator.of(context).push(MaterialPageRoute(builder: (context)
          {
            return AddAttendanceScreen(subjectModel: subjectmodel,

            );}));


        }, icon: Icon(Icons.add))
      ],),

        body:SafeArea(
          child: ValueListenableBuilder(
      valueListenable: isemptycalculatebutton,
            builder: (BuildContext context, bool boolvalue, Widget? child) {
              return Column(

               // mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: boolvalue,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(onPressed: (){
                        rollnumber_calculation.clear();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){return CalculationScreen(passingmodel: subjectmodel);}));
                      },
                        child: Text('Calculate',style: TextStyle(color: Colors.black,),),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: attendance_box.listenable(),
                      builder: (BuildContext context, Box<AttendenceModel> value, Widget? child) {

                        final keys= value.keys.cast().where((element) => value.get(element)!.submodel.id==subjectmodel.id).toList();
                        return keys.isEmpty?Center(child: RichText(
                          text: const TextSpan(
                              style: TextStyle(color: Colors.black,fontSize: 20),
                              children: [
                                TextSpan(text: 'Press  '),
                                TextSpan(text: '+',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                                TextSpan(text: '  button to add Attendance'),
                              ]
                          ),)): ListView.separated(
                            itemBuilder: (context,index){
                              final attendance_item=value.get(keys[index]);
                              rollnumber_calculation.addAll(attendance_item!.rollnumberlist);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: Colors.black)),
                                  title: Text('Absentees : '+attendance_item.rollnumberlist.toString()),
                                  subtitle: ListView(

                                    shrinkWrap: true,
                                    //mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Dept. : '+attendance_item.department),
                                      SizedBox(width: 10),
                                      Text('Period : '+attendance_item.periods.toString().replaceAll('[', ' ').replaceAll(']', ' ')),
                                    ],
                                  ),
                                  leading: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.grey[400],
                                      child: Text(parsedate(attendance_item.date),
                                        style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),)),
                                  trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){
                                    showDialog(context: context, builder: (context){
                                      return AlertDialog(title: Text('Delete?'),content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Are you sure you want to delete this item ?'),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TextButton(onPressed: (){
                                                Navigator.of(context).pop();
                                              }, child:Text('Cancel') ),
                                              TextButton(onPressed: (){
                                                attendance_box.delete(keys[index]);
                                                Navigator.of(context).pop();
                                              }, child:Text('Ok') ),
                                            ],
                                          )
                                        ],
                                      ),);
                                    });


                                    final checkkeys=attendance_box.keys.where((element) => attendance_box.get(element)!.submodel.id==subjectmodel.id);
                                    if(checkkeys.isEmpty){
                                      isemptycalculatebutton.value=false;
                                      isemptycalculatebutton.notifyListeners();
                                    }
                                    else
                                    {
                                      isemptycalculatebutton.value=true;
                                      isemptycalculatebutton.notifyListeners();
                                    }
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
              );
    },

    ),

            ),

        ) ;
  }

  String parsedate(DateTime date) {
   final date1 = DateFormat.yMMMd().format(date);
   final splittedDate = date1.split(",");
   return "${splittedDate.first} \n${splittedDate.last}";
    
  }
}
