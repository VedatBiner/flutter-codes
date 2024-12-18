/// <----- text_entry.dart ----->
library;

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
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.indigo),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black54,
            width: 2,
          ),
          borderRadius:BorderRadius.circular(4),
        )
      ),
    );
  }
}

