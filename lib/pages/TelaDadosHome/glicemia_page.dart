// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/snackbar_widget.dart';
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
              key: const Key("addGlicemiaField"),
              controller: controller,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: "Glicemia (exemplo 80)"),
            ),
            actions: [
              TextButton(
                key: const Key("salvarButton"),
                onPressed: () async {
                  String glicemia = controller.text;
                  await usuarioService.setGlicemia(user.email!, glicemia);
                  SnackbarUtil.showSnackbar(context, 'Glicemia salva com sucesso!');
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
                        SnackbarUtil.showSnackbar(context, 'Glicemia removida com sucesso');
                      } catch (e) {
                        // debugPrint('Erro ao remover glicemia: $e');
                        SnackbarUtil.showSnackbar(context, 'Erro ao remover glicemia', isError: true);
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
      appBar:
          const AppBarWidget(titulo: 'Aferições de Glicemia', rota: '/home'),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: usuarioService.getListaGlicemia(user.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 123, 167, 150)));
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Sem dados'));
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
                color: Colors.grey[200],
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    key: Key("glicemiaListText_$index"),
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
    
      // Botão para criar nova info de Glicemia
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 123, 167, 150),
            shape: BoxShape.circle, // Mantém o formato circular
          ),
          child: IconButton(
            key: const Key("botaoAddGlicemia"),
            onPressed: () {
              _addGlicemia();
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
