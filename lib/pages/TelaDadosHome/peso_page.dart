import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
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
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Peso em kg"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: alturaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Altura em cm",
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  double? peso = double.tryParse(pesoController.text);
                  await usuarioService.setPeso(user.email!, peso!);
                  String altura = alturaController.text;
                  if (!(altura == "")) {
                    await usuarioService.setAltura(altura);
                  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Aferições de Peso', rota: '/home'),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: usuarioService.getListaPeso(user.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
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
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Peso: ${pesoData['peso']} kg',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Data: ${pesoData['timestamp']}',
                  ),
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
            _addPeso();
          },
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}
