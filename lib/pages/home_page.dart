import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: "Home Page",
        voltar: false,
      ),
      body: Center(
        child: Text(
          "logado como: ${user.email!}",
          // "logado como: " + user.email!,
          style: const TextStyle(fontSize: 20),
        ),
      )
    );
  }
}