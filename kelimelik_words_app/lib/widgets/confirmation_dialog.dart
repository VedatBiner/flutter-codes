// 📃 <----- confirmation_dialog.dart ----->
// Kelime silme ve veri tabanı işlemleri için ortak
// bir widget oluşturuldu.
// Bu dosya alphabet_word_list.dart, word_list.dart ve
// custom_drawer.dart dosyaları tarafından kullanılıyor.
//

import 'package:flutter/material.dart';

import '../constants/Button_constants.dart';
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  String confirmText = 'Evet',
  String cancelText = 'İptal',
  Color? confirmColor,
  Color? cancelColor,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AlertDialog(
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
            child: Text(title, style: dialogTitle, textAlign: TextAlign.center),
          ),
          content: content,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: elevatedCancelButtonStyle,
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelText, style: editButtonText),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: elevatedConfirmButtonStyle,
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(confirmText, style: editButtonText),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
  );
}
