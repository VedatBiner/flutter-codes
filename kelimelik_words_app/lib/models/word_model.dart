class Word {
  final int? id;
  final String word;
  final String meaning;

  Word({this.id, required this.word, required this.meaning});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      word: map['word'],
      meaning: map['meaning'],
    );
  }
}
