import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/page_button.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';
import 'package:teste_firebase/pages/TelaMedicamento/add_remedio_page.dart';
import 'package:teste_firebase/components/medicamento_hive.dart';
import 'package:intl/intl.dart'; // Adicione este pacote para formatação de data

class RemediosPage extends StatelessWidget {
  const RemediosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: 'Medicamentos',
        rota: '/home',
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<MedicamentoHive>('medicamentosBox').listenable(),
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
                    bool isExpired = false;

                    try {
                      DateTime periodo =
                          DateFormat('dd/MM/yyyy').parse(med.periodo);
                      if (DateTime.now().isAfter(periodo)) {
                        isExpired = true;
                      }
                    } catch (e){
                      //
                    }

                    return InkWell(
                      onLongPress: () {
                        // Confirmação de exclusão
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmar Exclusão", style: TextStyle(color: Colors.black)),
                              content: const Text(
                                  "Tem certeza que deseja excluir este medicamento?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    removeMedicamento(index);
                                    SnackbarUtil.showSnackbar(context, 'Medicamento removido com sucesso');
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
                        color: isExpired ? Colors.grey : null,
                        child: ListTile(
                          title: Text(med.nome),
                          subtitle: Text(
                              'Horário: ${med.horario}\nPeríodo: ${med.periodo}\nIntervalo: ${med.intervalo}'),
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
                                        "Tem certeza que deseja excluir este medicamento?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          removeMedicamento(index);
                                          SnackbarUtil.showSnackbar(context, 'Medicamento removido com sucesso');
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
                pagina: AddRemedioPage(),
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
