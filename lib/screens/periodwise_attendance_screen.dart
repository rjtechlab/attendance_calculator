import 'package:attendance_calculator/model/attendance_model.dart';
import 'package:flutter/material.dart';

class PeriodwiseAttendanceScreen extends StatelessWidget {
  AttendenceModel? attendance_item;

  PeriodwiseAttendanceScreen(this.attendance_item);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absent List'),centerTitle: true,),
      body: SafeArea(
        child: ListView.separated(
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 10,),
                child: ListTile( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black)),
                  title: Text('Period : ' + attendance_item!.periods[index].toString().replaceAll('[', ' ').replaceAll(']', ' ')) ,
                subtitle: Text('Absentees roll nos : '+ attendance_item!.rollnumberlist[index].toString().replaceAll('[', ' ').replaceAll(']', ' '),
                  style: TextStyle(color: Colors.black,fontSize: 15),),),
              );},
            separatorBuilder: (context,index){return SizedBox();},
            itemCount: attendance_item!.periods.length)
      ),
    );
  }
}
