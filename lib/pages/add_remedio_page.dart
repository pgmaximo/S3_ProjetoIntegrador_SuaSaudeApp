import 'package:flutter/material.dart';
import 'package:teste_firebase/pages/remedios_page.dart';

class AddRemedioPage extends StatelessWidget {
  const AddRemedioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Medicamentos", style: TextStyle(color: Colors.white, fontSize: 40))),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const RemediosPage()),
                    (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text("Cancelar", style: TextStyle(color: Colors.white, fontSize: 25),)),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const RemediosPage()),
                    (Route<dynamic> route) => false,
                    );
                  }, 
                  child: const Text("Salvar", style: TextStyle(color: Colors.white, fontSize: 25)))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
