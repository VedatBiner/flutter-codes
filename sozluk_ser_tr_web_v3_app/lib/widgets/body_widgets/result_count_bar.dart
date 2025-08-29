// <📜 ----- lib/widgets/result_count_bar.dart ----->
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../constants/text_constants.dart';

/// AppBar 'a yapışık, tam genişlikte üst bant.
/// Varsayılan metin: "Toplam kelime sayısı : <filtered>/<total>"
class ResultCountBar extends StatelessWidget {
  final int filteredCount;
  final int totalCount;

  /// Metni tamamen özelleştirmek istersen.
  final String? text;

  /// Stil ve görünüm ayarları
  final Color? backgroundColor;
  final TextStyle? style;
  final double height;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final TextAlign textAlign;

  const ResultCountBar({
    super.key,
    required this.filteredCount,
    required this.totalCount,
    this.text,
    this.backgroundColor,
    this.style,
    this.height = 28,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.alignment = Alignment.center,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final label = text ?? 'Toplam kayıt sayısı : $filteredCount / $totalCount';

    return Material(
      color: backgroundColor ?? drawerColor,
      child: Container(
        height: height,
        padding: padding,
        alignment: alignment,
        child: SelectionContainer.disabled(
          child: Text(
            label,
            textAlign: textAlign,
            style: style ?? subtitleText,
          ),
        ),
      ),
    );
  }
}
