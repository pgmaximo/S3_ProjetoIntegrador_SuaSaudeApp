import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/pages/remedios_page.dart';
import 'package:teste_firebase/services/medicamento_service.dart';

class AddRemedioPage extends StatefulWidget {
  const AddRemedioPage({super.key});

  @override
  State<AddRemedioPage> createState() => _AddRemedioPageState();
}

class _AddRemedioPageState extends State<AddRemedioPage> {
  final MedicamentoService medicamentoService = MedicamentoService();
  String? medicamentoSelec;
  List<String> nomeMedicamento = [];
  List<String> filteredNomeMedicamento = [];
  TextEditingController searchController = TextEditingController();

  List<String> times = List.generate(48, (index) => "${index ~/ 2}:${(index % 2 * 30).toString().padLeft(2, '0')}");
  List<String> periods = List.generate(30, (index) => '${index + 1} dias');
  List<String> intervals = List.generate(24, (index) => '${index + 1}h');

  String? selectedTime;
  String? selectedPeriod;
  String? selectedInterval;

  @override
  void initState() {
    super.initState();
    medicamentoService.getMedicationNames().listen((names) {
      setState(() {
        nomeMedicamento = names;
        filteredNomeMedicamento = names;
        if (nomeMedicamento.isNotEmpty) {
          medicamentoSelec = nomeMedicamento.first;
        }
      });
    }, onError: (error) {
      print("Ocorreu um erro ao carregar os nomes dos medicamentos: $error");
    });

    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  void filterSearchResults(String query) {
    List<String> dummyListData = nomeMedicamento
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredNomeMedicamento = dummyListData;
      medicamentoSelec = dummyListData.contains(medicamentoSelec) ? medicamentoSelec : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Adicionar Medicamento', logout: false),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Pesquisar Medicamento',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                    DropdownButton<String>(
                      value: medicamentoSelec,
                      hint: const Text("Selecione um Medicamento"),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          medicamentoSelec = newValue;
                        });
                      },
                      items: filteredNomeMedicamento.map<DropdownMenuItem<String>>((String name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                    ),
                    buildDropdown("Horário", selectedTime, times),
                    buildDropdown("Período", selectedPeriod, periods),
                    buildDropdown("Intervalo", selectedInterval, intervals),
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const RemediosPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Implement save functionality or other actions here
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const RemediosPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
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

  Widget buildDropdown(String title, String? value, List<String> options) {
    return ListTile(
      title: DropdownButton<String>(
        value: value,
        hint: Text(title),
        isExpanded: true,
        onChanged: (String? newValue) {
          setState(() {
            switch (title) {
              case "Horário":
                selectedTime = newValue;
                break;
              case "Período":
                selectedPeriod = newValue;
                break;
              case "Intervalo":
                selectedInterval = newValue;
                break;
              default:
            }
          });
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
