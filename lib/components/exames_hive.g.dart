// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exames_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamesHiveAdapter extends TypeAdapter<ExamesHive> {
  @override
  final int typeId = 2;

  @override
  ExamesHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamesHive(
      exame: fields[0] as String,
      data: fields[1] as String,
      valorRef: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExamesHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.exame)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.valorRef);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamesHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
