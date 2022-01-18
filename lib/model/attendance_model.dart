import 'package:hive_flutter/hive_flutter.dart';
part 'attendance_model.g.dart';

@HiveType(typeId: 2)
class AttendenceModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<int>rollnumberlist;

  @HiveField(2)
  final List<int> periods;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String subject;


  AttendenceModel(
      {required this.subject,required this.periods, required this.date, required this.id, required this.rollnumberlist,});

}