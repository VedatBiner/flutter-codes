import '../models/netflix_item.dart';
import '../models/series_models.dart';
import '../utils/csv_parser.dart';

class WatchlistRepository {

  Future<(List<NetflixItem>, List<SeriesGroup>)> loadWatchlist() async {

    final parsed = await CsvParser.parseCsvFast();

    return (
    parsed.movies,
    parsed.series
    );

  }

}