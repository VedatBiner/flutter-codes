class Item {
  final String title;
  bool isDone;

  Item({required this.title, this.isDone = false});

  // her bir nesne kendi statüsünü değiştirecek metoda sahip olmalı
  void toggleStatus() {
    isDone = !isDone;
  }

  // String 'i map 'a çeviren contructor
  Item.fromMap(Map<String, dynamic> map)
      : title = map["title"],
        isDone = map["isDone"];

  Map<String, dynamic> toMap() => {"title": title, "isDone": isDone};
}
