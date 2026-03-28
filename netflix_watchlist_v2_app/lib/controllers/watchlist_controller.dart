import 'package:flutter/cupertino.dart';

import '../models/filter_option.dart';
import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/watchlist_filter_engine.dart';

class WatchlistController extends ChangeNotifier {

  List<NetflixItem> allMovies = [];
  List<SeriesGroup> allSeries = [];

  List<NetflixItem> movies = [];
  List<SeriesGroup> series = [];

  FilterOption filter = FilterOption.all;

  String searchQuery = "";

  void setFilter(FilterOption newFilter) {

    filter = newFilter;
    _applyFilters();

  }

  void setSearchQuery(String query) {

    searchQuery = query;
    _applyFilters();

  }

  void loadData(List<NetflixItem> moviesData, List<SeriesGroup> seriesData) {

    allMovies = moviesData;
    allSeries = seriesData;

    _applyFilters();

  }

  void _applyFilters() {

    final result = WatchlistFilterEngine.apply(
      searchQuery: searchQuery,
      filter: filter,
      allMovies: allMovies,
      allSeries: allSeries,
    );

    movies = result.movies;
    series = result.series;

    notifyListeners();
  }
}