import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sozluk_app_ser_tr_fbfs/theme/theme_constants.dart';
import 'package:sozluk_app_ser_tr_fbfs/theme/theme_manager.dart';

import '../routes/app_routes.dart';
import '../firebase_options.dart';
import 'constants/base_constants/app_const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ThemeManager themeManager = ThemeManager();

  runApp(MyApp(themeManager: themeManager));
}

class MyApp extends StatefulWidget {
  final ThemeManager themeManager;

  const MyApp({Key? key, required this.themeManager}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    widget.themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    widget.themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConst.main.title,
      routes: AppRoute.routes,
      initialRoute: AppRoute.splash,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: widget.themeManager.themeMode,
    );
  }
}
