import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class ConsultPage extends StatefulWidget {
  const ConsultPage({super.key});

  @override
  State<ConsultPage> createState() => _ConsultPageState();
}

class _ConsultPageState extends State<ConsultPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        titulo: 'Pagina de consulta', 
        logout: false,
      ),

      body: Center(
        
      )

    );
  }
}