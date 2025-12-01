// 📃 <----- lib/widgets/bottom_banner_helper.dart ----->

import 'package:flutter/material.dart';

/// 🔥 Banner için kontrol objesi
class LoadingBannerController {
  final OverlayEntry entry;
  LoadingBannerController(this.entry);

  /// Banner 'ı güvenli şekilde kapatır
  void close() {
    try {
      entry.remove();
    } catch (_) {}
  }
}

/// 🌟 Alt bant loading gösterimi
class LoadingBottomBanner extends StatelessWidget {
  final String message;

  const LoadingBottomBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.85),
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
    );
  }
}

/// 🔧 Banner oluşturucu — kontrol objesi döner
LoadingBannerController showLoadingBanner(
  BuildContext context, {
  required String message,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: LoadingBottomBanner(message: message),
    ),
  );

  overlay.insert(entry);

  return LoadingBannerController(entry);
}
