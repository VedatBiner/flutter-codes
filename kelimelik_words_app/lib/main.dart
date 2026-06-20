// 📃 <----- main.dart ----->

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 📌 Yardımcı yüklemeler burada
import '../providers/item_count_provider.dart';
import '../providers/active_word_card_provider.dart';
import '../theme.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WordCountProvider()..updateCount(),
        ),
        ChangeNotifierProvider(create: (_) => ActiveWordCardProvider()),
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
      title: 'Kelimelik',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      home: const HomePage(),
    );
  }
}
