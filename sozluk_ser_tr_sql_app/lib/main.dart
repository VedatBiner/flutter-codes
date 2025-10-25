// 📜 <----- main.dart ----->
//

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/item_count_provider.dart';
import '../routes.dart';
import '../theme.dart';
import 'firebase_options.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WordCountProvider()..updateCount(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sırpça-Türkçe Sözlük (SQL)',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      routes: appRoutes,
      home: const HomePage(),
    );
  }
}
