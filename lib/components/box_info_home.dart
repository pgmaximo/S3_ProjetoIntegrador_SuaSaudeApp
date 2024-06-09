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

    // TextEditingController controller = TextEditingController();

    switch (campo) {
      case 'altura':
        Navigator.pushNamed(context, '/peso_page');
        break;
      case 'pressao':
        Navigator.pushNamed(context, '/pressao_page');
        break;
      case 'glicemia':
        Navigator.pushNamed(context, '/glicemia_page');
        break;
      case 'IMC':
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("IMC é definido inserindo altura e peso!", textAlign: TextAlign.center,),
              );
            });
        break;
    }
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
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: StreamBuilder<String>(
                      stream:
                          _getCampoStream(widget.documentId, widget.campo),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(color: Color.fromARGB(255, 123, 167, 150),);
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
        )
      )
    );
  }
}
