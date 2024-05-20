import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/consulta_hive.dart';

class TelaConsulta extends StatelessWidget {
  final ConsultaHive consulta;

  const TelaConsulta({super.key, required this.consulta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: "Consulta Realizada", rota: '/specialty_consulta',),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildInfoField('Especialidade', consulta.especialista),
              _buildInfoField('Data', DateFormat('dd/MM/yyyy').format(consulta.data)),
              _buildInfoField('Horário', consulta.horario),
              const SizedBox(height: 16.0),
              const Text(
                'Resumo da Consulta',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(consulta.descricao),
              const SizedBox(height: 16.0),
              _buildInfoField('Retorno em:', consulta.retorno ?? ''),
              _buildInfoField('Lembrete para agendamento:', consulta.lembrete ?? ''),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
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
}