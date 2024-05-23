import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setNome(String nome) async {
    final user = FirebaseAuth.instance.currentUser!;
    await _db
        .collection('Usuarios')
        .doc(user.email)
        .set({'nome': nome}, SetOptions(merge: true));
  }

  Future<void> setListaPressao(String documentId, String pressao) async {
    DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

    // Função para classificar a pressão
    String classifyPressao(String pressao) {
      final parts = pressao.split('/');
      if (parts.length != 2) return 'Desconhecida';

      final sistolica = int.tryParse(parts[0]);
      final diastolica = int.tryParse(parts[1]);

      if (sistolica == null || diastolica == null) return 'Desconhecida';

      if (sistolica < 9 || diastolica < 6) return 'Pressao baixa';
      if (sistolica < 12 && diastolica < 8) return 'Ótima';
      if (sistolica < 13 && diastolica < 8.5) return 'Normal';
      if (sistolica < 14 && diastolica < 9) return 'Atenção';
      return 'Alta';
    }

    final classification = classifyPressao(pressao);

    // Adiciona a entrada de pressão com DateTime.now() e classificação
    await docRef.update({
      'pressao': FieldValue.arrayUnion([
        {
          'pressao': pressao,
          'timestamp':
              DateTime.now().toIso8601String(), // Adiciona o timestamp local
          'classification': classification,
        }
      ])
    });
  }

  Future<void> setGlicemia(String documentId, String glicemia) async {
    DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

    // Função para classificar a glicemia
    String classifyGlicemia(String glicemia) {

      final glicemiaInt = int.tryParse(glicemia);

      if (glicemiaInt == null) return 'Desconhecida';
      if (glicemiaInt < 70) return 'Baixa';
      if (glicemiaInt < 100) return 'Normal';
      if (glicemiaInt <= 126) return 'Atenção';
      return 'Alta';
    }

    final classification = classifyGlicemia(glicemia);

    // Adiciona a entrada de pressão com DateTime.now() e classificação
    await docRef.update({
      'glicemia': FieldValue.arrayUnion([
        {
          'glicemia': glicemia,
          'timestamp':
              DateTime.now().toIso8601String(), // Adiciona o timestamp local
          'classification': classification,
        }
      ])
    });
  }

  // Future<void> setGlicemia(String glicemia) async {
  //   final user = FirebaseAuth.instance.currentUser!;
  //   await _db
  //       .collection('Usuarios')
  //       .doc(user.email)
  //       .set({'glicemia': glicemia}, SetOptions(merge: true));
  // }

  Future<void> setAltura(String altura) async {
    final user = FirebaseAuth.instance.currentUser!;
    await _db
        .collection('Usuarios')
        .doc(user.email)
        .set({'altura': altura}, SetOptions(merge: true));
  }

  Future<void> setPesoAltura(String altura, double peso) async {
    final user = FirebaseAuth.instance.currentUser!;
    await _db.collection('Usuarios').doc(user.email).set({
      'altura': altura,
      'peso': peso,
    }, SetOptions(merge: true));
  }

  Future<void> setPeso(double peso) async {
    final user = FirebaseAuth.instance.currentUser!;
    await _db
        .collection('Usuarios')
        .doc(user.email)
        .set({'peso': peso}, SetOptions(merge: true));
  }

  Stream<String> getUltimaPressao(String documentID) {
    return _db
        .collection('Usuarios')
        .doc(documentID)
        .snapshots()
        .map((snapshot) {
      List<dynamic> pressoes = snapshot.data()?['pressao'];

      if (pressoes.isNotEmpty) {
        pressoes.sort((a, b) {
          DateTime timeA = DateTime.parse(a['timestamp']);
          DateTime timeB = DateTime.parse(b['timestamp']);
          return timeB.compareTo(timeA);
        });
        return "${pressoes.first['pressao'] as String}\n${pressoes.first['classification']}";
      } else {
        return "sem dados";
      }
    });
  }

  Stream<String> getUltimaGlicemia(String documentID) {
    return _db
        .collection('Usuarios')
        .doc(documentID)
        .snapshots()
        .map((snapshot) {
      List<dynamic> glicemias = snapshot.data()?['glicemia'];

      if (glicemias.isNotEmpty) {
        glicemias.sort((a, b) {
          DateTime timeA = DateTime.parse(a['timestamp']);
          DateTime timeB = DateTime.parse(b['timestamp']);
          return timeB.compareTo(timeA);
        });
        return "${glicemias.first['glicemia'] as String} mg/dL\n${glicemias.first['classification']}";
      } else {
        return "sem dados";
      }
    });
  }

  Stream<List<Map<String, dynamic>>> getListaPressao(String documentId) {
    return _db
        .collection('Usuarios')
        .doc(documentId)
        .snapshots()
        .map((snapshot) {
      var data = snapshot.data() as Map<String, dynamic>;
      var pressaoList = data['pressao'] as List<dynamic>?;

      if (pressaoList == null) return [];

      // Ordena a lista de pressões do mais recente para o mais antigo
      pressaoList.sort((a, b) {
        DateTime timestampA = DateTime.parse(a['timestamp']);
        DateTime timestampB = DateTime.parse(b['timestamp']);
        return timestampB.compareTo(timestampA); // Inverte a comparação
      });

      return pressaoList.map((pressaoEntry) {
        return {
          'pressao': pressaoEntry['pressao'],
          'timestamp': DateTime.parse(pressaoEntry['timestamp']),
          'classification': pressaoEntry['classification'],
        };
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getListaGlicemia(String documentId) {
    return _db
        .collection('Usuarios')
        .doc(documentId)
        .snapshots()
        .map((snapshot) {
      var data = snapshot.data() as Map<String, dynamic>;
      var glicemiaList = data['glicemia'] as List<dynamic>?;

      if (glicemiaList == null) return [];

      // Ordena a lista de pressões do mais recente para o mais antigo
      glicemiaList.sort((a, b) {
        DateTime timestampA = DateTime.parse(a['timestamp']);
        DateTime timestampB = DateTime.parse(b['timestamp']);
        return timestampB.compareTo(timestampA); // Inverte a comparação
      });

      return glicemiaList.map((glicemiaEntry) {
        return {
          'glicemia': glicemiaEntry['glicemia'],
          'timestamp': DateTime.parse(glicemiaEntry['timestamp']),
          'classification': glicemiaEntry['classification'],
        };
      }).toList();
    });
  }

  Stream<String> getNome(String documentID) {
    return _db
        .collection('Usuarios')
        .doc(documentID)
        .snapshots()
        .map((snapshot) => snapshot.data()?['nome'] as String);
  }

  Stream<String> getGlicemia(String documentId) {
    return _db
        .collection('Usuarios')
        .doc(documentId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['glicemia'] as String);
  }

  Stream<String> getAltura(String documentId) {
    return _db
        .collection('Usuarios')
        .doc(documentId)
        .snapshots()
        .map((snapshot) {
      String alturaCm = snapshot.data()?['altura'] as String;
      alturaCm = alturaCm.replaceAll('m', '');
      double? altura = double.tryParse(alturaCm);
      final alturaM = altura! / 100;
      return '${alturaM.toStringAsFixed(2)}m';
    });
  }

  Stream<String> getPeso(String documentId) {
    return _db
        .collection('Usuarios')
        .doc(documentId)
        .snapshots()
        .map((snapshot) => '${snapshot.data()?['peso'] as double} kg');
  }

  Stream<String> getPesoAltura(String documentId) {
    return Rx.combineLatest2(
      getAltura(documentId),
      getPeso(documentId),
      (String altura, String peso) {
        return 'Altura: $altura\nPeso: $peso';
      },
    );
  }

  Stream<String> getIMC(String documentId) {
    Stream<double> alturaStream = getAltura(documentId).map((alturaString) {
      alturaString = alturaString.replaceAll('m', '');
      double? altura = double.tryParse(alturaString);
      if (altura == null || altura <= 0) {
        throw Exception('Altura inválida');
      }
      return altura;
    });

    Stream<double> pesoStream = getPeso(documentId).map((pesoString) {
      pesoString = pesoString.replaceAll('kg', '');
      double? peso = double.tryParse(pesoString);
      if (peso == null || peso <= 0) {
        throw Exception('Altura inválida');
      }
      return peso;
    });

    return Rx.combineLatest2(alturaStream, pesoStream,
        (double altura, double peso) {
      double imc = peso / (altura * altura);
      String classificacao;

      if (imc < 18.5) {
        classificacao = 'Abaixo do peso';
      } else if (imc >= 18.5 && imc <= 24.9) {
        classificacao = 'Peso normal';
      } else if (imc >= 25 && imc <= 29.9) {
        classificacao = 'Sobrepeso';
      } else if (imc >= 30 && imc <= 34.9) {
        classificacao = 'Obesidade Grau 1';
      } else if (imc >= 35 && imc <= 39.9) {
        classificacao = 'Obesidade Grau 2';
      } else {
        classificacao = 'Obesidade Grau 3';
      }

      return '${imc.toStringAsFixed(2)} - $classificacao';
    });
  }
}
