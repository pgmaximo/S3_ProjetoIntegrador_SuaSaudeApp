class Exame {
  final String nome;

  Exame(
      {required this.nome});

  factory Exame.fromFirestore(Map<String, dynamic> firestoreData) {
    return Exame(
      nome: firestoreData['exame'] as String);
  }
}
