import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'consulta_hive.g.dart';

@HiveType(typeId: 1) // Usando um ID diferente do MedicamentoHive
class ConsultaHive extends HiveObject {
  @HiveField(0)
  String especialista;

  @HiveField(1)
  DateTime data;

  @HiveField(2)
  String horario;

  @HiveField(3)
  String? descricao;

  @HiveField(4)
  DateTime? retorno;

  @HiveField(5)
  String? lembrete;

  @HiveField(6)
  Uint8List? imagem;

  ConsultaHive({
    required this.especialista,
    required this.data,
    required this.horario,
    this.descricao,
    this.retorno,
    this.lembrete,
    this.imagem,
  });
}
