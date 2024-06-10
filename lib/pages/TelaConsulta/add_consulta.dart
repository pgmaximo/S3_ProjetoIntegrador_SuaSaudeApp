import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';
import 'package:teste_firebase/pages/TelaConsulta/specialty_consulta.dart';

class NovaConsulta extends StatefulWidget {
  final ConsultaHive? consulta;
  final String? especialidade;

  const NovaConsulta({super.key, this.consulta, this.especialidade});

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
  Uint8List? _imagemEmBytes;

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
    _especialistaController.text = widget.consulta?.especialista ?? widget.especialidade ?? '';
    _descricaoController.text = widget.consulta?.descricao ?? '';
    _retornoController.text = retornoSelecionado != null ? DateFormat('dd/MM/yyyy').format(retornoSelecionado!) : '';
    _lembreteController.text = widget.consulta?.lembrete ?? '';
    _imagemEmBytes = widget.consulta?.imagem;
    _updateDateTimeController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: "Nova Consulta", rota: '/specialty_consulta'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _especialistaController,
                decoration: const InputDecoration(labelText: 'Especialidade'),
                validator: (value) => value!.isEmpty ? 'Por favor, insira a especialidade' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _dateTimeController,
                decoration: const InputDecoration(labelText: 'Data e Horário'),
                onTap: _selectDateTime,
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'Por favor, insira a data e o horário' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Resumo da Consulta'),
                maxLines: 3,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _retornoController,
                decoration: const InputDecoration(labelText: 'Retorno em'),
                onTap: _selectReturnDate,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _lembreteController,
                decoration: const InputDecoration(labelText: 'Lembrete para agendamento'),
              ),
              const SizedBox(height: 40),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 123, 167, 150)),
                  fixedSize: WidgetStateProperty.all(const Size.fromWidth(100)),
                ),
                onPressed: _pickImage,
                child: const Text('Adicionar Foto da consulta', style: TextStyle(color: Colors.white)),
              ),
              _buildPreviewImagem(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 123, 167, 150),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SpecialtyConsulta(),
                    ),
                  );
                }
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveConsulta();
                }
              },
              child: const Text("Salvar",
                  style: TextStyle(color: Colors.white, fontSize: 25)),
            ),
          ],
        ),
      )
    );
  }

  void _selectReturnDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: retornoSelecionado ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        retornoSelecionado = picked;
        _retornoController.text = DateFormat('dd/MM/yyyy').format(picked);
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
    try {
      final box = await Hive.openBox<ConsultaHive>('consultasBox');

      final consulta = ConsultaHive(
        especialista: _especialistaController.text,
        data: dataSelecionada,
        horario: '${horarioSelecionado.hour}:${horarioSelecionado.minute}',
        descricao: _descricaoController.text,
        retorno: retornoSelecionado,
        lembrete: _lembreteController.text,
        imagem: _imagemEmBytes,
      );

      await box.add(consulta);
      SnackbarUtil.showSnackbar(context, 'Consulta criada com sucesso!'); // Usando o SnackbarUtil para sucesso
    } catch (e) {
      SnackbarUtil.showSnackbar(context, 'Erro ao criar a consulta!', isError: true); // Usando o SnackbarUtil para erro
    }
    
    Navigator.of(context).pushReplacementNamed(
      '/list_consulta',
      arguments: _especialistaController.text,
    );
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final image = await ImagePickerWeb.getImageAsBytes();
      if (image != null) {
        setState(() {
          _imagemEmBytes = image;
        });
      }
    } else {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final imageBytes = await pickedImage.readAsBytes();
        setState(() {
          _imagemEmBytes = imageBytes;
        });
      }
    }
  }
  

  Widget _buildPreviewImagem() {
    if (_imagemEmBytes != null) {
      return Column(
        children: [
          const SizedBox(height: 15),
          const Text('Imagem Selecionada:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Image.memory(_imagemEmBytes!, height: 200),
        ],
      );
    } else if (widget.consulta?.imagem != null) {
      return Column(
        children: [
          const SizedBox(height: 15),
          const Text('Imagem Selecionada:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Image.memory(widget.consulta!.imagem!, height: 200),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
