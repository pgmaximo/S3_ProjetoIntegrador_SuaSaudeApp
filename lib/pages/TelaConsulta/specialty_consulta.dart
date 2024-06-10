import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';
import 'package:teste_firebase/pages/TelaConsulta/add_consulta.dart';
import 'package:teste_firebase/pages/TelaConsulta/list_consulta.dart';
import 'package:teste_firebase/components/page_button.dart';  // Certifique-se de importar a classe ButtonPage

class SpecialtyConsulta extends StatefulWidget {
  const SpecialtyConsulta({super.key});

  @override
  State<SpecialtyConsulta> createState() => _SpecialtyConsulta();
}

class _SpecialtyConsulta extends State<SpecialtyConsulta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Especialidade das consultas', rota: '/home'),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
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
                    return InkWell(
                      onLongPress: () {
                        // Confirmação de exclusão
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmar Exclusão", style: TextStyle(color: Colors.black)),
                              content: const Text(
                                  "Tem certeza que deseja excluir todas as consultas deste especialista?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    removeEspecialista(especialista);
                                    SnackbarUtil.showSnackbar(context, 'Especilidade de consulta removida com sucesso');
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Excluir", style: TextStyle(color: Colors.black)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        child: ListTile(
                          title: Text(especialista, style: const TextStyle(color: Colors.black, fontSize: 20)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              // Confirmação de exclusão
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmar Exclusão", style: TextStyle(color: Colors.black)),
                                    content: const Text(
                                        "Tem certeza que deseja excluir todas as consultas deste especialista?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          removeEspecialista(especialista);
                                          SnackbarUtil.showSnackbar(context, 'Especilidade de consulta removida com sucesso');
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Excluir", style: TextStyle(color: Colors.black)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConsultaMarcadas(especialista: especialista)
                              )
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Center(
              child: ButtonPage(
                icone: Icon(Icons.add),
                pagina: NovaConsulta(),
                cor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void removeEspecialista(String especialista) {
    final box = Hive.box<ConsultaHive>('consultasBox');
    final consultaParaRemover = box.values.where((consulta) => consulta.especialista == especialista).toList();
    for (var consulta in consultaParaRemover) {
      consulta.delete();
    }
  }
}
