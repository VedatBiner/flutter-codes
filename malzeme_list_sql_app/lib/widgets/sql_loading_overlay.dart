// 📃 sql_loading_overlay.dart

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import 'sql_loading_card.dart';

class SQLLoadingCardOverlay extends StatefulWidget {
  static _SQLLoadingCardOverlayState? _state;

  const SQLLoadingCardOverlay({super.key});

  static void update({
    required double progress,
    required String? loadingWord,
    required Duration elapsedTime,
    required bool show,
  }) {
    _state?._updateCard(progress, loadingWord, elapsedTime, show);
  }

  @override
  State<SQLLoadingCardOverlay> createState() {
    _state = _SQLLoadingCardOverlayState();
    return _state!;
  }
}

class _SQLLoadingCardOverlayState extends State<SQLLoadingCardOverlay> {
  double _progress = 0;
  String? _loadingWord;
  Duration _elapsed = Duration.zero;
  bool _show = true;

  void _updateCard(double progress, String? word, Duration elapsed, bool show) {
    setState(() {
      _progress = progress;
      _loadingWord = word;
      _elapsed = elapsed;
      _show = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return const SizedBox.shrink();

    return Positioned.fill(
      child: Material(
        color: Colors.black54,
        child: SQLLoadingCard(
          progress: _progress,
          loadingItem: _loadingWord,
          elapsedTime: _elapsed,
        ),
      ),
    );
  }
}
