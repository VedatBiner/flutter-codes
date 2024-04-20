/// bu dosya kullanılmıyor mu ?
library;
import 'package:flutter/material.dart';

class HomeCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool aramaYapiliyorMu;
  final String aramaKelimesi;
  final ValueChanged<String> onAramaKelimesiChanged;
  final VoidCallback onCancelPressed;
  final VoidCallback onSearchPressed;
  final String appBarTitle;

  const HomeCustomAppBar({
    super.key,
    required this.aramaYapiliyorMu,
    required this.aramaKelimesi,
    required this.onAramaKelimesiChanged,
    required this.onCancelPressed,
    required this.onSearchPressed,
    required this.appBarTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: aramaYapiliyorMu
          ? TextField(
              onChanged: onAramaKelimesiChanged,
              decoration: const InputDecoration(
                hintText: 'Kelime ara...',
              ),
            )
          : Text(appBarTitle),
      actions: [
        aramaYapiliyorMu
            ? IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: onCancelPressed,
              )
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: onSearchPressed,
              ),
      ],
    );
  }
}
