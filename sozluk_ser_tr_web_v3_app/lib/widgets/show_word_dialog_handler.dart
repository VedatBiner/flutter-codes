// <📜 ----- lib/handlers/show_word_dialog_handler.dart ----->

import 'dart:developer';

import 'package:flutter/material.dart';

import '../constants/text_constants.dart';
import '../models/word_model.dart';
import '../services/export_words.dart' show ExportResult, ExportResultX;
import '../services/notification_service.dart';
import '../services/word_service.dart';
import '../widgets/body_widgets/delete_word_dialog.dart';
import '../widgets/body_widgets/edit_word_dialog.dart';
import '../widgets/word_dialog.dart';

/// ADD: Yeni kelime ekleme diyaloğu
Future<void> showWordDialogHandler(
  BuildContext context,
  VoidCallback onWordAdded,
) async {
  final result = await showDialog<Word>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const WordDialog(),
  );

  if (result != null) {
    /// ❓Kelime varsa bildirim göster
    final exists = await WordService.wordExists(result.sirpca);
    if (exists) {
      if (!context.mounted) return;
      NotificationService.showCustomNotification(
        context: context,
        title: 'Uyarı Mesajı',
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: result.sirpca, style: kelimeExistText),
              const TextSpan(text: ' zaten var!', style: normalBlackText),
            ],
          ),
        ),
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
        progressIndicatorColor: Colors.orange,
        progressIndicatorBackground: Colors.orange.shade100,
      );
      return;
    }

    /// 📌 Kelime yoksa ekle
    await WordService.addWord(result);
    log('Kelime eklendi: ${result.sirpca}', name: 'ADD_WORD');

    onWordAdded();
    if (!context.mounted) return;

    NotificationService.showCustomNotification(
      context: context,
      title: 'Kelime Ekleme İşlemi',
      message: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: result.sirpca, style: kelimeAddText),
            const TextSpan(text: ' kelimesi eklendi.', style: normalBlackText),
          ],
        ),
      ),
      icon: Icons.check_circle,
      iconColor: Colors.blue.shade700,
      progressIndicatorColor: Colors.blue,
      progressIndicatorBackground: Colors.blue.shade200,
      height: 140,
      width: 300,
    );
  }
}

/// 📌 Var olan kelimeyi güncelle
Future<void> showEditWordDialogHandler(
  BuildContext context, {
  required Word word,
  required Future<void> Function() onRefetch,
}) async {
  final ok = await editWordDialog(
    context: context,
    word: word,
    onRefetch: onRefetch, // güncelleme ve refetch içeride
  );

  if (!context.mounted || !ok) return;

  // ✅ Bildirim burada
  NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Güncelleme İşlemi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: word.sirpca, style: kelimeUpdateText),
          const TextSpan(
            text: ' kelimesi güncellenmiştir',
            style: normalBlackText,
          ),
        ],
      ),
    ),
    icon: Icons.check_circle,
    iconColor: Colors.green.shade700,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade200,
    height: 140,
    width: 300,
  );
}

/// 📌 Silme akışını yönetir:
/// - deleteWordDialog ile onay alır + siler + refetch eder
/// - başarılıysa burada bildirimi gösterir
Future<bool> showDeleteWordHandler({
  required BuildContext context,
  required Word word,
  required Future<void> Function() onRefetch,
}) async {
  final deleted = await deleteWordDialog(
    context: context,
    word: word,
    onRefetch: onRefetch,
  );

  if (!deleted || !context.mounted) return false;

  // 🔔 Bildirimi burada
  NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Silme İşlemi',
    message: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: word.sirpca, style: kelimeDeleteText),
          const TextSpan(text: ' Kelimesi silinmiştir', style: normalBlackText),
        ],
      ),
    ),
    icon: Icons.delete,
    iconColor: Colors.red.shade700,
    progressIndicatorColor: Colors.red,
    progressIndicatorBackground: Colors.red.shade200,
    height: 140,
    width: 300,
  );

  return true;
}

/// ✅ BACKUP başarı bildirimi artık burada (helper, callback ile burayı çağırır)
void showBackupExportNotification(BuildContext context, ExportResultX res) {
  NotificationService.showCustomNotification(
    context: context,
    title: 'Yedek Oluşturuldu',
    message: RichText(
      text: TextSpan(
        style: normalBlackText,
        children: [
          const TextSpan(text: "\nVeriler yedeklendi\n", style: kelimeAddText),
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
}
