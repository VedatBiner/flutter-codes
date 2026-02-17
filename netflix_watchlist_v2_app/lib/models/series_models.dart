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

  // ✅ OMDb alanları (dizi için)
  String? year;
  String? genre;
  String? rating;
  String? poster;
  String? type;
  String? originalTitle;
  String? imdbId;

  SeriesGroup({
    required this.seriesName,
    required this.seasons,
    this.year,
    this.genre,
    this.rating,
    this.poster,
    this.type,
    this.originalTitle,
    this.imdbId,
  });
}