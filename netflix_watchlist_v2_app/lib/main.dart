// 📁 lib/main.dart
//

// ============================================================================
// 🎬 Netflix Watchlist Uygulaması – Ana Giriş Noktası
// ============================================================================
//
// Bu dosya uygulamanın başlangıç noktasıdır (entry point).
// Flutter uygulaması burada başlatılır ve tüm global yapılandırmalar
// bu dosya üzerinden yapılır.
//
// ---------------------------------------------------------------------------
// 🔹 Sorumlulukları
// ---------------------------------------------------------------------------
// 1️⃣ Uygulamayı başlatmak (runApp).
// 2️⃣ Tema yönetimini merkezi olarak kontrol etmek (Light / Dark Mode).
// 3️⃣ GetX ile route (sayfa yönlendirme) sistemini tanımlamak.
// 4️⃣ Stats sayfasına film ve dizi listelerini parametre olarak aktarmak.
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Yapı
// ---------------------------------------------------------------------------
// • GetX kullanılır (GetMaterialApp).
// • ThemeController → Light/Dark mod kontrolünü sağlar.
// • CustomTheme → uygulamanın açık ve koyu temalarını içerir.
// • Route yönetimi getPages listesi ile merkezi olarak tanımlanır.
// • Stats sayfasına veri aktarımı Get.arguments ile yapılır.
//
// ---------------------------------------------------------------------------
// 📌 Route Akışı
// ---------------------------------------------------------------------------
// '/'       → HomePage (ana ekran)
// '/stats'  → StatsPage (film + dizi istatistik ekranı)
//
// Stats route ’u parametreli çalışır:
//   Get.toNamed('/stats', arguments: {
//      'movies': movies,
//      'series': series,
//   });
//
// Bu parametreler burada alınır ve StatsPage’e aktarılır.
//
// ---------------------------------------------------------------------------
// 🎨 Tema Yönetimi
// ---------------------------------------------------------------------------
// ThemeController (GetX) üzerinden anlık tema değişimi yapılır.
// Obx widget sayesinde tema değiştiğinde tüm uygulama otomatik
// olarak yeniden render edilir.
//
// ---------------------------------------------------------------------------
// ⚙️ Teknik Notlar
// ---------------------------------------------------------------------------
// • debugShowCheckedModeBanner kapalıdır.
// • GetMaterialApp kullanıldığı için klasik Navigator yerine
//   GetX navigation tercih edilmiştir.
// • Uygulamanın global yapılandırması burada tutulur.
// • Bu dosya iş mantığı içermez, sadece uygulama iskeletini kurar.
//
// ============================================================================
// Bu dosya uygulamanın "beyni" değil,
// uygulamanın "iskeletini ve yönlendirme sistemini" kuran merkezdir.
// ============================================================================
//

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
