import 'package:attendance_calculator/model/subject_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class EnterAttendance extends StatelessWidget {

  List<int> text;
  SubjectModel passingsubjectmodel;
  EnterAttendance(this.text, this.passingsubjectmodel);
  final _FormKey = GlobalKey<FormState>();
  bool checkedValue=false;
  ValueNotifier<bool>checkvalue= ValueNotifier(false);
  bool limitexeed=false;
  bool fullpresent=false;

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers;
    controllers=List.generate(text.length, (index) => TextEditingController());
    List<Widget> list=[];
    List<String> controllerlist = [];

    for(int i=0;i<text.length;i++){
      list.add( Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('  Period '+ text[i].toString()+' :  '),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                  inputFormatters: [
                   FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
                   // FilteringTextInputFormatter.allow(RegExp(r"\d+([]\d+)?")),
                  ],
                decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (v){
                    if(v!=null){
                      checkvalue.value=false;
                    }
                  },
                  controller:controllers[i]
              ),
            ),
          ),
          SizedBox(height: 20,),

        ],
      )

      );

    }
    final firstwidget=list[0];
    list.remove(list[0]);


    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: checkvalue,

          builder: (BuildContext context, bool value, Widget? child) {
            if(value==true){
              for(int k=1;k<text.length;k++)
              {
                controllers[k].text=controllers[0].text;
              } }
            return ListView(
                children: [
                  firstwidget,
                  CheckboxListTile(
                    title: Text("select if attendance same for all periods."),
                    value: value,
                    onChanged: (newValue) {
                      {
                        checkvalue.value = newValue!;

                      }
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),
                  ...list,


                  Padding(
                    padding: const EdgeInsets.only(left: 150,right: 150),
                    child: ElevatedButton(onPressed: (){
                      controllerlist.clear();

                      for(int j=0;j<text.length;j++)
                      {
                        if(controllers[j].text.contains(',,')){}
                        else{
                          if(controllers[j].text.isNotEmpty){
                            final spilittedlcontroller= controllers[j].text.split(',');

                            controllerlist.addAll(spilittedlcontroller);

                          }
                        }


                      }



                      // List<int>controllerlist_int= controllerlist.map(int.parse).toList();
                     controllerlist.remove('');
                    controllerlist.remove('  ');
                     // print(controllerlist[1]);
                      validation(context,controllerlist);

                    }, child: Text('Add')),
                  ),
                ]
            );
          },
        ),),
    );
  }

  Future<void> validation(context, List<String> controllerlist) async {
    if (controllerlist.isNotEmpty)
    {
      List<int>controllerlist_int= controllerlist.map(int.parse).toList();
      for (var i in controllerlist_int) {
        //element.value=i;
        if (i>passingsubjectmodel.totalstrength) {
          limitexeed=true;
      }
  }
      if(limitexeed==true||controllerlist_int.contains(0)){
        await showDialog(context: context, builder: (context) {
          return AlertDialog(title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Text('error'),
                limitexeed==true?Text('Entered roll number exceeds the total strength'): Text('Remove Zero in attendence entry') ,
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text('Ok'))],),

          );
        });
      }
      else{
        print(controllerlist_int);
      }
    }

  }
}
