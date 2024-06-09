import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:teste_firebase/pages/TelaConsulta/edit_consulta.dart';

class TelaConsulta extends StatefulWidget {
  final ConsultaHive consulta;

  const TelaConsulta({super.key, required this.consulta});

  @override
  State<TelaConsulta> createState() => _TelaConsultaState();

}

class _TelaConsultaState extends State<TelaConsulta> {
  late ConsultaHive consulta;

  void _atualizarConsulta() {
    setState(() {}); // Isso forçará a reconstrução do widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titulo: "Consulta",
        rota: '/list_consulta',
        arguments: widget.consulta.especialista,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 16),

            Row(
              children: [
                const Text(
                  'Consulta com o especialista ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  widget.consulta.especialista,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),

            const SizedBox(height: 5),

            Row(
              children: [
                const Text(
                  'Data: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(widget.consulta.data),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Horário: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatTime(widget.consulta.horario), // Chama a função para formatar
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            
            const SizedBox(height: 10),

            if (widget.consulta.descricao != null && widget.consulta.descricao!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumo da Consulta:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.consulta.descricao!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

            const SizedBox(height: 10),

            if (widget.consulta.retorno != null)
              Row(
                children: [
                  const Text(
                    'Retorno: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(widget.consulta.retorno!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

            const SizedBox(height: 5),

            widget.consulta.lembrete != null && widget.consulta.lembrete!.isNotEmpty
              ? Row(
                  children: [
                    const Text(
                      'Lembrete: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.consulta.lembrete!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
              : const SizedBox.shrink(),

            const SizedBox(height: 20),

            widget.consulta.imagem != null
              ? ElevatedButton(
                onPressed: () => _showImageDialog(context, widget.consulta.imagem!),
                style: const ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 123, 167, 150)),
                  fixedSize: WidgetStatePropertyAll(Size(30,20))
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, color: Colors.white, size: 26),
                    SizedBox(width: 5),
                    Text('Foto da consulta', style: TextStyle(color: Colors.white))
                  ],
                ),
                )
              : const SizedBox(),            
          ],
        )
      ),

      // Botao para editar informaçoes da consulta
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 123, 167, 150),
          ),
          child: IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarConsulta(
                    consulta: widget.consulta,  aoSalvar: _atualizarConsulta
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Função para formatar a string de horário
String _formatTime(String timeString) {
  // Divide a string em horas e minutos
List<String> parts = timeString.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  // Cria um objeto TimeOfDay
  TimeOfDay time = TimeOfDay(hour: hour, minute: minute);

  // Formata o TimeOfDay usando HourFormat
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

void _showImageDialog(BuildContext context, Uint8List imageBytes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.memory(
                  imageBytes,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}