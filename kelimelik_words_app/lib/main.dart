// 📃 <----- main.dart ----->

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/theme.dart';

import 'home_page.dart';

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
      // theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      theme: CustomTheme.theme,
      home: const HomePage(),
    );
  }
}
