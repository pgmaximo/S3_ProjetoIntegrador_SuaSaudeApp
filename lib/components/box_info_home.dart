// ignore_for_file: use_build_context_synchronously

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
  Future<void> _navigateHistorico(String campo) async {
    // TextEditingController pesoController = TextEditingController();
    // TextEditingController alturaController = TextEditingController();
    // TextEditingController controller = TextEditingController();
    
    switch(campo){
      case 'altura': 
        Navigator.pushNamed(context,'');
        break;
      case 'pressao':
        Navigator.pushNamed(context,'/pressao_page');
        break;
      case 'glicemia':
        Navigator.pushNamed(context,'/glicemia_page');
        break;
    }

    //       case 'altura':
    //         return AlertDialog(
    //           title: const Text('Inserir Peso e Altura'),
    //           content: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               TextField(
    //                 controller: pesoController,
    //                 keyboardType: TextInputType.number,
    //                 decoration: const InputDecoration(
    //                   hintText: "Peso em kg",
    //                 ),
    //               ),
    //               const SizedBox(height: 8),
    //               TextField(
    //                 controller: alturaController,
    //                 keyboardType: TextInputType.number,
    //                 decoration: const InputDecoration(
    //                   hintText: "Altura em cm",
    //                 ),
    //               ),
    //             ],
    //           ),
    //           actions: [
    //             TextButton(
    //               onPressed: () async {
    //                 double? peso = double.tryParse(pesoController.text);
    //                 String altura = alturaController.text;

    //                 if (peso != null) {
    //                   await usuarioService.setPesoAltura(altura, peso);
    //                   Navigator.of(context).pop();
    //                 } else {
    //                   ScaffoldMessenger.of(context).showSnackBar(
    //                     const SnackBar(
    //                         content: Text(
    //                             'Por favor, insira valores válidos para peso e altura.')),
    //                   );
    //                 }
    //               },
    //               child: const Text('Salvar'),
    //             ),
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: const Text('Cancelar'),
    //             ),
    //           ],
    //         );
  }

  final UsuarioService usuarioService = UsuarioService();

  Stream<String> _getCampoStream(String documentId, String campo) {
    switch (campo) {
      case 'pressao':
        return usuarioService.getUltimaPressao(documentId);
      case 'glicemia':
        return usuarioService.getUltimaGlicemia(documentId);
      case 'altura':
        return usuarioService.getPesoAltura(documentId);
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
            onTap: () => _navigateHistorico(widget.campo),
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
  }
}
