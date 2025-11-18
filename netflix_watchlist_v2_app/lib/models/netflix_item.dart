// <----- lib/models/netflix_item.dart ----->

class NetflixItem {
  final String title;
  final String date;
  final String type; // "movie" | "series"

  // OMDb alanları (lazy load ile doldurulacak)
  String? poster;
  String? year;
  String? genre;
  String? rating;

  bool omdbLoaded = false;

  NetflixItem({required this.title, required this.date, required this.type});

  void applyOmdb(Map<String, dynamic> data) {
    poster = data["Poster"];
    year = data["Year"];
    genre = data["Genre"];
    rating = data["imdbRating"];
    omdbLoaded = true;
  }
}
