import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';

class EditarConsulta extends StatefulWidget {
  final ConsultaHive consulta;
  final VoidCallback aoSalvar;

  const EditarConsulta({super.key, required this.consulta, required this.aoSalvar});

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
    _descricaoController.text = widget.consulta.descricao!;
    _retornoController.text = retornoSelecionado != null ? DateFormat('dd/MM/yyyy').format(retornoSelecionado!) : '';
    _lembreteController.text = widget.consulta.lembrete!;
    _imagemEmBytes = widget.consulta.imagem;
    _updateDateTimeController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titulo: "Edição da consulta",
        rota: '/list_consulta',
        arguments: widget.consulta.especialista,
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
                Navigator.pop(context);
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
    try {
      widget.consulta.especialista = _especialistaController.text;
      widget.consulta.data = dataSelecionada;
      widget.consulta.horario = '${horarioSelecionado.hour}:${horarioSelecionado.minute}';
      widget.consulta.descricao = _descricaoController.text;
      widget.consulta.retorno = retornoSelecionado;
      widget.consulta.lembrete = _lembreteController.text;
      widget.consulta.imagem = _imagemEmBytes;

      final box = await Hive.openBox<ConsultaHive>('consultasBox');
      await box.put(widget.consulta.key, widget.consulta);
      widget.aoSalvar();

      SnackbarUtil.showSnackbar(context, 'Consulta editada com sucesso!'); // Usando o SnackbarUtil para sucesso
    } catch (e) {
      SnackbarUtil.showSnackbar(context, 'Erro ao editar a consulta!', isError: true); // Usando o SnackbarUtil para erro
    }

    Navigator.of(context).pop();
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

  void _removerImagem() {
    _imagemEmBytes = null;
    setState(() {
      _imagemEmBytes = null;
    });
  }

  Widget _buildPreviewImagem() {
    return _imagemEmBytes != null
      ? Column(
        children: [
          Image.memory(
            _imagemEmBytes!,
            height: 300,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 123, 167, 150)),
              shape: WidgetStatePropertyAll(CircleBorder()),
            ),
            onPressed: _removerImagem,
            child: const Icon(Icons.delete, color: Colors.white, size: 24),
          ),
        ],
      )
      : const SizedBox();
  }
}