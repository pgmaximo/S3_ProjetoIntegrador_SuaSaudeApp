import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ExameService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<String>> getExameNames() {
    // Stream para a coleção "Exames"
    Stream<List<String>> examesStream = _db.collection('Exames')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()['exame'] as String).toList());

    // Stream para a coleção "exames"
    Stream<List<String>> examesLowercaseStream = _db.collection('exames')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()['exame'] as String).toList());

    // Combina as duas streams em uma única stream e remove duplicatas
    return CombineLatestStream.combine2(
      examesStream,
      examesLowercaseStream,
      (List<String> exames, List<String> examesLowercase) {
        // Remove duplicatas
        final allExames = {...exames, ...examesLowercase}.toList();
        return allExames;
      },
    );
  }
}
