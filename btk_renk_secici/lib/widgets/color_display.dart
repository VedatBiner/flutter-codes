// 📜 <----- color_display.dart ----->
import 'package:flutter/material.dart';

class ColorDisplay extends StatelessWidget {
  const ColorDisplay({
    super.key,
    required Color secilenRenk,
    required this.isCircular,
  }) : _secilenRenk = secilenRenk;

  final Color _secilenRenk;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final containerSize = deviceSize.shortestSide * 0.4;
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: _secilenRenk,

        /// Şeklin tipini değiştir
        borderRadius: BorderRadius.circular(
          isCircular ? containerSize / 2 : 10,
        ),
        boxShadow: [
          BoxShadow(
            color: _secilenRenk.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
