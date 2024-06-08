import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:teste_firebase/components/consulta_hive.dart';
import 'package:teste_firebase/components/exames_hive.dart';
import 'package:teste_firebase/components/medicamento_hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teste_firebase/pages/TelaCadastro/auth_page.dart';
import 'package:teste_firebase/routes.dart';
import 'firebase_options.dart';

void main() async {
  // descomentar para rodar testes
  // enableFlutterDriverExtension();

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Remedio
  Hive.registerAdapter(MedicamentoHiveAdapter());
  await Hive.openBox<MedicamentoHive>('medicamentosBox');

  // Consulta
  Hive.registerAdapter(ConsultaHiveAdapter());
  await Hive.openBox<ConsultaHive>('consultasBox');

  // Exames
  Hive.registerAdapter(ExamesHiveAdapter());
  await Hive.openBox<ExamesHive>('examesBox'); 
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: rotas,
    );
  }
}
