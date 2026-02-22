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
// • Swipe-to-close (vertical dismiss) → drag sırasında hareket + opaklık.
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

class PosterViewerPage extends StatefulWidget {
  final String heroTag;
  final String posterUrl;

  const PosterViewerPage({
    super.key,
    required this.heroTag,
    required this.posterUrl,
  });

  @override
  State<PosterViewerPage> createState() => _PosterViewerPageState();
}

class _PosterViewerPageState extends State<PosterViewerPage>
    with SingleTickerProviderStateMixin {
  // Dikey sürükleme offset ’i
  double _dragOffsetY = 0.0;

  // Drag bitince “geri dön” animasyonu
  late final AnimationController _resetCtrl;
  Animation<double>? _resetAnim;

  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    _resetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )..addListener(() {
      setState(() {
        _dragOffsetY = _resetAnim?.value ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _resetCtrl.dispose();
    super.dispose();
  }

  /// =========================================================================
  /// 🎯 Kapanma Eşiği
  /// =========================================================================
  /// Kullanıcı posteri yeterince sürüklerse kapanır.
  /// Eşik: ekran yüksekliğinin %18’i (pratikte iyi çalışır).
  bool _shouldClose(Size size) => _dragOffsetY.abs() > size.height * 0.18;

  /// =========================================================================
  /// 🌑 Arka Plan Opaklığı
  /// =========================================================================
  /// Sürükledikçe arka plan şeffaflaşır (0.85 → 0.20 aralığı).
  double _backgroundOpacity(Size size) {
    final t = (_dragOffsetY.abs() / (size.height * 0.35)).clamp(0.0, 1.0);
    // 0 → 0.85, 1 → 0.20
    return (0.85 - (0.65 * t)).clamp(0.20, 0.85);
  }

  void _animateBackToCenter() {
    _resetCtrl.stop();
    _resetCtrl.reset();

    _resetAnim = Tween<double>(
      begin: _dragOffsetY,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _resetCtrl,
      curve: Curves.easeOut,
    ));

    _resetCtrl.forward();
  }

  void _close() {
    if (_isClosing) return;
    _isClosing = true;
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(_backgroundOpacity(size)),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,

        // Tap ile kapat
        onTap: _close,

        // Drag sırasında posteri taşı
        onVerticalDragStart: (_) {
          _resetCtrl.stop();
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragOffsetY += details.delta.dy;
          });
        },
        onVerticalDragEnd: (_) {
          if (_shouldClose(size)) {
            _close();
          } else {
            _animateBackToCenter();
          }
        },

        child: SafeArea(
          child: Center(
            child: Transform.translate(
              offset: Offset(0, _dragOffsetY),
              child: Hero(
                tag: widget.heroTag,
                child: InteractiveViewer(
                  // Pinch zoom
                  minScale: 1,
                  maxScale: 3,

                  // Poster taşmasın
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: size.width,
                      maxHeight: size.height,
                    ),
                    child: Image.network(
                      widget.posterUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
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
      ),
    );
  }
}