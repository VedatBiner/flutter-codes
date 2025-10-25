// 📃 <----- item_action_buttons.dart ----->
// Kelime silme ve düzeltme işlemleri için ortak
// bir widget oluşturuldu.
// Bu dosya alphabet_word_list.dart ve word_list.dart
// dosyaları tarafından kullanılıyor.
//
import 'package:flutter/material.dart';

import '../constants/Button_constants.dart';
import '../constants/text_constants.dart';

class WordActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WordActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: onEdit,
          icon: Image.asset('assets/images/pen.png', width: 32, height: 32),
          label: const Text('Düzelt', style: editButtonText),
          style: elevatedUpdateButtonStyle,
        ),
        const SizedBox(width: 8),
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
