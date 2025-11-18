// <----- lib/models/series_models.dart ----->

class EpisodeItem {
  final String title; // Bölüm adı
  final String date; // İzlenme tarihi

  EpisodeItem({required this.title, required this.date});
}

class SeasonGroup {
  final int seasonNumber;
  final List<EpisodeItem> episodes;

  SeasonGroup({required this.seasonNumber, required this.episodes});
}

class SeriesGroup {
  final String seriesName;
  final List<SeasonGroup> seasons;

  SeriesGroup({required this.seriesName, required this.seasons});
}
