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
  String? exameSelec;
  List<String> nomeExames = [];
  List<String> nomeExamesFiltrado = [];
  TextEditingController controleBusca = TextEditingController();
  DateTime? dataSelec;
  TextEditingController valorRefController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exameService.getExameNames().listen((names) {
      setState(() {
        nomeExames = names;
        nomeExamesFiltrado = names;
        if (nomeExames.isNotEmpty) {
          exameSelec = nomeExames.first;
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
    List<String> dummyListData = nomeExames
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      nomeExamesFiltrado = dummyListData;
      exameSelec = dummyListData.contains(exameSelec) ? exameSelec : null;
    });
  }

  void saveExame() async {
  final box = Hive.box<ExamesHive>('examesBox');
  final novoExame = ExamesHive(
    exame: exameSelec ?? "Nome padrão",
    data: dataSelec != null ? DateFormat('dd/MM/yyyy').format(dataSelec!) : "Data não definida",
    valorRef: valorRefController.text,
  );
  await box.add(novoExame);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Exame salvo com sucesso!"))
  );

  // Navega para a página de histórico de exames após salvar
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
                        });
                      },
                      items: nomeExamesFiltrado
                          .map<DropdownMenuItem<String>>((String name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
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

