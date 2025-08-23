// <📃 ----- lib/widgets/loading_bottom_banner.dart ----->
import 'package:flutter/foundation.dart'; // ValueListenable için
import 'package:flutter/material.dart';

class LoadingBottomBanner extends StatelessWidget {
  final bool loading;
  final ValueListenable<int> elapsedSec;

  /// 🔹 Dışarıdan mesaj verilebilir (varsayılan: “Lütfen bekleyiniz…”)
  final String message;

  final EdgeInsets padding;
  final double indicatorSize;
  final Color backgroundColor;

  const LoadingBottomBanner({
    super.key,
    required this.loading,
    required this.elapsedSec,
    this.message = 'Lütfen bekleyiniz, veriler okunuyor…',
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.indicatorSize = 18,
    this.backgroundColor = const Color(0xBF000000), // %75 siyah
  });

  @override
  Widget build(BuildContext context) {
    if (!loading) return const SizedBox.shrink();

    return SafeArea(
      child: ValueListenableBuilder<int>(
        valueListenable: elapsedSec,
        builder: (_, sec, __) {
          return Container(
            padding: padding,
            color: backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: indicatorSize,
                  height: indicatorSize,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    '$message (${sec}s)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
