import 'package:attendance_calculator/main.dart';
import 'package:attendance_calculator/model/subject_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AddSubject extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final _globalKey=GlobalKey<FormState>();
    final _subject_controller=TextEditingController();
    final _dept_controller=TextEditingController();
    final _semester_controller=TextEditingController();
    final _totalstudent_controller=TextEditingController();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: Text('Add Subject'),
      ),
      body: SafeArea(
          child: Form(
            key:_globalKey ,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Subject Name'),
                      controller:_subject_controller ,
                     validator: (value){
                       if(value==null||value.isEmpty ){
                         return 'Enter Subject Name';
                       }
                     },
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Department Name'),
                      controller:_dept_controller ,
                      validator: (value){
                        if(value==null||value.isEmpty ){
                          return 'Enter Department Name';
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Semester'),
                      controller:_semester_controller ,
                      validator: (value){
                        if(value==null||value.isEmpty ){
                          return 'Enter Semester';
                        }
                      },
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Total no of students'),
                      controller:_totalstudent_controller ,
                      validator: (value){
                        if(value==null||value.isEmpty ){
                          return 'Enter Total no of students';
                        }
                      },
                    ),
                    SizedBox(height: 15,),
                    ElevatedButton(onPressed: (){
                      if(_globalKey.currentState!.validate()){
                        final student_strength= _totalstudent_controller.text;
                        final total_student= int.parse(student_strength);

                        final data= SubjectModel(
                            subject: _subject_controller.text,
                           dept: _dept_controller.text,
                           semester: _semester_controller.text,
                           totalstrength: total_student, id: DateTime.now().microsecondsSinceEpoch.toString()
                        );

                        subject_box.put(data.id, data);
                        Navigator.pop(context);
                      }

                    }, child: Text('Add Subject'))
                  ],
                ),
              ),
            ),

          )),
    );
  }
}
