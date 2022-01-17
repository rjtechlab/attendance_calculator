import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AttendanceScreen extends StatelessWidget {
  String subject;
  int totalstudents;

  AttendanceScreen({required this.subject, required this.totalstudents});

  @override
  Widget build(BuildContext context) {
    final absent_controller = TextEditingController();
    List  splittedabsentees=[];
   // final _GlobalKey2=GlobalKey<FormState>();
    List<String> absenteeslist=[];
    List<int> absenteeslist_integer=[];
    List<int> finalattendancelist=[];
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Attendance'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(

              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9,]')),],
              decoration: InputDecoration(hintText: 'Enter absentees seperated by comma',border: OutlineInputBorder()),
              controller: absent_controller,

            ),
          ),
          ElevatedButton(
              onPressed: () {
                final absentees=absent_controller.text;

                if(absentees.isNotEmpty)
                {
                  absenteeslist=absentees.split(",");
                  absenteeslist_integer=absenteeslist.map(int.parse).toList();

                  for (var element in absenteeslist_integer) {
                    if(element>totalstudents)   {

                      showDialog(context: context, builder: (ctx){
                        return AlertDialog(
                          title: Text('Alert!!'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(border: OutlineInputBorder()),
                                controller: absent_controller,
                              ),
                              Text('Total student strength is $totalstudents'),
                              ElevatedButton(onPressed: (){

                                absenteeslist.clear();
                                final absent=absent_controller.text;
                                absenteeslist=absent.split(",");
                                absenteeslist_integer = absenteeslist.map(int.parse).toList();

                              finalattendancelist=absenteeslist_integer;
                               print('parsed list=$finalattendancelist');
                                absent_controller.clear();//Clear textformfield after attendance  entering
                                Navigator.of(context).pop();
                              }, child: Text('OK'))
                            ],
                          ),
                        );
                      });
                      SystemChannels.textInput.invokeMethod('TextInput.hide');//Dispose keyboard
                    //  absent_controller.clear();//Clear textformfield after attendance  entering
                    }
                    else{
                      finalattendancelist=absenteeslist_integer;
                      print('parsed list=$finalattendancelist');
                    }
                  }
                }

               // Navigator.pop(context);
              },
              child: Text('Add')),
        ],
      )
          //Text(subject+ totalstudents.toString()),
          ),
    );
  }
}
