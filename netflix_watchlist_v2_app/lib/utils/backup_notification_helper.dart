// <📜 ----- lib/utils/backup_notification_helper.dart ----->
//
// Yedekleme (Export) sürecini UI’dan bağımsız yöneten yardımcı.
// -----------------------------------------------------------
// • Alt bant (LoadingBottomBanner) tek satır ile açılır
// • Export sürecini durumlara göre onStatusChange ile bildirir
// • Export tamamlanınca onSuccessNotify ile UI tarafına path’ler gönderilir
// • Hata durumunda SnackBar ile kullanıcı bilgilendirilir
//
// Not:
// ✅ Temp klasör temizliği export_items.dart içinde yapılır.
// ❌ Burada ekstra klasör silme yapılmaz (çifte silme riski yok).
// ---------------------------------------------------------------------------

import 'dart:developer';

import 'package:flutter/material.dart';

import 'export_items.dart';
import '../widgets/bottom_banner_helper.dart';

Future<void> backupNotificationHelper({
  required BuildContext context,

  /// Export aşamalarını dışarıya bildirmek için
  required void Function(String status) onStatusChange,

  /// Export başladı / bitti bilgisi için
  required void Function(bool exporting) onExportingChange,

  /// Export tamamlanınca sonuç UI’ya iletilir
  void Function(BuildContext ctx, ExportItems res)? onSuccessNotify,
}) async {
  const tag = "backup_notification_helper";

  // İlk durum bildirimi
  onExportingChange(true);
  onStatusChange("Yedek hazırlanıyor...");

  // Banner aç
  final bannerCtrl = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz,\nyedek hazırlanıyor...",
  );

  try {
    // Export (CSV + JSON + XLSX) -> Download/{appName} içine kopyalar
    final res = await exportItemsToFileFormats(
      subfolder: 'netflix_watch_list_backups',
    );

    onStatusChange("Tamamlandı: ${res.count} kayıt.");

    // UI tarafında başarı bildirimi
    if (onSuccessNotify != null && context.mounted) {
      onSuccessNotify(context, res);
    }

    log("✅ Yedekleme tamamlandı.", name: tag);
  } catch (e, st) {
    log("❌ Yedekleme hatası: $e", name: tag, stackTrace: st);

    final msg = "Hata: $e";
    onStatusChange(msg);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  } finally {
    // Banner kapanır
    bannerCtrl.close();

    if (context.mounted) {
      onExportingChange(false);
    }
  }
}
