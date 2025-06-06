// 📃 <----- main.dart ----->

import 'package:flutter/material.dart';
import 'package:malzeme_list_sql_app/providers/malzeme_quantity_provider.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../providers/malzeme_count_provider.dart';
import '../theme.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MalzemeCountProvider()..updateCount(),
        ),
        ChangeNotifierProvider(create: (_) => MalzemeQuantityProvider()),
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
      title: 'Malzeme Listesi',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      home: const HomePage(),
    );
  }
}
