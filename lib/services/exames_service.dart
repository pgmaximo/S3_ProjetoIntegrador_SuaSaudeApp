import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ExameService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, String>>> getExameNamesWithReferences() {
    Stream<List<Map<String, String>>> examesStream = _db.collection('Exames')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        return {
          'exame': doc.data()['exame'] as String,
          'referencia': doc.data()['referencia'] as String
        };
      }).toList());

    Stream<List<Map<String, String>>> examesLowercaseStream = _db.collection('exames')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        return {
          'exame': doc.data()['exame'] as String,
          'referencia': doc.data()['referencia'] as String
        };
      }).toList());

    return CombineLatestStream.combine2(
      examesStream,
      examesLowercaseStream,
      (List<Map<String, String>> exames, List<Map<String, String>> examesLowercase) {
        final allExames = exames + examesLowercase;
        final uniqueExames = <String, String>{};

        for (var exame in allExames) {
          uniqueExames[exame['exame']!] = exame['referencia']!;
        }

        return uniqueExames.entries.map((entry) {
          return {
            'exame': entry.key,
            'referencia': entry.value,
          };
        }).toList();
      },
    );
  }

  String? extractNumericValue(String value) {
    final regex = RegExp(r'\d+(\.\d+)?');
    final match = regex.firstMatch(value);
    return match?.group(0);
  }

  String interpretExame(String referencia, String resultado) {
    final valorReferencia = double.tryParse(extractNumericValue(referencia) ?? '');
    final valorResultado = double.tryParse(resultado);

    if (valorReferencia == null || valorResultado == null) {
      return "Valores inválidos para comparação";
    }

    if (valorResultado < valorReferencia) {
      return "Resultado abaixo do normal";
    } else if (valorResultado > valorReferencia) {
      return "Resultado acima do normal";
    } else {
      return "Resultado dentro do normal";
    }
  }
}
