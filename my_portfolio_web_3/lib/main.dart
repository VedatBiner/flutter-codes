import 'package:flutter/material.dart';
import '../product/main_screen.dart';

void main() {
  runApp(const MyApp());
}

MultiProvider provider() => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager),
      ],
      child: const MyApp(),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio Web Site',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
