// 📃 <----- word_card.dart ----->
// Kelimelerin Card Widget olarak gösterilmesi burada sağlanıyor.

import 'package:flutter/material.dart';
import 'package:kelimelik_words_app/constants/color_constants.dart';
import 'package:kelimelik_words_app/constants/text_constants.dart';
import 'package:kelimelik_words_app/models/word_model.dart';
import 'package:kelimelik_words_app/widgets/word_action_buttons.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WordCard({
    super.key,
    required this.word,
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
                    Text(word.word, style: kelimeText),
                    const Divider(thickness: 1),
                    Text(word.meaning, style: anlamText),
                  ],
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 12,
                  ),
                  child: WordActionButtons(onEdit: onEdit, onDelete: onDelete),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
