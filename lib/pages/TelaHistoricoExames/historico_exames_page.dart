import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/itens_lista.dart';

class HistoricoExamesPage extends StatefulWidget {
  const HistoricoExamesPage({super.key});

  @override
  State<HistoricoExamesPage> createState() => _HistoricoExamesPageState();
}

class _HistoricoExamesPageState extends State<HistoricoExamesPage> {
  List<int> contador = [];
  List<ItemLista> items = []; 

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:  AppBarWidget(
        titulo: "Histórico de exames",
        logout: false,
        rota: '/home',

      ),
    );
  }
}