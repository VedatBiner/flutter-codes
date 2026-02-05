// 📁 lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/theme_controller.dart';
import 'models/netflix_item.dart';
import 'models/series_models.dart';
import 'screens/home_page.dart';
import 'screens/stats_page.dart';
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
        darkTheme: CustomTheme.darkTheme,
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const HomePage()),

          /// 📊 Stats route: parametreleri Get.arguments ile alır
          GetPage(
            name: '/stats',
            page: () {
              final args = (Get.arguments as Map<String, dynamic>? ?? {});

              final movies =
                  (args['movies'] as List<NetflixItem>?) ?? const <NetflixItem>[];
              final series =
                  (args['series'] as List<SeriesGroup>?) ?? const <SeriesGroup>[];

              return StatsPage(movies: movies, series: series);
            },
          ),
        ],
      );
    });
  }
}
