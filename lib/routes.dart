import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:teste_firebase/pages/consult_page.dart';
import 'package:teste_firebase/pages/register_page.dart';
import 'package:teste_firebase/pages/remedios_page.dart';


Map<String, Widget Function(BuildContext context)> rotas = {
  '/home': (context) => HomePage(),
  '/consult_page' : (context) => const ConsultPage(),
  '/remedios_page' : (context) => const RemediosPage(),
  '/register_page' : (context) => RegisterPage(onTap: () {  },),
};