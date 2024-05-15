import 'pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/pages/TelaConsulta/add_consulta.dart';
import 'package:teste_firebase/pages/TelaConsulta/specialty_consulta.dart';
import 'package:teste_firebase/pages/TelaConsulta/detail_consulta.dart';
import 'package:teste_firebase/pages/TelaConsulta/list_consulta.dart';
import 'package:teste_firebase/pages/TelaCadastro/register_page.dart';
import 'package:teste_firebase/pages/TelaMedicamento/remedios_page.dart';
import 'package:teste_firebase/pages/LeituraPDFTeste/lerpdf_page.dart';


Map<String, Widget Function(BuildContext context)> rotas = {
  '/home': (context) => HomePage(),

  // Rotas para paginas de consultas
  '/category_consulta' : (context) => const SpecialtyConsulta(),
  '/view_consulta' : (context) => const ConsultaMarcadas(),
  '/add_consulta' : (context) => const NovaConsulta(),
  '/detail_consulta' : (context) => const TelaConsulta(),

  // Rotas para paginas de remedios
  '/remedios_page' : (context) => const RemediosPage(),
  '/register_page' : (context) => RegisterPage(onTap: () {  },),

  //Rota para pagina de ler pdf (pagina teste será removida/alterada depois)
  '/lerpdf_page' : (context) => const LerPdfPage(),
};