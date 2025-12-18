// 📃 <----- item_dialog.dart ----->
//
// Yeni kelime ekleme & düzenleme dialog 'u.
// SafeTextField entegrasyonu ile cihaz klavye hataları tamamen çözülür.
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/widgets/safe_text_field.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/button_constants.dart';
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../models/item_model.dart';

class WordDialog extends StatefulWidget {
  final Word? word;

  const WordDialog({super.key, this.word});

  @override
  State<WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _wordController;
  late final TextEditingController _meaningController;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.word?.word ?? '');
    _meaningController = TextEditingController(
      text: widget.word?.meaning ?? '',
    );
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    super.dispose();
  }

  /// 🔠 İlk harfi büyük yap
  String _capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: cardLightColor,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: drawerColor, width: 5),
      ),

      // 📌 Üst başlık barı
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
          widget.word == null ? 'Yeni Kelime Ekle' : 'Kelimeyi Düzenle',
          style: dialogTitle,
          textAlign: TextAlign.center,
        ),
      ),

      // 📌 İçerik
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),

            // ================================
            //  🔡 Kelime Girişi — SafeTextField
            // ================================
            SafeTextField(
              controller: _wordController,
              labelText: "Kelime",
              hint: "Yeni kelime giriniz",
              hintStyle: hintStil,
              autofocus: true,
              validator: (v) => v == null || v.isEmpty ? "Boş olamaz" : null,
              borderColor: menuColor,
              focusBorderColor: drawerColor,
            ),

            const SizedBox(height: 24),

            // ===================================
            //  📘 Anlam Girişi — SafeTextField
            // ===================================
            SafeTextField(
              controller: _meaningController,
              labelText: "Anlamı",
              hint: "Kelimenin anlamını giriniz",
              hintStyle: hintStil,
              validator: (v) => v == null || v.isEmpty ? "Boş olamaz" : null,
              borderColor: menuColor,
              focusBorderColor: drawerColor,
            ),
          ],
        ),
      ),

      // 📌 Alt butonlar
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// ❌ İptal
            ElevatedButton(
              style: elevatedCancelButtonStyle,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal', style: editButtonText),
            ),

            const SizedBox(width: 16),

            /// 💾 Kaydet
            ElevatedButton(
              style: elevatedAddButtonStyle,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedWord = Word(
                    id: widget.word?.id,
                    word: _capitalize(_wordController.text.trim()),
                    meaning: _capitalize(_meaningController.text.trim()),
                  );
                  Navigator.of(context).pop(updatedWord);
                }
              },
              child: const Text('Kaydet', style: editButtonText),
            ),

            const SizedBox(width: 12),
          ],
        ),
      ],
    );
  }
}
