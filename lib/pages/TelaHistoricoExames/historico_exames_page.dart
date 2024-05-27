import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/page_button.dart';
import 'package:teste_firebase/components/exames_hive.dart';
import 'package:teste_firebase/pages/TelaHistoricoExames/add_exames_page.dart'; // Importe este pacote para formatação de data

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
                return ListView.separated(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    ExamesHive exame = box.getAt(index) as ExamesHive;

                    return InkWell(
                      onLongPress: () {
                        // Confirmação de exclusão
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmar Exclusão"),
                              content: const Text(
                                  "Tem certeza que deseja excluir este exame?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    removeExame(index);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Excluir"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ListTile(
                        title: Text(exame.exame),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data: ${exame.data}'),
                            Text('Valor de Referência: ${exame.valorRef}'),
                            Text('Resultado: ${exame.resultado}'),
                            _compararResultado(exame.valorRef, exame.resultado),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Confirmação de exclusão
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar Exclusão"),
                                  content: const Text(
                                      "Tem certeza que deseja excluir este exame?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        removeExame(index);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Excluir"),
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
            padding: EdgeInsets.only(bottom: 7),
            child: Center(
              child: ButtonPage(
                icone: Icon(Icons.add),
                pagina: AddExamesPage(),
                corFundo: Colors.grey,
                cor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void removeExame(int index) {
    final box = Hive.box<ExamesHive>('examesBox');
    box.deleteAt(index);
  }

  Widget _compararResultado(String valorRef, String resultado) {
    final resultadoDouble = double.tryParse(resultado);
    final valorRefDouble = double.tryParse(valorRef);

    if (resultadoDouble == null || valorRefDouble == null) {
      return const Text(
        'Valores inválidos para comparação.',
        style: TextStyle(color: Colors.red),
      );
    }

    if (resultadoDouble < valorRefDouble) {
      return const Text(
        'Resultado abaixo do valor de referência.',
        style: TextStyle(color: Colors.orange),
      );
    } else if (resultadoDouble > valorRefDouble) {
      return const Text(
        'Resultado acima do valor de referência.',
        style: TextStyle(color: Colors.red),
      );
    } else {
      return const Text(
        'Resultado dentro do valor de referência.',
        style: TextStyle(color: Colors.green),
      );
    }
  }
}
