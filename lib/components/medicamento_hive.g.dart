// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicamento_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicamentoHiveAdapter extends TypeAdapter<MedicamentoHive> {
  @override
  final int typeId = 0;

  @override
  MedicamentoHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicamentoHive(
      nome: fields[0] as String,
      horario: fields[1] as String,
      periodo: fields[2] as String,
      intervalo: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MedicamentoHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.horario)
      ..writeByte(2)
      ..write(obj.periodo)
      ..writeByte(3)
      ..write(obj.intervalo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicamentoHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
