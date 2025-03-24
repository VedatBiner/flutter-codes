/// <----- main.dart ----->
///
library;

import 'package:flutter/material.dart';
import 'data/database/database_helper.dart';
import 'features/dictionary/presentation/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sırpça-Türkçe Sözlük',
      home: HomePage(), // sadece widget 'ı döndürüyor
    );
  }
}

