/// <----- main.dart ----->
///
library;
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sırpça-Türkçe Sözlük',
      home: HomePage(), // sadece widget 'ı döndürüyor
    );
  }
}

