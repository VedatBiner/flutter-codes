// 📃 <----- lib/widgets/loading_bottom_banner.dart ----->
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';

class LoadingBottomBanner extends StatelessWidget {
  final bool loading;
  final ValueListenable<int> elapsedSec;

  /// İsteğe bağlı özelleştirmeler
  final EdgeInsets padding;
  final Color backgroundColor;
  final double indicatorSize;
  final String Function(int seconds)? messageBuilder;

  const LoadingBottomBanner({
    super.key,
    required this.loading,
    required this.elapsedSec,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.backgroundColor = const Color(0xBF000000), // %75 siyah
    this.indicatorSize = 18.0,
    this.messageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (!loading) return const SizedBox.shrink();

    return SafeArea(
      child: ValueListenableBuilder<int>(
        valueListenable: elapsedSec,
        builder: (_, sec, __) {
          final text =
              messageBuilder?.call(sec) ??
              'Lütfen bekleyiniz, veriler okunuyor… (${sec}s)';
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
                    text,
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
