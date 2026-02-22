// <----- 📁 lib/screens/poster_viewer_page.dart ----->
//
// ============================================================================
// 🖼 PosterViewerPage – Tam Ekran Poster Görüntüleyici
// ============================================================================
//
// Bu ekran film ve diziler için ortak kullanılan
// tam ekran poster görüntüleme sayfasıdır.
//
// ---------------------------------------------------------------------------
// 🔹 Özellikler
// ---------------------------------------------------------------------------
// • Hero animasyon ile yumuşak geçiş.
// • Swipe-to-close (vertical dismiss).
// • Tap-to-close.
// • InteractiveViewer ile pinch zoom.
// • Ekranı taşmayan responsive yapı.
//
// ---------------------------------------------------------------------------
// Amaç:
// Film ve diziler için ortak, tekrar kullanılabilir
// poster görüntüleme deneyimi sunmak.
//
// ============================================================================
//
import 'package:flutter/material.dart';

class PosterViewerPage extends StatelessWidget {
  final String heroTag;
  final String posterUrl;

  const PosterViewerPage({
    super.key,
    required this.heroTag,
    required this.posterUrl,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: GestureDetector(
        onVerticalDragEnd: (_) => Navigator.of(context).maybePop(),
        onTap: () => Navigator.of(context).maybePop(),
        child: SafeArea(
          child: Center(
            child: Hero(
              tag: heroTag,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 3,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.width,
                    maxHeight: size.height,
                  ),
                  child: Image.network(
                    posterUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
