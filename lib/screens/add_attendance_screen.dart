import 'package:attendance_calculator/main.dart';
import 'package:attendance_calculator/model/attendance_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddAttendanceScreen extends StatelessWidget {
  String subject;
  int totalstudents;
  ValueNotifier<String> datein_string = ValueNotifier<String>('');
  DateTime? date;
  final absent_controller = TextEditingController();
  final period_controller = TextEditingController();
  List splittedabsentees = [];
  List<String> absenteeslist = [];
  List<int> absenteeslist_integer = [];
  List<int> finalattendancelist = [];
  final _FormKey=GlobalKey<FormState>();
  List<int> tempperiodlist=[1,2];

  AddAttendanceScreen({required this.subject, required this.totalstudents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$subject -Attendance List'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  if(value==null||value.isEmpty){
                    return 'Please enter period';
                  }
                },
                keyboardType: TextInputType.numberWithOptions(),
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
              } else {
                date = selecteddatetemp;
                datein_string.value = date.toString();
              }
            },
            icon: Icon(Icons.calendar_today),
            label:  ValueListenableBuilder( valueListenable: datein_string,
              builder: (BuildContext ctx, String finaldate, Widget? _) {
                return date==null?Text('SelectDate',style: TextStyle(color: Colors.red),):Text(DateFormat.yMMMd().format(date!));
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {

                _FormKey.currentState!.validate();
                if(date==null){
                  return;
                }
                final absentees = period_controller.text;
                find_finalattendance(context, absentees);
                final attendance_data=AttendenceModel(periods: tempperiodlist, date: date!, id: DateTime.now().microsecondsSinceEpoch.toString(), rollnumberlist: finalattendancelist, subject: subject);
                attendance_box.add(attendance_data);
                Navigator.pop(context);
              },
              child: Text('Add')),
        ],
      )
          //Text(subject+ totalstudents.toString()),
          ),
    );
  }

  void find_finalattendance(BuildContext context, String absentees) {
    if (absentees.isNotEmpty) {
      absenteeslist = absentees.split(",");
      absenteeslist_integer = absenteeslist.map(int.parse).toList();

      for (var element in absenteeslist_integer) {
        if (element > totalstudents) {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Alert!!'),
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
                      Text('Total student strength is $totalstudents'),
                      ElevatedButton(
                          onPressed: () {
                            absenteeslist.clear();
                            final absent = absent_controller.text;
                            absenteeslist = absent.split(",");
                            absenteeslist_integer =
                                absenteeslist.map(int.parse).toList();

                            finalattendancelist = absenteeslist_integer;
                            print('parsed list=$finalattendancelist');
                            absent_controller
                                .clear(); //Clear textformfield after attendance  entering
                            SystemChannels.textInput.invokeMethod(
                                'TextInput.hide'); //Dispose keyboard
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'))
                    ],
                  ),
                );
              });
        } else {
          finalattendancelist = absenteeslist_integer;
        }
      }
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide'); //Dispose keyboard
  }
}
