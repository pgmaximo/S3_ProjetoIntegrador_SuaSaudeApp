import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:hive/hive.dart';

class TelaConsulta extends StatefulWidget {
  final ConsultaHive consulta;

  const TelaConsulta({super.key, required this.consulta});

  @override
  State<TelaConsulta> createState() => _TelaConsultaState();
}

class _TelaConsultaState extends State<TelaConsulta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: "Consulta Realizada",
        rota: '/specialty_consulta',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildInfoField('Especialidade', widget.consulta.especialista),
              _buildInfoField('Data', DateFormat('dd/MM/yyyy').format(widget.consulta.data)),
              _buildInfoField('Horário', widget.consulta.horario),
              const SizedBox(height: 16.0),
              const Text(
                'Resumo da Consulta',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(widget.consulta.descricao),
              const SizedBox(height: 16.0),
              _buildInfoField('Retorno em', widget.consulta.retorno != null ? DateFormat('dd/MM/yyyy').format(widget.consulta.retorno!) : ''),
              _buildInfoField('Lembrete para agendamento', widget.consulta.lembrete ?? ''),
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
            // Confirmação de exclusão
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirmar Exclusão"),
                  content: const Text("Tem certeza que deseja excluir esta consulta?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _deleteConsulta(context);
                      },
                      child: const Text("Excluir"),
                    ),
                  ],
                );
              },
            );
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.delete, color: Colors.black,),

        )
      )
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteConsulta(BuildContext context) async {
    try {
      final box = await Hive.openBox<ConsultaHive>('consultasBox');
      await box.delete(widget.consulta.key);
      Navigator.of(context).pop(); // Fechar o diálogo de confirmação
      Navigator.of(context).pop(); // Voltar para a tela anterior
    } catch (e) {
      // Lidar com erros, se necessário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir consulta: $e')),
      );
    }
  }
}
