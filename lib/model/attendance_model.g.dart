// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendenceModelAdapter extends TypeAdapter<AttendenceModel> {
  @override
  final int typeId = 2;

  @override
  AttendenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendenceModel(
      subject: fields[4] as String,
      periods: (fields[2] as List).cast<int>(),
      date: fields[3] as DateTime,
      id: fields[0] as String,
      rollnumberlist: (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, AttendenceModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.rollnumberlist)
      ..writeByte(2)
      ..write(obj.periods)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.subject);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
