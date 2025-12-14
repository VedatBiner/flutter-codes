// <📜 ----- lib/utils/backup_notification_helper.dart ----->
//
//  Yedekleme (Export) sürecini UI ’dan bağımsız yöneten yardımcı dosya.
//  SQL → CSV → JSON → XLSX pipeline ’ını çalıştırır.
//  ❌ ZIP şu an devre dışıdır.
//
//  • Alt bant (LoadingBottomBanner) tek satır ile açılır
//  • Export sürecini duruma göre onStatusChange ile bildirir
//  • Export tamamlanınca onSuccessNotify ile UI tarafına path’ler gönderilir
//  • Hata durumunda SnackBar ile kullanıcı bilgilendirilir
//
// ---------------------------------------------------------------------------

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/file_info.dart';
import '../services/export_items.dart';
import '../widgets/bottom_banner_helper.dart';

Future<void> backupNotificationHelper({
  required BuildContext context,

  /// Export aşamalarını dışarıya bildirmek için
  required void Function(String status) onStatusChange,

  /// Export başladı / bitti bilgisi için
  required void Function(bool exporting) onExportingChange,

  /// Export tamamlanınca sonuç UI ’ya iletilir
  void Function(BuildContext ctx, ExportItems res)? onSuccessNotify,
}) async {
  const tag = "BackupNotificationHelper";

  // İlk durum bildirimi
  onExportingChange(true);
  onStatusChange("Yedek hazırlanıyor...");

  // ----------------------------------------------------------
  // 🔥 Alt bant banner → Tek satırlık helper ile açılır
  // ----------------------------------------------------------
  final bannerCtrl = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz,\nyedek hazırlanıyor...",
  );

  try {
    // ----------------------------------------------------------
    // 🚀 Export işlemleri
    // • Dosyalar GEÇİCİ olarak:
    //   app_flutter/kelimelik_backups
    //   dizinine üretilir
    // • Download kopyalama + cleanup
    //   export_items.dart içinde yapılır
    // ----------------------------------------------------------
    final res = await exportItemsToFileFormats();

    // Kullanıcıya bilgi ver
    onStatusChange("Tamamlandı: ${res.count} kayıt.");

    // UI tarafında başarı bildirimi
    if (onSuccessNotify != null && context.mounted) {
      onSuccessNotify(context, res);
    }

    log("✅ Yedekleme tamamlandı.", name: tag);

    // ----------------------------------------------------------
    // 🧹 GEÇİCİ kelimelik_words_app klasörünü SİL
    // ----------------------------------------------------------
    final docsDir = await getApplicationDocumentsDirectory();
    final tempBackupDir = Directory(
      join(docsDir.path, appName), // kelimelik_words_app
    );

    if (await tempBackupDir.exists()) {
      await tempBackupDir.delete(recursive: true);
      log("🧹 Geçici klasör silindi: ${tempBackupDir.path}", name: tag);
    }
  } catch (e, st) {
    // ----------------------------------------------------------
    // ❌ Hata yakalandı
    // ----------------------------------------------------------
    log("❌ Yedekleme hatası: $e", name: tag, stackTrace: st);

    if (context.mounted) {
      final msg = "Hata: $e";
      onStatusChange(msg);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  } finally {
    // ----------------------------------------------------------
    // 🔥 HER DURUMDA banner kapanır
    // ----------------------------------------------------------
    bannerCtrl.close();

    if (context.mounted) {
      onExportingChange(false);
    }
  }
}
