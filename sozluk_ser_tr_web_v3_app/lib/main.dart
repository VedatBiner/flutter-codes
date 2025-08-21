// <📜 ----- main.dart ----->

// 📌 Dart hazır paketleri
import 'dart:developer' show log;

/// 📌 Flutter hazır paketleri
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants/info_constants.dart';
import '../screens/home_page.dart';
import 'firebase_options.dart' show DefaultFirebaseOptions;
import 'routes.dart';

/// 📌 Yardımcı yüklemeler burada
import 'theme.dart';

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
      title: appBarName,
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      routes: appRoutes,
      home: const HomePage(),
    );
  }
}
