import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

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
            children: [
              // Text(
              //   "logado como: ${user.email!}",
              //   style: const TextStyle(fontSize: 20),
              // ),
              const SizedBox(height: 20),
              // TESTE DE PAGINGA! FAVOR APAGAR QUANDO FOR FAZER A HOMEPAGE
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/consult_page');
                  },
                  child: const Text('Pagina de consulta')),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/remedios_page');
                  },
                  child: const Text('Pagina de remedio')),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/lerpdf_page');
                  },
                  child: const Text('TESTE PDF')),
            ],
          ),
        ));
  }
}
