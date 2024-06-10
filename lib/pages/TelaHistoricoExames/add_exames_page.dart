import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/exames_hive.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';
import 'package:teste_firebase/services/exames_service.dart';

class AddExamesPage extends StatefulWidget {
  const AddExamesPage({super.key});

  @override
  State<AddExamesPage> createState() => _AddExamesPageState();
}

class _AddExamesPageState extends State<AddExamesPage> {
  final ExameService exameService = ExameService();
  String? exameSelec;
  String? valorRef;
  List<Map<String, String>> nomeExames = [];
  List<Map<String, String>> nomeExamesFiltrado = [];
  TextEditingController controleBusca = TextEditingController();
  DateTime? dataSelec;
  TextEditingController resultadoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exameService.getExameNamesWithReferences().listen((namesWithReferences) {
      setState(() {
        nomeExames = namesWithReferences;
        nomeExamesFiltrado = nomeExames;
        if (nomeExames.isNotEmpty) {
          exameSelec = nomeExames.first['exame'];
          valorRef = nomeExames.first['referencia'];
        }
      });
    }, onError: (error) {
      print("Ocorreu um erro ao carregar os nomes dos exames: $error");
    });

    controleBusca.addListener(() {
      filterSearchResults(controleBusca.text);
    });
  }

  void filterSearchResults(String query) {
    List<Map<String, String>> dummyListData = nomeExames
        .where((item) => item['exame']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      nomeExamesFiltrado = dummyListData;
      if (!dummyListData.any((item) => item['exame'] == exameSelec)) {
        exameSelec = null;
        valorRef = null;
      }
    });
  }

  void saveExame() async {
    final box = Hive.box<ExamesHive>('examesBox');
    final novoExame = ExamesHive(
      exame: exameSelec ?? "Nome padrão",
      data: dataSelec != null ? DateFormat('dd/MM/yyyy').format(dataSelec!) : "Data não definida",
      valorRef: valorRef ?? "Referência não definida",
      resultado: resultadoController.text,
      valorNumerico: ExameService().extractNumericValue(resultadoController.text) ?? '0',
    );
    await box.add(novoExame);

    SnackbarUtil.showSnackbar(context, "Exame salvo com sucesso!");
    Navigator.pushReplacementNamed(context, '/historico_exames_page');
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
                    DropdownButton<String>(
                      value: exameSelec,
                      hint: const Text("Selecione um Exame"),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          exameSelec = newValue;
                          valorRef = nomeExames
                              .firstWhere((item) => item['exame'] == newValue)['referencia'];
                        });
                      },
                      items: nomeExamesFiltrado
                          .map<DropdownMenuItem<String>>((Map<String, String> item) {
                        return DropdownMenuItem<String>(
                          value: item['exame'],
                          child: Text(item['exame']!),
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
                    Text(
                      "Valor de Referência: ${valorRef ?? 'Referência não definida'}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: resultadoController,
                      decoration: const InputDecoration(
                        labelText: 'Resultado',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            color: const Color.fromARGB(255, 123, 167, 150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/historico_exames_page');
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
