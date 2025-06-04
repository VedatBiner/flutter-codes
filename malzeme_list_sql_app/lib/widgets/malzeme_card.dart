// 📃 <----- malzeme_card.dart ----->
//
// Malzemelerin Card Widget olarak gösterilmesi burada sağlanıyor.

import 'package:flutter/material.dart';

/// 📌 sabitler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';

/// 📌 Yardımcı yüklemeler burada
import '../models/malzeme_model.dart';
import 'malzeme_action_buttons.dart';

class MalzemeCard extends StatelessWidget {
  final Malzeme malzeme;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MalzemeCard({
    super.key,
    required this.malzeme,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onEdit,
    required this.onDelete,
  });

  // 📌 Kart görünümü
  //
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Card(
          elevation: 5,
          color: cardLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 📌 Malzeme adı
                    Text(malzeme.malzeme, style: kelimeText),

                    const Divider(thickness: 1),

                    /// 📌 Miktar (nullable kontrolüyle)
                    Text(
                      malzeme.miktar != null
                          ? malzeme.miktar.toString()
                          : 'Miktar belirtilmemiş',
                      style: anlamText,
                    ),
                  ],
                ),
              ),

              /// 📌 Uzun basıldığında düzenle/sil butonları
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 12,
                  ),
                  child: MalzemeActionButtons(
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
