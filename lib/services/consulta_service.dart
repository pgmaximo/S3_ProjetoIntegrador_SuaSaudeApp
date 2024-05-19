import 'package:hive/hive.dart';
import 'package:teste_firebase/components/consulta_hive.dart';

class ConsultaService {
  static const String _boxName = 'consultas';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ConsultaHiveAdapter());
    }
    await Hive.openBox<ConsultaHive>(_boxName);
  }

  Future<void> addConsulta(ConsultaHive consulta) async {
    final box = Hive.box<ConsultaHive>(_boxName);
    await box.add(consulta);
  }

  List<ConsultaHive> getConsultas() {
    final box = Hive.box<ConsultaHive>(_boxName);
    return box.values.toList();
  }

  List<ConsultaHive> getConsultasPorEspecialista(String especialista) {
    final box = Hive.box<ConsultaHive>(_boxName);
    return box.values
        .where((consulta) => consulta.especialista == especialista)
        .toList();
  }

  Future<void> updateConsulta(ConsultaHive consulta) async {
    final box = Hive.box<ConsultaHive>(_boxName);
    await box.put(consulta.key, consulta);
  }

  Future<void> deleteConsulta(ConsultaHive consulta) async {
    final box = Hive.box<ConsultaHive>(_boxName);
    await box.delete(consulta.key);
  }
}