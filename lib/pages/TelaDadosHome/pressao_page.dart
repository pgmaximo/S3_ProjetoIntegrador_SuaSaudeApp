// import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/services/usuario_service.dart';

class PressaoPage extends StatefulWidget {
  const PressaoPage({super.key});

  @override
  State<PressaoPage> createState() => _PressaoPageState();
}

class _PressaoPageState extends State<PressaoPage> {
  final UsuarioService usuarioService = UsuarioService();
  final user = FirebaseAuth.instance.currentUser!;

  Color _getClassificationColor(String classification) {
    switch (classification) {
      case 'Baixa':
        return Colors.blue;
      case 'Ótima':
        return const Color.fromARGB(255, 0, 252, 8);
      case 'Normal':
        return Colors.green;
      case 'Atenção':
        return Colors.orange;
      case 'Alta':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Future<void> _addPressao() async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Inserir pressao'),
          content: TextField(
            key: const Key("addPressaoField"),
            controller: controller,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(hintText: "Pressao (exemplo 12/8)"),
          ),
          actions: [
            TextButton(
              key: const Key("salvarButton"),
              onPressed: () async {
                String pressao = controller.text;
                try {
                  await usuarioService.setListaPressao(user.email!, pressao);
                  Navigator.of(context).pop();
                } catch (e) {
                  // debugPrint('Erro ao adicionar pressão: $e');
                }
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removePressao(Map<String, dynamic> pressaoData) async {
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
                        debugPrint('Removing pressure data: $pressaoData');
                        await usuarioService.removePressao(
                            user.email!, pressaoData);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Pressão removida com sucesso')),
                        );
                      } catch (e) {
                        debugPrint('Erro ao remover pressão: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Erro ao remover pressão')),
                        );
                      }
                    },
                    child: const Text('Remover', key: Key("removerPopup"))),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Aferições de Pressão', rota: '/home'),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: usuarioService.getListaPressao(user.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhuma aferição de pressão encontrada'));
          }

          List<Map<String, dynamic>> pressaoList = snapshot.data!;

          return ListView.builder(
            itemCount: pressaoList.length,
            itemBuilder: (context, index) {
              var pressaoData = pressaoList[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    key: Key("pressaoListText_$index"),
                    'Pressão: ${pressaoData['pressao']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Data: ${(pressaoData['timestamp'] as DateTime).toIso8601String()}',
                  ),
                  trailing: Text(
                    '${pressaoData['classification']}',
                    style: TextStyle(
                      color: _getClassificationColor(
                          pressaoData['classification']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onLongPress: () async {
                    try {
                      await _removePressao(pressaoData);
                    } catch (e) {
                      // Handle error
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24),
        child: FloatingActionButton(
          key: const Key("botaoAddPressao"),
          onPressed: () {
            _addPressao();
          },
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}
