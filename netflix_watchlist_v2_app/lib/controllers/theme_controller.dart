// 📁 <----- lib/controllers/theme_controller.dart ----->
//
// ============================================================================
// 🎨 ThemeController – Uygulama Tema Yönetimi
// ============================================================================
//
// Bu controller, uygulamanın açık (light) ve koyu (dark) tema modları
// arasında geçiş yapılmasını sağlar.
//
// Controller GetX kullanılarak yazılmıştır.
//
// ---------------------------------------------------------------------------
// 🎯 Amaç
// ---------------------------------------------------------------------------
// • Kullanıcının uygulama temasını değiştirmesini sağlamak
// • Tema durumunu merkezi bir noktadan yönetmek
// • UI bileşenlerinin tema değişiminden otomatik haberdar olmasını sağlamak
//
// ---------------------------------------------------------------------------
// 🧠 Neden Controller?
// ---------------------------------------------------------------------------
// Tema bilgisi uygulamanın birçok yerinde kullanılabilir:
//
// • AppBar
// • Drawer
// • Card renkleri
// • Background renkleri
// • Icon renkleri
//
// Eğer tema state 'i widget içinde tutulursa:
//
// ❌ Her widget kendi state ’ini yönetmek zorunda kalır
// ❌ Tema değişince tüm ekranı yeniden yönetmek zorlaşır
//
// Controller kullanınca:
//
// ✅ Tema merkezi olarak yönetilir
// ✅ Reactive state sayesinde UI otomatik güncellenir
// ✅ Kod sade kalır
//
// ---------------------------------------------------------------------------
// 🧩 GetX Reactive State
// ---------------------------------------------------------------------------
// isDarkMode değişkeni `.obs` ile tanımlanmıştır.
//
// Bu şu anlama gelir:
//
// • değer değiştiğinde
// • bu değeri dinleyen tüm UI bileşenleri
// otomatik yeniden çizilir.
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ============================================================================
/// 🎨 ThemeController
/// ============================================================================
/// Uygulama temasını (light / dark) yöneten GetX controller.
///
/// Bu controller:
/// • mevcut tema durumunu tutar
/// • tema değiştirme işlemini gerçekleştirir
///
/// State:
/// • isDarkMode → reactive boolean
///
/// Kullanım:
/// final themeController = Get.find<ThemeController>();
/// ============================================================================
class ThemeController extends GetxController {
  // --------------------------------------------------------------------------
  // 🌙 isDarkMode
  // --------------------------------------------------------------------------
  // Reactive boolean değer.
  //
  // .obs kullanıldığı için:
  // bu değeri kullanan widget ’lar otomatik güncellenir.
  //
  // Örnek:
  // Obx(() => Icon(themeController.isDarkMode.value
  //     ? Icons.dark_mode
  //     : Icons.light_mode))
  //
  var isDarkMode = false.obs;

  // ==========================================================================
  // 🔄 toggleTheme()
  // ==========================================================================
  //
  // Uygulamanın temasını değiştirir.
  //
  // İşleyiş:
  //
  // 1️⃣ isDarkMode değerini tersine çevirir
  // 2️⃣ Get.changeThemeMode() ile uygulamanın aktif temasını değiştirir
  //
  // Eğer:
  //
  // isDarkMode = true
  // → ThemeMode.dark uygulanır
  //
  // isDarkMode = false
  // → ThemeMode.light uygulanır
  //
  // Bu işlem tüm uygulamayı yeniden tema ile render eder.
  //
  // ==========================================================================
  void toggleTheme() {
    // Mevcut değeri tersine çevir
    isDarkMode.value = !isDarkMode.value;

    // Tema modunu değiştir
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
