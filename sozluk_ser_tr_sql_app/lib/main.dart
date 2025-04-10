// 📃 <----- main.dart ----->

import 'package:flutter/material.dart';
import 'package:sozluk_ser_tr_sql_app/theme.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelimelik',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      home: const HomePage(),
    );
  }
}
