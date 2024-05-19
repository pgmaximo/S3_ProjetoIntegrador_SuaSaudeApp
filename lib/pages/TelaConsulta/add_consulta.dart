import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';

class NovaConsulta extends StatefulWidget {
  const NovaConsulta({super.key});

  @override
  State<NovaConsulta> createState() => _NovaConsultaState();
}

class _NovaConsultaState extends State<NovaConsulta> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _especialistaController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horarioController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _retornoController = TextEditingController();
  final TextEditingController _lembreteController = TextEditingController();

  DateTime dataSelecionada = DateTime.now();
  TimeOfDay horarioSelecionado = TimeOfDay.now();

  @override
  void dispose() {
    _especialistaController.dispose();
    _dataController.dispose();
    _horarioController.dispose();
    _descricaoController.dispose();
    _retornoController.dispose();
    _lembreteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: "Nova Consulta", rota: '/specialty_consulta',),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _especialistaController,
                  decoration: const InputDecoration(labelText: 'Especialidade'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a especialidade';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _dataController,
                  decoration: const InputDecoration(labelText: 'Data'),
                  onTap: () async {
                    DateTime? data = await showDatePicker(
                      context: context,
                      initialDate: dataSelecionada,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (data != null) {
                      setState(() {
                        dataSelecionada = data;
                        _dataController.text = DateFormat('dd/MM/yyyy').format(data);
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a data';
                    }
                  return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _horarioController,
                  decoration: const InputDecoration(labelText: 'Horário'),
                  onTap: () async {
                    TimeOfDay? horario = await showTimePicker(
                      context: context,
                      initialTime: horarioSelecionado,
                    );
                    if (horario != null) {
                      setState(() {
                        horarioSelecionado = horario;
                        _horarioController.text =
                            "${horario.hour}:${horario.minute.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o horário';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descricaoController,
                  decoration:
                      const InputDecoration(labelText: 'Resumo da Consulta'),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _retornoController,
                  decoration: const InputDecoration(labelText: 'Retorno em:'),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _lembreteController,
                  decoration: const InputDecoration(labelText: 'Lembrete para agendamento:'),
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveConsulta();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Salvar"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void saveConsulta() async {
    final box = await Hive.openBox<ConsultaHive>('consultasBox');
    final novaConsulta = ConsultaHive(
      especialista: _especialistaController.text,
      data: DateFormat('dd/MM/yyyy').parse(_dataController.text), // Formata a data
      horario: _horarioController.text,
      descricao: _descricaoController.text,
      retorno: _retornoController.text,
      lembrete: _lembreteController.text,
    );
    await box.add(novaConsulta);
    print("Consulta salva: $novaConsulta"); // Adicione esta linha para depurar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Consulta salva com sucesso!")));
  }
}