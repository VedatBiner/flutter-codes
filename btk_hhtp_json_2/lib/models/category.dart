class Category {
  int? id;
  String? categoryName;
  String? seoUrl;

  // Constructor oluşturalım.
  Category(
    this.id,
    this.categoryName,
    this.seoUrl,
  );

  // veri bize JSON olarak gelecek
  // JSON 'dan kategori nesnesine çevirmemiz gerekiyor.
  Category.fromJson(Map json) {
    id = json["id"];
    categoryName = json["categoryName"];
    seoUrl = json["seoUrl"];
  }

  // kategori eklemek gerekirse JSON formatında
  // göndereceğimiz için JSON 'a çevirme metodu
  Map toJson() {
    return {
      "id": id,
      "categoryName": categoryName,
      "seoUrl": seoUrl,
    };
  }
}
