import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/itens_lista.dart';

class HistoricoPage extends StatefulWidget {
   const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  List<int> contador = [];
  List<ItemLista> items = []; // Use 'ItemLista' instead of 'Widget'

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AppBarWidget(
        titulo: "Histórico de exames"
      
      ),
      body: Center(
        child: Column(
          children: [

            // LISTA DE ITEMS COM A ATUALIZAÇÃO
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.only(top: 100.0),
                itemBuilder: (context, index) {
                  return items[index];
                },
              ),
            ),

            // BOTÃO DE ADICIONAR ITEM
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final newItem = ItemLista(
                    contador: contador.length,
                  );
                  items.add(newItem);
                  contador.add(contador.length);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                padding: const EdgeInsets.all(30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )
              ),
              child: const Text('Adicionar exame', style: TextStyle(color: Colors. white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 25),

            //BOTÃO DE VOLTAR PARA A HOME
            /*ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                padding: const EdgeInsets.all(30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Voltar para homepage', style: TextStyle(color: Colors. white, fontSize: 18, fontWeight: FontWeight.bold)),
            ), */

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}