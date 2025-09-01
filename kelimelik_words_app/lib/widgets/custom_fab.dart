// 📃 <----- custom_fab.dart ----->

import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import 'show_word_dialog_handler.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback refreshWords;
  final VoidCallback clearSearch;

  const CustomFAB({
    super.key,
    required this.refreshWords,
    required this.clearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-20, 0),
      child: FloatingActionButton(
        tooltip: "Yeni kelime ekle",
        backgroundColor: Colors.transparent,
        foregroundColor: buttonIconColor,
        onPressed:
            () => showWordDialogHandler(context, refreshWords, clearSearch),
        child: Image.asset('assets/images/add.png', width: 56, height: 56),
      ),
    );
  }
}
