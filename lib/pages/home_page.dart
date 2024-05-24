import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/box_info_home.dart';
import 'package:teste_firebase/services/usuario_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UsuarioService usuarioService = UsuarioService();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: "Home Page",
        logout: true,
        rota: "",
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),

              //Texto bem vindo com nome do usuario
              StreamBuilder<String?>(
                stream: usuarioService.getNome(user.email!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String displayName = snapshot.data ?? user.email!;
                    return Text(
                      "Bem vindo $displayName!",
                      style: const TextStyle(fontSize: 20),
                    );
                  }
                },
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
                    ],
                  ),

                  // coluna para exibir glicemia e IMC
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // quadrado glicemia
                      BoxInfo(
                        textoTitulo: "Ultima aferição de glicemia",
                        documentId: user.email!,
                        campo: "glicemia",
                      ),

                      // quadrado IMC
                      BoxInfo(
                        textoTitulo: "IMC",
                        documentId: user.email!,
                        campo: "IMC",
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/specialty_consulta');
                          },
                          child: const Text('Pagina de consulta'),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/remedios_page');
                          },
                          child: const Text('Pagina de remedio'),
                        ),
                      ),
                      // const SizedBox(height: 50,),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/lerpdf_page');
                          },
                          child: const Text('TESTE PDF'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Sobre nós"),
                    content: const Text(
                        "Nós somos a Sua Saúde, um aplicativo desenvolvido para melhorar a gestão "
                        "da sua própria saúde e melhorar sua qualidade de vida. Aqui você pode colocar "
                        "lembretes de consultas, colocar um resumo delas, definir os horários de suas "
                        "medicações com facilidade, organizar os resultados de seus exames, bem como "
                        "armazenar uma cópia deles e muito mais"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Fechar"),
                      ),
                    ],
                  );
                },
              );
            },
            child:
                const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                "Sobre nós",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
