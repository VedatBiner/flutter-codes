/// ----- main.dart -----
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'firebase_options.dart';

import '../utils/authentication.dart';
import '../utils/theme_data.dart';
import '../screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyDynamicThemeWidget(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    log('UID: $uid');
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      debugShowCheckedModeBanner: false,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: const HomePage(),
    );
  }
}
