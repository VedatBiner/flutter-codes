/// <----- app_bar.dart ----->

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool aramaYapiliyorMu;
  final String aramaKelimesi;
  final Function(String) onAramaKelimesiChanged;
  final Function() onCancelPressed;
  final Function() onSearchPressed;

  const CustomAppBar({
    Key? key,
    required this.aramaYapiliyorMu,
    required this.aramaKelimesi,
    required this.onAramaKelimesiChanged,
    required this.onCancelPressed,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: aramaYapiliyorMu
          ? TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Aradığınız kelimeyi yazınız ...",
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
              onChanged: onAramaKelimesiChanged,
            )
          : const Text(
              "Sırpça-Türkçe Sözlük",
              style: TextStyle(color: Colors.white),
            ),
      iconTheme: const IconThemeData(color: Colors.amberAccent),
      actions: [
        aramaYapiliyorMu
            ? IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                onPressed: onCancelPressed,
              )
            : IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.amberAccent,
                ),
                onPressed: onSearchPressed,
              ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}




















