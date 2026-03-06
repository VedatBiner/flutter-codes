// <📜 ----- lib/utils/backup_notification_helper.dart ----->
//
// ============================================================================
// 💾 BackupNotificationHelper – Export Süreci Yardımcısı
// ============================================================================
//
// Bu yardımcı fonksiyon, yedekleme (export) işleminin UI ile koordinasyonunu
// yönetir.
//
// ---------------------------------------------------------------------------
// 🎯 Sorumlulukları
// ---------------------------------------------------------------------------
// • Export başlamadan önce “durum” bilgisini dışarıya bildirmek
// • Alt bant loading banner göstermek
// • ExportRepository üzerinden export sürecini başlatmak
// • Export tamamlanınca sonucu UI tarafına callback ile iletmek
// • Hata olursa kullanıcıya SnackBar göstermek
// • İşlem sonunda banner ’ı kapatmak ve exporting state ’ini sıfırlamak
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Not
// ---------------------------------------------------------------------------
// Bu dosya export dosyalarını üretmez.
//
// Gerçek export işlemi:
//   → ExportRepository
//
// Dosya üretimi:
//   → ExportFileService
//
// Bu helper ’ın görevi:
//   → UI ile export süreci arasında köprü kurmak
//
// Yani:
// • Repository iş akışını yürütür
// • Bu helper ise “kullanıcıya süreçte ne gösterilecek?” kısmını yönetir
//
// ---------------------------------------------------------------------------
// 📌 Neden ayrı helper?
// ---------------------------------------------------------------------------
// Eğer bu akış Drawer widget ’ının içinde yazılsaydı:
//
// ❌ DrawerShareTile / DrawerBackupTile çok şişerdi
// ❌ UI ve iş akışı birbirine karışırdı
//
// Bu helper sayesinde:
// ✅ Widget kodu sade kalır
// ✅ Export akışı tek yerden yönetilir
// ✅ Hata / loading / success davranışı standart olur
//
// ============================================================================

import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/export_items.dart';
import '../repositories/export_repository.dart';
import '../widgets/bottom_banner_helper.dart';


// ============================================================================
// 🚀 backupNotificationHelper()
// ============================================================================
//
// Bu fonksiyon export sürecini başlatır ve kullanıcıya süreç boyunca
// uygun görsel geri bildirimler verir.
//
// Parametreler:
// • context            → UI işlemleri (banner/snack bar) için gerekli context
// • onStatusChange     → dışarıya metin tabanlı durum bildirimi yapmak için
// • onExportingChange  → export başladı/bitti bilgisini dışarıya bildirmek için
// • onSuccessNotify    → export tamamlanınca sonucu UI tarafına iletmek için
//
// Kullanım amacı:
// DrawerBackupTile gibi bir widget sadece bu helper ’ı çağırır.
// Export ’un detaylarını bilmek zorunda kalmaz.
//
// ============================================================================
Future<void> backupNotificationHelper({
  required BuildContext context,

  /// Export aşamalarını dışarıya bildirmek için kullanılır.
  ///
  /// Örnek:
  ///   "Yedek hazırlanıyor..."
  ///   "Tamamlandı: 154 kayıt."
  ///   "Hata: Storage izni verilmedi"
  required void Function(String status) onStatusChange,

  /// Export işleminin başlayıp bittiğini dışarıya bildirmek için kullanılır.
  ///
  /// Örnek:
  ///   true  -> export başladı
  ///   false -> export tamamlandı / hata ile bitti
  required void Function(bool exporting) onExportingChange,

  /// Export tamamlandığında sonuç nesnesini UI tarafına iletmek için kullanılır.
  ///
  /// Bu callback genelde:
  /// • notification göstermek
  /// • path bilgilerini paylaşmak
  /// için kullanılır.
  void Function(BuildContext ctx, ExportItems res)? onSuccessNotify,
}) async {
  const tag = "backup_notification_helper";

  // --------------------------------------------------------------------------
  // 1️⃣ Başlangıç durumu bildir
  // --------------------------------------------------------------------------
  //
  // UI tarafına export başladığını söyle.
  // Böylece parent widget isterse loading state gösterebilir.
  //
  onExportingChange(true);
  onStatusChange("Yedek hazırlanıyor...");

  // --------------------------------------------------------------------------
  // 2️⃣ Alt bant loading banner göster
  // --------------------------------------------------------------------------
  //
  // Kullanıcı export süresince ekranda bir işlem olduğunu görsün.
  // Bu banner overlay üzerinde çalışır ve Scaffold yapısını bozmaz.
  //
  final bannerCtrl = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz,\nyedek hazırlanıyor...",
  );

  try {
    // ------------------------------------------------------------------------
    // 3️⃣ Repository üzerinden export işlemini başlat
    // ------------------------------------------------------------------------
    //
    // ExportRepository:
    // • verileri okur
    // • CSV/JSON/XLSX üretir
    // • Download klasörüne kopyalar
    // • temp klasörü temizler
    //
    final repo = ExportRepository();

    final res = await repo.exportAll(
      subfolder: 'netflix_watch_list_backups',
    );

    // ------------------------------------------------------------------------
    // 4️⃣ Başarı durumunu dışarıya bildir
    // ------------------------------------------------------------------------
    onStatusChange("Tamamlandı: ${res.count} kayıt.");

    // ------------------------------------------------------------------------
    // 5️⃣ UI callback ’i varsa sonucu ilet
    // ------------------------------------------------------------------------
    //
    // Örn:
    // • showBackupNotification(...)
    // • path ’leri kullanıcıya göstermek
    //
    if (onSuccessNotify != null && context.mounted) {
      onSuccessNotify(context, res);
    }

    log("✅ Yedekleme tamamlandı.", name: tag);
  } catch (e, st) {
    // ------------------------------------------------------------------------
    // 6️⃣ Hata yönetimi
    // ------------------------------------------------------------------------
    //
    // Export sırasında oluşabilecek hatalar:
    // • storage izni yok
    // • download klasörü bulunamadı
    // • dosya yazma hatası
    // • excel/json/csv üretim hatası
    //
    log("❌ Yedekleme hatası: $e", name: tag, stackTrace: st);

    final msg = "Hata: $e";
    onStatusChange(msg);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  } finally {
    // ------------------------------------------------------------------------
    // 7️⃣ Her durumda banner kapanır
    // ------------------------------------------------------------------------
    //
    // İster başarı ister hata olsun,
    // kullanıcı ekranda sonsuz loading görmemeli.
    //
    bannerCtrl.close();

    // ------------------------------------------------------------------------
    // 8️⃣ Exporting state reset 'lenir
    // ------------------------------------------------------------------------
    if (context.mounted) {
      onExportingChange(false);
    }
  }
}