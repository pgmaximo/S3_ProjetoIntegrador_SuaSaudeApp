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

  // Generate dynamic options
  List<String> generateTimes() {
    List<String> times = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int min = 0; min < 60; min += 30) {
        String timeString = '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
        times.add(timeString);
      }
    }
    return times;
  }

  List<String> generatePeriods(int days) {
    return List.generate(days, (index) => '${index + 1} dias');
  }

  List<String> generateIntervals(int hours) {
    return List.generate(hours, (index) => '${index + 1}h');
  }

  String? horarioSelec;
  String? periodoSelec;
  String? intervaloSelec;

  List<String> horarios = [];
  List<String> periodos = [];
  List<String> intervalos = [];

  @override
  void initState() {
    super.initState();
    horarios = generateTimes();
    periodos = generatePeriods(365); 
    intervalos = generateIntervals(48); 

    medicamentoService.getMedicationNames().listen((names) {
      setState(() {
        nomeMedicamento = names;
      });
    }, onError: (error) {
      print("Ocorreu um erro ao carregar os nomes dos medicamentos: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Adicionar Medicamento', logout: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (nomeMedicamento.isNotEmpty) ...[
              DropdownButton<String>(
                value: medicamentoSelec,
                hint: const Text("Selecione um Medicamento"),
                onChanged: (String? newValue) {
                  setState(() {
                    medicamentoSelec = newValue;
                  });
                },
                items: nomeMedicamento.map<DropdownMenuItem<String>>((String name) {
                  return DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  );
                }).toList(),
              ),
              buildDropdown(title: "Horário", value: horarioSelec, items: horarios, onChanged: (value) {
                setState(() {
                  horarioSelec = value;
                });
              }),
              buildDropdown(title: "Período", value: periodoSelec, items: periodos, onChanged: (value) {
                setState(() {
                  periodoSelec = value;
                });
              }),
              buildDropdown(title: "Intervalo", value: intervaloSelec, items: intervalos, onChanged: (value) {
                setState(() {
                  intervaloSelec = value;
                });
              }),
            ] else ...[
              const CircularProgressIndicator(),
            ],
            Spacer(),
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const RemediosPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 25)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown({required String title, String? value, required List<String> items, required void Function(String?) onChanged}) {
    return ListTile(
      title: DropdownButton<String>(
        value: value,
        hint: Text(title),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
