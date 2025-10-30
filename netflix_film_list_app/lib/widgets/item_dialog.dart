// 📃 <----- item_dialog.dart ----->

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/button_constants.dart';
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../models/item_model.dart';

class WordDialog extends StatefulWidget {
  final NetflixItem? netflixItem;

  const WordDialog({super.key, this.netflixItem});

  @override
  State<WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _netflixItemController;
  late TextEditingController _watchDateController;

  @override
  void initState() {
    super.initState();
    _netflixItemController = TextEditingController(
      text: widget.netflixItem?.netflixItemName ?? '',
    );
    _watchDateController = TextEditingController(
      text: widget.netflixItem?.watchDate ?? '',
    );
  }

  @override
  void dispose() {
    _netflixItemController.dispose();
    _watchDateController.dispose();
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
          widget.netflixItem == null
              ? 'Yeni Film/Dizi Ekle'
              : 'Film/Dizi Düzenle',
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
              controller: _netflixItemController,
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
              autofocus: true,
              textInputAction: TextInputAction.next,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Boş olamaz' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _watchDateController,
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
                  final updatedWord = NetflixItem(
                    id: widget.netflixItem?.id,
                    netflixItemName: _capitalize(
                      _netflixItemController.text.trim(),
                    ),
                    watchDate: _capitalize(_watchDateController.text.trim()),
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
