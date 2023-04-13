class Recipe {
  String name;
  String image;
  double rating;
  String totalTime;

  // constructor
  Recipe({
    required this.name,
    required this.image,
    required this.rating,
    required this.totalTime,
  });

  // parse metodu
  factory Recipe.fromJson(dynamic json) {
    return json != null ? Recipe(
      name: json["name"] != null ? json["name"] as String : "",
      image: json["image"] != null && json["image"][0]["hostedLargeUrl"] != null ? json["image"][0]["hostedLargeUrl"] as String : "",
      rating: json["rating"] != null ? json["rating"] as double : 0.0,
      totalTime: json["totalTime"] != null ? json["totalTime"] as String : "",
    ) : Recipe(
      name: "",
      image: "",
      rating: 0.0,
      totalTime: "",
    );
  }

  //recipe list 'e dönüştürme metodu
  static List<Recipe> recipesFromSnapshot(List? snapshot) {
    if (snapshot == null) {
      return [];
    }
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return "Recipe {name: $name, image:$image, rating:$rating, totalTime: $totalTime}";
  }
}
