class Medicamento {
  final String nome;

  Medicamento(
      {required this.nome});

  factory Medicamento.fromFirestore(Map<String, dynamic> firestoreData) {
    return Medicamento(
      nome: firestoreData['Nome'] as String);
  }
}
