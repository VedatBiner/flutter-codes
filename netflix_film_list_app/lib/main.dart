// 📦 main.dart

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 yardımcı paketler
import '../screens/home_page.dart';

void main() {
  runApp(const NetflixHistoryApp());
}

class NetflixHistoryApp extends StatelessWidget {
  const NetflixHistoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Netflix İzleme Geçmişi',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
