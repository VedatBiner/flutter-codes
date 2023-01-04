import 'package:flutter/material.dart';
import './screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.green,
        appBarTheme: const AppBarTheme(
          color: Colors.green,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(
          secondary: Colors.green,
        ),
        textTheme: const TextTheme(
          subtitle1: TextStyle(
            color: Colors.white,
          ),
          headline3: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}