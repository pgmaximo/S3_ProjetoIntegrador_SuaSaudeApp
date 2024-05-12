import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class ConsultaMarcadas extends StatefulWidget {
  const ConsultaMarcadas({super.key});

  @override
  State<ConsultaMarcadas> createState() => _ConsultaStateMarcadas();
}

class _ConsultaStateMarcadas extends State<ConsultaMarcadas> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(titulo: 'Consultas Marcadas'),

      body: Center(),
    );
  }
}