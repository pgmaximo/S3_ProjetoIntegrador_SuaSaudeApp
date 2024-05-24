// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/services/usuario_service.dart';

class GlicemiaPage extends StatefulWidget {
  const GlicemiaPage({super.key});

  @override
  State<GlicemiaPage> createState() => _GlicemiaPageState();
}

class _GlicemiaPageState extends State<GlicemiaPage> {
  final UsuarioService usuarioService = UsuarioService();
  final user = FirebaseAuth.instance.currentUser!;

  Color _getClassificationColor(String classification) {
    switch (classification) {
      case 'Baixa':
        return Colors.blue;
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

  Future<void> _addGlicemia() async {
    TextEditingController controller = TextEditingController();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Inserir glicemia'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: "Glicemia (exemplo 80)"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String glicemia = controller.text;
                  await usuarioService.setGlicemia(user.email!, glicemia);
                  Navigator.of(context).pop();
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
        });
  }

  Future<void> _removeGlicemia(Map<String, dynamic> glicemiaData) async {
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
                        // debugPrint('Glicemia data: $glicemiaData');
                        await usuarioService.removeGlicemia(user.email!, glicemiaData);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Glicemia removido com sucesso')),
                        );
                      } catch (e) {
                        // debugPrint('Erro ao remover glicemia: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao remover glicemia')),
                        );
                      }
                    },
                    child: const Text('Remover')),
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
      appBar:
          const AppBarWidget(titulo: 'Aferições de Glicemia', rota: '/home'),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: usuarioService.getListaGlicemia(user.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhuma aferição de glicemia encontrada'));
          }

          List<Map<String, dynamic>> glicemiaList = snapshot.data!;

          return ListView.builder(
            itemCount: glicemiaList.length,
            itemBuilder: (context, index) {
              var glicemiaData = glicemiaList[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    '${glicemiaData['glicemia']}mg/dL',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Data: ${(glicemiaData['timestamp'] as DateTime).toIso8601String()}',
                  ),
                  trailing: Text(
                    '${glicemiaData['classification']}',
                    style: TextStyle(
                      color: _getClassificationColor(
                          glicemiaData['classification']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onLongPress: () async {
                    // print('Long press on: ${glicemiaData['glicemia']}');
                    try {
                      await _removeGlicemia(glicemiaData);
                      // print('Glicemia removed: ${glicemiaData['glicemia']}');
                    } catch (e) {
                      // print('Erro ao remover glicemia: $e');
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
          onPressed: () {
            _addGlicemia();
          },
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}
