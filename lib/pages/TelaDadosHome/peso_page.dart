// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';
import 'package:teste_firebase/services/usuario_service.dart';

class PesoPage extends StatefulWidget {
  const PesoPage({super.key});

  @override
  State<PesoPage> createState() => _PesoPageState();
}

class _PesoPageState extends State<PesoPage> {
  final UsuarioService usuarioService = UsuarioService();
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> _addPeso() async {
    TextEditingController pesoController = TextEditingController();
    TextEditingController alturaController = TextEditingController();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Inserir Peso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  key: const Key("addPesoField"),
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Peso em kg"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: alturaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Altura em cm (vazio se nao for mudar)",
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                key: const Key("salvarButton"),
                onPressed: () async {
                  double? peso = double.tryParse(pesoController.text);
                  await usuarioService.setPeso(user.email!, peso!);
                  String altura = alturaController.text;
                  if (!(altura == "")) {
                    await usuarioService.setAltura(altura);
                  }
                  SnackbarUtil.showSnackbar(context, 'Peso salvo com sucesso!');
                  Navigator.of(context).pop();
                },
                child: const Text('Salvar', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        });
  }

  Future<void> _removePeso(Map<String, dynamic> pesoData) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Apagar registro'),
              content: const Text('Deseja excluir essa entrada?'),
              actions: [
                TextButton(
                    onPressed: () async {
                      try {
                        // debugPrint('Peso data: $pesoData');
                        await usuarioService.removePeso(user.email!, pesoData);
                        Navigator.of(context).pop();
                        SnackbarUtil.showSnackbar(context, 'Peso removido com sucesso');
                      } catch (e) {
                        // debugPrint('Erro ao remover peso: $e');
                        SnackbarUtil.showSnackbar(context, 'Erro ao remover peso', isError: true);
                      }
                    },
                    child: const Text('Remover', style: TextStyle(color: Colors.black))),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Aferições de Peso', rota: '/home'),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: usuarioService.getListaPeso(user.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 123, 167, 150)));
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Sem dados'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhuma aferição de peso encontrada'));
          }

          List<Map<String, dynamic>> pesoList = snapshot.data!;

          return ListView.builder(
            itemCount: pesoList.length,
            itemBuilder: (context, index) {
              var pesoData = pesoList[index];
              return Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    key: Key("pesoListText_$index"),
                    '${pesoData['peso']}kg',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Data: ${(pesoData['timestamp'] as DateTime).toIso8601String()}',
                  ),
                  onLongPress: () async {
                    // print('Long press on: ${pesoData['peso']}');
                    try {
                      await _removePeso(pesoData);
                      // print('Peso removed: ${pesoData['peso']}');
                    } catch (e) {
                      // print('Erro ao remover peso: $e');
                    }
                  },
                ),
              );
            },
          );
        },
      ),

      // Botão para criar nova info de Peso
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 123, 167, 150),
            shape: BoxShape.circle, // Mantém o formato circular
          ),
          child: IconButton(
            key: const Key("botaoAddPeso"),
            onPressed: () {
              _addPeso();
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
