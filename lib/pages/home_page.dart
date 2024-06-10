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
        titulo: "Sua Saúde",
        logout: true,
        rota: "",
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150),

              //Texto bem vindo com nome do usuario
              StreamBuilder<String?>(
                stream: usuarioService.getNome(user.email!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Color.fromARGB(255, 123, 167, 150));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String displayName = snapshot.data ?? user.email!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text(
                            key: Key("boasvindas"),
                            "Bem vindo ",
                            style: TextStyle(fontSize: 24),
                          ),
                          Flexible(
                            child: Text(
                              displayName,
                              key: const Key("boasvindasNome"),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 50),

              // row com 2 colunas para exibir as 4 informaçoes (pressao glicemia peso imc)
              Wrap(
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
                    ]
                  ),

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
                    ]
                  ),
                ],
              ),

              const SizedBox(height: 50),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all(const Size.fromWidth(120)),
                          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return const Color.fromARGB(255, 123, 167, 150);
                            }
                            return Colors.grey[200]!;
                          }),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/specialty_consulta');
                        },
                        child: const Text('Consultas',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all(const Size.fromWidth(120)),
                            backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color.fromARGB(255, 123, 167, 150);
                              }
                              return Colors.grey[200]!;
                            }),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/remedios_page');
                          },
                          child: const Text('Remédios',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all(const Size.fromWidth(120)),
                            backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color.fromARGB(255, 123, 167, 150);
                              }
                              return Colors.grey[200]!;
                            }),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/historico_exames_page');
                          },
                          child: const Text('Exames',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ),
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
