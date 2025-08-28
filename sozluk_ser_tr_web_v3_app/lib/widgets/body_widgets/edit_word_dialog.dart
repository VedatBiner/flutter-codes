// <📜 ----- lib/widgets/body_widgets/edit_word_dialog.dart ----->

// 📌 Flutter paketleri burada
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../../constants/button_constants.dart';
import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';
import '../../models/word_model.dart';
import '../../services/notification_service.dart';
import '../../services/word_service.dart';

/// Kelime düzenleme diyaloğunu açar.
/// Kaydedilirse serviste günceller, snackbar gösterir ve onRefetch çağırır.
/// Kaydedildiyse true, iptal/başarısızsa false döner.
Future<bool> editWordDialog({
  required BuildContext context,
  required Word word,
  required Future<void> Function() onRefetch,
}) async {
  final formKey = GlobalKey<FormState>();
  final sirpcaCtl = TextEditingController(text: word.sirpca);
  final turkceCtl = TextEditingController(text: word.turkce);

  String cap(String s) => s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);

  final updated = await showDialog<Word>(
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
          'Kelimeyi Düzenle',
          style: dialogTitle,
          textAlign: TextAlign.center,
        ),
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            TextFormField(
              controller: sirpcaCtl,
              decoration: InputDecoration(
                labelText: 'Sırpça kelime',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: drawerColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.amber.shade600,
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Boş olamaz' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: turkceCtl,
              decoration: InputDecoration(
                labelText: 'Türkçe karşılığı',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: drawerColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.amber.shade600,
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Boş olamaz' : null,
            ),
          ],
        ),
      ),

      // 🔽 Butonları sola hizala + sola hafif iç boşluk ver
      actionsAlignment: MainAxisAlignment.start,
      actionsPadding: const EdgeInsets.only(left: 84, bottom: 16),

      actions: [
        ElevatedButton(
          style: elevatedCancelButtonStyle,
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('İptal', style: editButtonText),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: elevatedAddButtonStyle,
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              final w = word.copyWith(
                sirpca: cap(sirpcaCtl.text.trim()),
                turkce: cap(turkceCtl.text.trim()),
              );
              Navigator.of(context).pop(w);
            }
          },
          child: const Text('Güncelle', style: editButtonText),
        ),
      ],
    ),
  );

  if (updated == null) return false;

  await WordService.updateWord(updated, oldSirpca: word.sirpca);
  if (!context.mounted) return false;

  NotificationService.showCustomNotification(
    context: context,
    title: 'Kelime Güncelleme İşlemi',
    message: RichText(
      text: const TextSpan(
        children: [
          TextSpan(text: ' Kelime güncellenmiştir', style: normalBlackText),
        ],
      ),
    ),
    icon: Icons.check_circle,
    iconColor: Colors.green.shade700,
    progressIndicatorColor: Colors.green,
    progressIndicatorBackground: Colors.green.shade200,
  );

  await onRefetch();
  return true;
}
