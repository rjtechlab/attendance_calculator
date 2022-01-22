import 'dart:async';

import 'package:attendance_calculator/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/attendance_model.dart';
import 'model/subject_model.dart';

late Box<SubjectModel>subject_box;
late Box<AttendenceModel>attendance_box;
ValueNotifier<bool> isemptycalculatebutton=ValueNotifier(true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if(!Hive.isAdapterRegistered(1)){
    Hive.registerAdapter(SubjectModelAdapter());
  }

  if(!Hive.isAdapterRegistered(2)){
    Hive.registerAdapter(AttendenceModelAdapter());
  }
  subject_box=await Hive.openBox<SubjectModel>('name');
  attendance_box=await Hive.openBox<AttendenceModel>('attendance');
  //attendance_box.clear();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     home: SplashScreen(),
     debugShowCheckedModeBanner: false,
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
Timer(Duration(seconds: 4), (){
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){ return HomeScreen();}), (route) => false);
});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(600)),
                child: Image.asset('assets/RJ1.jpg')),
          )),
    );
  }
}
