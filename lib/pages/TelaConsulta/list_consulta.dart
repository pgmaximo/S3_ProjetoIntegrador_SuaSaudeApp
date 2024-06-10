import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';
import 'package:teste_firebase/pages/TelaConsulta/add_consulta.dart';
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

          // Ordena a lista de consultas pela data em ordem decrescente
          consultasDoEspecialista.sort((a, b) => b.data.compareTo(a.data));

          if (consultasDoEspecialista.isEmpty) {
            return const Center(
              child: Text(
                "Nenhuma consulta encontrada para esta especialidade."
              )
            );
          }
          return ListView.builder(
            itemCount: consultasDoEspecialista.length,
            itemBuilder: (context, index) {
              ConsultaHive consulta = consultasDoEspecialista[index];
              bool isFutureConsulta = consulta.data.isAfter(DateTime.now());

              return InkWell(
                key: Key(consulta.key.toString()),
                onLongPress: () => _confirmDeleteDialog(context, consulta),
                child: Container(
                  child: ListTile(
                    title: Text(
                      '${isFutureConsulta ? 'Próxima consulta - ' : ''}${DateFormat('dd/MM/yyyy').format(consulta.data)}',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.black),
                      onPressed: () => _confirmDeleteDialog(context, consulta),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaConsulta(consulta: consulta),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 123, 167, 150),
        ),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NovaConsulta(especialidade: especialista),
              ),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _confirmDeleteDialog(BuildContext context, ConsultaHive consulta) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão", style: TextStyle(color: Colors.black)),
          content: const Text("Tem certeza que deseja excluir esta consulta?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                consulta.delete();
                SnackbarUtil.showSnackbar(context, 'Consulta removida com sucesso');
                Navigator.of(context).pop();
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
