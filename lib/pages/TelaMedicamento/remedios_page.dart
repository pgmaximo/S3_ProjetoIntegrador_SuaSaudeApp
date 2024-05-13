import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/page_button.dart';
import 'package:teste_firebase/pages/TelaMedicamento/add_remedio_page.dart';
import 'package:teste_firebase/components/medicamento_hive.dart'; // Certifique-se de importar a classe Medicamento

class RemediosPage extends StatelessWidget {
  const RemediosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: 'Medicamentos'
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
                return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    MedicamentoHive med = box.getAt(index) as MedicamentoHive;
                    return ListTile(
                      title: Text(med.nome),
                      subtitle: Text('Horário: ${med.horario}, Período: ${med.periodo}, Intervalo: ${med.intervalo}'),
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
}
