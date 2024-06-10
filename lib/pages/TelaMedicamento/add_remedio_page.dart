import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/medicamento_hive.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';
import 'package:teste_firebase/pages/TelaMedicamento/remedios_page.dart';
import 'package:teste_firebase/services/medicamento_service.dart';
import 'package:teste_firebase/services/notification_service.dart';


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
  final NotificationService _notificationService = NotificationService(); // Inicializa o serviço de notificação


  TimeOfDay? horaSelec;
  DateTime? periodoSelec;
  int? horasIntervalo;
  int? minutosIntervalo;

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
      appBar: const AppBarWidget(
          titulo: 'Adicionar Medicamento',
          logout: false,
          rota: '/remedios_page'),
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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    ListTile(
                      title: Text(horaSelec == null
                          ? "Selecione o Horário"
                          : "Horário: ${horaSelec!.format(context)}"),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: horaSelec ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            horaSelec = pickedTime;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: Text(periodoSelec == null
                          ? "Selecione o Período "
                          : "Período: ${DateFormat('dd/MM/yyyy').format(periodoSelec!)}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: periodoSelec ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            periodoSelec = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: const Text("Selecione o Intervalo"),
                      subtitle: Row(
                        children: [
                          DropdownButton<int>(
                            value: horasIntervalo,
                            hint: const Text("Horas"),
                            items: List.generate(24, (index) => index)
                                .map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                horasIntervalo = newValue;
                              });
                            },
                          ),
                          const Text("  horas   "),
                          DropdownButton<int>(
                            value: minutosIntervalo,
                            hint: const Text("Minutos"),
                            items: List.generate(60, (index) => index)
                                .map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                minutosIntervalo = newValue;
                              });
                            },
                          ),
                          const Text("  minutos"),
                        ],
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
        horario: horaSelec != null ? horaSelec!.format(context) : "08:00",
        periodo: periodoSelec != null
            ? DateFormat('dd/MM/yyyy').format(periodoSelec!)
            : "1 dia",
        intervalo: horasIntervalo != null && minutosIntervalo != null
            ? "${horasIntervalo!}h ${minutosIntervalo!}m"
            : "1h");
    await box.add(novoMedicamento);

    // Agendar notificação recorrente
    if (horaSelec != null && periodoSelec != null && horasIntervalo != null && minutosIntervalo != null) {
      DateTime startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        horaSelec!.hour,
        horaSelec!.minute,
      );

      Duration interval = Duration(hours: horasIntervalo!, minutes: minutosIntervalo!);

      await _notificationService.showRepeatingNotification(
        id: box.length, // Usar o comprimento da caixa como ID único
        title: 'Hora de tomar o remédio',
        body: 'É hora de tomar o ${novoMedicamento.nome}',
        startTime: startTime,
        interval: interval,
        endTime: periodoSelec!,
      );
    }

    // Opcional: Mostra um snackbar ou outro feedback
    SnackbarUtil.showSnackbar(context, "Medicamento salvo com sucesso!");
  }
}
