// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/components/bottom_appbar_widget.dart';
import 'package:teste_firebase/components/my_button.dart';
import 'package:teste_firebase/components/my_textfield.dart';
import 'package:teste_firebase/components/square_tile.dart';
import 'package:teste_firebase/services/auth_service.dart';
import 'package:teste_firebase/services/usuario_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controllers
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign in
  void signUserUp() async {
    //circulo loading
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(color: Color.fromARGB(255, 123, 167, 150)),
          );
        });

    //cadastrar
    try {
      //checar senha == confirmacao
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        UsuarioService usuarioService = UsuarioService();
        usuarioService.setNome(nomeController.text);
        //tirar loading
        Navigator.pop(context);
      } else {
        //tirar loading
        Navigator.pop(context);
        //msg erro
        showErrorMessage("Senhas não coincidem");
      }
    } on FirebaseAuthException catch (e) {
      //tirar loading
      e.stackTrace;
      Navigator.pop(context);

      // popup erro
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // texto placeholder, mudar pra um logo depois
                const Text("YE Gestão de Saúde",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),

                const SizedBox(height: 50),

                //texto boas-vindas
                Text("Vamos criar sua conta!",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),
                const SizedBox(
                  height: 25,
                ),

                //nome textfield
                MyTextField(
                  controller: nomeController,
                  hintText: "Nome",
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                //user textfield
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                //pass textfield
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                //confirm pass textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm password",
                  obscureText: true,
                ),

                const SizedBox(height: 50),

                //botao login
                MyButton(onTap: signUserUp, text: "Cadastrar-se"),

                const SizedBox(height: 25),

                //texto outras formas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),

                      // texto
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("Outras formas",
                            style: TextStyle(color: Colors.grey[700])),
                      ),

                      // divider
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                //login google
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //google
                  SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imgPath: "lib/images/google_logo.png"),
                ]),

                const SizedBox(height: 50),

                //ainda nao cadastrado
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("Faça login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBarWidget(),
    );
  }
}
