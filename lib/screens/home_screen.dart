import 'package:attendance_calculator/main.dart';
import 'package:attendance_calculator/model/subject_model.dart';
import 'package:attendance_calculator/screens/addsubject_screen.dart';
import 'package:attendance_calculator/screens/add_attendance_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'attendance_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Subjects'),
        actions: [ IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){return AddSubject();}));
        }, icon: Icon(Icons.add),)],
      ),
      body: SafeArea(
          child: ValueListenableBuilder(

            valueListenable: subject_box.listenable(),

            builder: (BuildContext context, Box<SubjectModel> value, Widget? child) {
              final keys= value.keys.cast().toList();

              return ListView.separated(
                  itemBuilder: (context, index){
                    final subject_item= value.get(keys[index]);
                    return Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15,top: 8),
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: Colors.black)),
                        onTap: (){
                         // final subject_value= subject_item!.subject;
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return AttendanceScreen(
                                subjectmodel: subject_item!
                            );}));
                        },
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(subject_item!.subject),
                        ),

                        //---------------------------------------------
                      // subtitle: Container(
                      //   height: 20,
                      //   width: 50,
                      //   //color: Colors.grey[400],
                      //   child: ListView(
                      //     scrollDirection: Axis.horizontal,
                      //     children: [
                      //
                      //       Text(subject_item.semester),
                      //    Container(child: VerticalDivider(thickness:1,color: Colors.black,)),
                      //     Text(subject_item.dept),
                      //     Container(child: VerticalDivider(thickness:1,color: Colors.black,)),
                      //     Text('Total student : '+ subject_item.totalstrength.toString()),
                      //   ],),
                      // ),
                        //---------------------------------------------
                        subtitle: Column(
                          children: [
                          Row(
                            children: [
                              Text(subject_item.semester,style: TextStyle(color: Colors.teal),),
                              SizedBox(width: 10),
                              Text(subject_item.dept,style: TextStyle(color: Colors.teal),),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text('Total student : '+ subject_item.totalstrength.toString(),style: TextStyle(color: Colors.pink),),
                              ),
                            ],
                          ),
                          // Text('Total student : '+ subject_item.totalstrength.toString())
                        ],),
                        //----------------------------------------
                        trailing: IconButton(onPressed: (){
                         subject_box.delete(subject_item.id);
                        },icon: Icon(Icons.delete),),
                      ),
                    );
                  },
                  separatorBuilder:(context, index){
                    return SizedBox(height: 8);
                  } ,
                  itemCount: value.length);
            },

          )
      ),

          );
  }
}
