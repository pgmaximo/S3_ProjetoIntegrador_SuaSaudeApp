import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:teste_firebase/components/bottom_appbar_widget.dart';
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
                      key: const Key("boasvindas"),
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
                          key: const Key("histPressaoButton"),
                          textoTitulo: "Ultima aferição de pressão",
                          documentId: user.email!,
                          campo: 'pressao',
                        ),

                        // quadrado Peso e altura
                        BoxInfo(
                          key: const Key("histPesoButton"),
                          textoTitulo: "Peso e altura",
                          documentId: user.email!,
                          campo: "altura",
                        ),
                      ]),

                  // coluna para exibir glicemia e IMC
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BoxInfo(
                          key: const Key("histGlicemiaButton"),
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
                      ]),
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
                              Navigator.pushNamed(
                                  context, '/specialty_consulta');
                            },
                            child: const Text('Consultas')),
                      ),
                      // const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/remedios_page');
                            },
                            child: const Text('Remédios')),
                      ),
                      // const SizedBox(height: 50,),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/historico_exames_page');
                            },
                            child: const Text('Exames')),
                      ),
                      // const SizedBox(height: 50,),
                      // Padding(
                      //   padding: const EdgeInsets.all(15.0),
                      //   child: ElevatedButton(
                      //       onPressed: () {
                      //         Navigator.pushNamed(context, '/lerpdf_page');
                      //       },
                      //       child: const Text('TESTE PDF')),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBarWidget(),
    );
  }
}
