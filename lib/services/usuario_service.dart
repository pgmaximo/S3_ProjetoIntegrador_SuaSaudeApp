import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:flutter/material.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //funçõs para nome

  Future<void> setNome(String nome) async {
    final user = FirebaseAuth.instance.currentUser!;
    await _db
        .collection('Usuarios')
        .doc(user.email)
        .set({'nome': nome}, SetOptions(merge: true));
  }

  Stream<String?> getNome(String documentId) {
    return _db
        .collection('Usuarios')
        .doc(documentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.data()?['nome'] as String?;
    });
  }

  // funções para pressao

  Future<void> setListaPressao(String documentId, String pressao) async {
    DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

    // Função para classificar a pressão
    String classifyPressao(String pressao) {
      final parts = pressao.split('/');
      if (parts.length != 2) return 'Desconhecida';

      final sistolica = int.tryParse(parts[0]);
      final diastolica = int.tryParse(parts[1]);

      if (sistolica == null || diastolica == null) return 'Desconhecida';

      if (sistolica < 9 || diastolica < 6) return 'Baixa';
      if (sistolica < 12 && diastolica < 8) return 'Ótima';
      if (sistolica < 13 && diastolica < 8.5) return 'Normal';
      if (sistolica < 14 && diastolica < 9) return 'Atenção';
      return 'Alta';
    }

    final classification = classifyPressao(pressao);
    // debugPrint('Classificação: $classification');

    try {
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
    } catch (e) {
      // cria o documento se ainda nao existir
      if (e is FirebaseException && e.code == 'not-found') {
        await docRef.set({
          'pressao': [
            {
              'pressao': pressao,
              'timestamp': DateTime.now()
                  .toIso8601String(), // Adiciona o timestamp local
              'classification': classification,
            }
          ]
        });
      } else {
        throw e;
      }
    }
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

  Future<void> removePressao(
      String documentId, Map<String, dynamic> pressaoData) async {
    // debugPrint('Removing pressure data: $pressaoData');
    DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

    try {
      pressaoData['timestamp'] =
          (pressaoData['timestamp'] as DateTime).toIso8601String();

      await docRef.update({
        'pressao': FieldValue.arrayRemove([
          {
            'pressao': pressaoData['pressao'],
            'timestamp': pressaoData['timestamp'],
            'classification': pressaoData['classification']
          }
        ])
      });
      // debugPrint('Pressão successfully removed');
    } catch (error) {
      // debugPrint('Erro ao remover pressão: $error');
    }
  }

  // funções para glicemia

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

    try {
      // Adiciona a entrada de glicemia com DateTime.now() e classificação
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
    } catch (e) {
      // criar documento se nao existir
      if (e is FirebaseException && e.code == 'not-found') {
        await docRef.set({
          'glicemia': [
            {
              'glicemia': glicemia,
              'timestamp': DateTime.now()
                  .toIso8601String(), // Adiciona o timestamp local
              'classification': classification,
            }
          ]
        });
      } else {
        throw e;
      }
    }
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
        return timestampB.compareTo(timestampA);
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

  Stream<String> getGlicemia(String documentId) {
    return _db
        .collection('Usuarios')
        .doc(documentId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['glicemia'] as String);
  }

  Future<void> removeGlicemia(
      String documentId, Map<String, dynamic> glicemiaData) async {
    // debugPrint('Removing glicemia data: $glicemiaData');
    DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

    try {
      // Ensure the timestamp is a string in ISO 8601 format
      glicemiaData['timestamp'] =
          (glicemiaData['timestamp'] as DateTime).toIso8601String();

      await docRef.update({
        'glicemia': FieldValue.arrayRemove([
          {
            'glicemia': glicemiaData['glicemia'],
            'timestamp': glicemiaData['timestamp'],
            'classification': glicemiaData['classification']
          }
        ])
      });
      // debugPrint('Glicemia successfully removed');
    } catch (error) {
      // debugPrint('Erro ao remover pressão: $error');
    }
  }

  //funções para altura e peso
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

  Future<void> setPeso(String documentId, double peso) async {
    DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

    try {
      // Adiciona a entrada de peso com DateTime.now()
      await docRef.update({
        'peso': FieldValue.arrayUnion([
          {
            'peso': peso,
            'timestamp':
                DateTime.now().toIso8601String(), // Adiciona o timestamp local
          }
        ])
      });
    } catch (e) {
      // cria o documento se ainda nao existir
      if (e is FirebaseException && e.code == 'not-found') {
        await docRef.set({
          'peso': [
            {
              'peso': peso,
              'timestamp': DateTime.now()
                  .toIso8601String(), // Adiciona o timestamp local
            }
          ]
        });
      } else {
        throw e;
      }
    }
  }

  Stream<String> getAltura(String documentId) {
    return _db
        .collection('Usuarios')
        .doc(documentId)
        .snapshots()
        .map((snapshot) {
      String alturaCm = snapshot.data()?['altura'] as String? ?? '';
      // debugPrint('Altura raw data: $alturaCm');

      alturaCm = alturaCm.replaceAll('m', '');
      double? altura = double.tryParse(alturaCm);
      if (altura == null) {
        return 'Sem dados';
      }

      final alturaM = altura / 100;
      String alturaStr = '${alturaM.toStringAsFixed(2)}m';
      // debugPrint('Parsed altura: $alturaStr');
      return alturaStr;
    });
  }

  Stream<String> getPesoAltura(String documentId) {
    return Rx.combineLatest2(
      getAltura(documentId),
      getUltimoPeso(documentId),
      (String altura, String peso) {
        String combinedStr = 'Altura: $altura\nPeso: $peso';
        // debugPrint('altura e peso: $combinedStr');
        return combinedStr;
      },
    );
  }

  Stream<String> getUltimoPeso(String documentID) {
    return _db
        .collection('Usuarios')
        .doc(documentID)
        .snapshots()
        .map((snapshot) {
      List<dynamic> pesos = snapshot.data()?['peso'] ?? [];
      // debugPrint('Pesos raw data: $pesos');

      if (pesos.isNotEmpty) {
        pesos.sort((a, b) {
          DateTime timeA = DateTime.parse(a['timestamp']);
          DateTime timeB = DateTime.parse(b['timestamp']);
          return timeB.compareTo(timeA);
        });

        String pesoStr = "${pesos.first['peso']} kg";
        // debugPrint('Latest peso: $pesoStr');
        return pesoStr;
      } else {
        return "sem dados";
      }
    });
  }

  Stream<List<Map<String, dynamic>>> getListaPeso(String documentId) {
    return _db
        .collection('Usuarios')
        .doc(documentId)
        .snapshots()
        .map((snapshot) {
      var data = snapshot.data() as Map<String, dynamic>;
      var pesoList = data['peso'] as List<dynamic>?;

      if (pesoList == null) return [];

      // Ordena a lista de pressões do mais recente para o mais antigo
      pesoList.sort((a, b) {
        DateTime timestampA = DateTime.parse(a['timestamp']);
        DateTime timestampB = DateTime.parse(b['timestamp']);
        return timestampB.compareTo(timestampA); // Inverte a comparação
      });

      return pesoList.map((pesoEntry) {
        return {
          'peso': pesoEntry['peso'],
          'timestamp': DateTime.parse(pesoEntry['timestamp']),
        };
      }).toList();
    });
  }

  Future<void> removePeso(
      String documentId, Map<String, dynamic> pesoData) async {
    // debugPrint('Removing peso data: $pesoData');
    DocumentReference docRef = _db.collection('Usuarios').doc(documentId);

    try {
      // Ensure the timestamp is a string in ISO 8601 format
      pesoData['timestamp'] =
          (pesoData['timestamp'] as DateTime).toIso8601String();

      await docRef.update({
        'peso': FieldValue.arrayRemove([
          {
            'peso': pesoData['peso'],
            'timestamp': pesoData['timestamp'],
          }
        ])
      });
      // debugPrint('Peso successfully removed');
    } catch (error) {
      // debugPrint('Erro ao remover pressão: $error');
    }
  }

  Stream<String> getIMC(String documentId) {
    Stream<double> alturaStream = getAltura(documentId).map((alturaString) {
      alturaString = alturaString.replaceAll('m', '').trim();
      double? altura = double.tryParse(alturaString);
      if (altura == null || altura <= 0) {
        throw Exception('Altura inválida');
      }
      return altura;
    });

    Stream<double> pesoStream = getUltimoPeso(documentId).map((pesoString) {
      pesoString = pesoString.replaceAll('kg', '').trim();
      double? peso = double.tryParse(pesoString);
      if (peso == null || peso <= 0) {
        throw Exception('Peso inválido');
      }
      return peso;
    });

    return Rx.combineLatest2(alturaStream, pesoStream,
        (double altura, double peso) {
      double imc = peso / (altura * altura);
      String classificacao;

      if (imc < 18.5) {
        classificacao = 'Abaixo do peso';
      } else if (imc >= 18.5 && imc < 25) {
        classificacao = 'Peso normal';
      } else if (imc >= 25 && imc < 30) {
        classificacao = 'Sobrepeso';
      } else if (imc >= 30 && imc < 35) {
        classificacao = 'Obesidade Grau 1';
      } else if (imc >= 35 && imc < 40) {
        classificacao = 'Obesidade Grau 2';
      } else {
        classificacao = 'Obesidade Grau 3';
      }

      return '${imc.toStringAsFixed(2)} - $classificacao';
    });
  }
}
