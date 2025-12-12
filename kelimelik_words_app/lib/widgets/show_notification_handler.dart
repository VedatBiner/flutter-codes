// 📃 <----- show_word_dialog_handler.dart ----->
// Kelime varsa mesaj verip uyarıyor
// Kelime yoksa listeye ekliyor.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../constants/file_info.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../models/item_model.dart';
import '../services/notification_service.dart';
import 'item_dialog.dart';

const tag = "Notification_handler";

/// 📌 Yedekleme bildirim gösterir
///
void showBackupNotification(
  BuildContext rootCtx,
  String sqlPathDownload,
  String csvPathDownload,
  String jsonPathDownload,
  String excelPathDownload,
  String zipPathDownload,
) {
  return NotificationService.showCustomNotification(
    context: rootCtx,
    title: ' ',
    message: RichText(
      text: TextSpan(
        style: normalBlackText,
        children: [
          const TextSpan(
            text: '\nVeriler yedeklendi ... :\n\n',
            style: kelimeAddText,
          ),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(sqlPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(csvPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(jsonPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(excelPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(zipPathDownload)}\n"),
        ],
      ),
    ),
    icon: Icons.download_for_offline_outlined,
    iconColor: Colors.green,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade100,
    width: 260,
    height: 280,
  );
}

void showCreateDbNotification(
  BuildContext rootCtx,
  String sqlPathDownload,
  String csvPathDownload,
  String jsonPathDownload,
  String excelPathDownload,
  String zipPathDownload,
) {
  logCreate(
    sqlPathDownload,
    csvPathDownload,
    jsonPathDownload,
    excelPathDownload,
    zipPathDownload,
  );
  return NotificationService.showCustomNotification(
    context: rootCtx,
    title: ' ',
    message: RichText(
      text: TextSpan(
        style: normalBlackText,
        children: [
          const TextSpan(text: '\nVeriler yüklendi\n\n', style: kelimeAddText),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(sqlPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(csvPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(jsonPathDownload)}\n"),
          const TextSpan(text: '✅ '),
          TextSpan(text: "${p.basename(excelPathDownload)}\n"),
          // const TextSpan(text: '✅ '),
          // TextSpan(text: "${p.basename(zipPathDownload)}\n"),
        ],
      ),
    ),
    icon: Icons.download_for_offline_outlined,
    iconColor: Colors.green,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade100,
    width: 260,
    height: 260,
  );
}

void showShareFilesNotification(BuildContext rootCtx) {
  return NotificationService.showCustomNotification(
    context: rootCtx,
    title: ' ',
    message: RichText(
      text: const TextSpan(
        style: normalBlackText,
        children: [
          TextSpan(
            text: '\nDosyalar paylaşılmıştır ... \n\n',
            style: kelimeAddText,
          ),
        ],
      ),
    ),
    icon: Icons.download_for_offline_outlined,
    iconColor: Colors.green,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade100,
    width: 260,
    height: 200,
  );
}

/// 📌 Notification göster - Kelime Silindi
///
void showDeleteNotification(BuildContext context, Word word) {
  return NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Silme İşlemi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: word.word, style: kelimeText),
          const TextSpan(text: ' kelimesi silindi.', style: normalBlackText),
        ],
      ),
    ),
    icon: Icons.delete,
    iconColor: Colors.red,
    progressIndicatorColor: Colors.red,
    progressIndicatorBackground: Colors.red.shade100,
    width: 260,
    height: 200,
  );
}

/// 📌 Notification göster - Kelime güncellendi
///
void showUpdateNotification(BuildContext context, Word updated) {
  return NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Güncelleme İşlemi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: updated.word, style: kelimeAddText),
          const TextSpan(
            text: ' kelimesi güncellendi.',
            style: normalBlackText,
          ),
        ],
      ),
    ),
    icon: Icons.check_circle,
    iconColor: Colors.green,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade100,
    width: 260,
    height: 200,
  );
}

/// 📌 Notification göster - Kelime eklendi
///
void showAddNotification(BuildContext context, Word result) {
  /// 📌 Log yazdır
  log(logLine, name: tag);
  log("Kelime eklendi: ${result.word}", name: tag);
  log(logLine, name: tag);
  return NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Ekleme İşlemi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: result.word, style: kelimeAddText),
          const TextSpan(text: ' kelimesi eklendi.', style: normalBlackText),
        ],
      ),
    ),
    icon: Icons.check_circle,
    iconColor: Colors.blue.shade700,
    progressIndicatorColor: Colors.blue,
    progressIndicatorBackground: Colors.blue.shade200,
    width: 260,
    height: 200,
  );
}

/// 📌 Notification göster - Kelime var
///
void showExistNotification(BuildContext context, Word result) {
  return NotificationService.showCustomNotification(
    context: context,
    title: 'Uyarı Mesajı',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: result.word, style: kelimeExistText),
          const TextSpan(text: ' zaten var!', style: normalBlackText),
        ],
      ),
    ),
    icon: Icons.warning_amber_rounded,
    iconColor: Colors.orange,
    progressIndicatorColor: Colors.orange,
    progressIndicatorBackground: Colors.orange.shade100,
    width: 260,
    height: 200,
  );
}

Future<void> showWordDialogHandler(
  BuildContext context,
  VoidCallback onWordAdded,
  VoidCallback onCancelSearch, // arama kutusunu kapatmak için
) async {
  onCancelSearch(); // arama kutusunu kapat
  final result = await showDialog<Word>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const WordDialog(),
  );

  if (result != null) {
    final existing = await DbHelper.instance.getItem(result.word);

    if (existing != null) {
      /// ✅ Eğer kelime zaten varsa: Uyarı bildirimi göster
      if (!context.mounted) return;

      /// 📌 Notification göster - Kelime var
      showExistNotification(context, result);
      return;
    }

    await DbHelper.instance.insertRecord(result);
    onWordAdded();

    /// ✅ Başarılı ekleme bildirimi göster
    if (!context.mounted) return;

    /// 📌 Notification göster - Kelime eklendi
    showAddNotification(context, result);
  }
}

void logCreate(
  String csvPathDownload,
  String jsonPathDownload,
  xlsxPathDownload,
  sqlPathDownload,
  zipPathDownload,
) {
  log(logLine, name: tag);
  log("✅ CSV oluşturuldu: $csvPathDownload", name: tag);
  log("✅ JSON oluşturuldu: $jsonPathDownload", name: tag);
  log("✅ XLSX oluşturuldu: $xlsxPathDownload", name: tag);
  log("✅ SQL oluşturuldu: $sqlPathDownload", name: tag);
  // log("✅ ZIP oluşturuldu: $zipPathDownload", name: tag);
  log(logLine, name: tag);
}
