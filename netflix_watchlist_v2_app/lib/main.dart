// 📁 lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/theme_controller.dart';
import 'screens/home_page.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Netflix Watchlist',
        theme: CustomTheme.theme,
        darkTheme: ThemeData.dark(),
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        home: const HomePage(),
      );
    });
  }
}
