// 📃 <----- item_dialog.dart ----->

import 'package:flutter/material.dart';

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

  late TextEditingController _wordController;
  late TextEditingController _meaningController;

  // 🔥 Klavye donmasını engelleyen FocusNode
  final FocusNode _wordFocus = FocusNode();
  final FocusNode _meaningFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _wordController = TextEditingController(text: widget.word?.word ?? '');
    _meaningController = TextEditingController(
      text: widget.word?.meaning ?? '',
    );

    // 🔥 Güvenli gecikmeli autofocus — Flutter bug fix
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          _wordFocus.requestFocus();
        }
      });
    });
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _wordFocus.dispose();
    _meaningFocus.dispose();
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

      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),

            /// 🔥 Otomatik focus artık buradan yönlendirilir
            TextFormField(
              controller: _wordController,
              focusNode: _wordFocus,
              decoration: InputDecoration(
                labelText: 'Kelime',
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
              validator: (value) =>
                  value == null || value.isEmpty ? 'Boş olamaz' : null,
              onFieldSubmitted: (_) => _meaningFocus.requestFocus(),
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _meaningController,
              focusNode: _meaningFocus,
              decoration: InputDecoration(
                labelText: 'Anlamı',
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
              validator: (value) =>
                  value == null || value.isEmpty ? 'Boş olamaz' : null,
              onFieldSubmitted: (_) {},
            ),
          ],
        ),
      ),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: elevatedCancelButtonStyle,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal', style: editButtonText),
            ),
            const SizedBox(width: 16),

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
