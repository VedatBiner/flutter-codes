// 📃 <----- word_model.dart ----->

import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final int? id;
  final String word;
  final String meaning;

  const Word({this.id, required this.word, required this.meaning});

  /// 📌 Equatable karşılaştırması için kullanılacak alanlar
  @override
  List<Object?> get props => [id, word, meaning];

  /// 📌 Kolay güncelleme için yardımcı (opsiyonel ama faydalı)
  Word copyWith({int? id, String? word, String? meaning}) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
    );
  }

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
