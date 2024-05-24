import 'package:flutter/material.dart';

class BottomAppBarWidget extends StatefulWidget {
  const BottomAppBarWidget({super.key});

  @override
  State<BottomAppBarWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 75,
      color: Colors.blueGrey[400], 
      elevation: 0,
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Sobre nós"),
                    content: const Text(
                        "Nós somos a Sua Saúde, um aplicativo desenvolvido para melhorar a gestão "
                        "da sua própria saúde e melhorar sua qualidade de vida. Aqui você pode colocar "
                        "lembretes de consultas, colocar um resumo delas, definir os horários de suas "
                        "medicações com facilidade, organizar os resultados de seus exames, bem como "
                        "armazenar uma cópia deles e muito mais"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Fechar"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Sobre nós",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
