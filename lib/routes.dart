import 'package:teste_firebase/pages/TelaCadastro/auth_page.dart';
import 'package:teste_firebase/pages/TelaDadosHome/pressao_page.dart';
import 'pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:teste_firebase/pages/TelaConsulta/add_consulta.dart';
import 'package:teste_firebase/pages/TelaConsulta/specialty_consulta.dart';
import 'package:teste_firebase/pages/TelaConsulta/detail_consulta.dart';
import 'package:teste_firebase/pages/TelaConsulta/list_consulta.dart';
import 'package:teste_firebase/pages/TelaCadastro/register_page.dart';
import 'package:teste_firebase/pages/TelaMedicamento/remedios_page.dart';
import 'package:teste_firebase/pages/LeituraPDFTeste/lerpdf_page.dart';


Map<String, Widget Function(BuildContext context)> rotas = {
  '/home': (context) => HomePage(),

  // Rota para pagina de autenticaçao
  '/auth_page' : (context) => const AuthPage(),

  // Rotas para pagina de pressao, glicemia, altura e peso
  '/pressao_page' : (context) => const PressaoPage(),

  // Rotas para paginas de consultas
  '/specialty_consulta' : (context) => const SpecialtyConsulta(),
  '/list_consulta' : (context) => const ConsultaMarcadas(especialista: '',),
  '/add_consulta' : (context) => const NovaConsulta(),
    '/detail_consulta': (context) => TelaConsulta(
    consulta: ModalRoute.of(context)!.settings.arguments as ConsultaHive, 
  ),

  // Rotas para paginas de remedios
  '/remedios_page' : (context) => const RemediosPage(),
  '/register_page' : (context) => RegisterPage(onTap: () {  },),

  //Rota para pagina de ler pdf (pagina teste será removida/alterada depois)
  '/lerpdf_page' : (context) => const LerPdfPage(),
};