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
  bool get _isLoaded {
    final id = widget.group.imdbId;
    return id != null && id.isNotEmpty;
  }

  // ==========================================================================
  // 🔄 OMDb Lazy Load
  // ==========================================================================
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
  @override
  Widget build(BuildContext context) {
    final textColor = widget.isLightTheme ? Colors.black : null;
    final bgColor = widget.isLightTheme ? cardLightColor : Colors.transparent;

    return Material(
      color: bgColor,
      child: ExpansionTile(
        maintainState: true,
        iconColor: widget.isLightTheme ? Colors.black : null,
        collapsedIconColor: widget.isLightTheme ? Colors.black : null,
        leading: _buildLeading(),

        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _ensureLoaded,
          onLongPress: _openPosterFullScreen,
          child: Text(
            widget.group.seriesName,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),

        subtitle: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _ensureLoaded,
          onLongPress: _openPosterFullScreen,
          child: Text(_subtitleText(), style: TextStyle(color: textColor)),
        ),

        onExpansionChanged: (open) async {
          if (open) {
            await _ensureLoaded();
            if (mounted) setState(() {});
          }
        },

        children: widget.group.seasons.map((season) {
          return Material(
            color: bgColor,
            child: ExpansionTile(
              iconColor: widget.isLightTheme ? Colors.black : null,
              collapsedIconColor: widget.isLightTheme ? Colors.black : null,
              title: Text(
                "Sezon ${season.seasonNumber}",
                style: TextStyle(color: textColor),
              ),
              children: season.episodes.map((ep) {
                return Material(
                  color: bgColor,
                  child: ListTile(
                    textColor: textColor,
                    iconColor: textColor,
                    title: Text(ep.title),
                    subtitle: Text(formatDate(parseDate(ep.date))),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}