import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//App bar com o botão para o logout a ultima tela
class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String rota;
  final String titulo;
  final bool logout;
  /*FALSE (padrão) = Botão para voltar pagina | TRUE = Botão para logout*/
  const AppBarWidget({super.key, required this.titulo, this.logout = false, required this.rota});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[700],
      title: Text (
        widget.titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        key: const Key("appbarButton"),
        onPressed: widget.logout ? 
          signUserOut : 
          () => widget.rota == '/home' ?
            Navigator.pushNamed(context, '/auth_page'):
            Navigator.pushNamed(context, widget.rota),
        icon: Icon(widget.logout ? Icons.logout : Icons.arrow_back, color: Colors.white, ),
        style: const ButtonStyle(alignment: Alignment.center),
      ),
    );
  }

  // @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}