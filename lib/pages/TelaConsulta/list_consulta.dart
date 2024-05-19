import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:teste_firebase/pages/TelaConsulta/detail_consulta.dart';

class ConsultaMarcadas extends StatelessWidget {
  final String especialista;

  const ConsultaMarcadas({super.key, required this.especialista});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titulo: 'Consultas - $especialista',
        rota: '/specialty_consulta',
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ConsultaHive>('consultasBox').listenable(),
        builder: (context, Box<ConsultaHive> box, _) {
          List<ConsultaHive> consultasDoEspecialista = box.values
              .where((consulta) => consulta.especialista == especialista)
              .toList();

          if (consultasDoEspecialista.isEmpty) {
            return const Center(
                child: Text(
                    "Nenhuma consulta encontrada para este especialista."));
          }
          return ListView.builder(
            itemCount: consultasDoEspecialista.length,
            itemBuilder: (context, index) {
              ConsultaHive consulta = consultasDoEspecialista[index];
              return BotaoListConsulta(consulta: consulta);
            },
          );
        },
      ),
    );
  }
}

class BotaoListConsulta extends StatelessWidget {
  final ConsultaHive consulta;
  const BotaoListConsulta({super.key, required this.consulta});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TelaConsulta(consulta: consulta)));
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
              Text(DateFormat('dd/MM/yyyy').format(consulta.data),
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}