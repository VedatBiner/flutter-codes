// main.dart
import 'package:flutter/material.dart';

import '../config/theme/theme_dark.dart';
import '../core/app_const.dart';
import '../config/route/app_routes.dart';
import '../config/theme/theme_manager.dart';
import '../core/main/main_starter.dart';
import '../core/language_model/language_listener.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppConst.themeNotifier,
        builder: (context, themeData, child) {
          return ThemeManager(
            theme: themeData,
            changeTheme: AppConst.themeNotifier.changeTheme,
            child: ValueListenableBuilder(
              valueListenable: AppConst.language,
              builder: (context, language, child) {
                return LanguageManager(
                  changeLang: AppConst.language.changeLang,
                  value: language,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    // Routes //
                    title: MainStarter.title,
                    routes: AppRoute.routes,
                    initialRoute: AppRoute.splash,
                    // Theme ///
                    theme: themeData,
                    darkTheme: DarkTheme.theme,
                    themeMode: ThemeMode.system,
                  ),
                );
              }
            ),
          );
        });
  }
}