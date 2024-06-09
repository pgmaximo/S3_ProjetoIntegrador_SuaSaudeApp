import 'package:flutter/material.dart';

class ButtonPage extends StatelessWidget {
  final Icon icone; // Ícone é opcional, pode ser nulo
  final Widget pagina;
  final Color cor;

  const ButtonPage({
    super.key,
    required this.icone,
    required this.pagina,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 123, 167, 150),
        shape: BoxShape.circle, // Mantém o formato circular
      ),
      child: IconButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => pagina),
            (Route<dynamic> route) => false,
          );
        },
        icon: icone,
        color: cor,
      )
    );
  }
}
