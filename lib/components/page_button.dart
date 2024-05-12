import 'package:flutter/material.dart';

class ButtonPage extends StatelessWidget {
  final Color corFundo;
  final Icon icone; // Ícone é opcional, pode ser nulo
  final Widget pagina;
  final Color cor;

  const ButtonPage({
    super.key,
    required this.icone,
    required this.pagina,
    required this.corFundo,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: corFundo,
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
        ));
  }
}
