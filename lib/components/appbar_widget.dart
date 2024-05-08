import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


//App bar com o botão para o Voltar a ultima tela
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  final String titulo;
  final bool voltar; /*TRUE = A VOLTAR A ULTIMA PAGINA E FALSE = FAZER LOGOUT*/
  const AppBarWidget({super.key, required this.titulo, required this.voltar});

  // metodo de sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[850],
      title: Text(titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 40, color: Colors.white)),
      actions: [
        if (voltar)
          IconButton(
            onPressed: () {
              const BackButton();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        IconButton(
          onPressed: signUserOut,
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}