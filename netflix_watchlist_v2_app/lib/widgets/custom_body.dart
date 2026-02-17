// 📁 lib/widgets/custom_body.dart

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../screens/poster_viewer_page.dart';
import '../utils/csv_parser.dart';
import 'filter_chips.dart';

class CustomBody extends StatefulWidget {
  final bool loading;
  final List<NetflixItem> movies;
  final List<SeriesGroup> series;
  final FilterOption filter;
  final ValueChanged<FilterOption> onFilterSelected;
  final ValueChanged<NetflixItem> onMovieTap;

  const CustomBody({
    super.key,
    required this.loading,
    required this.movies,
    required this.series,
    required this.filter,
    required this.onFilterSelected,
    required this.onMovieTap,
  });

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  final _seriesController = ExpansibleController();
  final _moviesController = ExpansibleController();

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        FilterChips(
          filter: widget.filter,
          onSelected: widget.onFilterSelected,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              _buildSeriesSection(context),
              const SizedBox(height: 20),
              _buildMovieSection(context),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // 📺 DİZİLER
  // ----------------------------------------------------------------
  Widget _buildSeriesSection(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        controller: _seriesController,
        onExpansionChanged: (isExpanding) {
          if (isExpanding) {
            _moviesController.collapse();
          }
        },
        collapsedBackgroundColor: isLightTheme ? Colors.red : null,
        backgroundColor: isLightTheme ? Colors.red.shade700 : null,
        childrenPadding: isLightTheme ? const EdgeInsets.all(2) : EdgeInsets.zero,
        iconColor: isLightTheme ? Colors.white : null,
        collapsedIconColor: isLightTheme ? Colors.white : null,
        title: Text(
          "Diziler (${widget.series.length})",
          style: isLightTheme
              ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              : null,
        ),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: ListView.separated(
              itemCount: widget.series.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade300, height: 1),
              itemBuilder: (context, index) =>
                  _buildSeriesTile(widget.series[index], isLightTheme),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSeriesTile(SeriesGroup group, bool isLightTheme) {
    return ExpansionTile(
      // ✅ Dizi adında ikon (sadece burada)
      leading: Icon(
        Icons.movie,
        color: isLightTheme ? Colors.black : null,
      ),
      backgroundColor: isLightTheme ? cardLightColor : null,
      collapsedBackgroundColor: isLightTheme ? cardLightColor : null,
      iconColor: isLightTheme ? Colors.black : null,
      collapsedIconColor: isLightTheme ? Colors.black : null,
      title: Text(
        group.seriesName,
        style: TextStyle(
          color: isLightTheme ? Colors.black : null,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: group.seasons.map((season) {
        return ExpansionTile(
          backgroundColor: isLightTheme ? cardLightColor : null,
          collapsedBackgroundColor: isLightTheme ? cardLightColor : null,
          iconColor: isLightTheme ? Colors.black : null,
          collapsedIconColor: isLightTheme ? Colors.black : null,
          title: Text(
            "Sezon ${season.seasonNumber}",
            style: TextStyle(color: isLightTheme ? Colors.black : null),
          ),
          children: season.episodes.map((ep) {
            return ListTile(
              tileColor: isLightTheme ? cardLightColor : null,
              textColor: isLightTheme ? Colors.black : null,
              title: Text(ep.title),
              subtitle: Text(formatDate(parseDate(ep.date))),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  // ----------------------------------------------------------------
  // 🎬 FİLMLER
  // ----------------------------------------------------------------
  Widget _buildMovieSection(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        controller: _moviesController,
        onExpansionChanged: (isExpanding) {
          if (isExpanding) {
            _seriesController.collapse();
          }
        },
        backgroundColor: isLightTheme ? Colors.indigo.shade700 : null,
        collapsedBackgroundColor: isLightTheme ? Colors.indigo : null,
        childrenPadding: isLightTheme ? const EdgeInsets.all(2) : EdgeInsets.zero,
        iconColor: isLightTheme ? Colors.white : null,
        collapsedIconColor: isLightTheme ? Colors.white : null,
        title: Text(
          "Filmler (${widget.movies.length})",
          style: isLightTheme
              ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              : null,
        ),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: ListView.separated(
              itemCount: widget.movies.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade300, height: 1),
              itemBuilder: (context, index) =>
                  _buildMovieTile(context, widget.movies[index], isLightTheme),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMovieTile(BuildContext context, NetflixItem movie, bool isLightTheme) {
    // ✅ Hero tag (benzersiz)
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
              errorBuilder: (_, __, ___) => const Icon(Icons.movie),
            ),
          ),
        ),

        title: Text(movie.title),
        subtitle: Text(
          "${formatDate(parseDate(movie.date))}\n"
              "${movie.year ?? ''} ${movie.genre ?? ''} IMDB: ${movie.rating ?? '...'}",
        ),

        onTap: () => widget.onMovieTap(movie),

        // ✅ Uzun basınca poster büyük aç (Hero + swipe-to-close)
        onLongPress: () {
          if (movie.poster == null) return;

          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.transparent,
              pageBuilder: (_, __, ___) => PosterViewerPage(
                heroTag: heroTag,
                posterUrl: movie.poster!,
              ),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
      ),
    );
  }
}
