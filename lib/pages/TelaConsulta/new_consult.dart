import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class NovaConsulta extends StatefulWidget {
  const NovaConsulta({super.key});

  @override
  State<NovaConsulta> createState() => _NovaConsultaState();
}

class _NovaConsultaState extends State<NovaConsulta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: "Nova Consulta", logout: false, rota:'/consult_page'),

      body: Column(
        children:  [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,

              decoration: InputDecoration(
                hintText: 'Categoria', // Nome da caixa como dica
                filled: true, // Preenchimento ativado
                fillColor: Colors.grey[200], // Cor do preenchimento
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25), // Borda arredondada
                  borderSide: BorderSide.none, // Sem borda visível
                ),
              ),
            ),
          ),
          // Padding( - DIA DA CONSULTA
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // COLOCAR PICKER DE DATA
          // ),
          // Padding( - HORA DA CONSULTA
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // COLOCAR PICKER DE HORA
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: TextField(
              minLines: 3,
              maxLines: 5,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Descrição da consulta', // Nome da caixa como dica
                filled: true, // Preenchimento ativado
                fillColor: Colors.grey[200], // Cor do preenchimento
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25), // Borda arredondada
                  borderSide: BorderSide.none, // Sem borda visível
                ),
              ),
            ),
          ),

          // Padding( - RETORNO
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // COLOCAR PICKER DE HORA e DATA 
          // ),

        ],
      ),
    );
  }
}