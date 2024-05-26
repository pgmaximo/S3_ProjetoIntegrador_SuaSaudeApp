import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class ExamesRealizadosPage extends StatelessWidget {
  const ExamesRealizadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        titulo: 'Exames Realizados', 
        rota: '/historico_exames_page',
      
      ),
    );
  }
}