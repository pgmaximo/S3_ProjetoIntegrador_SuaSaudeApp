import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/page_button.dart';
import 'package:teste_firebase/pages/add_remedio_page.dart';

class RemediosPage extends StatelessWidget {
  const RemediosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(titulo: 'Medicamentos', logout: false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 7),
            child: Center(
              child: ButtonPage(icone: Icon(Icons.add), pagina: AddRemedioPage(), corFundo: Colors.grey, cor: Colors.white),
              ),
          ),
        ]
      )
    );
  }
}
