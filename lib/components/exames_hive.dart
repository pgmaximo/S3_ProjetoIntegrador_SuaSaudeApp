import 'package:hive/hive.dart';
part 'exames_hive.g.dart';
@HiveType(typeId: 2) // Usando um ID diferente do MedicamentoHive (2)
class ExamesHive extends HiveObject {
  @HiveField(0)
  String exame;

  @HiveField(1)
  String data;

  @HiveField(2)
  String valorRef;


  ExamesHive({
    required this.exame,
    required this.data,
    required this.valorRef,

  });
}