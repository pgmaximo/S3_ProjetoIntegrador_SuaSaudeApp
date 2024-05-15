import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class SpecialtyConsulta extends StatefulWidget {
  const SpecialtyConsulta({super.key});

  @override
  State<SpecialtyConsulta> createState() => _ConsultPageState();
}

class _ConsultPageState extends State<SpecialtyConsulta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: 'Consultas Realizadas', 
      ),

      body: const SingleChildScrollView(
        child: Column(
          children: [
            // PRECISA ADICIONAR SISTEMA DE ADIÇÃO DE MAIS BOTOES DE CATEGARIAS
            BotaoCategoriaConsulta()
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

class BotaoCategoriaConsulta extends StatelessWidget {
  const BotaoCategoriaConsulta({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/view_consult');
      },
      child: Container(
        width: size.width,
        height: 75,
        decoration: const BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide(color: Colors.grey, width: 3.0)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribui os elementos com espaço entre eles
            children: [
              Text('EXEMPLO', style: TextStyle(color: Colors.black, fontSize: 20)),
              Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}