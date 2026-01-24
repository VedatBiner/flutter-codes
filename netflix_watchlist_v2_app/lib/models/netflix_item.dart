class NetflixItem {
  String title;
  String date;
  String? year;
  String? genre;
  String? rating;
  String? poster;
  String? type;

  String? originalTitle; // 🎬 OMDb Title
  String? imdbId; // ⭐ OMDb imdbID → IMDB link için

  NetflixItem({
    required this.title,
    required this.date,
    this.year,
    this.genre,
    this.rating,
    this.poster,
    this.type,
    this.originalTitle,
    this.imdbId,
  });
}