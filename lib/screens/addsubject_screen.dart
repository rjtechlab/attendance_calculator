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
      appBar: AppBar(
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

                        print(_subject_controller.text);


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
