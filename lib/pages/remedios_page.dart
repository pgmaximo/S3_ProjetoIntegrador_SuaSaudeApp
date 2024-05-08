import 'package:flutter/material.dart';
import 'package:teste_firebase/components/button_page.dart';
import 'package:teste_firebase/pages/add_remedio_page.dart';

class RemediosPage extends StatelessWidget {
  const RemediosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Medicamentos", style: TextStyle(color: Colors.white, fontSize: 40))),
        backgroundColor: Colors.grey,
        ),
      body: const Column(
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
