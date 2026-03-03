// 📃 <----- lib/widgets/bottom_banner_helper.dart ----->
//
// ============================================================================
// 📌 Bottom Banner Helper – Alt Bant Yükleme Göstergesi
// ============================================================================
//
// Bu dosya, ekranın en altında “alt bant / banner” şeklinde geçici bir mesaj
// göstermek için kullanılan yardımcı yapıyı içerir.
//
// Banner, Scaffold yapısına eklenmez; Overlay katmanına eklenir.
// Böylece:
//
// ✅ Sayfa layout ’u bozulmaz
// ✅ Rebuild olsa bile banner görünmeye devam eder
// ✅ Her ekranda aynı mantıkla kullanılabilir
//
// ---------------------------------------------------------------------------
// 🔎 Overlay Mantığı
// ---------------------------------------------------------------------------
// Overlay, uygulamanın UI ağacının üstünde duran ayrı bir katmandır.
// SnackBar gibi çalışır ama tamamen özelleştirilebilir.
//
// showLoadingBanner() → OverlayEntry üretir ve overlay.insert(entry) ile ekler.
// LoadingBannerController → bu entry ’yi güvenli şekilde kapatmak için döner.
//
// ============================================================================

import 'dart:developer';
import 'package:flutter/material.dart';

// ============================================================================
// 🔥 LoadingBannerController
// ============================================================================
//
// Bu sınıf, OverlayEntry’yi kontrollü şekilde kaldırmak için kullanılır.
//
// Neden gerekli?
// - Async süreçlerde banner birden fazla yerde close() edilmeye çalışabilir.
// - OverlayEntry.remove() iki kez çağrılırsa hata oluşabilir.
// - Bu controller, close() metodunu “idempotent” (tekrar güvenli) hale getirir.
//
// Kullanım örneği:
//   final ctrl = showLoadingBanner(context, message: "Yükleniyor...");
//   ...
//   ctrl.close();
//
// ============================================================================
class LoadingBannerController {
  final OverlayEntry entry;

  /// Aynı entry üzerinde tekrar tekrar remove() çağrılmasını engeller.
  bool _isClosed = false;

  LoadingBannerController(this.entry);

  // ==========================================================================
  // 🛑 close()
  // ==========================================================================
  /// Banner ’ı güvenli şekilde kapatır.
  ///
  /// Güvenlik:
  /// • Zaten kapalıysa hiçbir şey yapmaz.
  /// • remove() sırasında hata oluşursa uygulama çökmez.
  void close() {
    if (_isClosed) return;

    try {
      entry.remove();
    } catch (_) {
      // OverlayEntry zaten kaldırılmış olabilir.
      // Burada crash istemiyoruz.
    }

    _isClosed = true;
  }
}

// ============================================================================
// 🌟 LoadingBottomBanner
// ============================================================================
//
// Bu widget, ekrana yerleştirilen alt bant tasarımını üretir.
// Tasarım basit tutuldu:
//
// • SafeArea(bottom: true) → gesture bar / navigation bar ile çakışmasın
// • Material → yazı/tema davranışları düzgün olsun
// • Siyah yarı saydam arka plan → okunabilirlik
//
// ============================================================================
class LoadingBottomBanner extends StatelessWidget {
  final String message;

  const LoadingBottomBanner({super.key, required this.message});

  // ==========================================================================
  // 🏗 build()
  // ==========================================================================
  /// Alt bant UI ’sini üretir.
  ///
  /// Not:
  /// Buradaki widget sadece görünümü sağlar.
  /// Overlay ekleme/çıkarma mantığı showLoadingBanner() içindedir.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Material(
        color: Colors.black.withOpacity(0.88),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 🔧 showLoadingBanner()
// ============================================================================
//
// Bu fonksiyon, alt bant banner ’ı Overlay ’e ekler ve kontrol nesnesi döndürür.
//
// Parametreler:
// • context : Overlay ’e erişmek için (rootOverlay tercih edilir)
// • message : Kullanıcıya gösterilecek metin
//
// Çalışma akışı:
// 1) Overlay.of(context, rootOverlay:true) alınır
// 2) OverlayEntry oluşturulur (Positioned + AnimatedOpacity + Banner widget)
// 3) overlay.insert(entry) ile ekrana basılır
// 4) LoadingBannerController(entry) döndürülür
//
// ⚠️ Önemli:
/// Overlay bazen null dönebilir (çok nadir; örn. context overlay ağacına bağlı değilse).
/// Bu yüzden fallback olarak ScaffoldMessenger ile SnackBar basıyoruz
/// ve “dummy controller” döndürüyoruz (close() çağrısı sorun çıkarmasın diye).
//
// ============================================================================
LoadingBannerController showLoadingBanner(
  BuildContext context, {
  required String message,
  String tag = "bottom_banner_helper",
}) {
  final overlay = Overlay.of(context, rootOverlay: true);

  // --------------------------------------------------------------------------
  // 🛡 Overlay null fallback
  // --------------------------------------------------------------------------
  if (overlay == null) {
    log("⚠️ Overlay bulunamadı. Fallback SnackBar çalıştı.", name: tag);

    // UI bozulmasın diye SnackBar fallback (en azından kullanıcı mesajı görsün)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );

    // close() çağrılabilsin diye boş entry ile controller döndür
    final dummyEntry = OverlayEntry(builder: (_) => const SizedBox.shrink());
    return LoadingBannerController(dummyEntry);
  }

  late OverlayEntry entry;

  // --------------------------------------------------------------------------
  // 📌 OverlayEntry üretimi
  // --------------------------------------------------------------------------
  entry = OverlayEntry(
    builder: (ctx) => Positioned(
      left: 0,
      right: 0,
      bottom: 0,

      // AnimatedOpacity: görünüm daha “yumuşak” his versin diye
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 200),
        child: LoadingBottomBanner(message: message),
      ),
    ),
  );

  // --------------------------------------------------------------------------
  // ➕ Overlay ’e ekle
  // --------------------------------------------------------------------------
  overlay.insert(entry);

  return LoadingBannerController(entry);
}
