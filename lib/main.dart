import 'dart:async';

import 'package:attendance_calculator/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
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


