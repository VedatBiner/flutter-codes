// <📜 ----- lib/utils/backup_notification_helper.dart ----->
/*
  🔔 Yedek/Export tetikleme helper 'ı — UI 'dan bağımsız, yeniden kullanılabilir.
  Değişiklik:
  - Başarı bildirimi artık burada gösterilmiyor.
  - Bunun yerine, (opsiyonel) onSuccessNotify callback 'i ile dışarıya devredildi.
    Örn: onSuccessNotify: showBackupExportNotification
  EKSTRA
  - Export başlamadan önce sayaçlı alt-bant (LoadingBottomBanner) Overlay ile açılır,
    export bitince kapatılır.
*/

// 📌 Dart paketleri burada
import 'dart:async';
import 'dart:developer';

/// 📌 Flutter paketleri burada
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../services/export_items.dart'
    show exportWordsToJsonCsvXlsx, ExportResultX;
import '../widgets/loading_bottom_banner.dart';

Future<void> triggerBackupExport({
  required BuildContext context,
  required void Function(String status) onStatusChange,
  required void Function(bool exporting) onExportingChange,
  int pageSize = 1000,
  String? subfolder,

  /// ✅ Başarı bildirimi artık callback ile dışarıdan gösteriliyor
  void Function(BuildContext ctx, ExportResultX res)? onSuccessNotify,
}) async {
  // 🔑 await 'ten ÖNCE messenger 'ı al
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
      builder: (_) => Positioned(
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

  // Banner 'ı göster
  showBanner();
  const tag = 'backup_notification_helper';
  try {
    final res = await exportWordsToJsonCsvXlsx(
      pageSize: pageSize,
      subfolder: subfolder,
    );

    // 🔐 Context hala mounted mı kontrol et
    if (!context.mounted) {
      await hideBanner(); // Banner 'ı kaldır
      return;
    }

    onStatusChange(
      'Tamam: ${res.count} kayıt • JSON: ${res.jsonPath} • CSV: ${res.csvPath} • XLSX: ${res.xlsxPath}',
    );

    // ✅ Bildirimi artık DIŞARIDAN göster (context hala geçerliyken)
    if (onSuccessNotify != null && context.mounted) {
      onSuccessNotify(context, res);
    }

    // Log
    log("-----------------------------------------------", name: tag);
    log("Toplam Kayıt sayısı : ${res.count} ✅", name: tag);
    log("-----------------------------------------------", name: tag);
    log("✅ JSON yedeği → ${res.jsonPath}", name: tag);
    log("✅ CSV  yedeği → ${res.csvPath}", name: tag);
    log("✅ XLSX yedeği → ${res.xlsxPath}", name: tag);
    log("-----------------------------------------------", name: tag);
  } catch (e) {
    // 🔐 Hata durumunda da context kontrolü
    if (!context.mounted) {
      await hideBanner();
      return;
    }

    onStatusChange('Hata: $e');

    // 🔐 Messenger kullanımında da context kontrolü
    if (context.mounted) {
      messenger?.showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  } finally {
    await hideBanner(); // mutlaka kaldır

    // 🔐 onExportingChange çağrısında context kontrolü
    if (context.mounted) {
      onExportingChange(false);
    }
  }
}
