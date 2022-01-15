
import 'package:hive_flutter/adapters.dart';
part 'subject_model.g.dart';

@HiveType(typeId: 1)
class SubjectModel{
  @HiveField(0)
  String subject;

  @HiveField(1)
  String dept;

  @HiveField(2)
  String semester;

  @HiveField(3)
  int totalstrength;

  @HiveField(4)
  String id;
  SubjectModel({required this.subject,required this.dept,required this.semester,required this.totalstrength,required this.id});
}