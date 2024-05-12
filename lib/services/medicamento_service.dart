import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste_firebase/components/medicamento.dart';

class MedicamentoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Medicamento>> getMedicamentos() {
    return _db.collection('Medicamentos')
      .snapshots()
      .map((snapshot) =>
        snapshot.docs.map((doc) => Medicamento.fromFirestore(doc.data())).toList());

  }

  // Em MedicamentoService
Stream<List<String>> getMedicationNames() {
  return _db.collection('Medicamentos')
    .snapshots()
    .map((snapshot) =>
      snapshot.docs.map((doc) => doc.data()['Nome'] as String).toList());
}

}
