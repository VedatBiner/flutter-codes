// <📜 ----- main.dart ----->

// 📌 Dart hazır paketleri
import 'dart:developer' show log;

/// 📌 Flutter hazır paketleri
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../screens/home_page.dart';

/// 📌 Yardımcı yüklemeler burada
import 'firebase_options.dart' show DefaultFirebaseOptions;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('🚀 Firebase başlatıldı.', name: 'app');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SER-TR Sözlük WEB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}
