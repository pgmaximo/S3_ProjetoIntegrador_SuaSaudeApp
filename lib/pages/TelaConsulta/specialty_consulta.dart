import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:teste_firebase/pages/TelaConsulta/add_consulta.dart';
import 'package:teste_firebase/pages/TelaConsulta/list_consulta.dart';

class SpecialtyConsulta extends StatefulWidget {
  const SpecialtyConsulta({super.key});

  @override
  State<SpecialtyConsulta> createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<SpecialtyConsulta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Consultas Realizadas', rota: '/home'),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ConsultaHive>('consultasBox').listenable(),
        builder: (context, Box<ConsultaHive> box, _) {
          // Obter a lista de especialistas únicos
          Set<String> especialistas = box.values.map((consulta) => consulta.especialista).toSet();
          if (especialistas.isEmpty) {
            return const Center(child: Text("Nenhuma consulta adicionada."));
          }
          return ListView.builder(
            itemCount: especialistas.length,
            itemBuilder: (context, index) {
              String especialista = especialistas.elementAt(index);
              return BotaoCategoriaConsulta(
                especialista: especialista,
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NovaConsulta()));
          },
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}

class BotaoCategoriaConsulta extends StatelessWidget {
  final String especialista;

  const BotaoCategoriaConsulta({super.key, required this.especialista});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConsultaMarcadas(especialista: especialista)));
      },
      child: Container(
        width: size.width,
        height: 75,
        decoration: const BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(color: Colors.grey, width: 3.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(especialista,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}