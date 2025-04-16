// 📜 <----- main.dart ----->
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/word_count_provider.dart';
import '../routes.dart';
import '../theme.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WordCountProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelimelik',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      routes: appRoutes,
      home: const HomePage(),
    );
  }
}
