import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//App bar com o botão para o logout a ultima tela
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool logout;
  /*TRUE = HABILITA O LOGOUT (OU SEJA É TELA INICIAL) : FALSE = APENAS A SETA DE logout*/
  const AppBarWidget({super.key, required this.titulo, required this.logout});

  // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[700],
      title: Text (
        titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: logout ? signUserOut : () => Navigator.pop(context),
        icon: Icon(logout ? Icons.logout : Icons.arrow_back, color: Colors.white, ),
        style: const ButtonStyle(alignment: Alignment.center),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}