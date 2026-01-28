// 📁 lib/widgets/custom_body.dart

import 'package:flutter/material.dart';

import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';
import 'filter_chips.dart';

class CustomBody extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        FilterChips(
          filter: filter,
          onSelected: onFilterSelected,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              _buildSeriesSection(),
              const SizedBox(height: 20),
              _buildMovieSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeriesSection() {
    return Card(
      child: ExpansionTile(
        title: Text("Diziler (${series.length})"),
        children: series.map(_buildSeriesTile).toList(),
      ),
    );
  }

  Widget _buildSeriesTile(SeriesGroup group) {
    return ExpansionTile(
      title: Text(group.seriesName),
      children: group.seasons.map((season) {
        return ExpansionTile(
          title: Text("Sezon ${season.seasonNumber}"),
          children: season.episodes.map((ep) {
            return ListTile(
                title: Text(ep.title),
                subtitle: Text(formatDate(parseDate(ep.date))));
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildMovieSection() {
    return Card(
      child: ExpansionTile(
        title: Text("Filmler (${movies.length})"),
        children: movies.map(_buildMovieTile).toList(),
      ),
    );
  }

  Widget _buildMovieTile(NetflixItem movie) {
    return ListTile(
      leading: movie.poster == null
          ? const Icon(Icons.movie)
          : Image.network(movie.poster!, width: 50, fit: BoxFit.cover),
      title: Text(movie.title),
      subtitle: Text(
        "${formatDate(parseDate(movie.date))}\n"
        "${movie.year ?? ''} ${movie.genre ?? ''} IMDB: ${movie.rating ?? '...'}",
      ),
      onTap: () => onMovieTap(movie),
    );
  }
}
