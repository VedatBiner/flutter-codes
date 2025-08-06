// 📃 utils/bottom_waiting_overlay.dart
//
// Ekranın altına sabitlenen, gölgeli “Lütfen bekleyiniz” paneli
//

// 📌 Flutter paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/text_constants.dart';

class BottomWaitingOverlay extends StatelessWidget {
  const BottomWaitingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        // gölge verir
        elevation: 12,
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 28,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Kelimeler okunuyor \nLütfen bekleyiniz…',
                style: loadingWordText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
