// <📜 ----- lib/utils/backup_notification_helper.dart ----->
/*
  🔔 Yedek/Export tetikleme helper 'ı — UI 'dan bağımsız, yeniden kullanılabilir

  EKSTRA
  - Export başlamadan önce sayacı olan bir alt-bant (LoadingBottomBanner) Overlay ile açılır,
    export bitince kapatılır.
*/

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../constants/text_constants.dart';
import '../services/export_words.dart';
import '../services/notification_service.dart';
import '../widgets/loading_bottom_banner.dart';

Future<void> triggerBackupExport({
  required BuildContext context,
  required void Function(String status) onStatusChange,
  required void Function(bool exporting) onExportingChange,
  int pageSize = 1000,
  String? subfolder,
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

  // Banner ’ı göster
  showBanner();

  try {
    final res = await exportWordsToJsonCsvXlsx(
      pageSize: pageSize,
      subfolder: subfolder,
    );

    if (!context.mounted) return;

    onStatusChange(
      'Tamam: ${res.count} kayıt • JSON: ${res.jsonPath} • CSV: ${res.csvPath} • XLSX: ${res.xlsxPath}',
    );

    // Başarılı bildirim
    NotificationService.showCustomNotification(
      context: context,
      title: 'Yedek Oluşturuldu',
      message: RichText(
        text: TextSpan(
          style: normalBlackText,
          children: [
            const TextSpan(
              text: "\nVeriler yedeklendi\n",
              style: kelimeAddText,
            ),
            const TextSpan(
              text: "Toplam Kayıt sayısı:\n",
              style: notificationTitle,
            ),
            TextSpan(text: "${res.count} ✅\n", style: notificationText),
            const TextSpan(text: "JSON yedeği →\n", style: notificationItem),
            TextSpan(text: "${res.jsonPath} ✅\n", style: notificationText),
            const TextSpan(text: "CSV yedeği →\n", style: notificationItem),
            TextSpan(text: "${res.csvPath} ✅\n", style: notificationText),
            const TextSpan(text: "XLSX yedeği →\n", style: notificationItem),
            TextSpan(text: "${res.xlsxPath} ✅\n", style: notificationText),
          ],
        ),
      ),
      icon: Icons.download_for_offline_outlined,
      iconColor: Colors.green,
      progressIndicatorColor: Colors.green,
      progressIndicatorBackground: Colors.greenAccent.shade100,
      height: 340,
      width: 360,
    );

    log("-----------------------------------------------", name: "Backup");
    log("Toplam Kayıt sayısı : ${res.count} ✅", name: "Backup");
    log("-----------------------------------------------", name: "Backup");
    log("JSON yedeği → ${res.jsonPath} ✅", name: "Backup");
    log("CSV  yedeği → ${res.csvPath} ✅", name: "Backup");
    log("XLSX yedeği → ${res.xlsxPath} ✅", name: "Backup");
    log("-----------------------------------------------", name: "Backup");
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
