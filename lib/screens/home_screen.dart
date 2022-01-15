import 'package:attendance_calculator/screens/addsubject_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Subjects'),centerTitle: true,
      ),
      body: SafeArea(
          child: ListView.separated(
              itemBuilder: (context, index){
                return ListTile(title: Text('sub'),);
              },
              separatorBuilder:(context, index){
                return Divider();
              } ,
              itemCount: 10)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
       Navigator.of(context).push(MaterialPageRoute(builder: (context){return AddSubject();}));
        },
      child: Icon(Icons.add,size: 35,),
      ),
    );
  }
}
