import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/services/usuario_service.dart';

class BoxInfo extends StatefulWidget {
  final String textoTitulo;
  final String documentId;
  final String campo;

  const BoxInfo({
    super.key,
    required this.textoTitulo,
    required this.documentId,
    required this.campo,
  });

  @override
  State<BoxInfo> createState() => _BoxInfoState();
}

class _BoxInfoState extends State<BoxInfo> {
  Future<void> _showInputDialog(String campo) async {
    TextEditingController pesoController = TextEditingController();
    TextEditingController alturaController = TextEditingController();
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        switch (campo) {
          case 'altura':
            return AlertDialog(
              title: const Text('Inserir Peso e Altura'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: pesoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Digite seu peso em kg",
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: alturaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Digite sua altura em metros",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    double? peso = double.tryParse(pesoController.text);
                    String altura = alturaController.text;

                    if (peso != null) {
                      await usuarioService.setPesoAltura(altura, peso);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Por favor, insira valores válidos para peso e altura.')),
                      );
                    }
                  },
                  child: Text('Salvar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
              ],
            );

          case 'pressao':
            return AlertDialog(
              title: const Text('Inserir pressao'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Digite sua pressao (por exemplo, 12/8)"),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    String pressao = controller.text;
                    await usuarioService.setPressao(pressao);
                    Navigator.of(context).pop();
                  },
                  child: Text('Salvar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
              ],
            );

          case 'glicemia':
            return AlertDialog(
              title: const Text('Inserir glicemia'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: "Digite sua glicemia"),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    String glicemia = controller.text;
                    await usuarioService.setGlicemia(glicemia);
                    Navigator.of(context).pop();
                  },
                  child: Text('Salvar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
              ],
            );
          default:
            return AlertDialog(
              title: Text('IMC'),
              content: Text('Defina o campo IMC preenchendo altura e peso'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
        }
      },
    );
  }

  final UsuarioService usuarioService = UsuarioService();

  Stream<String> _getCampoStream(String documentId, String campo) {
    switch (campo) {
      case 'pressao':
        return usuarioService.getPressao(documentId);
      case 'glicemia':
        return usuarioService.getGlicemia(documentId);
      case 'altura':
        return usuarioService.getPesoAltura(documentId);
      // return usuarioService.getAltura(documentId);
      case 'IMC':
        return usuarioService.getIMC(documentId);
      default:
        throw ArgumentError('Campo desconhecido: $campo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
            //ontap vai redirecionar pra uma pagina para adicionar a pressão que tem o historico de aferiçoes
            onTap: () => _showInputDialog(widget.campo),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      // texto que sera exibido acima da caixa com a informação
                      widget.textoTitulo,
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: StreamBuilder<String>(
                          stream:
                              _getCampoStream(widget.documentId, widget.campo),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Sem dados');
                            } else if (snapshot.hasData) {
                              return Text(
                                snapshot.data ?? 'Sem dados',
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return const Text('Sem dados');
                            }
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));

    // return SizedBox(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       SizedBox(
    //         width: 150,
    //         child: Text(
    //           // texto que sera exibido acima da caixa com a informação
    //           widget.textoTitulo,
    //           style: const TextStyle(fontSize: 15),
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //       SizedBox(
    //         height: 50,
    //         width: 150,
    //         child: DecoratedBox(
    //           decoration: BoxDecoration(
    //             color: Colors.grey[300],
    //           ),
    //           child: Center(
    //             child: StreamBuilder<String>(
    //               stream: _getCampoStream(widget.documentId, widget.campo),
    //               builder: (context, snapshot) {
    //                 if (snapshot.connectionState == ConnectionState.waiting) {
    //                   return const CircularProgressIndicator();
    //                 } else if (snapshot.hasError) {
    //                   return Text('Erro: ${snapshot.error}');
    //                 } else if (snapshot.hasData) {
    //                   return Text(
    //                     snapshot.data ?? 'Sem dados',
    //                     textAlign: TextAlign.center,
    //                   );
    //                 } else {
    //                   return const Text('Sem dados');
    //                 }
    //               },
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
