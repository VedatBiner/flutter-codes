/// <----- text_entry.dart ----->

import 'package:flutter/material.dart';

class TextEntry extends StatelessWidget {
  const TextEntry({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}

