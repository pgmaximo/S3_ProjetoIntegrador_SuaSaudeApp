import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/box_info_home.dart';
import 'package:teste_firebase/services/usuario_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UsuarioService usuarioService = UsuarioService();
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> _showPesoAlturaInputDialog() async {
    TextEditingController pesoController = TextEditingController();
    TextEditingController alturaController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Inserir Peso e Altura'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Digite seu peso em kg",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: alturaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Digite sua altura em metros",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                double? peso = double.tryParse(pesoController.text);
                String altura = alturaController.text;

                if (peso != null) {
                  await usuarioService.setPesoAltura(altura, peso);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor, insira valores válidos para peso e altura.')),
                  );
                }
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(
          titulo: "Home Page",
          logout: true,
          rota: "",
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),

              //Text sera substituido por um texto que mostre o nome nao email
              Text(
                "logado como: ${user.email!}",
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 50),

              // row com 2 colunas para exibir as 4 informaçoes (pressao glicemia peso imc)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // quadrado pressao
                        BoxInfo(
                          textoTitulo: "Ultima aferição de pressão",
                          documentId: user.email!,
                          campo: 'pressao',
                        ),

                        // quadrado Peso e altura
                        BoxInfo(
                          textoTitulo: "Peso e altura",
                          documentId: user.email!,
                          campo: "altura",
                        ),
                      ]),

                  // coluna para exibir glicemia e IMC
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // quadrado glicemia
                        BoxInfo(
                            textoTitulo: "Ultima aferição de glicemia",
                            documentId: user.email!,
                            campo: "glicemia"),

                        // quadrado IMC
                        BoxInfo(
                            textoTitulo: "IMC",
                            documentId: user.email!,
                            campo: "IMC"),
                      ]),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/specialty_consulta');
                              },
                              child: const Text('Pagina de consulta')),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/remedios_page');
                              },
                              child: const Text('Pagina de remedio')),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/lerpdf_page');
                              },
                              child: const Text('TESTE PDF')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
