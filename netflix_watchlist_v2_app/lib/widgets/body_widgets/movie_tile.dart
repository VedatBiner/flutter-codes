// ============================================================================
// 🎞 MovieTile – Tekil Film Satırı
// ============================================================================
//
// Bu widget tek bir filmi temsil eder.
// Poster, başlık, tarih ve OMDb bilgilerini gösterir.
//
// ---------------------------------------------------------------------------
// 🔹 Özellikleri
// ---------------------------------------------------------------------------
// • Küçük poster thumbnail (varsa).
// • Yıl, Tür, IMDB rating alt satırda.
// • onTap → OMDb lazy load tetikler.
// • onLongPress → Hero + tam ekran poster viewer.
// • Swipe-to-close desteklidir.
//
// ---------------------------------------------------------------------------
// Amaç:
// Film UI mantığını CustomBody’den ayırarak modüler yapı sağlamak.
// ============================================================================
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import '../../models/netflix_item.dart';
import '../../screens/poster_viewer_page.dart';
import '../../utils/csv_parser.dart';

class MovieTile extends StatelessWidget {
  final NetflixItem movie;
  final bool isLightTheme;
  final ValueChanged<NetflixItem> onMovieTap;

  const MovieTile({
    super.key,
    required this.movie,
    required this.isLightTheme,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = (movie.imdbId != null && movie.imdbId!.isNotEmpty)
        ? "poster_${movie.imdbId}"
        : "poster_${movie.title}_${movie.date}";

    return Container(
      color: isLightTheme ? cardLightColor : null,
      child: ListTile(
        iconColor: isLightTheme ? Colors.black : null,
        textColor: isLightTheme ? Colors.black : null,

        leading: movie.poster == null
            ? const Icon(Icons.movie)
            : Hero(
          tag: heroTag,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              movie.poster!,
              width: 50,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.movie),
            ),
          ),
        ),

        title: Text(movie.title),

        subtitle: Text(
          "${formatDate(parseDate(movie.date))}\n"
              "${movie.year ?? ''} ${movie.genre ?? ''} IMDB: ${movie.rating ?? '...'}",
        ),

        onTap: () => onMovieTap(movie),

        onLongPress: () {
          if (movie.poster == null) return;

          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.transparent,
              pageBuilder: (_, _, _) => PosterViewerPage(
                heroTag: heroTag,
                posterUrl: movie.poster!,
              ),
              transitionsBuilder: (_, animation, _, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
      ),
    );
  }
}
