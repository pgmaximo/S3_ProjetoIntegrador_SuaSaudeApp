import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/page_button.dart';
import 'package:teste_firebase/components/exames_hive.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';
import 'package:teste_firebase/pages/TelaHistoricoExames/add_exames_page.dart';
import 'package:teste_firebase/pages/TelaHistoricoExames/exames_realizados_page.dart';

class HistoricoExamesPage extends StatelessWidget {
  const HistoricoExamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: 'Histórico de Exames',
        rota: '/home',
      ),

      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<ExamesHive>('examesBox').listenable(),
              builder: (context, Box<ExamesHive> box, _) {
                if (box.values.isEmpty) {
                  return const Center(
                    child: Text("Nenhum exame realizado."),
                  );
                }

                // Agrupar exames por tipo
                final Map<String, List<ExamesHive>> examesPorTipo = {};
                for (var exame in box.values) {
                  if (examesPorTipo.containsKey(exame.exame)) {
                    examesPorTipo[exame.exame]!.add(exame);
                  } else {
                    examesPorTipo[exame.exame] = [exame];
                  }
                }

                final List<String> tiposExames = examesPorTipo.keys.toList();

                return ListView.separated(
                  itemCount: tiposExames.length,
                  itemBuilder: (context, index) {
                    String tipoExame = tiposExames[index];
                    return InkWell(
                      onTap: () {
                        // Navega para a ExamesRealizadosPage ao clicar em um exame
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamesRealizadosPage(
                              exameTipo: tipoExame,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        // Confirmação de exclusão
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmar Exclusão", style: TextStyle(color: Colors.black)),
                              content: const Text("Tem certeza que deseja excluir todos os exames deste tipo?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    removeExamesPorTipo(tipoExame);
                                    SnackbarUtil.showSnackbar(context, 'Exame removido com sucesso');
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Excluir", style: TextStyle(color: Colors.black)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ListTile(
                        title: Text(tipoExame),
                        subtitle: Text('Exames Realizados: ${examesPorTipo[tipoExame]!.length}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar Exclusão", style: TextStyle(color: Colors.black)),
                                  content: const Text("Tem certeza que deseja excluir todos os exames deste tipo?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        removeExamesPorTipo(tipoExame);
                                        SnackbarUtil.showSnackbar(context, 'Exame removido com sucesso');
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
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1,
                      height: 1,
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
                pagina: AddExamesPage(),
                cor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void removeExamesPorTipo(String tipoExame) {
    final box = Hive.box<ExamesHive>('examesBox');
    final examesParaRemover = box.values.where((exame) => exame.exame == tipoExame).toList();
    for (var exame in examesParaRemover) {
      box.delete(exame.key);
    }
  }
}
