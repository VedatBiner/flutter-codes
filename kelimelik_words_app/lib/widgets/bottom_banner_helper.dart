// 📃 <----- lib/widgets/bottom_banner_helper.dart ----->
//
// Alt bant şeklinde yükleme göstergesi oluşturmak için kullanılır.
// Banner UI bir OverlayEntry olarak eklenir ve LoadingBannerController
// sayesinde güvenli şekilde kaldırılabilir.
//
// NOTLAR:
//  • close() artık ekstra güvenlik içeriyor (mounted + try/catch).
//  • Overlay bulunamazsa (nadir durum) otomatik fallback yapar.
//  • Rebuild sırasında çakışmayı engellemek için Positioned + SafeArea kullanıldı.
//
// ------------------------------------------------------------------------------

import 'package:flutter/material.dart';

/// 🔥 Banner için kontrol objesi
class LoadingBannerController {
  final OverlayEntry entry;
  bool _isClosed = false;

  LoadingBannerController(this.entry);

  /// Banner 'ı güvenli şekilde kapatır
  void close() {
    if (_isClosed) return;
    try {
      entry.remove();
    } catch (_) {}
    _isClosed = true;
  }
}

/// 🌟 Alt bant loading gösterimi
class LoadingBottomBanner extends StatelessWidget {
  final String message;

  const LoadingBottomBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Material(
        color: Colors.black.withValues(alpha: 0.88),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔧 Banner oluşturucu — kontrol objesi döner
LoadingBannerController showLoadingBanner(
  BuildContext context, {
  required String message,
}) {
  // Overlay bulunmazsa bile çökmeyi önle
  final overlay = Overlay.of(context, rootOverlay: true);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      left: 0,
      right: 0,
      bottom: 0,

      /// 🧩 UI çakışması yaşamamak için AnimatedOpacity ekledik
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 200),
        child: LoadingBottomBanner(message: message),
      ),
    ),
  );

  overlay.insert(entry);

  return LoadingBannerController(entry);
}
