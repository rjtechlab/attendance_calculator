import 'package:attendance_calculator/main.dart';
import 'package:attendance_calculator/model/attendance_model.dart';
import 'package:attendance_calculator/model/subject_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providerclass.dart';

class AddAttendanceScreen extends StatelessWidget {
  SubjectModel subjectModel;
  //String subject;
  //int totalstudents;
  ValueNotifier<String> datein_string = ValueNotifier<String>('');
  ValueNotifier<int> element = ValueNotifier<int>(0);
  DateTime? date;
  final absent_controller = TextEditingController();
  final period_controller = TextEditingController();
  List splittedabsentees = [];
  List<String> absenteeslist = [];
  List<int> absenteeslist_integer = [];
  List<int> finalattendancelist = [];
  final _FormKey=GlobalKey<FormState>();
  List<int> tempperiodlist=[1,2];

  AddAttendanceScreen({required this.subjectModel
    //required this.subject, required this.totalstudents
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(backgroundColor: Colors.brown,
        title: Text(subjectModel.subject),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
            shrinkWrap: true,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
              ],
              decoration: const InputDecoration(
                  hintText: 'Enter absentees seperated by comma',
                  border: OutlineInputBorder()),
              controller: absent_controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _FormKey,
              child: TextFormField(
                validator: (value){
                  if(value=='0'||value==null||value.isEmpty){
                    return 'Please enter period';
                  }

                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
                ],
                decoration: const InputDecoration(
                    hintText: 'Enter period', border: OutlineInputBorder()),
                controller: period_controller,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              final selecteddatetemp = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 30)),
                  lastDate: DateTime.now());
              if (selecteddatetemp == null) {
                return;
              }
              else {
                date = selecteddatetemp;
                datein_string.value = date.toString();
              }
            },
            icon: Icon(Icons.calendar_today,color: Colors.brown,),
            label:  ValueListenableBuilder( valueListenable: datein_string,
              builder: (BuildContext ctx, String finaldate, Widget? _) {
                return date==null?Text('SelectDate',style: TextStyle(color: Colors.red),):Text(DateFormat.yMMMd().format(date!),style: TextStyle(color: Colors.brown),);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 150,right: 150),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
                onPressed: () async {

               if( _FormKey.currentState!.validate()){
                 if(date==null){
                   return;
                 }
                 final  periodlist = period_controller.text.split(",");
                 final periodlist_integer = periodlist.map(int.parse).toList();


                 // final absentees = absent_controller.text.split(',');
                 find_finalattendance(context, absent_controller.text);

                 final attendance_data=AttendenceModel(periods: periodlist_integer, date: date!, id: DateTime.now().microsecondsSinceEpoch.toString(),
                     rollnumberlist: finalattendancelist, subject:subjectModel.subject, department: subjectModel.dept, submodel: subjectModel);
                 attendance_box.add(attendance_data);
                 final list=attendance_box.values.toList();
                 list.sort((a,b)=>b.date.compareTo(a.date));
                 final listkeys=attendance_box.keys.cast();
                 attendance_box.deleteAll(listkeys);
                 await attendance_box.addAll(list);


                 attendance_box.isEmpty?isemptycalculatebutton.value=false:isemptycalculatebutton.value=true;
                 isemptycalculatebutton.notifyListeners();

                 Navigator.pop(context);
               }

                },
                child: Text('Add',style: TextStyle(color: Colors.black),)),
          ),
        ],
      )
          //Text(subject+ totalstudents.toString()),
          ),
    );
  }

   find_finalattendance(context, String absentees, )  async {

    if (absentees.isNotEmpty) {
      absenteeslist = absentees.split(",");
     // absenteeslist.remove('0');
      absenteeslist_integer = absenteeslist.map(int.parse).toList();
        print('ok $absenteeslist_integer');

      for (var i in absenteeslist_integer) {
        element.value=i;
        if (i>subjectModel.totalstrength || i==0) {
          print(element);
          print(subjectModel.totalstrength);
         //  await showDialog(context: context, builder: (context){
         //   return AlertDialog(title: Text('text'),);
         // });

          await showDialog(context: context, builder: (context) {
            return ValueListenableBuilder(
              valueListenable: element,
              builder: (BuildContext context, element, Widget? child) {
                return AlertDialog(title: Text('Alert!!'),
                  // });
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        keyboardType: TextInputType.numberWithOptions(),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
                        ],
                        decoration:
                        InputDecoration(border: OutlineInputBorder()),
                        controller: absent_controller,
                      ),
                      Text(element==0?'Remove 0 in attendance list':'Total student strength is' +
                          subjectModel.totalstrength.toString()),
                      ElevatedButton(
                          onPressed: () {
                            absenteeslist.clear();
                            final absent = absent_controller.text;
                            absenteeslist = absent.split(",");
                            find_finalattendance(context, absent_controller.text);
                            absenteeslist_integer =
                                absenteeslist.map(int.parse).toList();

                            finalattendancelist = absenteeslist_integer;

                            print('parsed list=$finalattendancelist');
                            // absent_controller.clear();

                            //Clear textformfield after attendance  entering
                            SystemChannels.textInput.invokeMethod(
                                'TextInput.hide'); //Dispose keyboard
                            Navigator.of(context).pop();
                          },
                          child: Text('OK')),
                    ],
                  ),);
              },

            );
          });
              }
          else
            {
          finalattendancelist = absenteeslist_integer;
        }
      }
    }
    else{
      finalattendancelist=absenteeslist_integer;
      print('in else');

    }
    SystemChannels.textInput.invokeMethod('TextInput.hide'); //Dispose keyboard
  }


}
