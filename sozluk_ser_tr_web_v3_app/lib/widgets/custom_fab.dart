// 📃 <----- custom_fab.dart ----->

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import 'add_word_dialog_handler.dart';

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
        onPressed: () => showAddWordDialog(context, onWordAdded),
        child: Image.asset('assets/images/add.png', width: 56, height: 56),
      ),
    );
  }
}
