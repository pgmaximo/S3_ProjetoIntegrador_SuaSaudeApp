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

  Stream<String> getPressao(String documentID) {
    return _db
        .collection('Usuarios')
        .doc(documentID)
        .snapshots()
        .map((snapshot) => snapshot.data()?['pressao'] as String);
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
        .map((snapshot) => '${snapshot.data()?['altura'] as String}m');
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
      } else if (imc >= 18.5 && imc < 24.9) {
        classificacao = 'Peso normal';
      } else if (imc >= 25 && imc < 29.9) {
        classificacao = 'Sobrepeso';
      } else if (imc >= 30 && imc < 34.9) {
        classificacao = 'Obesidade Grau 1';
      } else if (imc >= 35 && imc < 39.9) {
        classificacao = 'Obesidade Grau 2';
      } else {
        classificacao = 'Obesidade Grau 3';
      }

      return '${imc.toStringAsFixed(2)} - $classificacao';
    });
  }
}
