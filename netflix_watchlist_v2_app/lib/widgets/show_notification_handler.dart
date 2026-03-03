// 📃 <----- lib/widgets/show_notification_handler.dart ----->
//
// ============================================================================
// 🔔 ShowNotificationHandler – Bildirim Gösterim Yardımcısı
// ============================================================================
//
// Bu dosya, uygulamada kullanılan “özel bildirim” (custom notification)
// akışlarını tek bir yerde toplar.
//
// Notification tasarımını doğrudan widget ’ların içine gömmek yerine
// burada fonksiyonlara ayırarak:
//
// ✅ UI tarafında tekrar eden kodu azaltır
// ✅ Bildirim tasarımı değişirse tek yerden yönetilir
// ✅ Yedekleme / paylaşım gibi işlemler sonrası kullanıcıya net geri bildirim verir
//
// ---------------------------------------------------------------------------
// Bu dosya neyi yapar?
// ---------------------------------------------------------------------------
// 1) showBackupNotification()
//    - Yedekleme bittiğinde CSV/JSON/XLSX dosyalarının adını kullanıcıya gösterir.
//
// 2) showShareFilesNotification()
//    - Paylaşım işlemi sonrasında “dosyalar paylaşıldı” bilgisini gösterir.
//
// Bildirimlerin gerçek UI çizimi NotificationService.showCustomNotification()
// metodunda yapılır. Bu dosya sadece “hangi mesaj, hangi icon, hangi içerik?”
// kısmını yönetir.
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../constants/text_constants.dart';
import '../services/notification_service.dart';

/// ============================================================================
/// ✅ showBackupNotification
/// ============================================================================
///
/// Yedekleme (export) işlemi tamamlandıktan sonra kullanıcıya:
///   • hangi dosyaların üretildiğini
///   • dosya isimleriyle (basename) birlikte
/// “tek bir bildirim” üzerinde gösterir.
///
/// ---------------------------------------------------------------------------
/// Parametreler
/// ---------------------------------------------------------------------------
/// [rootCtx]          → Bildirimin gösterileceği “geçerli” context.
/// [csvPathDownload]  → Download klasöründeki CSV ’nin tam yolu.
/// [jsonPathDownload] → Download klasöründeki JSON ’un tam yolu.
/// [excelPathDownload]→ Download klasöründeki XLSX ’in tam yolu.
///
/// Not:
/// - Biz kullanıcıya “tam path” değil, daha okunur olsun diye dosya adını
///   (basename) gösteriyoruz: p.basename(...).
///
/// - Bu fonksiyon “sadece bildirimi gösterir”, export işlemi burada yapılmaz.
///   Export işlemi export_items.dart / backup_notification_helper.dart içinde olur.
/// ============================================================================
void showBackupNotification(
  BuildContext rootCtx,
  String csvPathDownload,
  String jsonPathDownload,
  String excelPathDownload,
) {
  // NotificationService içindeki custom UI ’ı çağırır.
  return NotificationService.showCustomNotification(
    context: rootCtx,
    title: ' ',
    message: RichText(
      text: TextSpan(
        style: normalBlackText,
        children: [
          // Üst başlık satırı
          const TextSpan(
            text: '\nVeriler yedeklendi ... \n\n',
            style: kelimeAddText,
          ),

          // CSV dosyası
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(csvPathDownload)}\n"),

          // JSON dosyası
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(jsonPathDownload)}\n"),

          // XLSX dosyası
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(excelPathDownload)}\n"),
        ],
      ),
    ),

    // Görsel detaylar
    icon: Icons.download_for_offline_outlined,
    iconColor: Colors.green,

    // Bildirimdeki progress / çizgi (NotificationService tasarımına göre)
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade100,

    // Bildirim boyutu (tasarımsal)
    width: 320,
    height: 200,
  );
}

/// ============================================================================
/// ✅ showShareFilesNotification
/// ============================================================================
///
/// Kullanıcı “Yedekleri Paylaş” dediğinde share_plus ile paylaşım menüsü
/// açıldıktan sonra kullanıcıya “paylaşım işlemi başlatıldı / dosyalar paylaşıldı”
/// şeklinde bilgi vermek için kullanılır.
///
/// ---------------------------------------------------------------------------
/// Parametreler
/// ---------------------------------------------------------------------------
/// [rootCtx] → Bildirimin gösterileceği context.
///
/// Not:
/// - Paylaşım “gerçekten tamamlandı mı?” bilgisi share_plus tarafında kesin
///   olarak takip edilemez (kullanıcı menüden vazgeçebilir).
/// - Bu bildirim pratikte “paylaşım akışı açıldı / kullanıcıya iletildi”
///   anlamına gelir.
///
/// İstersen bunu daha doğru yapmak için:
/// - shareBackupFolder() içinde sonucu bool döndürüp,
/// - burada “başarılı/iptal” gibi iki ayrı mesaj da gösterebiliriz.
/// ============================================================================
void showShareFilesNotification(BuildContext rootCtx) {
  return NotificationService.showCustomNotification(
    context: rootCtx,
    title: ' ',
    message: RichText(
      text: const TextSpan(
        style: normalBlackText,
        children: [
          TextSpan(
            text: '\nDosyalar paylaşılmıştır ... \n\n',
            style: kelimeAddText,
          ),
        ],
      ),
    ),
    icon: Icons.download_for_offline_outlined,
    iconColor: Colors.green,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade100,
    width: 260,
    height: 200,
  );
}
