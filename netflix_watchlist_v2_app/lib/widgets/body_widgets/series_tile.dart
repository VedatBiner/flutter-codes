// ============================================================================
// 📺 SeriesTile – Tekil Dizi Satırı
// ============================================================================
//
// Bu widget tek bir diziyi temsil eder.
// OMDb bilgileri (poster, yıl, tür, rating) lazy-load edilir.
//
// ---------------------------------------------------------------------------
// 🔹 Özellikleri
// ---------------------------------------------------------------------------
// • Küçük poster thumbnail (varsa).
// • Dizi adı altında yıl / tür / IMDB rating.
// • Dizi satırına dokununca OMDb yüklenir.
// • Uzun basınca Hero animasyonlu tam ekran poster açılır.
// • Swipe-to-close desteklidir (PosterViewerPage içinde).
// • Sezon ve bölüm ExpansionTile’ları içerir.
//
// ---------------------------------------------------------------------------
// Mimari Avantaj:
// OMDb yükleme mantığı SeriesGroup modelini kirletmeden
// widget state içinde "tetikleyici" olarak yönetilir.
// (Veri modelin içinde saklanır: SeriesGroup.year/genre/rating/poster/imdbId)
//
// ============================================================================

import 'dart:developer';
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../models/series_models.dart';
import '../../screens/poster_viewer_page.dart';
import '../../utils/csv_parser.dart';
import '../../utils/omdb_series_loader.dart';

class SeriesTile extends StatefulWidget {
  final SeriesGroup group;
  final bool isLightTheme;

  const SeriesTile({
    super.key,
    required this.group,
    required this.isLightTheme,
  });

  @override
  State<SeriesTile> createState() => _SeriesTileState();
}

class _SeriesTileState extends State<SeriesTile> {
  static const _logTag = "series_tile";

  /// OMDb çağrısı sürerken UI ’da “Bilgiler yükleniyor...” gösterebilmek için.
  /// Aynı anda birden fazla istek gitmesini de engeller.
  bool _loading = false;

  // ==========================================================================
  // 🏷 Hero Tag
  // ==========================================================================
  /// Bu getter Hero animasyonunda kullanılan benzersiz etiketi üretir.
  ///
  /// Neden gerekli?
  /// - Hero animasyonunda aynı tag ’e sahip iki widget çakışırsa animasyon bozulur.
  /// - imdbId varsa onu kullanmak en güvenilir yöntemdir (global unique).
  /// - imdbId yoksa fallback olarak seriesName kullanırız.
  ///
  /// Kullanıldığı yerler:
  /// - Listede küçük poster thumbnail (Hero source)
  /// - PosterViewerPage içinde büyük poster (Hero destination)
  String get _heroTag {
    final id = widget.group.imdbId;
    if (id != null && id.isNotEmpty) {
      return "series_poster_$id";
    }
    return "series_poster_${widget.group.seriesName}";
  }

  // ==========================================================================
  // 🔎 OMDb Verisi Yüklü mü?
  // ==========================================================================
  /// Bu getter, ilgili dizi için OMDb verisinin “yüklenmiş” kabul edilip
  /// edilmeyeceğini belirler.
  ///
  /// Buradaki kriter:
  /// - imdbId doluysa: OMDb başarılı bir şekilde bulunmuş / çekilmiş demektir.
  ///
  /// Not:
  /// - poster, year, genre gibi alanlar bazen OMDb ’de "N/A" dönebilir.
  /// - Yine de imdbId dolu ise “bu dizi OMDb ’de eşleşti” demek yeterli.
  bool get _isLoaded {
    final id = widget.group.imdbId;
    return id != null && id.isNotEmpty;
  }

  // ==========================================================================
  // 🔄 OMDb Lazy Load
  // ==========================================================================
  /// Dizinin OMDb bilgilerini "lazily" yükler.
  ///
  /// Ne zaman çağrılır?
  /// - Dizi satırına tıklanınca (title/subtitle/leading)
  /// - ExpansionTile açılınca (kullanıcı ok ’a basarsa)
  /// - Long press ile poster açılmak istendiğinde
  ///
  /// Neden bu yöntem?
  /// - Tüm diziler için OMDb’yi açılışta çekmek pahalı (yavaş + quota riski).
  /// - Kullanıcı sadece ilgilendiği dizinin detaylarını görmek ister.
  ///
  /// Nasıl çalışır?
  /// 1) Zaten _loading true ise yeni istek başlatmaz.
  /// 2) Zaten _isLoaded ise tekrar API çağrısı yapmaz.
  /// 3) OmdbSeriesLoader.loadIfNeeded(widget.group) çağrılır:
  ///    - Eğer group içinde imdbId yoksa OMDb ’ye gider
  ///    - Bulduğu verileri group.year/genre/rating/poster/imdbId alanlarına yazar
  /// 4) UI state güncellenir (_loading false)
  Future<void> _ensureLoaded() async {
    if (_loading) return;
    if (_isLoaded) return;

    setState(() => _loading = true);

    try {
      await OmdbSeriesLoader.loadIfNeeded(widget.group);
    } catch (e) {
      log("OMDb yükleme hatası: $e", name: _logTag);
    }

    if (!mounted) return;

    setState(() => _loading = false);
  }

  // ==========================================================================
  // 🖼 Poster Fullscreen Viewer (Hero + Swipe-to-close)
  // ==========================================================================
  /// Dizinin posterini tam ekranda açar.
  ///
  /// Akış:
  /// 1) Önce _ensureLoaded() çağrılır → poster bilgisi gelmiş olabilir.
  /// 2) Poster hala yoksa kullanıcıya SnackBar ile bilgi verilir.
  /// 3) Poster varsa PosterViewerPage açılır:
  ///    - Hero animasyon ile yumuşak geçiş
  ///    - PosterViewerPage içinde swipe-to-close / tap-to-close destekli
  ///
  /// Neden PageRouteBuilder?
  /// - opaque:false ile arka planı “yarı saydam” yapabiliyoruz.
  /// - FadeTransition ile daha sinematik bir geçiş elde edilir.
  Future<void> _openPosterFullScreen() async {
    await _ensureLoaded();
    if (!mounted) return;

    final poster = widget.group.poster;
    if (poster == null || poster.isEmpty) {
      log("Poster yok: ${widget.group.seriesName}", name: _logTag);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Poster bulunamadı.")));
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, _, _) =>
            PosterViewerPage(heroTag: _heroTag, posterUrl: poster),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  // ==========================================================================
  // 🎬 Leading (Poster Thumbnail veya TV ikonu)
  // ==========================================================================
  /// Listede satırın sol tarafında görünen “leading” alanını üretir.
  ///
  /// İki durum var:
  /// - Poster yoksa: Icons.tv gösterilir (placeholder)
  /// - Poster varsa: küçük thumbnail gösterilir (Hero ile sarılı)
  ///
  /// Ayrıca kullanıcı deneyimi için:
  /// - Leading ’e tap → OMDb yükleme tetiklenir (poster hemen gelmeyebilir)
  /// - Leading ’e long press → poster tam ekran açılır
  ///
  /// Böylece kullanıcı sadece dizi adına değil, görsele basarak da
  /// aynı etkileşimi yapabilir.
  Widget _buildLeading() {
    final poster = widget.group.poster;

    if (poster == null || poster.isEmpty) {
      return GestureDetector(
        onTap: _ensureLoaded,
        onLongPress: _openPosterFullScreen,
        child: const Icon(Icons.tv),
      );
    }

    return GestureDetector(
      onTap: _ensureLoaded,
      onLongPress: _openPosterFullScreen,
      child: Hero(
        tag: _heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            poster,
            width: 50,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Icon(Icons.tv),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 🧾 Subtitle (Yıl / Tür / IMDB)
  // ==========================================================================
  /// Dizi adının altında görünen açıklama satırını üretir.
  ///
  /// 3 durum yönetir:
  /// 1) _loading true → “Bilgiler yükleniyor...”
  /// 2) OMDb henüz yüklenmediyse → kullanıcıya yönlendirme metni
  /// 3) OMDb yüklüyse → yıl / tür / IMDb rating tek satırda gösterilir
  ///
  /// Format:
  ///   "{Yıl} {Tür}  IMDB: {Rating}"
  /// Boş gelen alanlar varsa (örn. genre yok) otomatik atlanır.
  String _subtitleText() {
    if (_loading) return "Bilgiler yükleniyor...";
    if (!_isLoaded) return "Dokun → poster / IMDB / tür";

    final year = (widget.group.year ?? '').trim();
    final genre = (widget.group.genre ?? '').trim();
    final rating = (widget.group.rating ?? '...').trim();

    final parts = <String>[];
    if (year.isNotEmpty) parts.add(year);
    if (genre.isNotEmpty) parts.add(genre);

    final meta = parts.join(" ");
    if (meta.isEmpty) return "IMDB: $rating";

    return "$meta  IMDB: $rating";
  }

  // ==========================================================================
  // 🏗 build
  // ==========================================================================
  /// Widget ağacını üretir.
  ///
  /// Yapı:
  /// - Container: light mode ’da arka planı cardLightColor yapar
  /// - ExpansionTile:
  ///   • leading: _buildLeading()
  ///   • title: dizi adı (GestureDetector ile tap/long press)
  ///   • subtitle: _subtitleText() (GestureDetector ile tap/long press)
  ///   • onExpansionChanged: açıldığında _ensureLoaded()
  ///   • children: sezon ve bölüm listesi (nested ExpansionTile + ListTile)
  ///
  /// Kritik not:
  /// ExpansionTile’ın kendi üzerinde onLongPress yok.
  /// Bu yüzden title / subtitle / leading üzerine GestureDetector koyuyoruz.
  @override
  Widget build(BuildContext context) {
    final textColor = widget.isLightTheme ? Colors.black : null;

    return Container(
      color: widget.isLightTheme ? cardLightColor : null,
      child: ExpansionTile(
        maintainState: true,
        backgroundColor: widget.isLightTheme ? cardLightColor : null,
        collapsedBackgroundColor: widget.isLightTheme ? cardLightColor : null,
        iconColor: widget.isLightTheme ? Colors.black : null,
        collapsedIconColor: widget.isLightTheme ? Colors.black : null,

        leading: _buildLeading(),

        // ✅ Title üstünden tap/longPress yönetimi
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _ensureLoaded,
          onLongPress: _openPosterFullScreen,
          child: Text(
            widget.group.seriesName,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),

        // ✅ Yıl / tür / IMDB sadece dizi adı altında
        subtitle: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _ensureLoaded,
          onLongPress: _openPosterFullScreen,
          child: Text(_subtitleText(), style: TextStyle(color: textColor)),
        ),

        // Expansion açılınca da yükleyelim (kullanıcı ok ’a basarsa)
        onExpansionChanged: (open) async {
          if (open) {
            await _ensureLoaded();
            if (mounted) setState(() {});
          }
        },

        // Sezonlar + bölümler
        children: widget.group.seasons.map((season) {
          return ExpansionTile(
            backgroundColor: widget.isLightTheme ? cardLightColor : null,
            collapsedBackgroundColor: widget.isLightTheme
                ? cardLightColor
                : null,
            iconColor: widget.isLightTheme ? Colors.black : null,
            collapsedIconColor: widget.isLightTheme ? Colors.black : null,
            title: Text(
              "Sezon ${season.seasonNumber}",
              style: TextStyle(color: textColor),
            ),
            children: season.episodes.map((ep) {
              return ListTile(
                tileColor: widget.isLightTheme ? cardLightColor : null,
                textColor: textColor,
                title: Text(ep.title),
                subtitle: Text(formatDate(parseDate(ep.date))),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
