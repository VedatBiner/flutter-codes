/// <----- note_model.dart ----->
///
class Note {
  final int? id;
  final String title;
  final String description;

  /// constructor
  Note({
    this.id,
    required this.title,
    required this.description,
  });

  /// factory
  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json["id"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "title" : title,
    "description" : description,
  };
}
