import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/pages/home_page.dart';
import 'package:teste_firebase/pages/TelaCadastro/login_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              //usuario logado
              if (snapshot.hasData) {
                return const HomePage();
              } 
              
              //usuario nao logado
              else {
                return const LoginRegisterPage();
              }
            }
        )
    );
  }
}

