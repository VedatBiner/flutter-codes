// 📃 <----- malzeme_list.dart ----->
//
// Klasik görünümlü listeleme için kullanılır.

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../models/item_model.dart';
import '../widgets/malzeme_actions.dart';
import '../widgets/malzeme_card.dart';

class MalzemeList extends StatefulWidget {
  final List<Malzeme> malzemeler;
  final VoidCallback onUpdated;

  const MalzemeList({
    super.key,
    required this.malzemeler,
    required this.onUpdated,
  });

  @override
  State<MalzemeList> createState() => _MalzemeListState();
}

class _MalzemeListState extends State<MalzemeList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.malzemeler.isEmpty) {
      return const Center(child: Text('Henüz malzeme eklenmedi.'));
    }

    /// 🔤 Alfabetik sıralama (Türkçe karakterler dikkate alınmaz)
    final sortedList = List<Malzeme>.from(widget.malzemeler)
      ..sort(
        (a, b) => a.malzeme.toLowerCase().compareTo(b.malzeme.toLowerCase()),
      );

    return GestureDetector(
      onTap: () {
        if (selectedIndex != null) {
          setState(() => selectedIndex = null);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: ListView.builder(
        itemCount: sortedList.length,
        itemBuilder: (context, index) {
          final malzeme = sortedList[index];
          final isSelected = selectedIndex == index;

          return MalzemeCard(
            malzeme: malzeme,
            isSelected: isSelected,
            onTap: () {
              if (selectedIndex != null) {
                setState(() => selectedIndex = null);
              }
            },

            /// 📌 malzeme kartına uzun basılınca
            /// düzeltme ve silme butonları çıkıyor.
            onLongPress: () {
              setState(() => selectedIndex = isSelected ? null : index);
            },

            /// 📌 düzeltme metodu
            onEdit: () => editWord(
              context: context,
              word: malzeme,
              onUpdated: widget.onUpdated,
            ),

            /// 📌 silme metodu
            onDelete: () => confirmDelete(
              context: context,
              word: malzeme,
              onDeleted: widget.onUpdated,
            ),
          );
        },
      ),
    );
  }
}
