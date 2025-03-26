import 'package:flutter/material.dart';
import '../models/word_model.dart';

class WordDialog extends StatefulWidget {
  const WordDialog({super.key});

  @override
  State<WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  final _formKey = GlobalKey<FormState>();
  final wordController = TextEditingController();
  final meaningController = TextEditingController();

  /// İlk harfi büyük yapan yardımcı fonksiyon
  String capitalize(String input) {
    if (input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final word = capitalize(wordController.text.trim());
      final meaning = capitalize(meaningController.text.trim());

      Navigator.pop(
        context,
        Word(word: word, meaning: meaning),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Kelime Ekle'),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            controller: wordController,
            decoration: const InputDecoration(labelText: 'Kelime'),
            validator: (val) => val == null || val.isEmpty ? 'Boş olamaz' : null,
          ),
          TextFormField(
            controller: meaningController,
            decoration: const InputDecoration(labelText: 'Anlamı'),
            validator: (val) => val == null || val.isEmpty ? 'Boş olamaz' : null,
          ),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Ekle'),
        )
      ],
    );
  }
}
