import 'package:hive/hive.dart';
part 'medicamento_hive.g.dart';

@HiveType(typeId: 0)
class MedicamentoHive extends HiveObject {
  @HiveField(0)
  String nome;
  
  @HiveField(1)
  String horario;
  
  @HiveField(2)
  String periodo;
  
  @HiveField(3)
  String intervalo;

  MedicamentoHive({required this.nome, required this.horario, required this.periodo, required this.intervalo});
}
