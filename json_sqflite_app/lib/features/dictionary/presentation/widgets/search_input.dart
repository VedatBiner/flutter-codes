// <----- 📜 search_input.dart ----->
// -----------------------------------------------------------------------------
// AppBar içindeki arama kutusunu oluşturmak için kullanılan widget
// -----------------------------------------------------------------------------
//
import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Ara...',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      onChanged: onChanged,
    );
  }
}
