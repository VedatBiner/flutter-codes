// <📜 ----- lib/utils/backup_notification_helper.dart ----->
//
// UI → backupNotificationHelper()
// export işlemlerini tetikler, LoadingBanner ile ilerleme gösterir,
// sonuç gelince dışarıdan Notification gösterilmesini sağlar.
//

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/file_info.dart';
import '../../widgets/loading_bottom_banner.dart';
import 'export_items.dart';

Future<void> backupNotificationHelper({
  required BuildContext context,
  required void Function(String status) onStatusChange,
  required void Function(bool exporting) onExportingChange,

  /// ExportItems → UI Notification
  void Function(BuildContext ctx, ExportItems res)? onSuccessNotify,

  String? subfolder,
}) async {
  const tag = "BackupNotificationHelper";
  onExportingChange(true);
  onStatusChange("Export başlatılıyor...");

  // Banner hazırlığı
  OverlayEntry? bannerEntry;
  final elapsedSec = ValueNotifier<int>(0);
  Timer? timer;

  final overlay = Overlay.of(context, rootOverlay: true);

  void showBanner() {
    bannerEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Material(
          color: Colors.transparent,
          child: LoadingBottomBanner(
            loading: true,
            elapsedSec: elapsedSec,
            message: "Lütfen bekleyiniz,\nyedek hazırlanıyor...",
          ),
        ),
      ),
    );

    overlay?.insert(bannerEntry!);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSec.value++;
    });
  }

  Future<void> hideBanner() async {
    timer?.cancel();
    bannerEntry?.remove();
    elapsedSec.dispose();
    await Future.delayed(const Duration(milliseconds: 50));
  }

  showBanner();

  try {
    // ExportItems → JSON/CSV/XLSX/SQL/ZIP yolları
    final res = await exportItemsToFileFormats(subfolder: subfolder ?? appName);

    onStatusChange("Tamamlandı: ${res.count} kayıt.");

    // Dışarıya bildirim gösterme delegesi
    if (onSuccessNotify != null && context.mounted) {
      onSuccessNotify(context, res);
    }

    log("🔄 Export tamamlandı.", name: tag);
  } catch (e) {
    if (context.mounted) {
      onStatusChange("Hata: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  } finally {
    await hideBanner();
    if (context.mounted) {
      onExportingChange(false);
    }
  }
}
