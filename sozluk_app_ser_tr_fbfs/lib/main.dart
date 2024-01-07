/// <----- main.dart ----->

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../routes/app_routes.dart';
import '../theme/theme_dark.dart';
import '../firebase_options.dart';
import 'constants/base_constants/app_const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppConst.listener.themeNotifier,
        builder: (context, themeData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConst.main.title,
            routes: AppRoute.routes,
            initialRoute: AppRoute.splash,
            theme: themeData,
            darkTheme: DarkTheme.theme,
            themeMode: ThemeMode.system,
          );
        });
  }
}
