class Recipe {
  String name;
  String images;
  double rating;
  String totalTime;

  // constructor
  Recipe({
    required this.name,
    required this.images,
    required this.rating,
    required this.totalTime,
  });

  // parse metodu
  factory Recipe.fromJson(dynamic json) {
    return Recipe(
      name: json["name"] != null ? json["name"] as String : "",
      images: json["images"] != null && json["images"][0] != null && json["images"][0]["hostedLargeUrl"] != null ? json["images"][0]["hostedLargeUrl"] as String : "",
      rating: json["rating"] != null ? json["rating"] as double : 0.0,
      totalTime: json["totalTime"] != null ? json["totalTime"] as String : "",
    );
  }


  //recipe list 'e dönüştürme metodu
  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return "Recipe {name: $name, image:$images, rating:$rating, totalTime: $totalTime}";
  }
}
