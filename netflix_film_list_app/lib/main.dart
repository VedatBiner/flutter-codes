// 📦 main.dart

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

import '../screens/home_page.dart';

/// 📌 Yardımcı paketler
import 'theme.dart';

void main() {
  runApp(const NetflixHistoryApp());
}

class NetflixHistoryApp extends StatelessWidget {
  const NetflixHistoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix İzleme Geçmişi',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      home: const HomePage(),
    );
  }
}
