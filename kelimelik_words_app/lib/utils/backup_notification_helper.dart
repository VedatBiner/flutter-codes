// <📜 ----- lib/utils/backup_notification_helper.dart ----->
//
//  Yedekleme (Export) sürecini UI ’dan bağımsız yöneten yardımcı dosya.
//  Eksiksiz SQL → CSV → JSON → XLSX → ZIP pipeline ’ı sil_export_items.dart üzerinden çalıştırır.
//
//  • Alt bant (LoadingBottomBanner) tek satır ile açılır: showLoadingBanner()
//  • Export sürecini duruma göre onStatusChange ile bildirir
//  • Export tamamlanınca onSuccessNotify ile UI tarafına tüm dosya path ’leri gönderilir
//  • Hata durumunda Snack bar ile kullanıcı bilgilendirilir
//
// ---------------------------------------------------------------------------

import 'dart:developer';

import 'package:flutter/material.dart';

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

  /// İsteğe bağlı: Download/{subfolder} hedef klasörü
  String? subfolder,
}) async {
  const tag = "BackupNotificationHelper";

  // İlk durum bildirimi
  onExportingChange(true);
  onStatusChange("Export başlatılıyor...");

  // ----------------------------------------------------------
  // 🔥 Alt bant banner → Tek satırlık helper ile açılır
  // ----------------------------------------------------------
  final bannerCtrl = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz,\nyedek hazırlanıyor...",
  );

  try {
    // ----------------------------------------------------------
    // 🚀 Tüm export işlemleri (SQL → CSV/JSON/XLSX → ZIP)
    // sil_export_items.dart → file_exporter.dart zinciri
    // ----------------------------------------------------------
    final res = await exportItemsToFileFormats(subfolder: subfolder ?? appName);

    // Kullanıcıya bilgi ver
    onStatusChange("Tamamlandı: ${res.count} kayıt.");

    // UI tarafında başarı bildirimi (notification)
    if (onSuccessNotify != null && context.mounted) {
      onSuccessNotify(context, res);
    }

    // Log çıktıları
    log("🔄 Export tamamlandı.", name: tag);
    log(logLine, name: tag);
  } catch (e) {
    // ----------------------------------------------------------
    // ❌ Hata yakalandı
    // ----------------------------------------------------------
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

    // Export durumu bitti
    if (context.mounted) {
      onExportingChange(false);
    }
  }
}
