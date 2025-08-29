// 📃 <----- custom_fab.dart ----->

// 📌 Flutter paketleri burada
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/color_constants.dart';
import '../widgets/show_word_dialog_handler.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onWordAdded;
  // final VoidCallback refreshWords;
  // final VoidCallback clearSearch;

  const CustomFAB({
    super.key,
    required this.onWordAdded,
    // required this.refreshWords,
    // required this.clearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-20, 0),
      child: FloatingActionButton(
        tooltip: "Yeni kelime ekle",
        backgroundColor: Colors.transparent,
        foregroundColor: buttonIconColor,
        onPressed: () => showWordDialogHandler(context, onWordAdded),
        child: Image.asset('assets/images/add.png', width: 56, height: 56),
      ),
    );
  }
}
