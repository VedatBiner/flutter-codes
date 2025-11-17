// <----- lib/screens/home_page.dart ----->

import 'package:flutter/material.dart';

import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';
import '../utils/omdb_lazy_loader.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? toggleTheme; // 🌙 Tema değiştirme butonu

  const HomePage({super.key, this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum FilterOption { all, movies, series, last30days }

class _HomePageState extends State<HomePage> {
  List<NetflixItem> allMovies = [];
  List<SeriesGroup> allSeries = [];

  List<NetflixItem> movies = [];
  List<SeriesGroup> series = [];

  bool loading = true;
  String searchQuery = "";
  FilterOption filter = FilterOption.all;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final parsed = await CsvParser.parseCsvFast();

    setState(() {
      allMovies = parsed.movies;
      allSeries = parsed.series;

      movies = parsed.movies;
      series = parsed.series;

      loading = false;
    });
  }

  // ----------------------------------------------------------------
  // 🔍 Arama + Filtre Uygulama
  // ----------------------------------------------------------------
  void applySearchAndFilter() {
    final q = searchQuery.toLowerCase().trim();

    // ---------------------
    // Filmler
    // ---------------------
    List<NetflixItem> filteredMovies = allMovies.where((m) {
      return q.isEmpty || m.title.toLowerCase().contains(q);
    }).toList();

    // ---------------------
    // Diziler + Bölümler
    // ---------------------
    List<SeriesGroup> filteredSeries = allSeries.where((s) {
      final seriesMatch = s.seriesName.toLowerCase().contains(q);

      final episodeMatch = s.seasons.any(
        (season) =>
            season.episodes.any((ep) => ep.title.toLowerCase().contains(q)),
      );

      return q.isEmpty ? true : (seriesMatch || episodeMatch);
    }).toList();

    // ---------------------
    // Filtre butonu
    // ---------------------
    final now = DateTime.now();
    final last30 = now.subtract(const Duration(days: 30));

    if (filter == FilterOption.movies) {
      filteredSeries = [];
    } else if (filter == FilterOption.series) {
      filteredMovies = [];
    } else if (filter == FilterOption.last30days) {
      filteredMovies = filteredMovies
          .where((m) => parseDate(m.date).isAfter(last30))
          .toList();

      filteredSeries = filteredSeries.where((s) {
        final latest = s.seasons
            .expand((e) => e.episodes)
            .map((e) => parseDate(e.date))
            .reduce((x, y) => x.isAfter(y) ? x : y);
        return latest.isAfter(last30);
      }).toList();
    }

    setState(() {
      movies = filteredMovies;
      series = filteredSeries;
    });
  }

  // ----------------------------------------------------------------
  Future<void> loadOmdb(NetflixItem movie) async {
    await OmdbLazyLoader.loadOmdbIfNeeded(movie);
    setState(() {});
  }

  // ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Netflix İzleme Listesi"),

        actions: [
          // 📊 İSTATİSTİK SAYFASI
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: "İstatistikler",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      StatsPage(movies: allMovies, series: allSeries),
                ),
              );
            },
          ),

          // 🌙 TEMA BUTONU
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: "Tema Değiştir",
            onPressed: widget.toggleTheme,
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                hintText: "Ara (Dizi, Film, Bölüm)...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                searchQuery = value;
                applySearchAndFilter();
              },
            ),
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilters(),
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
            ),
    );
  }

  // ----------------------------------------------------------------
  // 🔽 Filtre Butonları
  // ----------------------------------------------------------------
  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Wrap(
        spacing: 8,
        children: [
          _filterChip("Tümü", FilterOption.all),
          _filterChip("Filmler", FilterOption.movies),
          _filterChip("Diziler", FilterOption.series),
          _filterChip("Son 30 Gün", FilterOption.last30days),
        ],
      ),
    );
  }

  Widget _filterChip(String label, FilterOption option) {
    final selected = filter == option;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        filter = option;
        applySearchAndFilter();
      },
    );
  }

  // ----------------------------------------------------------------
  // 📺 Diziler → Sezon → Bölüm
  // ----------------------------------------------------------------
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
              subtitle: Text(formatDate(parseDate(ep.date))),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  // ----------------------------------------------------------------
  // 🎬 Filmler
  // ----------------------------------------------------------------
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
      onTap: () => loadOmdb(movie),
    );
  }
}
