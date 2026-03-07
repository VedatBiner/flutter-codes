// 📃 <----- lib/services/notification_service.dart ----->
//
// ============================================================================
// 🔔 NotificationService – Uygulama Genel Bildirim Servisi
// ============================================================================
//
// Bu servis, uygulama içinde gösterilen özel bildirimleri
// tek bir merkezden yönetmek için kullanılır.
//
// Bildirimler, `elegant_notification` paketi kullanılarak gösterilir.
//
// ---------------------------------------------------------------------------
// 🎯 Amaç
// ---------------------------------------------------------------------------
// • Bildirim tasarımını merkezi hale getirmek
// • Farklı ekranlarda aynı görsel standardı korumak
// • Genişlik / yükseklik / animasyon / ikon / progress bar gibi
//   ortak ayarları tek noktadan kontrol etmek
//
// ---------------------------------------------------------------------------
// 🧠 Neden ayrı bir servis?
// ---------------------------------------------------------------------------
// Eğer her widget içinde doğrudan ElegantNotification yazılsaydı:
//
// ❌ Kod tekrar ederdi
// ❌ Bildirim tasarımı dağınık olurdu
// ❌ Stil değişikliği için birçok dosya güncellemek gerekirdi
//
// Bu servis sayesinde:
//
// ✅ Tüm bildirimler aynı tasarım dilini kullanır
// ✅ UI katmanı sadece “hangi mesajı göstereceğini söyler
// ✅ Tasarım değişirse tek dosyadan yönetilir
//
// ---------------------------------------------------------------------------
// 📌 Kullanım Örneği
// ---------------------------------------------------------------------------
// NotificationService.showCustomNotification(
//   context: context,
//   title: 'Başarılı',
//   message: const Text('İşlem tamamlandı'),
//   progressIndicatorBackground: Colors.green.shade100,
//   progressIndicatorColor: Colors.green,
// );
//
// ============================================================================

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

/// ============================================================================
/// 🔔 NotificationService
/// ============================================================================
/// Uygulama genelinde ortak bildirim gösterim servisidir.
///
/// Şu anda tek bir public metot içerir:
///   • showCustomNotification()
///
/// Bu metot:
/// • bildirim boyutunu ekran boyutuna göre ayarlar
/// • ikon, renk, animasyon, progress bar gibi ayarları uygular
/// • ElegantNotification paketini kullanarak bildirimi ekrana basar
///
/// Not:
/// Bu sınıf state tutmaz. Tüm davranış static metot üzerinden yürür.
/// ============================================================================
class NotificationService {
  // ==========================================================================
  // 🚀 showCustomNotification()
  // ==========================================================================
  /// Uygulama içinde özelleştirilmiş bir bildirim gösterir.
  ///
  /// ------------------------------------------------------------------------
  /// Parametreler
  /// ------------------------------------------------------------------------
  /// [context]
  ///   Bildirimin gösterileceği BuildContext.
  ///
  /// [title]
  ///   Bildirimin başlığı.
  ///   Boşluk (' ') verilirse başlık alanı boş bırakılabilir.
  ///
  /// [message]
  ///   Bildirim gövdesinde gösterilecek içerik.
  ///   Widget tipinde olduğu için:
  ///   • Text
  ///   • RichText
  ///   • Column
  ///   • başka özel widget
  ///   kullanılabilir.
  ///
  /// [icon]
  ///   Solda gösterilecek ikon.
  ///   Varsayılan: check_circle
  ///
  /// [iconColor]
  ///   İkon rengi.
  ///
  /// [position]
  ///   Bildirimin ekrandaki konumu.
  ///   Varsayılan: center
  ///
  /// [animation]
  ///   Bildirimin ekrana giriş animasyonu.
  ///   Varsayılan: soldan gelme
  ///
  /// [progressIndicatorBackground]
  ///   Progress çubuğunun arka plan rengi.
  ///
  /// [progressIndicatorColor]
  ///   Progress çubuğunun dolu rengi.
  ///
  /// [width], [height]
  ///   İsteğe bağlı manuel override ölçüler.
  ///   Verilmezse ekran boyutuna göre otomatik hesaplanır.
  ///
  /// [duration]
  ///   Bildirimin ekranda kalma süresi.
  ///
  /// ------------------------------------------------------------------------
  /// Boyut Hesap Mantığı
  /// ------------------------------------------------------------------------
  /// Eğer width/height verilmemişse:
  ///
  /// • Desktop → daha dar (yaklaşık ekranın %28’i)
  /// • Tablet  → orta genişlik (yaklaşık ekranın %60’ı)
  /// • Telefon → daha geniş (yaklaşık ekranın %92’si)
  ///
  /// Sonra clamp ile:
  /// • width  280 - 560 aralığına
  /// • height 160 - 400 aralığına
  /// sabitlenir.
  ///
  /// Bu sayede:
  /// ✅ çok küçük ekranlarda taşma olmaz
  /// ✅ çok büyük ekranlarda anlamsız dev kutular oluşmaz
  ///
  /// ------------------------------------------------------------------------
  /// Not
  /// ------------------------------------------------------------------------
  /// `ElegantNotification.dismissAll(context)` satırı şu an kapalıdır.
  /// Açılırsa eski bildirimler kapanır ve üst üste binme engellenir.
  /// İleride ihtiyaç olursa aktif edilebilir.
  // ==========================================================================
  static void showCustomNotification({
    required BuildContext context,
    required String title,
    required Widget message,
    IconData icon = Icons.check_circle,
    Color iconColor = Colors.blue,
    Alignment position = Alignment.center,
    AnimationType animation = AnimationType.fromLeft,
    required Color progressIndicatorBackground,
    required Color progressIndicatorColor,

    // İsteğe bağlı boyut override ’ları
    double? width,
    double? height,

    // Bildirimin ekranda kalma süresi
    Duration duration = const Duration(seconds: 6),
  }) {
    // ------------------------------------------------------------------------
    // 📏 Ekran boyutuna göre otomatik bildirim ölçüsü hesapla
    // ------------------------------------------------------------------------
    final size = MediaQuery.sizeOf(context);

    double w =
        width ??
        (size.width >= 1024
            ? size.width *
                  0.28 // desktop
            : size.width >= 600
            ? size.width *
                  0.60 // tablet
            : size.width *
                  0.92 // phone
                  );

    double h = height ?? (size.height * 0.22);

    // ------------------------------------------------------------------------
    // 📐 Uç değerleri sınırla
    // ------------------------------------------------------------------------
    // Çok büyük veya çok küçük bildirim oluşmasını engeller
    w = w.clamp(280.0, 560.0);
    h = h.clamp(160.0, 400.0);

    // ------------------------------------------------------------------------
    // 🧹 Eski bildirimleri kapatma opsiyonu
    // ------------------------------------------------------------------------
    // İstenirse üst üste bildirim binmesini engellemek için açılabilir.
    //
    // ElegantNotification.dismissAll(context);

    // ------------------------------------------------------------------------
    // 🔔 Bildirimi oluştur ve göster
    // ------------------------------------------------------------------------
    ElegantNotification(
      // Genel arka plan rengi (color_constants.dart içinden gelir)
      background: notificationColor,

      // Hesaplanan / override edilen ölçüler
      width: w,
      height: h,

      // Aynı noktada gelen bildirimlerin nasıl üst üste dizileceği
      stackedOptions: StackedOptions(
        key: 'center',
        type: StackedType.same,
        scaleFactor: 0.2,
        itemOffset: const Offset(-20, 10),
      ),

      // Bildirimin ekranda kalma süresi
      toastDuration: duration,

      // Pozisyon ve giriş animasyonu
      position: position,
      animation: animation,

      // Başlık ve açıklama
      title: Text(title),
      description: message,

      // Progress bar ayarları
      progressBarHeight: 10,
      progressBarPadding: const EdgeInsets.symmetric(horizontal: 20),
      showProgressIndicator: true,
      progressIndicatorColor: progressIndicatorColor,
      progressIndicatorBackground: progressIndicatorBackground,

      // Sol ikon
      icon: Icon(icon, color: iconColor),

      // Hafif gölge
      shadow: const BoxShadow(
        color: Colors.black38,
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 4),
      ),
    ).show(context);
  }
}
