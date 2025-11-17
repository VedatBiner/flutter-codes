import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const NetflixFilmListApp());
}

class NetflixFilmListApp extends StatelessWidget {
  const NetflixFilmListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Film List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: const HomePage(),
    );
  }
}
