import 'package:flutter/material.dart';
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
        appBar: AppBar(
          actions: [
            IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)),
          ],
        ),
        body: Center(
          child: Text(
            "logado como: ${user.email!}",
            // "logado como: " + user.email!,
            style: const TextStyle(fontSize: 20),
          ),
        ));
  }
}
