import 'package:flutter/material.dart';
import 'package:teste_firebase/pages/LeituraPDFTeste/lerpdf_page.dart';
import 'pages/home_page.dart';
import 'package:teste_firebase/pages/TelaConsulta/new_consult.dart';
import 'package:teste_firebase/pages/TelaConsulta/view_consult.dart';
import 'package:teste_firebase/pages/TelaConsulta/category_consult.dart';
import 'package:teste_firebase/pages/TelaCadastro/register_page.dart';
import 'package:teste_firebase/pages/TelaMedicamento/remedios_page.dart';


Map<String, Widget Function(BuildContext context)> rotas = {
  '/home': (context) => HomePage(),

  // Rotas para paginas de consultas
  '/consult_page' : (context) => const ConsultPage(),
  '/view_consult' : (context) => const ConsultaMarcadas(),
  '/new_consult' : (context) => const NovaConsulta(),

  // Rotas para paginas de remedios
  '/remedios_page' : (context) => const RemediosPage(),
  '/register_page' : (context) => RegisterPage(onTap: () {  },),

  //Rota para pagina de ler pdf (pagina teste será removida/alterada depois)
  '/lerpdf_page' : (context) => const LerPdfPage(),
};