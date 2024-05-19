// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consulta_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConsultaHiveAdapter extends TypeAdapter<ConsultaHive> {
  @override
  final int typeId = 1;

  @override
  ConsultaHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConsultaHive(
      especialista: fields[0] as String,
      data: fields[1] as DateTime,
      horario: fields[2] as String,
      descricao: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ConsultaHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.especialista)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.horario)
      ..writeByte(3)
      ..write(obj.descricao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsultaHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
