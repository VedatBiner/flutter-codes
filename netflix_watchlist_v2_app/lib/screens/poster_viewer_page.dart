// 📁 lib/screens/poster_viewer_page.dart

import 'dart:math' as math;
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
  Offset _dragOffset = Offset.zero;
  double _dragProgress = 0.0; // 0..1
  late final AnimationController _resetCtrl;
  late Animation<Offset> _resetOffsetAnim;
  late Animation<double> _resetProgAnim;

  @override
  void initState() {
    super.initState();
    _resetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  @override
  void dispose() {
    _resetCtrl.dispose();
    super.dispose();
  }

  void _animateBack() {
    _resetOffsetAnim = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _resetCtrl, curve: Curves.easeOut));

    _resetProgAnim = Tween<double>(
      begin: _dragProgress,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _resetCtrl, curve: Curves.easeOut));

    _resetCtrl
      ..reset()
      ..addListener(() {
        setState(() {
          _dragOffset = _resetOffsetAnim.value;
          _dragProgress = _resetProgAnim.value;
        });
      })
      ..forward();
  }

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Drag arttıkça arkaplan saydamlaşsın, image biraz küçülsün
    final bgOpacity = (1.0 - (_dragProgress * 0.85)).clamp(0.0, 1.0);
    final scale = (1.0 - (_dragProgress * 0.12)).clamp(0.88, 1.0);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(bgOpacity),
      body: SafeArea(
        child: Stack(
          children: [
            // Kapama butonu
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: _close,
                icon: const Icon(Icons.close, color: Colors.white),
                tooltip: "Kapat",
              ),
            ),

            // İçerik
            Center(
              child: GestureDetector(
                onTap: _close, // tek dokunuşla kapat (istersen kaldırırız)
                onVerticalDragUpdate: (d) {
                  final next = _dragOffset + Offset(0, d.delta.dy);
                  final progress = (next.dy.abs() / (size.height * 0.25))
                      .clamp(0.0, 1.0);

                  setState(() {
                    _dragOffset = next;
                    _dragProgress = progress;
                  });
                },
                onVerticalDragEnd: (d) {
                  // Eşik: %18 sürükleme veya hızlı fırlatma
                  final shouldClose = _dragProgress > 0.18 ||
                      (d.primaryVelocity != null &&
                          d.primaryVelocity!.abs() > 900);

                  if (shouldClose) {
                    _close();
                  } else {
                    _animateBack();
                  }
                },
                child: Transform.translate(
                  offset: _dragOffset,
                  child: Transform.scale(
                    scale: scale,
                    child: Hero(
                      tag: widget.heroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: InteractiveViewer(
                          minScale: 1,
                          maxScale: 4,
                          child: Image.network(
                            widget.posterUrl,
                            fit: BoxFit.contain,
                            // Ekranı taşırmasın:
                            width: size.width * 0.95,
                            height: size.height * 0.85,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.black26,
                              alignment: Alignment.center,
                              width: size.width * 0.95,
                              height: size.height * 0.85,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Alt ipucu
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: IgnorePointer(
                child: Opacity(
                  opacity: (1.0 - _dragProgress).clamp(0.0, 1.0),
                  child: const Text(
                    "Aşağı/yukarı kaydır → kapat • Pinch → zoom",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
