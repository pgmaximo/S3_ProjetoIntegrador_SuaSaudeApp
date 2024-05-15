import 'package:flutter/material.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class NovaConsulta extends StatefulWidget {
  const NovaConsulta({super.key});

  @override
  State<NovaConsulta> createState() => _NovaConsultaState();
}

class _NovaConsultaState extends State<NovaConsulta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: "Nova Consulta"),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: ,
                      decoration: const InputDecoration(
                        labelText: 'Pesquisar Medicamento',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                    DropdownButton<String>(
                      value: ,
                      hint: const Text("Selecione um Medicamento"),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                        });
                      },
                      items: 
                          .map<DropdownMenuItem<String>>((String name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                    ),
                    buildDropdown("Horário", horaSelec, horas),
                    buildDropdown("Período", periodoSelec, periodos),
                    buildDropdown("Intervalo", intervaloSelec, intervalos),
                  ],
                ),
              ),
            ),
          ),
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
                      MaterialPageRoute(
                          builder: (context) => const ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text("Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}