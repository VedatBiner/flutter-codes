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

/// ============================================================================
/// 🖼 PosterViewerPage
/// ============================================================================
/// Bu sayfa, film/dizi kartında görülen küçük poster görselini:
///  1) Hero animasyon ile “aynı görselin büyüyerek” tam ekrana gelmesini sağlar.
///  2) Kullanıcı isterse posteri pinch-zoom ile yakınlaştırabilir.
///  3) Dikey swipe ile “dismiss” davranışı sunar:
///      - Drag esnasında poster ekranda aşağı/yukarı taşınır
///      - Arka plan opaklığı sürükleme ile birlikte azalır
///      - Drag eşiği aşılırsa sayfa kapanır
///      - Eşik aşılmazsa poster animasyonla merkeze geri döner
///
/// ⚠️ Gesture Notu:
/// InteractiveViewer pan (tek parmak sürükleme) ile
/// swipe-to-close (tek parmak dikey sürükleme) çakışabilir.
/// Bu yüzden burada **panEnabled: false** yapıp:
///  - tek parmak: sayfa kapatma swipe ’ı
///  - iki parmak: pinch zoom
/// davranışını daha deterministik hale getiriyoruz.
///
/// Parametreler:
///  • heroTag   → Kaynak widget ile eşleşen Hero etiketi
///  • posterUrl → Gösterilecek poster URL
/// ============================================================================
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
  // ==========================================================================
  // 🎯 DRAG STATE (Swipe-to-close davranışının çekirdeği)
  // ==========================================================================
  //
  // Kullanıcı posteri dikey sürükledikçe bu değer artar/azalır.
  // Bu değer:
  //  • Transform.translate ile posteri yukarı/aşağı taşımada kullanılır.
  //  • _backgroundOpacity() içinde arka planı şeffaflaştırmada kullanılır.
  //
  double _dragOffsetY = 0.0;

  // ==========================================================================
  // 🎞️ “Merkeze geri dön” animasyonu
  // ==========================================================================
  //
  // Kullanıcı sürüklemeyi bıraktığında kapanma eşiğini aşmadıysa,
  // posteri animasyonla tekrar 0 offset ’e (merkeze) döndürürüz.
  //
  late final AnimationController _resetCtrl;
  Animation<double>? _resetAnim;

  // ==========================================================================
  // 🎞️ “Merkeze geri dön” animasyonu
  // ==========================================================================
  //
  // Kullanıcı sürüklemeyi bıraktığında kapanma eşiğini aşmadıysa,
  // posteri animasyonla tekrar 0 offset ’e (merkeze) döndürürüz.
  //
  bool _isClosing = false;

  // ==========================================================================
  // 🧩 initState
  // ==========================================================================
  //
  // Burada:
  //  • _resetCtrl oluşturulur
  //  • controller listener ’ı ile animasyon sırasında _dragOffsetY güncellenir
  //
  // Neden listener?
  //  - Tween ’in her frame ’inde setState ile offset ’i güncelleyip
  //    posterin “kayarak” merkeze dönmesini sağlamak için.
  //
  @override
  void initState() {
    super.initState();

    _resetCtrl =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 180),
        )..addListener(() {
          setState(() {
            _dragOffsetY = _resetAnim?.value ?? 0.0;
          });
        });
  }

  // ==========================================================================
  // 🧹 dispose
  // ==========================================================================
  //
  // AnimationController mutlaka dispose edilmeli:
  //  • memory leak riskini önler
  //  • ticker açık kalmasını engeller
  //
  @override
  void dispose() {
    _resetCtrl.dispose();
    super.dispose();
  }

  /// =========================================================================
  /// 🎯 Kapanma Eşiği
  /// =========================================================================
  /// Kullanıcı posteri yeterince sürüklerse “dismiss” olur.
  ///
  /// Neden %18?
  /// - Çok küçük eşik: kazara kapanma
  /// - Çok büyük eşik: kullanıcı zorlanır
  /// - %15–%20 bandı pratikte rahat hissettirir
  ///
  /// Bu fonksiyon sadece “kapanmalı mı?” kararını verir.
  bool _shouldClose(Size size) => _dragOffsetY.abs() > size.height * 0.18;

  /// =========================================================================
  /// 🌑 Arka Plan Opaklığı
  /// =========================================================================
  /// Kullanıcı sürükledikçe arka plan şeffaflaşır.
  ///
  /// Amaç:
  /// - “Dismiss” hissini güçlendirmek
  /// - Kullanıcıya “kapatma” davranışında olduğunu görsel olarak hissettirmek
  ///
  /// Mekanik:
  ///  • Drag mesafesini ekrana oranlarız (0..1)
  ///  • 0.85 → 0.20 aralığında opaklık düşürürüz
  ///
  /// clamp kullanımı:
  /// - opaklığın uç değerleri aşmasını engeller
  double _backgroundOpacity(Size size) {
    final t = (_dragOffsetY.abs() / (size.height * 0.35)).clamp(0.0, 1.0);
    // 0 → 0.85, 1 → 0.20
    return (0.85 - (0.65 * t)).clamp(0.20, 0.85);
  }

  /// =========================================================================
  /// 🔄 Merkeze Geri Toplama Animasyonu
  /// =========================================================================
  /// Kullanıcı drag ’i bıraktı ama kapanma eşiğini aşmadıysa:
  ///  • _dragOffsetY mevcut değerinden 0’a tween edilir
  ///  • kısa bir easeOut animasyonuyla poster yerine “oturur”
  ///
  /// Not:
  /// - _resetCtrl.reset() ile animasyon başa sarılır
  /// - Tween begin/end değerleri dinamik: (o anki offset → 0)
  void _animateBackToCenter() {
    _resetCtrl.stop();
    _resetCtrl.reset();

    _resetAnim = Tween<double>(
      begin: _dragOffsetY,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _resetCtrl, curve: Curves.easeOut));

    _resetCtrl.forward();
  }

  /// =========================================================================
  /// ❌ Kapat (Dismiss)
  /// =========================================================================
  /// Bu fonksiyon tek bir yerden pop çağırmamızı sağlar.
  ///
  /// Neden ayrı fonksiyon?
  /// - onTap ve onVerticalDragEnd içinde aynı pop mantığı tekrar etmesin
  /// - _isClosing guard ile double-pop riskini yönetelim
  void _close() {
    if (_isClosing) return;
    _isClosing = true;
    Navigator.of(context).maybePop();
  }

  // ==========================================================================
  // 🏗 build
  // ==========================================================================
  //
  // Yapı:
  //  Scaffold
  //   └─ GestureDetector (tap + vertical drag)
  //       └─ SafeArea
  //           └─ Center
  //               └─ Transform.translate (drag offset)
  //                   └─ Hero
  //                       └─ InteractiveViewer (pinch zoom)
  //                           └─ ConstrainedBox (taşmayı önler)
  //                               └─ Image.network
  //
  // Kritik noktalar:
  //  • backgroundColor opaklığı drag ’e göre değişir.
  //  • behavior: HitTestBehavior.opaque -> boş alanlar da gesture alsın.
  //  • onVerticalDragStart -> reset animasyonunu durdurur.
  //  • onVerticalDragUpdate -> offset biriktirir.
  //  • onVerticalDragEnd -> eşik kontrolü (kapat / geri dön).
  //
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      // Drag ile değişen arka plan opaklığı:
      // - Sürükleme arttıkça arka plan daha şeffaf olur.
      backgroundColor: Colors.black.withValues(alpha: _backgroundOpacity(size)),
      body: GestureDetector(
        // Boş alanlara da tıklayınca kapanması için:
        behavior: HitTestBehavior.opaque,

        // ✅ Tap-to-close
        // Kullanıcı tek dokunuşla çıkmak isterse hızlı çıkış sağlar.
        onTap: _close,

        // ✅ Drag başlangıcında:
        // Eğer poster “geri toplama animasyonu” çalışıyorsa durdururuz.
        // Böylece kullanıcı drag sırasında animasyonla kavga etmez.
        onVerticalDragStart: (_) {
          _resetCtrl.stop();
        },
        // ✅ Drag başlangıcında:
        // Eğer poster “geri toplama animasyonu” çalışıyorsa durdururuz.
        // Böylece kullanıcı drag sırasında animasyonla kavga etmez.
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragOffsetY += details.delta.dy;
          });
        },

        // ✅ Drag bitince:
        // - Eşik aşıldıysa: kapat
        // - Aşılmadıysa: merkeze geri dön
        onVerticalDragEnd: (_) {
          if (_shouldClose(size)) {
            _close();
          } else {
            _animateBackToCenter();
          }
        },

        child: SafeArea(
          child: Center(
            // Drag offset ’i postere uygularız (dismiss hissi)
            child: Transform.translate(
              offset: Offset(0, _dragOffsetY),
              child: Hero(
                // Kaynak widget ile aynı tag olmalı:
                // Örn: film_tile.dart içinde Hero(tag: "movie_poster_xxx")
                tag: widget.heroTag,
                child: InteractiveViewer(
                  // Pinch zoom açık kalsın
                  minScale: 1,
                  maxScale: 3,

                  // ⚠️ Tek parmak pan kapalı:
                  // Çünkü tek parmak drag burada swipe-to-close için kullanılıyor.
                  // Aksi halde “poster hareket ettirme” ile “sayfayı kapatma”
                  // gesture ’ları karışabiliyor.
                  panEnabled: false,

                  // Poster ekranı taşmasın:
                  // ConstrainedBox ile maxWidth/maxHeight veriyoruz,
                  // Image.contain ile de en-boy oranını koruyarak sığdırıyoruz.
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: size.width,
                      maxHeight: size.height,
                    ),
                    child: Image.network(
                      widget.posterUrl,
                      fit: BoxFit.contain,

                      // Resim yüklenemezse kullanıcıya net bir ikon göster.
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
      ),
    );
  }
}
