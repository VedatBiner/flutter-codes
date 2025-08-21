// <📜 ----- lib/utils/backup_notification_helper.dart ----->
/*
  🔔 Yedek/Export tetikleme helper'ı — UI'dan bağımsız, yeniden kullanılabilir

  NE YAPAR?
  - Dışa aktarma sürecini başlatır (JSON+CSV+XLSX).
  - UI durumunu güncellemek için dışarıdan verilen callback’leri çağırır:
      • onExportingChange(true/false)  → buton kilidi / loading
      • onStatusChange(text)           → ekrandaki durum metni
  - Snackbar göstermek için, await'ten önce alınan ScaffoldMessenger ile güvenli çağrı yapar.
  - Widget dispose olmuşsa (navigation vb.), context.mounted ile güvenli çıkış yapar.

  KULLANIM
    await triggerBackupExport(
      context: context,
      onStatusChange: (s) => setState(() => status = s),
      onExportingChange: (v) => setState(() => exporting = v),
      pageSize: 1000,
      subfolder: appName, // info_constants.dart'tan
    );
*/

import 'package:flutter/material.dart';

import '../constants/text_constants.dart';
import '../services/export_words.dart';
import '../services/notification_service.dart';

Future<void> triggerBackupExport({
  required BuildContext context,
  required void Function(String status) onStatusChange,
  required void Function(bool exporting) onExportingChange,
  int pageSize = 1000,
  String? subfolder,
}) async {
  /* 🔑  Linter uyarısı olmasın diye context ’i hemen sakla */
  final rootCtx = Navigator.of(context, rootNavigator: true).context;
  // Başlangıç UI durumu
  // onExportingChange(true);
  onStatusChange('JSON + CSV + Excel hazırlanıyor...');
  String status = 'Hazır. Konsolu kontrol edin.';
  bool exporting = false;

  // await 'ten ÖNCE messenger 'ı al → use_build_context_synchronously lint yok
  final messenger = ScaffoldMessenger.maybeOf(context);

  try {
    final res = await exportWordsToJsonCsvXlsx(
      pageSize: pageSize,
      subfolder: subfolder,
    );

    if (!context.mounted) return;

    onStatusChange(
      'Tamam: ${res.count} kayıt • JSON: ${res.jsonPath} • CSV: ${res.csvPath} • XLSX: ${res.xlsxPath}',
    );

    NotificationService.showCustomNotification(
      context: rootCtx, // ← güvenli
      title: 'Yedek Oluşturuldu',
      message: RichText(
        text: TextSpan(
          style: normalBlackText,
          children: [
            const TextSpan(
              text: "\nVeriler yedeklendi \n",
              style: kelimeAddText,
            ),
            TextSpan(text: "Toplam : ${res.count} kayıt ✅ \n"),
            TextSpan(text: "JSON → ${res.jsonPath} ✅ \n"),
            TextSpan(text: "CSV → ${res.csvPath} ✅ \n"),
            TextSpan(text: "XLSX → ${res.xlsxPath} ✅ \n"),
          ],
        ),
      ),
      icon: Icons.download_for_offline_outlined,
      iconColor: Colors.green,
      progressIndicatorColor: Colors.green,
      progressIndicatorBackground: Colors.green.shade100,
    );
  } catch (e) {
    if (!context.mounted) return;
    onStatusChange('Hata: $e');
    messenger?.showSnackBar(SnackBar(content: Text('Hata: $e')));
  } finally {
    if (!context.mounted) return;
    onExportingChange(false);
  }
}
