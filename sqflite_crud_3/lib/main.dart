/// <----- main.dart ----->
library;

import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../pages/home_page.dart';

Future<void> main() async {
  /// widget 'ların başlatılmasını sağlayalım
  WidgetsFlutterBinding.ensureInitialized();
  /// veri tabanını başlatalım
  await AppDatabase.instance.database;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Color(0xFFF08A4B),
        ),
        useMaterial3: true,
      ),

    );
  }
}

