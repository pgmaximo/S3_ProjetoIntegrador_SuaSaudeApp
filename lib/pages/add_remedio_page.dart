import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/medicamento_hive.dart';
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
  List<String> nomeMedicamentoFiltrado = [];
  TextEditingController controleBusca = TextEditingController();

  List<String> horas = List.generate(
      48,
      (index) =>
          "${index ~/ 2}:${(index % 2 * 30).toString().padLeft(2, '0')}");
  List<String> periodos = List.generate(30, (index) => '${index + 1} dias');
  List<String> intervalos = List.generate(24, (index) => '${index + 1}h');

  String? horaSelec;
  String? periodoSelec;
  String? intervaloSelec;

  @override
  void initState() {
    super.initState();
    medicamentoService.getMedicationNames().listen((names) {
      setState(() {
        nomeMedicamento = names;
        nomeMedicamentoFiltrado = names;
        if (nomeMedicamento.isNotEmpty) {
          medicamentoSelec = nomeMedicamento.first;
        }
      });
    }, onError: (error) {
      print("Ocorreu um erro ao carregar os nomes dos medicamentos: $error");
    });

    controleBusca.addListener(() {
      filterSearchResults(controleBusca.text);
    });
  }

  void filterSearchResults(String query) {
    List<String> dummyListData = nomeMedicamento
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      nomeMedicamentoFiltrado = dummyListData;
      medicamentoSelec =
          dummyListData.contains(medicamentoSelec) ? medicamentoSelec : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const AppBarWidget(titulo: 'Adicionar Medicamento', logout: false),
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
                      items: nomeMedicamentoFiltrado
                          .map<DropdownMenuItem<String>>((String name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                    ),
                    buildDropdown("Horário", horaSelec, horas),
                    buildDropdown("Período", periodoSelec, periodos),
                    buildDropdown("Intervalo", intervaloSelec, intervalos),
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
                      MaterialPageRoute(
                          builder: (context) => const RemediosPage()),
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
                    saveMedicamento();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RemediosPage()),
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

  void saveMedicamento() async {
    final box = Hive.box<MedicamentoHive>('medicamentosBox');
    final novoMedicamento = MedicamentoHive(
        nome: medicamentoSelec ?? "Nome padrão",
        horario: horaSelec ?? "08:00",
        periodo: periodoSelec ?? "1 dia",
        intervalo: intervaloSelec ?? "1h");
    await box.add(novoMedicamento);

    // Opcional: Mostra um snackbar ou outro feedback
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicamento salvo com sucesso!")));
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
                horaSelec = newValue;
                break;
              case "Período":
                periodoSelec = newValue;
                break;
              case "Intervalo":
                intervaloSelec = newValue;
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
