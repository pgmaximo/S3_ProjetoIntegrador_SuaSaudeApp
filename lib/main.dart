import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:teste_firebase/components/medicamento_hive.dart';
import 'package:teste_firebase/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teste_firebase/pages/historico_page.dart';
import 'package:teste_firebase/pages/remedios_page.dart';
import 'package:teste_firebase/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MedicamentoHiveAdapter());
  await Hive.openBox<MedicamentoHive>('medicamentosBox');
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
