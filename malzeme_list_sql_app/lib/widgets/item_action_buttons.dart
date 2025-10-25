// 📃 <----- item_action_buttons.dart ----->
//
// Malzeme silme ve düzeltme işlemleri için ortak
// bir widget oluşturuldu.
// Bu dosya alphabet_malzeme_list.dart ve malzeme_list.dart
// dosyaları tarafından kullanılıyor.
//

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/Button_constants.dart';
import '../constants/text_constants.dart';

class MalzemeActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MalzemeActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /// 📌 Düzeltme butonu
        ElevatedButton.icon(
          onPressed: onEdit,
          icon: Image.asset('assets/images/pen.png', width: 32, height: 32),
          label: const Text('Düzelt', style: editButtonText),
          style: elevatedUpdateButtonStyle,
        ),

        const SizedBox(width: 8),

        /// 📌 Silme butonu
        ElevatedButton.icon(
          onPressed: onDelete,
          icon: Image.asset('assets/images/trash.png', width: 32, height: 32),
          label: const Text('Sil', style: editButtonText),
          style: elevateDeleteButtonStyle,
        ),

        const SizedBox(width: 8),
      ],
    );
  }
}
