import 'dart:async';

import 'package:attendance_calculator/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/subject_model.dart';

late Box<SubjectModel>subject_box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if(!Hive.isAdapterRegistered(1)){
    Hive.registerAdapter(SubjectModelAdapter());
  }
  subject_box=await Hive.openBox<SubjectModel>('name');
  //subject_box= await Hive.openBox<SubjectModel>('name');
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     home: SplashScreen(),
   );
  }
}
class SplashScreen extends StatefulWidget {


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
Timer(Duration(seconds: 3), (){
  Navigator.of(context).push(MaterialPageRoute(builder: (context){return HomeScreen();}));
});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(600)),
                child: Image.asset('assets/rj logo.jpg')),
          )),
    );
  }
}


