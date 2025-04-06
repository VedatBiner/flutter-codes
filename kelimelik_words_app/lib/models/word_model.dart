// 📃 <----- word_database.dart ----->

class Word {
  final int? id;
  final String word;
  final String meaning;

  Word({this.id, required this.word, required this.meaning});

  Map<String, dynamic> toMap() {
    return {'id': id, 'word': word, 'meaning': meaning};
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(id: map['id'], word: map['word'], meaning: map['meaning']);
  }

  /// ✅ JSON ’dan veri okumak için
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(id: json['id'], word: json['word'], meaning: json['meaning']);
  }

  /// ✅ JSON ’a veri yazmak için
  Map<String, dynamic> toJson() {
    return {'id': id, 'word': word, 'meaning': meaning};
  }
}
