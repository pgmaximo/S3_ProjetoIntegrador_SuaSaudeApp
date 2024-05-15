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
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: 'Consultas Realizadas', 
      ),

      body: const SingleChildScrollView(
        child: Column(
          children: [
            BotaoCategoriaConsulta() //Quero que seja um botão parecido com essa classe do category_consult, mas com um destino diferente (não sei se é possivel utilizar a mesma)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/new_consult');
          },
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.black,),
        ),
      ),
    );
  }
}