// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/components/bottom_appbar_widget.dart';
import 'package:teste_firebase/components/my_button.dart';
import 'package:teste_firebase/components/my_textfield.dart';
import 'package:teste_firebase/components/square_tile.dart';
import 'package:teste_firebase/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign in
  void signUserIn() async {
    //circulo loading
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(color: Color.fromARGB(255, 123, 167, 150)),
          );
        });

    //login
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //tirar loading
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //tirar loading
      e.stackTrace;
      Navigator.pop(context);

      // popup login errado
      showErrorMessage();
      // debugPrint("email/senha invalido");
    }
  }

  void showErrorMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Email/senha invalidos"),
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
                key: Key("tituloText"),
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),

                const SizedBox(height: 50),

                //texto boas-vindas
                Text("Bem-vindo!",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),

                const SizedBox(
                  height: 25,
                ),

                //user textfield
                MyTextField(
                  key: const Key("userfield"),
                  controller: emailController,
                  hintText: "email",
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                //pass textfield
                MyTextField(
                  key: const Key("passfield"),
                  controller: passwordController,
                  hintText: "password",
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // esqueceu senha
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Esqueceu a senha?",
                          style: TextStyle(
                            color: Colors.grey[700],
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //botao login
                MyButton(
                    key: const Key("botaologin"),
                    onTap: signUserIn,
                    text: "Login"
                  ),

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  //google
                  SquareTile(
                    key: const Key("logingoogle"),
                    onTap: () => AuthService().signInWithGoogle(),
                    imgPath: "lib/images/google_logo.png"
                  ),

                  // const SizedBox(width: 25),

                  //facebook
                  // SquareTile(
                  //   key: const Key("loginfacebook"),
                  //   onTap: () => {},
                  //   imgPath: "lib/images/facebook_logo.png",
                  // )
                  ]
                ),

                const SizedBox(height: 50),

                //Ainda nao cadastrado
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ainda não cadastrado?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      key: const Key("cadastrese"),
                      onTap: widget.onTap,
                      child: const Text("Cadastre-se agora",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )),
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
