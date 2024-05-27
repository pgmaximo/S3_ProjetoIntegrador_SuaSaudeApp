import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class Exame {
  final String exame;
  final String referencia;

  Exame({required this.exame, required this.referencia});
}

class ExameService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Exame>> getExames() {
    Stream<List<Exame>> examesStream = _db.collection('Exames')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Exame(
            exame: doc.data()['exame'] as String,
            referencia: doc.data()['referencia'] as String,
        )).toList());

    Stream<List<Exame>> examesLowercaseStream = _db.collection('exames')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Exame(
            exame: doc.data()['exame'] as String,
            referencia: doc.data()['referencia'] as String,
        )).toList());

    return CombineLatestStream.combine2(
      examesStream,
      examesLowercaseStream,
      (List<Exame> exames, List<Exame> examesLowercase) {
        final allExames = {...exames, ...examesLowercase}.toList();
        return allExames;
      },
    );
  }

  int extractNumericValue(String valueString) {
    final numericString = valueString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numericString) ?? 0;
  }

  String compareValues(String referencia, String resultado) {
    final int referenciaValue = extractNumericValue(referencia);
    final int resultadoValue = extractNumericValue(resultado);

    if (resultadoValue < referenciaValue) {
      return 'Resultado abaixo do valor de referência.';
    } else if (resultadoValue > referenciaValue) {
      return 'Resultado acima do valor de referência.';
    } else {
      return 'Resultado dentro do valor de referência.';
    }
  }
}
