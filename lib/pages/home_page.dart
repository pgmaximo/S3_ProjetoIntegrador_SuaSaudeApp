import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        logout: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "logado como: ${user.email!}",
              // "logado como: " + user.email!,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // TESTE DE PAGINGA! FAVOR APAGAR QUANDO FOR FAZER A HOMEPAGE
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/consult_page');
              }, 
              child: const Text('Pagina de consulta')
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/remedios_page');
              }, 
              child: const Text('Pagina de remedio')
            )
          ],
        ),
      )
    );
  }
}
