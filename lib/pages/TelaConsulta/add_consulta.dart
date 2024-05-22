import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';



class NovaConsulta extends StatefulWidget {
  final ConsultaHive? consulta;

  const NovaConsulta({Key? key, this.consulta}) : super(key: key);

  @override
  State<NovaConsulta> createState() => _NovaConsultaState();
}

class _NovaConsultaState extends State<NovaConsulta> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _especialistaController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _retornoController = TextEditingController();
  final TextEditingController _lembreteController = TextEditingController();

  late DateTime dataSelecionada;
  late TimeOfDay horarioSelecionado;
  late DateTime? retornoSelecionado;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dataSelecionada = widget.consulta?.data ?? now;
    horarioSelecionado = TimeOfDay(
      hour: widget.consulta?.data.hour ?? now.hour,
      minute: widget.consulta?.data.minute ?? now.minute,
    );
    retornoSelecionado = widget.consulta?.retorno;
    _especialistaController.text = widget.consulta?.especialista ?? '';
    _descricaoController.text = widget.consulta?.descricao ?? '';
    _retornoController.text = retornoSelecionado != null ? DateFormat('dd/MM/yyyy').format(retornoSelecionado!) : ''; // Inicializado corretamente
    _lembreteController.text = widget.consulta?.lembrete ?? '';
    _updateDateTimeController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: "Nova Consulta", rota: '/specialty_consulta'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _especialistaController,
                decoration: const InputDecoration(labelText: 'Especialidade'),
                validator: (value) => value!.isEmpty ? 'Por favor, insira a especialidade' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dateTimeController,
                decoration: const InputDecoration(labelText: 'Data e Horário'),
                onTap: _selectDateTime,
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'Por favor, insira a data e o horário' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Resumo da Consulta'),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _retornoController, // Alterado para o controller de retorno
                decoration: const InputDecoration(labelText: 'Retorno em'),
                onTap: _selectReturnDate, // Novo método para selecionar a data de retorno
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _lembreteController,
                decoration: const InputDecoration(labelText: 'Lembrete para agendamento'),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24),
        child: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _saveConsulta();
            }
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.save, color: Colors.black),
        ),
      ),
    );
  }

  void _selectReturnDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: retornoSelecionado ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        retornoSelecionado = picked;
        _retornoController.text = DateFormat('dd/MM/yyyy').format(picked); // Atualiza o controlador de retorno
      });
    }
  }

  void _selectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: horarioSelecionado,
      );
      if (pickedTime != null) {
        setState(() {
          dataSelecionada = DateTime(picked.year, picked.month, picked.day, pickedTime.hour, pickedTime.minute);
          horarioSelecionado = pickedTime;
          _updateDateTimeController();
        });
      }
    }
  }

  void _updateDateTimeController() {
    _dateTimeController.text = DateFormat('dd/MM/yyyy HH:mm').format(dataSelecionada);
  }

  void _saveConsulta() async {
    final box = await Hive.openBox<ConsultaHive>('consultasBox');

    final consulta = ConsultaHive(
      especialista: _especialistaController.text,
      data: dataSelecionada,
      horario: '${horarioSelecionado.hour}:${horarioSelecionado.minute}',
      descricao: _descricaoController.text,
      retorno: retornoSelecionado,
      lembrete: _lembreteController.text,
    );

    if (widget.consulta != null) {
      await box.put(widget.consulta!.key, consulta);
    } else {
      await box.add(consulta);
    }
    Navigator.of(context).pop();
  }

}
