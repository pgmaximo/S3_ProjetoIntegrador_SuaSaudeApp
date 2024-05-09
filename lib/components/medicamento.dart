class Medicamento {
  final String registro;
  final String nome;
  final String farmaco;
  final String concentracao;

  Medicamento(
      {required this.registro,
      required this.nome,
      required this.farmaco,
      required this.concentracao});

  factory Medicamento.fromFirestore(Map<String, dynamic> firestoreData) {
    return Medicamento(
      nome: firestoreData['Nome'] as String,
      farmaco: firestoreData['Farmaco'] as String,
      concentracao: firestoreData['Concentracao'] as String,
      registro: firestoreData['Registro'] as String,
    );
  }
}
