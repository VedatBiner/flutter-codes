// <📜 ----- lib/utils/backup_notification_helper.dart ----->
/*🔔 Yedek/Export tetikleme helper 'ı — UI 'dan bağımsız, yeniden kullanılabilir.

Değişiklik:
- Başarı bildirimi artık burada gösterilmiyor.
- Bunun yerine, (opsiyonel) onSuccessNotify callback 'i ile dışarıya devredildi.
Örn: onSuccessNotify: showBackupExportNotification

EKSTRA
- Export başlamadan önce sayaçlı alt-bant (LoadingBottomBanner) Overlay ile açılır,
export bitince kapatılır.
*/

// 📌 Dart hazır paketleri
import 'dart:async';
import 'dart:developer';

/// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

import '../constants/file_info.dart';
import '../services/export_items.dart';
import '../widgets/loading_bottom_banner.dart';

Future<void> backupNotificationHelper({
  required BuildContext context,
  required void Function(String status) onStatusChange,
  required void Function(bool exporting) onExportingChange,
  int pageSize = 1000,
  String? subfolder,

  /// ✅ Başarı bildirimi artık callback ile dışarıdan gösteriliyor
  void Function(BuildContext ctx, ExportItems res)? onSuccessNotify,
}) async {
  // 🔑 await ’ten ÖNCE messenger ’ı al
  final messenger = ScaffoldMessenger.maybeOf(context);

  // Başlangıç UI durumu
  onExportingChange(true);
  onStatusChange('JSON + CSV + Excel hazırlanıyor...');

  // ⬇️ Overlay tabanlı alt-bant (sayaçlı) hazırlığı
  OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);
  OverlayEntry? bannerEntry;
  final elapsedSec = ValueNotifier<int>(0);
  Timer? timer;

  void showBanner() {
    if (overlay == null) return;
    bannerEntry = OverlayEntry(
      builder:
          (_) => Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: LoadingBottomBanner(
                loading: true,
                elapsedSec: elapsedSec,
                message: 'Lütfen bekleyiniz, \nverilerin yedeği oluşturuluyor…',
              ),
            ),
          ),
    );
    overlay.insert(bannerEntry!);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSec.value = elapsedSec.value + 1;
    });
  }

  Future<void> hideBanner() async {
    timer?.cancel();
    timer = null;
    bannerEntry?.remove();
    bannerEntry = null;
    elapsedSec.dispose();
    // küçük bir nefes payı (görsel yırtılmayı önler)
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  // Banner ’ı göster
  showBanner();

  try {
    final res = await exportItemsToFileFormats(
      // pageSize parametresini ÇAĞIRMAYIN; export_words.dart imzanızda yok.
      subfolder: subfolder ?? appName,
    );

    if (!context.mounted) return;

    onStatusChange(
      'Tamam: ${res.count} kayıt • JSON: ${res.jsonPath} • CSV: ${res.csvPath} • XLSX: ${res.xlsxPath}',
    );

    // ✅ Bildirimi artık DIŞARIDAN göster
    if (onSuccessNotify != null) {
      onSuccessNotify(context, res);
    }

    // Log
    log(
      "-----------------------------------------------------------------------",
      name: "Backup_notification_helper",
    );
    log(
      "Toplam Kayıt sayısı : ${res.count} ✅",
      name: "Backup_notification_helper",
    );
    log(
      "-----------------------------------------------------------------------",
      name: "Backup_notification_helper",
    );
    log("✅ JSON yedeği → ${res.jsonPath}", name: "Backup_notification_helper");
    log("✅ CSV  yedeği → ${res.csvPath}", name: "Backup_notification_helper");
    log("✅ XLSX yedeği → ${res.xlsxPath}", name: "Backup_notification_helper");
    log("✅ SQL  yedeği → ${res.sqlPath}", name: "Backup_notification_helper");
    log(
      "-----------------------------------------------------------------------",
      name: "Backup_notification_helper",
    );
  } catch (e) {
    if (!context.mounted) return;
    onStatusChange('Hata: $e');
    messenger?.showSnackBar(SnackBar(content: Text('Hata: $e')));
  } finally {
    await hideBanner(); // mutlaka kaldır
    if (context.mounted) {
      onExportingChange(false);
    }
  }
}
