// 📃 <----- word_dialog.dart ----->

import 'package:flutter/material.dart';

import '../constants/Button_constants.dart';
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../models/word_model.dart';

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

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.word?.sirpca ?? '');
    _meaningController = TextEditingController(text: widget.word?.turkce ?? '');
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
            TextFormField(
              controller: _wordController,
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
              autofocus: true,
              textInputAction: TextInputAction.next,
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Boş olamaz' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _meaningController,
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
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Boş olamaz' : null,
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
                    sirpca: _capitalize(_wordController.text.trim()),
                    turkce: _capitalize(_meaningController.text.trim()),
                    userEmail: _capitalize(_wordController.text.trim()),
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
