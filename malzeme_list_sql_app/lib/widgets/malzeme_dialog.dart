// 📃 <----- malzeme_dialog.dart ----->
//
// eski word_dialog.dart

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/Button_constants.dart';
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../models/malzeme_model.dart';

class MalzemeDialog extends StatefulWidget {
  final Malzeme? malzeme;

  const MalzemeDialog({super.key, this.malzeme});

  @override
  State<MalzemeDialog> createState() => _MalzemeDialogState();
}

class _MalzemeDialogState extends State<MalzemeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _malzemeController;
  late TextEditingController _miktarController;

  @override
  void initState() {
    super.initState();
    _malzemeController = TextEditingController(
      text: widget.malzeme?.malzeme ?? '',
    );
    _miktarController = TextEditingController(
      text: widget.malzeme?.miktar?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _malzemeController.dispose();
    _miktarController.dispose();
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
          widget.malzeme == null ? 'Yeni Malzeme Ekle' : 'Malzemeyi Düzenle',
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
              controller: _malzemeController,
              decoration: InputDecoration(
                labelText: 'Malzeme Adı',
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
              controller: _miktarController,
              decoration: InputDecoration(
                labelText: 'Miktar',
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
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Boş olamaz';
                if (int.tryParse(value) == null) return 'Sayısal değer girin';
                return null;
              },
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
                  final updatedMalzeme = Malzeme(
                    id: widget.malzeme?.id,
                    malzeme: _capitalize(_malzemeController.text.trim()),
                    miktar: int.tryParse(_miktarController.text.trim()),
                  );
                  Navigator.of(context).pop(updatedMalzeme);
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
