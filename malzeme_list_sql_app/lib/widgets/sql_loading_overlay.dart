// 📃 <----- sql_loading_overlay.dart ----->
//
// Bu dosya, SQL yükleme işlemleri sırasında ekranda geçici olarak
// bir `SQLLoadingCard` göstermek için kullanılır.
//
// Kullanımı: Overlay sistemine geçici olarak kart ekler ve
// yükleme ilerlemesini dinamik olarak günceller.
//

import 'package:flutter/material.dart';

import '../widgets/sql_loading_card.dart';

/// `SQLLoadingCardOverlay`
///
/// Bu widget, uygulama ekranına geçici bir `OverlayEntry` olarak eklenir.
/// JSON'dan veritabanına veri aktarılırken yükleme durumu burada gösterilir.
///
/// `update()` metoduyla dışarıdan progress ve metinler güncellenebilir.
class SQLLoadingCardOverlay extends StatefulWidget {
  /// Widget'ın state referansı – dışarıdan güncelleme için static tutulur
  static late _SQLLoadingCardOverlayState _state;

  const SQLLoadingCardOverlay({super.key});

  /// Dışarıdan çağrılarla güncellenmesini sağlar
  static void update({
    required double progress,
    required String? loadingWord,
    required Duration elapsedTime,
    required bool show,
  }) {
    if (_state.mounted) {
      _state.updateState(progress, loadingWord, elapsedTime, show);
    }
  }

  @override
  State<SQLLoadingCardOverlay> createState() {
    _state = _SQLLoadingCardOverlayState();
    return _state;
  }
}

/// State sınıfı – widget’ın iç durumunu yönetir
class _SQLLoadingCardOverlayState extends State<SQLLoadingCardOverlay> {
  double _progress = 0.0; // Yükleme yüzdesi (0‒1 arası)
  String? _currentWord; // O an yüklenen malzeme
  Duration _elapsed = Duration.zero; // Geçen süre
  bool _visible = true; // Kart görünsün mü?

  /// Yeni durum bilgileri ile widget’ı yeniden oluşturur
  void updateState(
    double progress,
    String? currentWord,
    Duration elapsedTime,
    bool show,
  ) {
    setState(() {
      _progress = progress;
      _currentWord = currentWord;
      _elapsed = elapsedTime;
      _visible = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Eğer görünür değilse boş widget döndür
    if (!_visible) return const SizedBox.shrink();

    return Stack(
      children: [
        /// Ekranın tamamını hafif karartarak arka planı bloke eder
        ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.3)),

        /// Ortada SQLLoadingCard widget’ı gösterilir
        Center(
          child: SQLLoadingCard(
            progress: _progress,
            loadingItem: _currentWord,
            elapsedTime: _elapsed,
          ),
        ),
      ],
    );
  }
}
