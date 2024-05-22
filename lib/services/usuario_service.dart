import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Future<void> createUsuario(String pressao, String glicemia, String altura, double peso) async {
  //   final user = FirebaseAuth.instance.currentUser!;
  //   // final String email = user.email!;
  //   await _db.collection('Usuarios').doc(user.email).set({
  //     'pressao': pressao,
  //     'glicemia': glicemia,
  //     'altura': altura,
  //     'peso': peso
  //   });
  // }

  Future<void> setPressao(String pressao) async {
    final user = FirebaseAuth.instance.currentUser!;
    await _db
        .collection('Usuarios')
        .doc(user.email)
        .set({'pressao': pressao}, SetOptions(merge: true));
  }

  // Future<void> setListaPressao(String documentId, String pressao) async {
  //   await _db.collection('Usuarios').doc(documentId).update({
  //     'pressao': FieldValue.arrayUnion([
  //       {
  //         'pressao': pressao,
  //         'timestamp': FieldValue.serverTimestamp(),
  //       }
  //     ])
  //   });
  // }

  // Future<void> setListaPressao(String documentId, String pressao) async {
  //   DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

  //   // Adicionar a pressão ao array
  //   await docRef.update({
  //     'pressao': FieldValue.arrayUnion([pressao]),
  //     'lastUpdated': FieldValue.serverTimestamp(),  // Adicionar um timestamp ao documento
  //   });
  // }

  // Future<void> setListaPressao(String documentId, String pressao) async {
  //   DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

  //   // Adicionar a entrada de pressão com o timestamp
  //   Map<String, dynamic> pressaoEntry = {
  //     'pressao': pressao,
  //     'timestamp': null,
  //   };

  //   // Adicionar a entrada de pressão à lista
  //   await docRef.update({
  //     'pressao': FieldValue.arrayUnion([pressaoEntry]),
  //     'timestamp': FieldValue.serverTimestamp()
  //   });
  // }

  Future<void> setListaPressao(String documentId, String pressao) async {
    DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

    // Adiciona a entrada de pressão com DateTime.now()
    await docRef.update({
      'pressao': FieldValue.arrayUnion([
        {
          'pressao': pressao,
          'timestamp':
              DateTime.now().toIso8601String(), // Adiciona o timestamp local
        }
      ])
    });
  }

  Future<void> setNome(String nome) async {
    final user = FirebaseAuth.instance.currentUser!;
    await _db
        .collection('Usuarios')
        .doc(user.email)
        .set({'nome': nome}, SetOptions(merge: true));
  }

  Future<void> setGlicemia(String glicemia) async {
    final user = FirebaseAuth.instance.currentUser!;
    await _db
        .collection('Usuarios')
        .doc(user.email)
        .set({'glicemia': glicemia}, SetOptions(merge: true));
  }

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

  // Stream<String> getPressao(String documentID) {
  //   return _db
  //       .collection('Usuarios')
  //       .doc(documentID)
  //       .snapshots()
  //       .map((snapshot) => snapshot.data()?['pressao'] as String);
  // }

  Stream<String> getPressao(String documentID) {
    return _db
        .collection('Usuarios')
        .doc(documentID)
        .snapshots()
        .map((snapshot) {
      // lista com todos os registros
      List<dynamic> pressoes = snapshot.data()?['pressao'];

      // Verifica se há registros
      if (pressoes.isNotEmpty) {
        // Ordena os registros pelo timestamp
        pressoes.sort((a, b) {
          DateTime timeA = DateTime.parse(a['timestamp']);
          DateTime timeB = DateTime.parse(b['timestamp']);
          return timeB.compareTo(timeA);
        });

        // pressão do registro mais recente
        return pressoes.first['pressao'] as String;
      } else {
        return "sem dados de pressao";
      }
    });
  }

  // Stream<List<Map<String, dynamic>>> getListaPressao(String documentID) {
  //   return _db
  //       .collection('Usuarios')
  //       .doc(documentID)
  //       .snapshots()
  //       .map((snapshot) {
  //     var data = snapshot.data() as Map<String, dynamic>;
  //     var pressaoList = data['pressao'] as List<dynamic>?;
  //     if (pressaoList == null) return [];

  //     // Convert timestamp strings to DateTime objects
  //     pressaoList.forEach((entry) {
  //       entry['timestamp'] = DateTime.parse(entry['timestamp']);
  //     });

  //     // Sort the list by timestamp in descending order
  //     pressaoList.sort((a, b) =>
  //         (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

  //     // Convert timestamp back to string (if needed)
  //     pressaoList.forEach((entry) {
  //       entry['timestamp'] = (entry['timestamp'] as DateTime).toIso8601String();
  //     });

  //     return pressaoList.map((pressaoEntry) {
  //       return {
  //         'pressao': pressaoEntry['pressao'],
  //         'timestamp': pressaoEntry['timestamp'],
  //       };
  //     }).toList();
  //   });
  // }

  Stream<List<Map<String, dynamic>>> getListaPressao(String documentID) {
  return _db
      .collection('Usuarios')
      .doc(documentID)
      .snapshots()
      .map((snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    var pressaoList = data['pressao'] as List<dynamic>?;
    if (pressaoList == null) return [];

    // Convert timestamp strings to DateTime objects
    pressaoList.forEach((entry) {
      entry['timestamp'] = DateTime.parse(entry['timestamp']);
    });

    // Sort the list by timestamp in descending order
    pressaoList.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    // Convert timestamp back to string (if needed)
    pressaoList.forEach((entry) {
      entry['timestamp'] = (entry['timestamp'] as DateTime).toIso8601String();
    });

    // Classify blood pressure readings
    pressaoList.forEach((entry) {
      var pressao = entry['pressao'] as String;
      var parts = pressao.split('/');
      var sistolico = int.parse(parts[0]);
      var diastolico = int.parse(parts[1]);

      if (sistolico < 90 && diastolico < 60) {
        entry['classificacao'] = 'Pressao baixa';
      } else if (sistolico >= 90 && sistolico <= 120 && diastolico >= 60 && diastolico <= 80) {
        entry['classificacao'] = 'Ótima';
      } else if (sistolico > 120 && sistolico <= 129 && diastolico > 80 && diastolico <= 84) {
        entry['classificacao'] = 'Normal';
      } else if (sistolico >= 130 && sistolico <= 139 && diastolico >= 85 && diastolico <= 89) {
        entry['classificacao'] = 'Atenção';
      } else if (sistolico >= 140 && diastolico >= 90) {
        entry['classificacao'] = 'Alta';
      } else {
        entry['classificacao'] = 'Desconhecido';
      }
    });

    return pressaoList.map((pressaoEntry) {
      return {
        'pressao': pressaoEntry['pressao'],
        'timestamp': pressaoEntry['timestamp'],
        'classificacao': pressaoEntry['classificacao'],
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
