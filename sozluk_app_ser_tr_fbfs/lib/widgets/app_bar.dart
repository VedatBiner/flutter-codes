import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool aramaYapiliyorMu;
  final String aramaKelimesi;
  final Function(String) onSearchChanged;
  final VoidCallback onSearchCancelled; // Bu satırı güncelledik

  const CustomAppBar({
    Key? key,
    required this.aramaYapiliyorMu,
    required this.aramaKelimesi,
    required this.onSearchChanged,
    required this.onSearchCancelled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: aramaYapiliyorMu
          ? TextField(
              decoration: const InputDecoration(
                hintText: "Arama için bir şey yazın",
              ),
              onChanged: (aramaSonucu) {
                onSearchChanged(aramaSonucu);
              },
            )
          : const Text("Sırpça-Türkçe Sözlük"),
      actions: [
        aramaYapiliyorMu
            ? IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: onSearchCancelled,
              )
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
