import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class TelaConsulta extends StatelessWidget {
  const TelaConsulta({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(titulo: "Tela da consulta"),
      body: Center(),
    );
  }
}