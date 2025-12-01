// <📜 ----- lib/utils/backup_notification_helper.dart ----->

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/file_info.dart';
import '../../widgets/bottom_banner_helper.dart';
import 'export_items.dart';

Future<void> backupNotificationHelper({
  required BuildContext context,
  required void Function(String status) onStatusChange,
  required void Function(bool exporting) onExportingChange,

  void Function(BuildContext ctx, ExportItems res)? onSuccessNotify,
  String? subfolder,
}) async {
  const tag = "BackupNotificationHelper";

  onExportingChange(true);
  onStatusChange("Export başlatılıyor...");

  /// 🔥 Tek satırda banner göster
  final bannerCtrl = showLoadingBanner(
    context,
    message: "Lütfen bekleyiniz,\nyedek hazırlanıyor...",
  );

  try {
    final res = await exportItemsToFileFormats(subfolder: subfolder ?? appName);

    onStatusChange("Tamamlandı: ${res.count} kayıt.");

    if (onSuccessNotify != null && context.mounted) {
      onSuccessNotify(context, res);
    }

    log("🔄 Export tamamlandı.", name: tag);
    log(logLine, name: tag);
  } catch (e) {
    if (context.mounted) {
      onStatusChange("Hata: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  } finally {
    bannerCtrl.close(); // 🔥 tek satır
    if (context.mounted) onExportingChange(false);
  }
}
