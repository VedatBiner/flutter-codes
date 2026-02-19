import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../models/series_models.dart';
import '../../screens/poster_viewer_page.dart';
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
  OmdbSeriesInfo? _info;
  bool _loading = false;

  String get _heroTag {
    final id = _info?.imdbId;
    if (id != null && id.isNotEmpty) return "series_poster_$id";
    return "series_poster_${widget.group.seriesName}";
  }

  Future<void> _ensureLoaded() async {
    if (_loading) return;
    if (_info != null &&
        ((_info!.imdbId != null && _info!.imdbId!.isNotEmpty) ||
            (_info!.originalTitle != null && _info!.originalTitle!.isNotEmpty))) {
      return;
    }

    setState(() => _loading = true);
    final res = await OmdbSeriesLoader.loadSeries(widget.group.seriesName);

    if (!mounted) return;
    setState(() {
      _info = res;
      _loading = false;
    });
  }

  Future<void> _openPosterFullScreen() async {
    await _ensureLoaded();

    final poster = _info?.poster;
    if (!mounted) return;

    if (poster == null) {
      log("⚠️ Poster yok: ${widget.group.seriesName}", name: "series_tile");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Poster bulunamadı.")),
      );
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, _, _) => PosterViewerPage(
          heroTag: _heroTag,
          posterUrl: poster,
        ),
        transitionsBuilder: (_, anim, _, child) => FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  Widget _leading() {
    final poster = _info?.poster;

    if (poster == null) {
      return const Icon(Icons.tv);
    }

    return Hero(
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
    );
  }

  String _subtitleText() {
    if (_loading) return "Bilgiler yükleniyor...";
    if (_info == null) return "Dokun → poster / IMDB / tür";

    final year = _info?.year ?? '';
    final genre = _info?.genre ?? '';
    final rating = _info?.rating ?? '...';
    final parts = <String>[];

    if (year.trim().isNotEmpty) parts.add(year.trim());
    if (genre.trim().isNotEmpty) parts.add(genre.trim());

    final meta = parts.join(" ");
    if (meta.isEmpty) return "IMDB: $rating";
    return "$meta  IMDB: $rating";
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isLightTheme ? Colors.black : null;

    return Container(
      color: widget.isLightTheme ? cardLightColor : null,

      // ✅ Long-press garanti: InkWell
      child: InkWell(
        onTap: () async {
          // ✅ Dizi satırına dokununca OMDb yükle (expansion açılmasa da)
          await _ensureLoaded();
          setState(() {});
        },
        onLongPress: _openPosterFullScreen,
        child: ExpansionTile(
          maintainState: true,
          backgroundColor: widget.isLightTheme ? cardLightColor : null,
          collapsedBackgroundColor: widget.isLightTheme ? cardLightColor : null,
          iconColor: widget.isLightTheme ? Colors.black : null,
          collapsedIconColor: widget.isLightTheme ? Colors.black : null,

          leading: _leading(),

          title: Text(
            widget.group.seriesName,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          // ✅ Yıl / tür / IMDB sadece dizi adı altında
          subtitle: Text(
            _subtitleText(),
            style: TextStyle(color: textColor),
          ),

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
                  subtitle: Text(ep.date),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
