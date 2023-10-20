import 'package:flutter/material.dart';
import 'package:tutorial_app/config/theme/theme_dark.dart';
import 'package:tutorial_app/core/app_const.dart';

import '../config/route/app_routes.dart';
import '../config/theme/theme_manager.dart';
import '../core/main/main_starter.dart';

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
    );
  }
}
