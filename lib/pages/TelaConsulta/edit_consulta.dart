import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';

class EditarConsulta extends StatefulWidget {
  final ConsultaHive consulta;
  final VoidCallback aoSalvar; 

  const EditarConsulta({super.key, required this.consulta, required this.aoSalvar,});

  @override
  State<EditarConsulta> createState() => _EditarConsultaState();
}

class _EditarConsultaState extends State<EditarConsulta> {
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
    dataSelecionada = widget.consulta.data;
    horarioSelecionado = TimeOfDay(
      hour: widget.consulta.data.hour,
      minute: widget.consulta.data.minute,
    );
    retornoSelecionado = widget.consulta.retorno;
    _especialistaController.text = widget.consulta.especialista;
    _descricaoController.text = widget.consulta.descricao ?? '';
    _retornoController.text = retornoSelecionado != null ? DateFormat('dd/MM/yyyy').format(retornoSelecionado!) : '';
    _lembreteController.text = widget.consulta.lembrete ?? '';
    _imagemEmBytes = widget.consulta.imagem;
    _updateDateTimeController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titulo: "Editar Consulta", 
        rota: '/detail_consulta',
        arguments: widget.consulta,
      ),
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
                readOnly: true,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _lembreteController,
                decoration: const InputDecoration(labelText: 'Lembrete para agendamento'),
              ),

              const SizedBox(height: 50),
              _buildSelectImageButton(),
              const SizedBox(height: 25),
              _buildPreviewImagem(),
            ]
          ),
        ),
      ),

      // Botão de salvar a consulta
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 123, 167, 150),
          ),
          child: IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveConsulta();
              }
            },
            icon: const Icon(Icons.save, color: Colors.white, size: 22),
          ),
        ),
      ),
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

    widget.consulta.especialista = _especialistaController.text;
    widget.consulta.data = dataSelecionada;
    widget.consulta.horario = '${horarioSelecionado.hour}:${horarioSelecionado.minute}';
    widget.consulta.descricao = _descricaoController.text;
    widget.consulta.retorno = retornoSelecionado;
    widget.consulta.lembrete = _lembreteController.text;
    widget.consulta.imagem = _imagemEmBytes;

    widget.aoSalvar(); 
    Navigator.of(context).pop();
  }

  Future<Uint8List?> pickImage() async {
    if (kIsWeb) {
      final image = await ImagePickerWeb.getImageAsBytes();
      return image;
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        return await File(pickedFile.path).readAsBytes();
      }
    }
    return null;
  }

  Widget _buildSelectImageButton() {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 123, 167, 150)),
      ),
      onPressed: () {
        _pickImage();
        _buildPreviewImagem();
      },
      child: const Text('Adicione uma foto da consulta', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildPreviewImagem() {
    return _imagemEmBytes != null
      ? Column(
        children: [
          Image.memory(
            _imagemEmBytes!,
            height: 150,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 123, 167, 150)),

            ),
            onPressed: _removerImagem,
            child: const Icon(Icons.delete, color: Colors.white,),
          ),
        ],
      )
      : const SizedBox();
  }

  void _removerImagem() {
    _imagemEmBytes = null;
    setState(() {
      _imagemEmBytes = null;
    });
  }

  Future<void> _pickImage() async {
    _imagemEmBytes = await pickImage();
    setState(() {}); 
  }
}
