import 'package:flutter/material.dart';

import 'home.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlphabetListView Example',
      theme: CustomTheme.theme,
      home: const Home(),
    );
  }
}
