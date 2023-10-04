class ChatMessageEntity {
  String text;
  String? imageUrl;
  String id;
  int createdAt;
  Author author;

  ChatMessageEntity({
    required this.text,
    this.imageUrl,
    required this.id,
    required this.createdAt,
    required this.author,
  });

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
      imageUrl: json["image"],
      text: json["text"],
      id: json["id"],
      createdAt: json["createdAt"],
      author: Author.fromJson(json["author"]),
    );
  }
}

class Author {
  String userName;

  Author({required this.userName});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(userName: json["username"]);
  }
}

