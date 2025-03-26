import 'package:flutter/material.dart';

import '../models/word_model.dart';

class WordDialog extends StatefulWidget {
  final Word? word; // <-- Eklendi

  const WordDialog({super.key, this.word}); // <-- Eklendi

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.word == null ? 'Yeni Kelime Ekle' : 'Kelimeyi Düzenle',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _wordController,
              decoration: const InputDecoration(labelText: 'Kelime'),
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Boş olamaz' : null,
            ),
            TextFormField(
              controller: _meaningController,
              decoration: const InputDecoration(labelText: 'Anlamı'),
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Boş olamaz' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final updatedWord = Word(
                id: widget.word?.id, // id varsa koru (güncelleme için)
                word: _wordController.text.trim(),
                meaning: _meaningController.text.trim(),
              );
              Navigator.of(context).pop(updatedWord);
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
