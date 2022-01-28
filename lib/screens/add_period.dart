import 'package:attendance_calculator/model/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'entery_attendance.dart';
class AddPeriodScreen extends StatelessWidget {

  List<int>periodlist=[];
  final period_controller=TextEditingController();
 final _FormKey = GlobalKey<FormState>();
  ValueNotifier<String> datein_string = ValueNotifier<String>('');
  DateTime? date;

  SubjectModel passingsubjectmodel;
  AddPeriodScreen({required this.passingsubjectmodel});



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
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
                        hintText: 'Enter periods', border: OutlineInputBorder()),
                    controller: period_controller,
                  ),
                ),
              ),
              //----------------
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
              //---------------------------------
              ElevatedButton(onPressed: (){
                  if( _FormKey.currentState!.validate()){
                          if(date==null)
                          {
                            return;
                          }
                              //----------------
                          final period= period_controller.text;
                          final period1= period.split(',');
                          periodlist = period1.map(int.parse).toList();
                          Navigator.of(context).push(MaterialPageRoute(builder: (C){
                            return EnterAttendance(periodlist,passingsubjectmodel);
                          }));

                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),),
    );
  }
}
