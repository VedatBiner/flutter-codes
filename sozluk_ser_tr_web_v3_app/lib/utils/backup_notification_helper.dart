// <📜 ----- lib/utils/backup_notification_helper.dart ----->
/*
  🔔 Yedek/Export tetikleme helper'ı — UI'dan bağımsız, yeniden kullanılabilir

  NE YAPAR?
  - Dışa aktarma sürecini başlatır (JSON+CSV+XLSX).
  - UI durumunu güncellemek için dışarıdan verilen callback’leri çağırır:
      • onExportingChange(true/false)  → buton kilidi / loading
      • onStatusChange(text)           → ekrandaki durum metni
  - Snackbar göstermek için, await'ten önce alınan ScaffoldMessenger ile güvenli çağrı yapar.
  - await sonrasında BuildContext kullanmadan önce `context.mounted` ile güvenlik sağlar
    (lint: use_build_context_synchronously uyarısını önlemek için).

  KULLANIM
    await triggerBackupExport(
      context: context,
      onStatusChange: (s) => setState(() => status = s),
      onExportingChange: (v) => setState(() => exporting = v),
      pageSize: 1000,
      subfolder: appName, // info_constants.dart'tan
    );
*/

import 'dart:developer';

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
  // 🔑 await’ten ÖNCE messenger’ı al → context’i saklamadan güvenli kullanım
  final messenger = ScaffoldMessenger.maybeOf(context);

  // Başlangıç UI durumu
  onExportingChange(true);
  onStatusChange('JSON + CSV + Excel hazırlanıyor...');

  try {
    final res = await exportWordsToJsonCsvXlsx(
      pageSize: pageSize,
      subfolder: subfolder,
    );

    // await sonrası context kullanmadan önce mutlaka kontrol et
    if (!context.mounted) return;

    onStatusChange(
      'Tamam: ${res.count} kayıt • JSON: ${res.jsonPath} • CSV: ${res.csvPath} • XLSX: ${res.xlsxPath}',
    );

    // Başarılı bildirim (UI içinde custom sheet/dialog vb.)
    NotificationService.showCustomNotification(
      context:
          context, // ✅ rootCtx tutmuyoruz; mounted kontrolünden sonra kullanıyoruz
      title: 'Yedek Oluşturuldu',
      message: RichText(
        text: TextSpan(
          style: normalBlackText,
          children: [
            const TextSpan(
              text: "\nVeriler yedeklendi \n",
              style: kelimeAddText,
            ),
            TextSpan(text: "Toplam Kayıt sayısı : \n ${res.count} ✅ \n"),
            TextSpan(text: "JSON yedeği → \n ${res.jsonPath} ✅ \n"),
            TextSpan(text: "CSV yedeği → \n ${res.csvPath} ✅ \n"),
            TextSpan(text: "XLSX yedeği → \n ${res.xlsxPath} ✅ \n"),
          ],
        ),
      ),
      icon: Icons.download_for_offline_outlined,
      iconColor: Colors.green,
      progressIndicatorColor: Colors.green,
      progressIndicatorBackground: Colors.green.shade100,
    );
    log("-----------------------------------------------", name: "Backup");
    log("Toplam Kayıt sayısı : ${res.count} ✅", name: "Backup");
    log("-----------------------------------------------", name: "Backup");
    log("JSON yedeği → ${res.jsonPath} ✅", name: "Backup");
    log("CSV yedeği → ${res.csvPath} ✅", name: "Backup");
    log("XLSX yedeği → ${res.xlsxPath} ✅", name: "Backup");
    log("-----------------------------------------------", name: "Backup");
  } catch (e) {
    if (!context.mounted) return;
    onStatusChange('Hata: $e');
    messenger?.showSnackBar(SnackBar(content: Text('Hata: $e')));
  } finally {
    if (!context.mounted) return;
    onExportingChange(false);
  }
}
