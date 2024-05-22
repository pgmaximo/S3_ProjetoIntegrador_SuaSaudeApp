import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/page_button.dart';
import 'package:teste_firebase/pages/TelaMedicamento/add_remedio_page.dart';
import 'package:teste_firebase/components/medicamento_hive.dart';

class RemediosPage extends StatelessWidget {
  const RemediosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: 'Medicamentos',
        logout: false,
        rota: '/home'
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<MedicamentoHive>('medicamentosBox').listenable(),
              builder: (context, Box<MedicamentoHive> box, _) {
                if (box.values.isEmpty) {
                  return const Center(
                    child: Text("Nenhum medicamento adicionado."),
                  );
                }
                return ListView.separated(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    MedicamentoHive med = box.getAt(index) as MedicamentoHive;
                    return InkWell(
                      onLongPress: () {
                        // Confirmação de exclusão
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmar Exclusão"),
                              content: const Text("Tem certeza que deseja excluir este medicamento?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    removeMedicamento(index);
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
                        title: Text(med.nome),
                        subtitle: Text('Horário: ${med.horario}, Período: ${med.periodo}, Intervalo: ${med.intervalo}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Confirmação de exclusão
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar Exclusão"),
                                  content: const Text("Tem certeza que deseja excluir este medicamento?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        removeMedicamento(index);
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
                pagina: AddRemedioPage(),
                corFundo: Colors.grey,
                cor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void removeMedicamento(int index) {
    final box = Hive.box<MedicamentoHive>('medicamentosBox');
    box.deleteAt(index);
  }
}
