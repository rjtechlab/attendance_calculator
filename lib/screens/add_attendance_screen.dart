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
DateTime date=DateTime.now();
  AddAttendance(this.periods, this.passingsubjectmodel, DateTime date);

  
  bool checkedValue = false;
  ValueNotifier<bool> checkvalue = ValueNotifier(false);
  bool limitexeed = false;
  bool fullpresent = false;
  List<String> spilittedlcontroller = [];
  List<int> controllerlist_int=[];

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers;
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
                        if(controllers[j].text.endsWith(',')){

                          await  alert(context,'Please enter valid period');

                          return;
                        }


                        if (controllers[j].text.contains(',,')) {
                         await alert(context,'Remove double entry of comma');
                          return;
                        } else {
                          spilittedlcontroller = controllers[j].text.split(',');
                          spilittedlcontroller.remove('');
                          controllerlist.addAll(spilittedlcontroller);
                        }
                      }
                      controllerlist.remove('');                      
                      print(controllerlist);
                      validation(context, controllerlist);
                      final data=AttendenceModel(subject: passingsubjectmodel.subject,
                          periods: periods,
                          date: date,
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          rollnumberlist: controllerlist_int,
                          department: passingsubjectmodel.dept,
                          submodel: passingsubjectmodel);
                      attendance_box.put(data.id, data);
                      Navigator.of(context).pop();
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
            builder: (context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    limitexeed == true
                        ? Text('Entered roll number exceeds the total strength')
                        : Text('Remove Zero in attendence entry'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ),
              );
            });
      }
      // else {
      //   print(controllerlist_int);
      // }
    }
  }
}
