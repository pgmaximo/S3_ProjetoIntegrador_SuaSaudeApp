import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:teste_firebase/components/appbar_widget.dart';

class LerPdfPage extends StatelessWidget {
  const LerPdfPage({super.key});

  void _readPDF() async {
    // nao retorna nada ainda, só imprime o que achou incluindo unidades de medida e outros caracteres
    // (ex: buscando "Lactate, venous blood" printa 0.7–1.8 mEq/L; 6–16 mg/dL )
    // precisa tratar string encontrada pra exibir/guardar/calcular

    // carrega o pdf com rootbundle em formato de bytes
    final ByteData data = await rootBundle.load('assets/pdf/sample.pdf');
    final Uint8List bytes = data.buffer.asUint8List();

    // cria o documento
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    // transforma o pdf inteiro em uma string
    // "frases" ficam separadas por quebra de linha normalmente
    final String text = PdfTextExtractor(document).extractText();
    // debugPrint(text);

    //procura no pdf exatamente o texto que estiver inserido na string procuraTexto e pega o indice
    //texto a procurar
    String procuraTexto = "Hydroxycorticosteroids (Porter-Silber), urine";
    int index = text.indexOf(procuraTexto);
    // debugPrint('index = $index');

    //procurar uma quebra de linha depois do texto encontrado
    // aparentemente +4 e +2 sempre funciona
    // +4 ultima letra \n espaço \n pra oq tiver na mesma linha
    // +2 coisas em linha separada só tem ultima letra \n
    int indexln = text.indexOf('\n', index + procuraTexto.length + 4);

    // pega a substring que vai do \n após o encontrado até o proximo \n
    String substring = text.substring(index + procuraTexto.length + 2, indexln);
    debugPrint(
        'Hydroxycorticosteroids (Porter-Silber), urine = $substring');

    // apaga o documento
    document.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: "Ler PDF",
        logout: false,
        rota: '/home'
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue)),
              onPressed: _readPDF,
              child: const Text(
                'Read PDF',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
