// tablomuzun adı
const String tableNameLists = "lists";

// Liste tablosunun alanları
class ListsTableFields {
  static final List<String> values = [id, name];

  static const String id = "id";
  static const String name = "name";
}

// Liste sınıfı
class Lists {
  int? id;
  String? name;

  Lists({
    this.id,
    this.name,
  });

  Lists copy({int? id, String? name}) {
    return Lists(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  // veri tabanına veriyi JSON olarak göndereceğiz
  Map<String, Object?> toJson() => {
    ListsTableFields.id : id,
    ListsTableFields.name : name,
  };

  // JSON dan listeye dönüştürme
  static Lists fromJson(Map<String, Object?> json) => Lists(
    id: json[ListsTableFields.id] as int?,
    name: json[ListsTableFields.name] as String?,
  );

}

