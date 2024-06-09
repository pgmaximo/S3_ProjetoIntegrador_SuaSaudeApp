import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/exames_hive.dart';

class ExamesRealizadosPage extends StatelessWidget {
  final String exameTipo;

  const ExamesRealizadosPage({super.key, required this.exameTipo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: 'Exames Realizados', 
        rota: '/historico_exames_page',
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ExamesHive>('examesBox').listenable(),
        builder: (context, Box<ExamesHive> box, _) {
          // Filtra os exames pelo tipo selecionado
          final exames = box.values.where((exame) => exame.exame == exameTipo).toList();

          if (exames.isEmpty) {
            return const Center(
              child: Text("Nenhum exame realizado."),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Center(
                child: Text(
                  exameTipo,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 20),
              ...exames.map((exame) {
                return ListTile(
                  title: Row(
                    children: [
                      const Text('Data: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(exame.data, style: const TextStyle(fontSize: 16),)
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Referência: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(exame.valorRef, style: const TextStyle(fontSize: 12, color: Colors.black))
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Resultado: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(exame.resultado, style: const TextStyle(fontSize: 12, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
