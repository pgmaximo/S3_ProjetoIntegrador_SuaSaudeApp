import 'package:hive/hive.dart';

part 'exames_hive.g.dart';

@HiveType(typeId: 3)
class ExamesHive extends HiveObject {
  @HiveField(0)
  String exame;

  @HiveField(1)
  String data;

  @HiveField(2)
  String valorRef;

  @HiveField(3)
  String resultado;

  @HiveField(4)
  String? valorNumerico; // Novo campo

  ExamesHive({
    required this.exame,
    required this.data,
    required this.valorRef,
    required this.resultado,
    required this.valorNumerico, // Novo campo
  });
}
