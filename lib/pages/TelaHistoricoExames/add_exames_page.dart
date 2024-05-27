import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/exames_hive.dart';
import 'package:teste_firebase/services/exames_service.dart';

class AddExamesPage extends StatefulWidget {
  const AddExamesPage({super.key});

  @override
  State<AddExamesPage> createState() => _AddExamesPageState();
}

class _AddExamesPageState extends State<AddExamesPage> {
  final ExameService exameService = ExameService();
  Exame? exameSelec;
  List<Exame> nomeExames = [];
  List<Exame> nomeExamesFiltrado = [];
  TextEditingController controleBusca = TextEditingController();
  DateTime? dataSelec;
  TextEditingController valorRefController = TextEditingController();
  TextEditingController resultadoController = TextEditingController();
  String comparacaoResultado = "";

  @override
  void initState() {
    super.initState();
    exameService.getExames().listen((exames) {
      setState(() {
        nomeExames = exames;
        nomeExamesFiltrado = exames;
        if (nomeExames.isNotEmpty) {
          exameSelec = nomeExames.first;
          valorRefController.text = exameSelec!.referencia;
        }
      });
    }, onError: (error) {
      print("Ocorreu um erro ao carregar os exames: $error");
    });

    controleBusca.addListener(() {
      filterSearchResults(controleBusca.text);
    });
  }

  void filterSearchResults(String query) {
    List<Exame> dummyListData = nomeExames
        .where((item) => item.exame.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      nomeExamesFiltrado = dummyListData;
      if (!dummyListData.contains(exameSelec)) {
        exameSelec = null;
        valorRefController.clear();
      }
    });
  }

  void saveExame() async {
    final box = Hive.box<ExamesHive>('examesBox');
    final novoExame = ExamesHive(
      exame: exameSelec?.exame ?? "Nome padrão",
      data: dataSelec != null ? DateFormat('dd/MM/yyyy').format(dataSelec!) : "Data não definida",
      valorRef: valorRefController.text,
      resultado: resultadoController.text,
    );
    await box.add(novoExame);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Exame salvo com sucesso!"))
    );

    Navigator.pushReplacementNamed(context, '/historico_exames_page');
  }

  void compararResultado() {
    if (exameSelec != null) {
      setState(() {
        comparacaoResultado = exameService.compareValues(valorRefController.text, resultadoController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: 'Adicionar Exame',
        rota: '/historico_exames_page',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controleBusca,
                      decoration: const InputDecoration(
                        labelText: 'Pesquisar Exame',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<Exame>(
                      value: exameSelec,
                      hint: const Text("Selecione um Exame"),
                      isExpanded: true,
                      onChanged: (Exame? newValue) {
                        setState(() {
                          exameSelec = newValue;
                          if (exameSelec != null) {
                            valorRefController.text = exameSelec!.referencia;
                          } else {
                            valorRefController.clear();
                          }
                        });
                      },
                      items: nomeExamesFiltrado
                          .map<DropdownMenuItem<Exame>>((Exame exame) {
                        return DropdownMenuItem<Exame>(
                          value: exame,
                          child: Text(exame.exame),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: Text(dataSelec == null
                          ? "Selecione a Data"
                          : "Data: ${DateFormat('dd/MM/yyyy').format(dataSelec!)}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: dataSelec ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dataSelec = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: valorRefController,
                      decoration: const InputDecoration(
                        labelText: 'Valor de Referência',
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: resultadoController,
                      decoration: const InputDecoration(
                        labelText: 'Resultado',
                      ),
                      onChanged: (text) => compararResultado(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      comparacaoResultado,
                      style: TextStyle(
                        color: comparacaoResultado.contains("dentro")
                            ? Colors.green
                            : comparacaoResultado.contains("acima")
                                ? Colors.red
                                : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                TextButton(
                  onPressed: saveExame,
                  child: const Text("Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
