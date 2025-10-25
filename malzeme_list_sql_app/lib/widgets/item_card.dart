// 📃 <----- item_card.dart ----->
//
// Malzemelerin Card Widget olarak gösterilmesi burada sağlanıyor.

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

/// 📌 sabitler burada
import '../constants/color_constants.dart';
import '../constants/text_constants.dart';

/// 📌 Yardımcı yüklemeler burada
import '../models/item_model.dart';
import '../providers/item_quantity_provider.dart';
import 'item_action_buttons.dart';

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
  @override
  Widget build(BuildContext context) {
    final quantityProvider = Provider.of<MalzemeQuantityProvider>(context);
    final miktar = quantityProvider.getQuantity(
      malzeme.id!,
      malzeme.miktar ?? 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Slidable(
          key: ValueKey(malzeme.id ?? malzeme.malzeme),
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.5,
            children: [
              SlidableAction(
                onPressed: (_) =>
                    quantityProvider.increaseQuantity(malzeme.id!),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.add,
                label: 'Ekle',
              ),
              SlidableAction(
                onPressed: (_) =>
                    quantityProvider.decreaseQuantity(malzeme.id!),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.remove,
                label: 'Çıkar',
              ),
            ],
          ),
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

                      /// 📌 Açıklama varsa göster
                      if ((malzeme.aciklama?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 6),
                        Text(
                          malzeme.aciklama!,
                          style: anlamText.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],

                      const Divider(thickness: 1),

                      /// 📌 Miktar (Provider ile güncel gösterim)
                      Text('$miktar adet', style: anlamText),
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
      ),
    );
  }
}
