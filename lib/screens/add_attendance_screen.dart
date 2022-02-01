import 'package:attendance_calculator/model/attendance_model.dart';
import 'package:attendance_calculator/model/subject_model.dart';
import 'package:attendance_calculator/screens/attendance_screen.dart';
import 'package:attendance_calculator/widgets/alert.dart';
import 'package:attendance_calculator/widgets/save_attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class AddAttendance extends StatelessWidget {
  List<int> periods;
  SubjectModel passingsubjectmodel;
DateTime date;
  AddAttendance(this.periods, this.passingsubjectmodel,this.date);
  int count=0;

  
  bool checkedValue = false;
  ValueNotifier<bool> checkvalue = ValueNotifier(false);
  bool limitexeed = false;
  bool fullpresent = false;
  List<String> splittedcontroller = [];
  List<int> controllerlist_int=[];
  List<List<int>> periodwise_absentlist=[];
  List<TextEditingController> controllers=[];

  @override
  Widget build(BuildContext context) {

    controllers =
        List.generate(periods.length, (index) => TextEditingController());
    List<Widget> list = [];
    List<String> controllerlist = [];

    for (int i = 0; i < periods.length; i++) {
      list.add(Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('  Period ' + periods[i].toString() + ' :  '),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9,]')),

                  ],
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) async {
                    checkvalue.value = false;
                    if (value.length > 2) {
                      var newString = value.substring((value.length - 2));
                      if (newString == ',,') {
                       await alert(context,'Remove double entry of comma');
                      }
                    } else {
                      if (value == ',,') {
                        alert(context,'Remove double entry of comma');
                      }
                    }
                  },
                  controller: controllers[i]),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ));
    }
    final firstwidget = list[0];
    list.remove(list[0]);

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: checkvalue,
          builder: (BuildContext context, bool value, Widget? child) {
            if (value == true) {
              for (int k = 1; k < periods.length; k++) {
                controllers[k].text = controllers[0].text;
              }
            }
            return ListView(children: [
              firstwidget,
              CheckboxListTile(
                title: Text("select if attendance same for all ."),
                value: value,
                onChanged: (newValue) {
                  {
                    checkvalue.value = newValue!;
                  }
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              ...list,
              Padding(
                padding: const EdgeInsets.only(left: 150, right: 150),
                child: ElevatedButton(
                    onPressed: () async {
                      controllerlist.clear();

                      for (int j = 0; j < periods.length; j++) {
                        // if(controllers[j].text.endsWith(',')){
                        //
                        //   await  alert(context,'Please enter valid period');
                        //
                        //   return;
                        // }


                        if (controllers[j].text.contains(',,')) {
                         await alert(context,'Remove double entry of comma');
                          return;
                        } else {

                          splittedcontroller = controllers[j].text.split(',');
                          splittedcontroller.remove('');
                         // periodwise_absentlist.clear();
                         // periodwise_absentlist.add(splittedcontroller);
                         // print('last : $periodwise_absentlist[1]');
                          controllerlist.addAll(splittedcontroller);
                        }
                      }
                      controllerlist.remove('');                      
                      print(controllerlist);
                     await validation(context, controllerlist);

                      //Navigator.of(context).push(MaterialPageRoute(builder: (context){return AttendanceScreen(subjectmodel);}));
                     // SaveAttendance(passingsubjectmodel,controllerlist_int,periods);
                    },
                    child: Text('Add')),
              ),
            ]);
          },
        ),
      ),
    );
  }



  Future<void> validation(context, List<String> controllerlist) async {
    if (controllerlist.isNotEmpty) {
      controllerlist_int = controllerlist.map(int.parse).toList();
      for (var i in controllerlist_int) {

        if (i > passingsubjectmodel.totalstrength) {
          limitexeed = true;
        }
      }
      if (limitexeed == true || controllerlist_int.contains(0)) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Alert'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    limitexeed == true
                        ? Text('Entered roll number exceeds the total strength')
                        : Text('Remove "0" in attendence entry'),
                    TextButton(
                        onPressed: () {
                          //controllerlist.clear();
                          //controllerlist_int.clear();
                          limitexeed=false;
                           Navigator.of(ctx).pop();

                        },
                        child: Text('Ok'))
                  ],
                ),
              );
            });
      }
      else {
        periodwise_absentlist.clear();
        for (int j = 0; j < periods.length; j++) {
          splittedcontroller = controllers[j].text.split(',');
          splittedcontroller.remove('');
          final splittedcontroller_int=splittedcontroller.map(int.parse).toList();

          periodwise_absentlist.add(splittedcontroller_int);

        }
        //print(periodwise_absentlist[1]);


        final data=AttendenceModel(subject: passingsubjectmodel.subject,
            periods: periods,
            date: date,
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            rollnumberlist: periodwise_absentlist,
            department: passingsubjectmodel.dept,
            submodel: passingsubjectmodel);
        attendance_box.put(data.id, data);
        isemptycalculatebutton.value=true;
        isemptycalculatebutton.notifyListeners();
        Navigator.of(context).popUntil((_) => count++>=2);
        print(controllerlist_int);
      }
    }
  }
}
