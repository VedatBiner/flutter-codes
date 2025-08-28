// <📜 ----- lib/widgets/body_widgets/delete_word_dialog.dart ----->

// 📌 Flutter paketleri burada
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/button_constants.dart';
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../models/word_model.dart';
import '../../services/notification_service.dart';
import '../../services/word_service.dart';

/// Silme diyaloğunu açar ve onaylanırsa kaydı siler.
/// Başarılı olursa `true`, iptal edilirse `false` döner.
Future<bool> deleteWordDialog({
  required BuildContext context,
  required Word word,
  required Future<void> Function() onRefetch,
}) async {
  final ok =
      await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: cardLightColor,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: drawerColor, width: 5),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: drawerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Text(
              'Silinsin mi?',
              style: dialogTitle,
              textAlign: TextAlign.center,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '"${word.sirpca}" kelimesini silmek istediğinize emin misiniz?',
            ),
          ),
          // 🔽 Butonları sola hizala + sola hafif iç boşluk ver
          actionsAlignment: MainAxisAlignment.start,
          actionsPadding: const EdgeInsets.only(left: 248, bottom: 16),
          actions: [
            ElevatedButton(
              style: elevatedCancelButtonStyle,
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İptal', style: editButtonText),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: elevatedAddButtonStyle,
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sil', style: editButtonText),
            ),
          ],
        ),
      ) ??
      false;

  if (!ok) return false;

  await WordService.deleteWord(word);
  if (!context.mounted) return false;

  NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Silme İşlemi',
    message: RichText(
      text: const TextSpan(
        children: [
          TextSpan(text: ' Kelime silinmiştir', style: normalBlackText),
        ],
      ),
    ),
    icon: Icons.delete,
    iconColor: Colors.red.shade700,
    progressIndicatorColor: Colors.red,
    progressIndicatorBackground: Colors.red.shade200,
  );

  // ScaffoldMessenger.of(
  //   context,
  // ).showSnackBar(const SnackBar(content: Text('Silindi')));

  await onRefetch();
  return true;
}
