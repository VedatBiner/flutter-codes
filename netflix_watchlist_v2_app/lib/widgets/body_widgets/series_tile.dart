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

/// =========================================================================
/// 📺 SeriesTile
/// =========================================================================
/// Tek bir diziyi temsil eden satır widget ’ıdır.
///
/// Özellikler:
///  • Dizi adına dokununca OMDb ’den dizi bilgilerini lazy-load eder
///  • Poster küçük thumbnail olarak görünür (varsa)
///  • Dizi adı altında: yıl / tür / IMDb rating gösterir
///  • Uzun basınca Hero animasyonlu tam ekran poster görüntüleyici açar
///  • İçeride sezon/bölüm ExpansionTile’larını üretir
///
/// Not:
/// ExpansionTile’ın kendisinde `onLongPress` parametresi yoktur.
/// Bu yüzden uzun basma ve dokunma aksiyonları title/leading üzerinden yönetilir.
/// =========================================================================
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
  static const _tag = "series_tile";

  bool _loading = false;

  /// =========================================================================
  /// 🏷 Hero Tag
  /// =========================================================================
  /// Hero animasyonunda çakışmayı önlemek için mümkünse imdbId kullanılır.
  /// imdbId yoksa seriesName baz alınır.
  String get _heroTag {
    final id = widget.group.imdbId;
    if (id != null && id.isNotEmpty) return "series_poster_$id";
    return "series_poster_${widget.group.seriesName}";
  }

  /// =========================================================================
  /// 🔄 OMDb Lazy Load (SeriesGroup içine yazar)
  /// =========================================================================
  /// Zaten imdbId varsa (veya başka bir alan doluysa) tekrar çağırmaz.
  Future<void> _ensureLoaded() async {
    if (_loading) return;

    // ✅ Cache kriteri: imdbId varsa bu öğeyi "yüklenmiş" kabul ediyoruz.
    if (widget.group.imdbId != null && widget.group.imdbId!.isNotEmpty) {
      return;
    }

    setState(() => _loading = true);

    await OmdbSeriesLoader.loadIfNeeded(widget.group);

    if (!mounted) return;
    setState(() => _loading = false);
  }

  /// =========================================================================
  /// 🖼 Poster Fullscreen Viewer (Hero + Swipe-to-close)
  /// =========================================================================
  Future<void> _openPosterFullScreen() async {
    // Poster yoksa önce yüklemeyi dene
    await _ensureLoaded();

    if (!mounted) return;

    final poster = widget.group.poster;
    if (poster == null || poster.isEmpty) {
      log("⚠️ Poster yok: ${widget.group.seriesName}", name: _tag);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Poster bulunamadı.")),
      );
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => PosterViewerPage(
          heroTag: _heroTag,
          posterUrl: poster,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  /// =========================================================================
  /// 🎬 Leading Widget (Poster thumbnail veya TV ikonu)
  /// =========================================================================
  /// Long press / tap aksiyonlarını burada da veriyoruz ki kullanıcı
  /// postere basınca direkt etkileşim olsun.
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
            errorBuilder: (_, __, ___) => const Icon(Icons.tv),
          ),
        ),
      ),
    );
  }

  /// =========================================================================
  /// 🧾 Subtitle (Yıl / Tür / IMDB)
  /// =========================================================================
  String _subtitleText() {
    if (_loading) return "Bilgiler yükleniyor...";

    // Henüz OMDb gelmediyse yönlendirici kısa metin
    if (widget.group.imdbId == null || widget.group.imdbId!.isEmpty) {
      return "Dokun → poster / IMDB / tür";
    }

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

  /// =========================================================================
  /// 🏗 build
  /// =========================================================================
  /// ExpansionTile:
  ///  • leading: poster/tv icon (Hero)
  ///  • title: dizi adı (tap → load, long press → poster viewer)
  ///  • subtitle: yıl / tür / imdb
  ///  • children: sezon/bölüm listesi
  ///
  /// Not:
  /// `ExpansionTile` içinde `onLongPress` yok.
  /// Bu yüzden title ve leading üstünden GestureDetector ile yönetiyoruz.
  /// =========================================================================
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
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // ✅ Yıl / tür / IMDB sadece dizi adı altında
        subtitle: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _ensureLoaded,
          onLongPress: _openPosterFullScreen,
          child: Text(
            _subtitleText(),
            style: TextStyle(color: textColor),
          ),
        ),

        // Expansion açılınca da yükleyelim (kullanıcı ok’a basarsa)
        onExpansionChanged: (open) async {
          if (open) {
            await _ensureLoaded();
            if (mounted) setState(() {});
          }
        },

        children: widget.group.seasons.map((season) {
          return ExpansionTile(
            backgroundColor: widget.isLightTheme ? cardLightColor : null,
            collapsedBackgroundColor: widget.isLightTheme ? cardLightColor : null,
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